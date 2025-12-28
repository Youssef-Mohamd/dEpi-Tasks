using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TMS.App.Dtos
{
    public class TaskDto
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime DueDate { get; set; }
        public bool IsCompleted { get; internal set; }
        public int UserId { get; internal set; }
    }

    public class CreateTaskDto
    {
        public required string Title { get; set; }
        public string? Description { get; set; }
        public DateTime DueDate { get; set; }
        public int UserId { get; set; }

    }

    public class UpdateTaskDto
    {
        [Required]
        [StringLength(200)]
        public required string Title { get; set; }

        [StringLength(1000)]
        public string? Description { get; set; }

        public DateTime? DueDate { get; set; }

        public bool IsCompleted { get; set; }
    }
}
