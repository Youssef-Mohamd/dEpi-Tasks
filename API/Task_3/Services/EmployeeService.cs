using System;
using Microsoft.EntityFrameworkCore;
using Api_Task__2.Models;

namespace Api_Task__2.Services
{
    public class EmployeeService : IEmployeeService
    {
        private readonly AppDbcontext _context;

        public EmployeeService(AppDbcontext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Employee>> GetAllAsync()
        {
            return await _context.Employees.ToListAsync();
        }

        public async Task<Employee?> GetByIdAsync(int id)
        {
            return await _context.Employees.FindAsync(id);
        }

        public async Task<Employee> AddAsync(Employee employee)
        {
            _context.Employees.Add(employee);
            await _context.SaveChangesAsync();
            return employee;
        }

        public async Task<Employee> UpdateAsync(int id, Employee employee)
        {
            employee.Id = id;                     
            _context.Employees.Update(employee);  
            await _context.SaveChangesAsync();
            return employee;
        }


     


        public async Task<bool> DeleteAsync(int id)
        {
            var emp = await _context.Employees.FindAsync(id);

            if (emp == null)
                return false;

            _context.Employees.Remove(emp);
            await _context.SaveChangesAsync();
            return true;
        }


    }
}


