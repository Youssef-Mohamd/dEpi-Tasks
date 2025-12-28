using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace examination_system
{
    public class Course
    {
        public string Title { get; set; }
        public string Description { get; set; }
        public double MaxDegree { get; set; }

        List<Student> students = new List<Student>();
        List<Instructor> instructors = new List<Instructor>();



        public Course(string title, string desc, double degree)
        
        { 
        
        Title = title;  
            Description = desc;
            MaxDegree = degree;


      
        
        }
    }
}
