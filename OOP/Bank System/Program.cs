using System;


namespace ConsoleApp4
{
    internal class Program
    {
        static void Main(string[] args)
        {


            Bank bank = new Bank("BANK Masr", "Banha ");



            SavingAccount saving = new SavingAccount(10);      // Interest 10%
            CurrentAccount current = new CurrentAccount(500); // Overdraft limit 500

            while (true)
            {

                Console.WriteLine("\n__Bank Menu ____");
                Console.WriteLine("1. Add Customer");
                Console.WriteLine("2. Deposit to Saving Account");
                Console.WriteLine("3. Withdraw from Saving Account");
                Console.WriteLine("4. Deposit to Current Account");
                Console.WriteLine("5. Withdraw from Current Account");
                Console.WriteLine("6. Transfer from Saving to Current");
                Console.WriteLine("7. Show Balances");
                Console.WriteLine("8.Update Customer");
                Console.WriteLine("0. Exit");
                Console.Write("Your choice: ");
                string choice = Console.ReadLine();

                switch (choice)
                {

                    case "1":

                        Console.Write("enter name of customer :  ");
                        string cusName = Console.ReadLine();

                        Console.Write("enter your national id : ");
                        string cusNid = Console.ReadLine();
                        Customer newCustomer = new Customer(1, cusName, cusNid, new DateTime(2025, 08, 24), 0);


                        Console.Write("Choose account type: (1) Saving, (2) Current : ");
                        string accType = Console.ReadLine();

                        if (accType == "1")
                        {
                            Console.Write("Enter interest rate (%): ");
                            //-------------------------------------//
                            decimal rate = decimal.Parse(Console.ReadLine());
                            newCustomer.Accounts.Add(new SavingAccount(rate));
                        }
                        else if (accType == "2")
                        {
                            Console.Write("Enter overdraft limit: ");
                            decimal limit = decimal.Parse(Console.ReadLine());
                            newCustomer.Accounts.Add(new CurrentAccount(limit));
                        }

                        // Customer.Add(newCustomer);
                        Console.WriteLine("Customer and account added successfully.");
                        break;

                    case "2":
                        Console.Write("Enter amount: ");
                        decimal depSav = decimal.Parse(Console.ReadLine());
                        saving.deposit(depSav);
                        Console.WriteLine($"Balance after deposit: {saving.Balance}");


                        decimal savingInterest = saving.CalculateInterest();
                        Console.WriteLine($"[Saving] Interest: {savingInterest}");
                        //---------------------------//   
                        break;

                    case "3":
                        Console.Write("Enter amount: ");
                        decimal withSav = decimal.Parse(Console.ReadLine());
                        saving.Withdraw(withSav);
                        Console.WriteLine($"[Saving] Balance after Withdraw: {saving.Balance}");
                        break;

                    case "4":
                        Console.Write("Enter amount: ");
                        decimal depCurrent = decimal.Parse(Console.ReadLine());
                        current.deposit(depCurrent);
                        Console.WriteLine("Deposit successful.");
                        break;


                    case "5":
                        Console.Write("Enter amount: ");
                        decimal withCurrent = decimal.Parse(Console.ReadLine());
                        current.Withdraw(withCurrent);
                        break;

                    case "6":
                        Console.Write("Enter amount: ");
                        decimal transferAmount = decimal.Parse(Console.ReadLine());
                        saving.Transfer(transferAmount, current);
                        break;

                    case "7":
                        Console.WriteLine("\n //////Saving Account///// ");
                        Console.WriteLine($"Balance: {saving.Balance}");
                        Console.WriteLine($"Interest: {saving.CalculateInterest()}");

                        Console.WriteLine("\n--- Current Account ---");
                        Console.WriteLine($"Balance: {current.Balance}");
                        Console.WriteLine($"Overdraft Limit: {current.OverdraftLimit}");
                        break;




                    case "8": // Update Customer
                        Console.Write("Enter Customer ID to update: ");
                        int updateId = int.Parse(Console.ReadLine());


                        Customer customerToUpdate = new Customer(1, "Youssef", "200548438", new DateTime(2025, 08, 24), 0);
                        if (customerToUpdate != null)

                        {
                            Console.Write("Enter new full name: ");
                            string newName = Console.ReadLine();

                            Console.Write("Enter new date of birth (yyyy-MM-dd): ");
                            DateTime newDate = DateTime.Parse(Console.ReadLine());

                            customerToUpdate.Update(newName, newDate);

                            Console.WriteLine("Customer updated successfully!");
                        }
                        else
                        {
                            Console.WriteLine("Customer not found.");
                        }
                        break;

                    case "0":
                        Console.WriteLine("Goodbye");
                        return;

                    default:
                        Console.WriteLine(" try again.");
                        break;
                }

