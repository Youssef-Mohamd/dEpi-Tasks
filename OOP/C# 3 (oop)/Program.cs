using Bank;

namespace ConsoleApp3
{
    internal class Program
    {
        static void Main(string[] args)
        {
            // Create Saving Account
            SavingAccount savingAcc = new SavingAccount(
                "Mohamed Ahmed", "12345678935467", "01012343567", "Cairo", 10000, 5);

            // Create Current Account
            CurretAccount currentAcc = new CurretAccount("Yousef Mohamed", "98765432109876", "01123456547", "Giza", 5000,43764);
           

            // List of BankAccounts 
            List<BankAccount> accounts = new List<BankAccount> { savingAcc, currentAcc };

            // Loop through accounts and display details
            foreach (var account in accounts)
            {
                account.ShowAccountDetails();
                Console.WriteLine($"Calculated Interest: {account.CalculateInterest()}");
                Console.WriteLine(new string('-', 30));
            }
        }
    }
}
