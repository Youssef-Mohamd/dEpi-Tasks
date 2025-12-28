using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TMS.Core.Entities
{
    public class User
    {
        public int Id { get; set; }
        public required string Username { get; set; }
        public required string Email { get; set; } 
        public  required string Password { get; set; } 
        public ICollection<UserTask> Tasks { get; set; } = new List<UserTask>();
    }
}
