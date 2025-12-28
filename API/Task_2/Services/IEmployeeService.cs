using Api_Task__2.Models;

namespace Api_Task__2.Services
{
    public interface IEmployeeService
    {
        Task<IEnumerable<Employee>> GetAllAsync();
        Task<Employee?> GetByIdAsync(int id);
        Task<Employee> AddAsync(Employee employee);
        Task<Employee?> UpdateAsync(int id, Employee employee);
        Task<bool> DeleteAsync(int id);
    }


}
