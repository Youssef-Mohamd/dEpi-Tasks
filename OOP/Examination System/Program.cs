using System;
using System.Collections.Generic;

namespace examination_system
{
    internal class Program
    {
        static void Main(string[] args)
        {
           
            Console.Write("Enter Course Title: ");
            string courseTitle = Console.ReadLine();

            Console.Write("Enter Course Description: ");
            string courseDesc = Console.ReadLine();

            Console.Write("Enter Max Degree for the Course: ");
            double maxDegree = double.Parse(Console.ReadLine());

            Course course = new Course(courseTitle, courseDesc, maxDegree);

            // create exam
            Console.Write("Enter Exam Title: ");
            string examTitle = Console.ReadLine();

            Exam exam = new Exam(examTitle, course);

          
            while (true)
            {
                Console.WriteLine("\nChoose Question Type:");
                Console.WriteLine("1. MCQ");
                Console.WriteLine("2. True/False");
                Console.WriteLine("3. Essay");
                Console.WriteLine("4. Done Adding Questions");

                string choice = Console.ReadLine();

                //if (choice == "4") break;

                Console.Write("Enter Question Text: ");
                string qText = Console.ReadLine();

                Console.Write("Enter Question Mark: ");
                int qMark = int.Parse(Console.ReadLine());

                Question question = null;

                if (choice == "1")
                {
                    MCQ mcq = new MCQ { Text = qText, Mark = qMark };

                    Console.Write("How many options? ");
                    int count = int.Parse(Console.ReadLine());

                    for (int i = 0; i < count; i++)
                    {
                        Console.Write($"Option {i + 1}: ");
                        mcq.Options.Add(Console.ReadLine());
                    }

                    Console.Write("Enter Correct Answer: ");
                    mcq.CorrectAnswer = Console.ReadLine();

                    question = mcq;
                }
                else if (choice == "2")
                {
                    TrueFalseQuestion tfq = new TrueFalseQuestion { Text = qText, Mark = qMark };

                    Console.Write("Enter Correct Answer (true/false): ");
                    tfq.Correct = bool.Parse(Console.ReadLine());

                    question = tfq;
                }
                else if (choice == "3")
                {
                    question = new EssayQuestion { Text = qText, Mark = qMark };
                }

                if (question != null)
                {
                    exam.AddQuestion(question);
                }

                if (choice == "4") break;

                

            }

        
            exam.StartExam();

           
            Dictionary<Question, string> studentAnswers = new Dictionary<Question, string>();

            Console.WriteLine("\n--- Answer the Questions ---");
            foreach (var q in exam.Questions)
            {
                Console.WriteLine($"\n{q.Text} (Mark: {q.Mark})");

                if (q is MCQ mcqQ)
                {
                    for (int i = 0; i < mcqQ.Options.Count; i++)
                    {
                        Console.WriteLine($"{i + 1}. {mcqQ.Options[i]}");
                    }
                }

                Console.Write("Your Answer: ");
                string answer = Console.ReadLine();

                studentAnswers[q] = answer;
            }

           // calculate final score
            int finalScore = exam.CalculateScore(studentAnswers);

            Console.WriteLine($"\nExam Finished! Your Score = {finalScore}/{course.MaxDegree}");
        }
    }
}

