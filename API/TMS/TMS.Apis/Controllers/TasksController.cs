using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using TMS.App.Dtos;
using TMS.App.Interfaces;
using TMS.App.Services;
namespace TMS.Apis.Controllers

{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class TasksController: ControllerBase
    {
        private readonly ITaskService _taskService; 

        public TasksController ( ITaskService userService)
        {
            _taskService = userService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var tasks = await _taskService.GetAllTasks();
            return Ok(tasks);
        }

        [HttpGet("{id}")]
        public async Task <IActionResult> GetById(int id)
        {
            var task = await _taskService.GetTaskByIdAsync(id);
            if (task == null)
                return NotFound(); // 404
            return Ok(task);
        }

        [HttpPost]
        public async Task<IActionResult> Create([FromBody] CreateTaskDto dto)
        {
            var newTask = await _taskService.CreateTaskAsync(dto);
            return CreatedAtAction(nameof(GetById), new { id = newTask.Id }, newTask);
            // 201 Created + Location Header + Task
        }

        [HttpPut("{id}")] // ✅ إضافة Update
        public async Task<IActionResult> Update(int id, [FromBody] UpdateTaskDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            try
            {
                var updated = await _taskService.UpdateTaskAsync(id, dto);
                if (updated == null)
                    return NotFound(new { message = "Task not found" });
                return Ok(updated);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var deleted = await _taskService.DeleteTaskAsync(id);
            if (!deleted)
                return NotFound(); // 404
            return NoContent(); // 204 No Content
        }
    }
}