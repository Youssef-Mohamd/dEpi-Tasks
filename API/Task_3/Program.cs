
using Api_Task__2.Models;
using Api_Task__2.Services;
using Microsoft.EntityFrameworkCore;
using Middelware.Middlewares;

namespace Middelware
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.

            builder.Services.AddControllers();
            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen();
            builder.Services.AddTransient<RequestLoggingMiddleware>();
           

            builder.Services.AddDbContext<AppDbcontext>(options =>
options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

            builder.Services.AddScoped<IEmployeeService, EmployeeService>();
            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI();
            }
            app.UseMiddleware<RequestLoggingMiddleware>();
            app.UseMiddleware<PrintMiddleware>();   
            app.UseHttpsRedirection();

            app.UseAuthorization();


            app.MapControllers();

            var employees = new List<Employee>
{
    new Employee(1, "Ali", 25, 5000),
    new Employee(2, "Omar", 30, 7000),
    new Employee(3, "Mona", 28, 6000),
    new Employee(4, "Sara", 35, 9000)
};



            app.MapGet("/employees/search", (string? name, int? age, decimal? salary) =>
            {
                var result = employees.AsQueryable();

                if (!string.IsNullOrEmpty(name))
                    result = result.Where(e => e.Name.Contains(name, StringComparison.OrdinalIgnoreCase));

                if (age.HasValue)
                    result = result.Where(e => e.Age == age.Value);

                if (salary.HasValue)
                    result = result.Where(e => e.Salary == salary.Value);

                return result.ToList();
            });
            app.MapGet("/employees/name/{name}", (string name) =>
            {
                return employees
                    .Where(e => e.Name.Contains(name, StringComparison.OrdinalIgnoreCase))
                    .ToList();
            });


            app.MapGet("/employees/age/{age:int}", (int age) =>
    employees.Where(e => e.Age == age));

            app.Run();
        }
    }
}
