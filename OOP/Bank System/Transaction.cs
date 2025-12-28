using System;


namespace ConsoleApp4
{
    public class Transaction
    {

        public string Type { get; set; }
        public string Amount { get; set; }
        public int TransactionId { get; set; }

        public DateTime Date { get; set; }

        private static int nextId = 1;



        public Transaction(string type, string amount, int transactionId, DateTime date)
        {

            Type = type;
            Amount = amount;
            TransactionId = nextId++;
            Date = DateTime.Now;


        }

    }
}
