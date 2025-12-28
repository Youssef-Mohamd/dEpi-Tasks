using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using TMS.App.Dtos;
using TMS.App.Interfaces;
using TMS.Core.Entities;
using TMS.infra.Data;

namespace TMS.App.Services
{
    public class TaskService : ITaskService
    {
        private readonly AppDbContext _context;

        public TaskService(AppDbContext context)
        {
            _context = context;
        }

       

        public async Task<TaskDto> CreateTaskAsync(CreateTaskDto dto)
        {
            // check إن اليوزر موجود
            var user = await _context.Users.FindAsync(dto.UserId);
            if (user == null)
                throw new Exception("User not found"); 

            var task = new UserTask
            {
                Title = dto.Title,
                Description = dto.Description,
                DueDate = dto.DueDate,
                IsCompleted = false,
                UserId = dto.UserId   
            };

            _context.Tasks.Add(task);
            await _context.SaveChangesAsync();

            return new TaskDto
            {
                Id = task.Id,
                Title = task.Title,
                Description = task.Description,
                DueDate = (DateTime)task.DueDate,
                IsCompleted = task.IsCompleted,
                UserId = task.UserId
            };
        }

        public async Task<bool> DeleteTaskAsync(int id)
        {
            var task = await _context.Tasks.FindAsync(id);
            if (task == null) return false;
        
            _context.Tasks.Remove(task);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<IEnumerable<TaskDto>> GetAllTasks()
        {
            return await _context.Tasks
            .Select(t => new TaskDto
            {
                Id = t.Id,
                Title = t.Title,
                Description = t.Description,
                DueDate = (DateTime)t.DueDate,
                IsCompleted = t.IsCompleted
            })
            .ToListAsync();
        }

        public async Task<TaskDto?> GetTaskByIdAsync(int id)
        {
            var task = await _context.Tasks.FindAsync(id);
            return task == null ? null :  new TaskDto
            {
                Id = task.Id,
                Title = task.Title,
                Description = task.Description,
                DueDate = (DateTime)task.DueDate,
                IsCompleted = task.IsCompleted
            };
        }

        public async Task<TaskDto?> UpdateTaskAsync(int id, UpdateTaskDto dto)
        {
            var task = await _context.Tasks.FindAsync(id);

            if (task == null)
                return null;

            // تحديث البيانات
            task.Title = dto.Title;
            task.Description = dto.Description ?? string.Empty;
            task.DueDate = dto.DueDate;
            task.IsCompleted = dto.IsCompleted;

            await _context.SaveChangesAsync();

            return new TaskDto
            {
                Id = task.Id,
                Title = task.Title,
                Description = task.Description,
                DueDate = (DateTime)task.DueDate,
                IsCompleted = task.IsCompleted,
                UserId = task.UserId
            };
        }
    }
}
