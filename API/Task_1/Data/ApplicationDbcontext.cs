using Microsoft.EntityFrameworkCore;

namespace WebApplication1.Data
{
    public class ApplicationDbcontext : DbContext
    {
        public ApplicationDbcontext(DbContextOptions<ApplicationDbcontext> options) : base(options)
        {

        }




        public DbSet<Product> Products { get; set; }

    }
}
