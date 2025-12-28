using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TMS.App.Dtos
{
    public class UserDto
    {
        public int Id { get; set; }
        public string Username { get; set; }
        public string Email { get; set; }

        }

    public class CreateUserDto
    {
        public required string Username { get; set; }
        public required string Email { get; set; }
        public required string Password { get; set; }
    }


    public class UpdateUserDto
    {
        [Required]
        [StringLength(50)]
        public required string Username { get; set; }

        [Required]
        [EmailAddress]
        public required string Email { get; set; }
    }

}
