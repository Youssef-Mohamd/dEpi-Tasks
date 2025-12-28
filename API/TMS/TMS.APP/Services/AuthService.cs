using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using TMS.App.Dtos;
using TMS.App.Interfaces;
using TMS.Core.Entities;
using TMS.infra.Data;

namespace TMS.App.Services
{
    public class AuthService : IAuthService
    {

        private readonly AppDbContext _context;
        private readonly IConfiguration _config;

        public AuthService(AppDbContext context, IConfiguration config)
        {
            _context = context;
            _config = config;
        }

        public string GenerateJwtToken(User user)
        {
           
            var key = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(_config["Jwt:Key"]!)
            );

           // البيانات اللي هتتحط في الـ Token
            var claims = new[]
            {
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(ClaimTypes.Email, user.Email),
                new Claim(ClaimTypes.Name, user.Username)
            };

            
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            //ـToken
            var token = new JwtSecurityToken(
                issuer: _config["Jwt:Issuer"],
                audience: _config["Jwt:Audience"],
                claims: claims,
                expires: DateTime.UtcNow.AddMinutes(30),
                signingCredentials: creds
            );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
    

        public async Task<UserDto?> GetCurrentUserAsync(int userId)
        {
            var user = await _context.Users.FindAsync(userId);

            if (user == null) return null;
            return new UserDto
            {
                Id = user.Id,
                Username = user.Username,
                Email = user.Email
            };
        }

        public async Task<LoginResponse?> LoginAsync(Login dto)
        {
           var user = await _context.Users
                .FirstOrDefaultAsync(u => u.Email == dto.Email && u.Password == dto.Password);
            if (user == null) return null;
            var token = GenerateJwtToken(user);
            return new LoginResponse
            {
                
                User = new UserDto
                {
                    Id = user.Id,
                    Username = user.Username,
                    Email = user.Email
                },
                Token = token,
               ExpiresAt = DateTime.Now.AddHours(1)
            };
        }
    }
}
