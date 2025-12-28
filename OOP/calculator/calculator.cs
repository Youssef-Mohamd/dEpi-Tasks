namespace ConsoleApp2
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Console.Write("Hello! \n Input the first number : ");
            int num1 = Convert.ToInt32(Console.ReadLine());

            Console.Write(" Input the second number : ");
            int num2 = Convert.ToInt32(Console.ReadLine());
            // Console.ReadKey();
            Console.WriteLine(" \n ");

            Console.WriteLine("What do you want to do with those numbers ? ");
            Console.WriteLine("[A]dd");
            Console.WriteLine("[S]ubtract");
            Console.WriteLine("[M]ultiply");
            Console.WriteLine("chose process: ");
            string choice = Console.ReadLine();

            //Console.ReadKey();
            double result;
            if (choice == "A" || choice == "a")
            {
                result = num1 + num2;
                Console.WriteLine($"Result: {num1} + {num2} = {result}");
            }
            else if (choice == "S" || choice == "s")
            {
                result = num1 - num2;
                Console.WriteLine($"Result: {num1} - {num2} = {result}");
            }
            else if (choice == "M" || choice == "m")
            {
                result = num1 * num2;
                Console.WriteLine($"Result: {num1} * {num2} = {result}");
            }
            else
            {
                Console.WriteLine("\n Invalid choice");
            }

            Console.ReadKey();
        }
    }
}
    


