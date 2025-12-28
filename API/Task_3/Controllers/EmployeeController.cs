using System;
using Api_Task__2.Models;
using Api_Task__2.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Api_Task__2.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        private readonly IEmployeeService _service;

        public EmployeeController(IEmployeeService service)
        {
            _service = service;
        }

        [HttpGet]
        public async Task<IActionResult>GetAll()
        {
            var employees = await _service.GetAllAsync();
            return Ok(employees);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult>GetById(int id)
        {
           
            var employee = await _service.GetByIdAsync(id);
            return Ok(employee);
        }

        [HttpPost]
        public async Task<IActionResult>Add(Employee employee)
        {
            var created = await _service.AddAsync(employee);
            return Ok(created);

        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, Employee employee)
        {
            var updated = await _service.UpdateAsync(id, employee);
            return Ok(updated);
        }

        [HttpDelete]
        public async Task<IActionResult> Delete(int id)
        {
            await _service.DeleteAsync(id);
            return NoContent();
        }

    }
}
