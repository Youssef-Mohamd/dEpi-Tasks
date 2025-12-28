using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TMS.App.Dtos;

namespace TMS.App.Interfaces
{
    public interface ITaskService
    {

        Task<IEnumerable<TaskDto>> GetAllTasks();
        Task<TaskDto> GetTaskByIdAsync(int id);
        Task<TaskDto> CreateTaskAsync(CreateTaskDto dto);

        Task<TaskDto?> UpdateTaskAsync(int id, UpdateTaskDto dto);
        Task<bool> DeleteTaskAsync(int id);
    }
}
