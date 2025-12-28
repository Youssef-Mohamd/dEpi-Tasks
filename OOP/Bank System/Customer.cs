using System;


namespace ConsoleApp4
{


   public class Customer
    {

        public const string UniqueID = "1423";   

        private static int counter = 1;
        public int ID
        {
            get; set;
        }

        public string FullName { get; set; }
        public string NationalID { get; set; }
        public DateTime DateOfBirth { get; set; }

        public decimal Balance;
        public List<Account> Accounts { get; set; } = new List<Account>();

        public Customer(int id, string fullname, string nationalid, DateTime date, decimal balance)
        {

            ID = id;
            FullName = fullname;
            NationalID = nationalid;
            DateOfBirth = date;
            Balance = balance;

        }

        public void Update(string newName, DateTime Newdate)
        {
            FullName = newName;
            DateOfBirth = Newdate;
        }


        public bool removing()
        {

            for (int i = 0; i < Accounts.Count; i++)
            {

                if (Accounts[i].Balance != 0)
                {
                    return false;
                }

            }

            return true;

        }




    }

    }

