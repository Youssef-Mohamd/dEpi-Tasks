using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using TMS.App.Interfaces;
using TMS.App.Dtos;
using TMS.Core.Entities;
using TMS.infra.Data;
namespace TMS.App.Services
{
    public class UserService : IUserService
    {
        private readonly AppDbContext _context;

        public UserService(AppDbContext context)
        {
            _context = context;
        }

        public async Task<UserDto> CreateUserAsync(CreateUserDto dto)
        {
            var user = new User
            {
                Username = dto.Username,
                Email = dto.Email,
                Password = dto.Password 
            };

            _context.Users.Add(user);
            await _context.SaveChangesAsync();

            return new UserDto
            {
                Id = user.Id,
                Username = user.Username,
                Email = user.Email
            };
        }

        public async Task<bool> DeleteUserAsync(int id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null) return false;
            _context.Users.Remove(user);
            await _context.SaveChangesAsync();
            return true;
        }

        public  async Task<IEnumerable<UserDto>> GetAllUsersAsync()
        {
            return await _context.Users
           .Select(u => new UserDto
           {
               Id = u.Id,
               Username = u.Username,
               Email = u.Email
           })
           .ToListAsync();
        }

        public async Task<UserDto?> GetUserByIdAsync(int id)
        {
            var user = await _context.Users.FindAsync(id);
           // if (user == null) return null;
            return user == null ? null:
             new UserDto
            {
                Id = user.Id,
                Username = user.Username,
                Email = user.Email
            };
        }


        public async Task<UserDto?> UpdateUserAsync(int id, UpdateUserDto dto)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null) return null;

            // تحقق من عدم تكرار البريد (إلا لو نفس المستخدم)
            if (await _context.Users.AnyAsync(u => u.Email == dto.Email && u.Id != id))
                throw new Exception("Email already exists");

            if (await _context.Users.AnyAsync(u => u.Username == dto.Username && u.Id != id))
                throw new Exception("Username already exists");

            user.Username = dto.Username;
            user.Email = dto.Email;

            await _context.SaveChangesAsync();

            return new UserDto
            {
                Id = user.Id,
                Username = user.Username,
                Email = user.Email
            };
        }
    }
 
}
