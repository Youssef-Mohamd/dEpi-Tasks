using System;


namespace ConsoleApp4
{
    public class Account
    {
        private int NextAcc = 1000;

        public int AccountNumber { get; set; }
        public decimal Balance { get; set; }
        public DateTime DateOpend { get; set; }

        public List<Transaction> Transactions { get; set; }

        public Account()
        {

            AccountNumber = ++NextAcc;
            DateOpend = DateTime.Now;
            Balance = 0;
            Transactions = new List<Transaction>();

            
        }


        public void deposit(decimal amount)
        {

            Balance += amount;

        }

        public void Withdraw(decimal amount)
        {
            if (amount <= Balance)
            {
                Balance -= amount;
             
            }
            else
            {
                Console.WriteLine("you dont have enough money");
            }
        }


        public void Transfer(decimal amount, Account account)
            
        {

 //witdh from this acc and deposit in anthor acc
 if (amount <= Balance)
            {

this.Withdraw(amount);  // withdraw from account 

                account.deposit(amount);    // deposit in anthor account 
            }

            else
            {
                Console.WriteLine(" Transfer failed");
            }

        }

        public virtual decimal CalculateInterest() => 0;

    }
    public class SavingAccount : Account
    {
        public decimal InterestRate { get; set; }
      
        public SavingAccount(decimal interestRate) : base()
        {
            InterestRate = interestRate;
        }

        public override decimal CalculateInterest()
        {
            return Balance * InterestRate / 100;
        }

      

    }

    class CurrentAccount : Account
    {

        public decimal OverdraftLimit { get; set; }
        public CurrentAccount(decimal overdraftlimit) : base()

        {

            OverdraftLimit = overdraftlimit;

        }
        public override decimal CalculateInterest()
        {
            return 0;
        }


    }
}
   
