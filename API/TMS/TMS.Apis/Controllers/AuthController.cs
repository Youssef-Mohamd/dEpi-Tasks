using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using TMS.App.Dtos;
using TMS.App.Interfaces;

namespace TMS.Apis.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly IAuthService _authService;
        private readonly IUserService _userService;

        public AuthController(IAuthService authService, IUserService userService)
        {
            _authService = authService;
            _userService = userService;
        }

        // Register

        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] CreateUserDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            try
            {
                var user = await _userService.CreateUserAsync(dto);
                return CreatedAtAction(nameof(GetCurrentUser), null, user);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        // Login    

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] Login dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var result = await _authService.LoginAsync(dto);

            if (result == null)
                return Unauthorized(new { message = "Invalid email or password" });

            return Ok(result);
        }




        [HttpGet("me")]
        [Authorize]
        public async Task<IActionResult> GetCurrentUser()
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            if (userIdClaim == null || !int.TryParse(userIdClaim, out int userId))
                return Unauthorized();

            var user = await _authService.GetCurrentUserAsync(userId);

            if (user == null)
                return NotFound(new { message = "User not found" });

            return Ok(user);
        }







    }

}
