namespace Middelware.Middlewares;
using Microsoft.AspNetCore.Http;

public class RequestLoggingMiddleware : IMiddleware
{
      public async Task InvokeAsync(HttpContext context , RequestDelegate next)
        {

            Console.WriteLine($"equest Path:{context.Request.Path}");
            await next(context);

            Console.WriteLine($"Response Status Code: {context.Response.StatusCode}");
        }
    }


