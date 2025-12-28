using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System;
using System.Net;
using System.Runtime.InteropServices;

namespace Bank
{

    class BankAccount
    {
        // Fields

        public const string BankCode = "BNK001";


        public DateTime DateTime { get; }
        private int _accountNumber;

        private string _fullName;
        private string _nationalID;
        private string _phoneNumber;
        private string _address;
        private decimal _balance;

        // Properties

        public string FullName //{ get; set; }
        {
            get
            {
                return _fullName;
            }
            set
            {
                if (value == "" || value == null)
                {
                    Console.WriteLine("Full name is required!");
                }
                else

                {
                    _fullName = value;
                }
            }
        }

        public string NationalID
        {
            get
            {
                return _nationalID;
            }

            set
            {

                if (value != null && value.Length == 14)
                {
                    _nationalID = value;
                }
                else
                {
                    Console.WriteLine("National ID must be 14 digits.");
                }
            }

        }

        public string PhoneNumber
        {
            get
            {
                return _phoneNumber;
            }
            set
            {
                if (value != null && value.StartsWith("01") && value.Length == 11)
                {
                    _phoneNumber = value;
                }
                else
                {
                    Console.WriteLine("Phone number must start with '01' and be 11 digits.");
                }
            }
        }


        public string Address
        {
            get
            {
                return _address;
            }
            set
            {
                _address = value;
            }
        }

        public decimal Balance

        {
            get
            {
                return _balance;
            }
            set
            {
                if (value >= 0)
                {
                    _balance = value;
                }
                else
                {
                    Console.WriteLine("Balance cannot  negative");
                }
            }
        }


        public BankAccount()

        {

            DateTime = DateTime.Now; ;
            _accountNumber = 10000000;
            FullName = "YOUSSEF MOHAMED";
            NationalID = "1234567";
            PhoneNumber = "0104356870";
            Address = "BENHA";
            Balance = 0;


        }


        public BankAccount(string fullName, string nationalID, string phoneNumber, string address, decimal balance)
        {
            DateTime = DateTime.Now;
            _accountNumber = _accountNumber;
            FullName = fullName;
            NationalID = nationalID;
            PhoneNumber = phoneNumber;
            Address = address;
            Balance = balance;


        }


        // overlod constructor

        public BankAccount(string fullName, string nationalID, string phoneNumber, string address)
    : this(fullName, nationalID, phoneNumber, address, 0m)
        {

            DateTime = DateTime.Now;
            _accountNumber = _accountNumber;
            FullName = fullName;
            NationalID = nationalID;
            PhoneNumber = phoneNumber;
            Address = address;
            Balance = _balance;

        }

        public virtual decimal CalculateInterest() => 0;


        public  virtual void ShowAccountDetails()
        {


            Console.WriteLine("Account Details ");
            Console.WriteLine($"Bank Code     : {BankCode}");
            Console.WriteLine($"Created Date  : {DateTime}");
            Console.WriteLine($"Account Number: {_accountNumber}");
            Console.WriteLine($"Full Name     : {FullName}");
            Console.WriteLine($"National ID   : {NationalID}");
            Console.WriteLine($"Phone Number  : {PhoneNumber}");
            Console.WriteLine($"Address       : {Address}");
            Console.WriteLine($"Balance       : {Balance:C}");
            Console.WriteLine();

        }

        public bool IsValidNationalID()
        {
            return NationalID.Length == 14;
        }

        public bool IsValidPhoneNumber()
        {
            return PhoneNumber.Length == 11;
        }

    }
    //internal class Program
    //{
    //    static void Main(string[] args)
    //    {

    //        BankAccount bank1 = new BankAccount();
    //        BankAccount bank2 = new BankAccount("yousef", "62523763534567", "01211020654", "banha", 600);
    //        bank1.ShowAccountDetails();
    //        Console.WriteLine("----------------------------------");
    //        bank2.ShowAccountDetails();
    //        Console.WriteLine("----------------------------------");
    //        bank1.ShowAccountDetails();




    //    }
    //}
}
