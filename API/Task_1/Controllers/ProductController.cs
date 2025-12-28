using System.Reflection.Metadata.Ecma335;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using WebApplication1.Data;

namespace WebApplication1.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductController : ControllerBase
    {

        private readonly ApplicationDbcontext _context;

        public ProductController(ApplicationDbcontext context)
        {
            _context = context;
        }

        [HttpPost]

        public async Task<ActionResult<Product>> CraeteProduct(Product product)
        {
            _context.Products.Add(product);
            await _context.SaveChangesAsync();
            return Ok();
        }


        [HttpGet]
        public async Task<ActionResult<Product>> GetProd([FromQuery] int id)
        {
            var product = await _context.Products.FindAsync(id);
            return Ok(product);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Product>> GetProduct(int id)
        {
            var product = await _context.Products.FindAsync(id);
            return Ok(product);
        }



        [HttpDelete("{id}")]
        public async Task<ActionResult<Product>> DeleteProduct(int id)
        {
            var product = await _context.Products.FindAsync(id);
            _context.Products.Remove(product);
            await _context.SaveChangesAsync();
            return NoContent();

        }



        [HttpPut("{id}")]
        public async Task<ActionResult<Product>> UpdateProduct(int id, Product p)
        {

            var product = await _context.Products.FindAsync(id);

            _context.Products.Update(product);
                product.Name   = p.Name;
                product.Price = p.Price;

            await _context.SaveChangesAsync();
            return Ok();
        }
    }      
}
