namespace Middelware.Middlewares
{
    public class PrintMiddleware
    {
   
    private readonly RequestDelegate _next;
    public PrintMiddleware (RequestDelegate next)
    {
        _next = next;
    }
   
     public async Task Invoke(HttpContext context)
        {
            Console.WriteLine("Hello");
            await _next(context);
        }


    }
}
