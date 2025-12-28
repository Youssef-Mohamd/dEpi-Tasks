using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TMS.App.Dtos;
using TMS.Core.Entities;

namespace TMS.App.Interfaces
{
    public interface IAuthService
    {
        Task<LoginResponse?> LoginAsync(Login dto);
        Task<UserDto?> GetCurrentUserAsync(int userId);
        string GenerateJwtToken(User user);
    }

}
