using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace examination_system
{
    public class Exam
    {
        public string Title { get; set; }
        public Course Course { get; }
        public List<Question> Questions { get; } = new List<Question>();
        public bool IsStarted { get; private set; }  // cant edit after exam start

        public Exam(string title, Course course)
        {
            Title = title;
            Course = course;
        }








        public void AddQuestion(Question question)
        {
            int currentMarks = Questions.Sum(q => q.Mark);
            if (currentMarks + question.Mark <= Course.MaxDegree)
            {
                Questions.Add(question);
            }
            else
            {
                Console.WriteLine(" Cannot add question");
            }

        }


        public void StartExam()
        {
            IsStarted = true;
            Console.WriteLine($"Exam '{Title}' Started");
        }



        public int CalculateScore(Dictionary<Question, string> studentAnswers)
        {
            int score = 0;

            foreach (var question in Questions)
            {

                if (studentAnswers.ContainsKey(question))
                {
                    string studentAnswer = studentAnswers[question];

                    if (question.CheckAnswer(studentAnswer))
                    {
                        score = score + question.Mark;
                    }
                }
            }

            return score;
        }

    }
}
