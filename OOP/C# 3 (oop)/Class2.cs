using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Bank;

namespace ConsoleApp3
{

    // Derived Class → SavingAccount
    class SavingAccount : BankAccount
    {

        //SavingAccount → InterestRate (decimal) 

        public decimal InterestRate { get; set; }

        public SavingAccount(string fullName, string nationalID, string phoneNumber, string address, decimal balance, decimal interestRate)
            : base(fullName, nationalID, phoneNumber, address, balance)
        {
            InterestRate = interestRate;
        }

        public override decimal CalculateInterest()
        {
            return Balance * InterestRate / 100;
        }

        public override void ShowAccountDetails()
        {
            base.ShowAccountDetails();
            Console.WriteLine($"Interest Rate: {InterestRate}%");
        }

    }


    class CurretAccount : BankAccount
    {

        public decimal OverdraftLimit { get; set; }
        public CurretAccount(string fullName, string nationalID, string phoneNumber, string address, decimal balance, decimal overdraftlimit)
        : base(fullName, nationalID, phoneNumber, address, balance)
        {
            OverdraftLimit = overdraftlimit;
        }
        public override decimal CalculateInterest()
        {
            return 0;
        }



        public override void ShowAccountDetails()
        {
            base.ShowAccountDetails();
            Console.WriteLine($"Overdraft Limit: {OverdraftLimit}");
        }
    }

}
