using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace examination_system
{
    public class Student
    {

        private static int _counter = 1;
        public int ID {get; }
        public string Name {get; set;}
        public string Email { get; set; }    
        public List<Course> courses = new List<Course>();


        public Student(string name,string email)
        {


            ID = _counter++;
            Name = name;
            Email = email;
           

        }




    }
}
