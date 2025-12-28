namespace Api_Task__2.Models
{
    public class Employee
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public decimal Salary { get; set; }
        public int Age { get; set; }


        public Employee(int id, string name, int age, decimal salary)
        {
            Id = id;
            Name = name;
            Age = age;
            Salary = salary;
        }
    }


}
