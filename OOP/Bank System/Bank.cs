using System;


namespace ConsoleApp4
{
    internal class Bank
    {

        public string Name { get; set; }
        public string BranchCode { get; set; }
        public List<Customer> Customers { get; set; }  

        public Bank(string name, string branch)
        {
            Name = name;
            BranchCode = branch;
           Customers = new List<Customer>();

        }




    }
}
