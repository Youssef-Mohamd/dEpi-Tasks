using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace examination_system
{
   public abstract class Question
    {

        public string Text { get; set; }   
        public int Mark { get; set; }      

        public abstract bool CheckAnswer(string answer);



    }     

    public class MCQ : Question
    {


        public List<string> Options { get; } = new List<string>();
        public string CorrectAnswer { get; set; }

        public override bool CheckAnswer(string answer)
        {

            if (Options.Count == 0)
                return false; 

            if (answer == CorrectAnswer)
                return true; 

            return false;

        }
       
       

    }


    public class TrueFalseQuestion : Question
    {
        public bool Correct { get; set; }

        public override bool CheckAnswer(string answer)
        {
            bool Answer = bool.Parse(answer);
            if (Answer == Correct)
            {
                return true;

            }
            else
            {
                return false;
            }


        }
           
    }


    public class EssayQuestion : Question

    {
        public override bool CheckAnswer(string answer)
       => true;
    }

}



