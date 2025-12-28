using System.Security.Cryptography.X509Certificates;
using LibraryManagementSystem;
using LINQ_DATA;
using Microsoft.VisualBasic;

namespace LINQ
{
    internal class Program
    {
        static void Main(string[] args)
        {

            //1
            var book = LibraryData.Books.Where(book => book.IsAvailable == true);


            book.ToConsoleTable("Available Books");
            Console.WriteLine($"Total Available Books: {book.Count()}\n");

            //----------------//

            var bookTitlesMethod = LibraryData.Books.Select(book => book.Title);

            bookTitlesMethod.ToConsoleTable("Title", "All Book Titles");
            Console.WriteLine($"Total Books: {bookTitlesMethod.Count()}\n");

            //----------------------------------------//

            var FindGenre = LibraryData.Books.Where(book => book.Genre == "Programming");

            FindGenre.ToConsoleTable("Programming Books");
            Console.WriteLine($"Programming Books Count: {FindGenre.Count()}\n");

            //-----------------------------//

            var books = LibraryData.Books.OrderBy(book => book.Title);
            books.ToConsoleTable("Books Sorted by Title");


            //------------------------------------//
            var highPrice = LibraryData.Books.Where(book => book.Price > 30);
            highPrice.ToConsoleTable("Expensive Books (> $30)");


            //------------------------------------//


            var uniqueGenresMethod = LibraryData.Books.Select(book => book.Genre)
                             .Distinct();

            uniqueGenresMethod.ToConsoleTable("Genre", "Unique Genres in Library");


            //------------------------------------//


            var bookCountByGenreMethod = LibraryData.Books
                                   .GroupBy(book => book.Genre)
                                   .Select(group => new
                                   {
                                       Genre = group.Key,
                                       Count = group.Count()
                                   });

            bookCountByGenreMethod.ToConsoleTable("Books Count by Genre (Extension Method)");


            //---------------------------------//

            var recentBooks = LibraryData.Books
                             .Where(book => book.PublishedYear > 2010);

            recentBooks.ToConsoleTable();


            //-------------------------//

            var first5Books = LibraryData.Books.Skip(0)
                             .Take(5);

            first5Books.ToConsoleTable();

            //--------------------------//

            var ExpensiveBooks = LibraryData.Books
                                   .Any(book => book.Price > 50);

            Console.WriteLine($"Extension Method Result: {ExpensiveBooks}");

            //-------------------------------------//

            var booksWithAuthor = from b in LibraryData.Books
                                  join author in LibraryData.Authors
                                  on b.AuthorId equals author.Id
                                  select new
                                  {
                                      Title = b.Title,
                                      AuthorName = author.Name,
                                      Genre = b.Genre
                                  };

            booksWithAuthor.ToConsoleTable("Books with Author Information");

            ////--------------------------------//


            var Avrage = LibraryData.Books
                .GroupBy(book => book.Genre)
                .Select(group => new
                {
                    Genre = group.Key,
                    Average = group.Average(book => book.Price)
                }
                );

            Avrage.ToConsoleTable("Average Price by Genre ");

            //-----------------------------------//

            var MaxBook = LibraryData.Books.Max(book => book.Price);

            Console.WriteLine($"Most Expensive Book: {MaxBook}");



            //------------------------------//


            var booksByDecade = LibraryData.Books
         .GroupBy(book => (book.PublishedYear / 10) * 10)
         .Select(group => new
         {
             Decade = $"{group.Key}",
             BookCount = group.Count(),
            
         })
         .OrderBy(x => x.Decade);

            booksByDecade.ToConsoleTable("Books Grouped by Decade (Extension Method)");


            //-----------------------------//


            var MemberActiveLoan = LibraryData.Loans
                .Where(loan => loan.ReturnDate == null)
                .Join(LibraryData.Members,
                    loan => loan.MemberId,
                  member => member.Id,
                  (loan, member) => member);

            MemberActiveLoan.ToConsoleTable("Members with Active Loans (Extension Method)");


            //-------------------------//

            var BookBorrow = LibraryData.Loans
               .GroupBy(loan => loan.BookId)
               .Where(group => group.Count() > 1)
                .Join(LibraryData.Books,
                  loanGroup => loanGroup.Key,
                  book => book.Id,
                  (loanGroup, book) 
                  => new
                  {
                      BookId = book.Id,
                      Title = book.Title,
                      LoanCount = loanGroup.Count(),
              
                  })
            .OrderByDescending(x => x.LoanCount);
            BookBorrow.ToConsoleTable("books borrow more than one");


            //---------------------------//

            var overdueBooksMethod = LibraryData.Loans
            .Where(loan => loan.ReturnDate == null && loan.ReturnDate < loan.DueDate)
            .Join(LibraryData.Books,
                  loan => loan.BookId,
                  book => book.Id,
                  (loan, book) => new
                  {
                      Title = book.Title,
                      DueDate = loan.DueDate,
                      DaysOverdue = (loan.DueDate - loan.ReturnDate),
                      MemberId = loan.MemberId
                  });
            overdueBooksMethod.ToConsoleTable("Overdue Books (Extension Method)");

            //-------------------------------//



            var authorBookCountsQuery = from author in LibraryData.Authors
                                        join book in LibraryData.Books
                                        on author.Id equals book.AuthorId
                                        group book by new { author.Id, author.Name } into authorGroup
                                        orderby authorGroup.Count() descending
                                        select new
                                        {
                                            AuthorName = authorGroup.Key.Name,
                                            BookCount = authorGroup.Count(),
                                            Books = string.Join(", ", authorGroup.Select(b => b.Title))
                                        };
            authorBookCountsQuery.ToConsoleTable("ksks");

            //------------------------//



            var priceRangeAnalysisMethod = LibraryData.Books
        .GroupBy(book => book.Price <= 20 ? "Cheap (≤$20)" :
                       book.Price <= 40 ? "Medium ($20-$40)" :
                       "Expensive (>$40)")
        .Select(group => new
        {
            PriceRange = group.Key,
            BookCount = group.Count(),
            AveragePrice = group.Average(b => b.Price)
        })
        .OrderBy(x => x.PriceRange);

            priceRangeAnalysisMethod.ToConsoleTable("Price Range Analysis (Extension Method)");

            //-------------------------//


            var memberLoanStatsMethod = LibraryData.Members
    .GroupJoin(LibraryData.Loans,
              member => member.Id,
              loan => loan.MemberId,
              (member, loans) => new
              {
                  MemberName = member.FullName,
                  TotalLoans = loans.Count(),
                  ActiveLoans = loans.Count(l => l.ReturnDate == null),
                  AverageDaysBorrowed = loans.Where(l => l.ReturnDate != null)
                                           .Select(l => (l.ReturnDate.Value - l.LoanDate).Days)
                                           .DefaultIfEmpty(0)
                                           .Average()
              })
    .Where(x => x.TotalLoans > 0)
    .OrderByDescending(x => x.TotalLoans);

        }
    }
}
