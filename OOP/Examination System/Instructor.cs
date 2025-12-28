using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace examination_system
{
    public
        class Instructor
    {
        private static int _counter = 1;
        public int ID { get; }
        public string Name { get; set; }
        public string Specialization { get; set; }
        List<Course> course { get; set; } = new List<Course>();


           public Instructor( string name, string spec)
               {

                ID = _counter++;
                Name=name;
                Specialization=spec;

              }





    }

}




