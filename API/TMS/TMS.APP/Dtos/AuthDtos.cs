using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TMS.App.Dtos
{
    public class Login
    {
        [Required]
        [EmailAddress]
        public required string Email { get; set; }

        [Required]
        public required string Password { get; set; }
    }


    public class LoginResponse
    {
        public required string Token { get; set; }
        public required UserDto User { get; set; }
        public DateTime ExpiresAt { get; set; }
    }
}
