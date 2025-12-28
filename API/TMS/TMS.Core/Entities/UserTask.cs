using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TMS.Core.Entities
{
    public class UserTask
    {
        public  int Id { get; set; }
        public required string Title { get; set; } 
        public required string Description { get; set; }

        public DateTime? DueDate { get; set; }

        // Relationship
        public int UserId { get; set; }
        public User User { get; set; }
        public bool IsCompleted { get; set; }
    }
}
