using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using TMS.App.Interfaces;
using TMS.App.Services;
using TMS.App.Dtos;
using Microsoft.AspNetCore.Authorization;
///using TMS.App.Data;
namespace TMS.Apis.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class UserController : ControllerBase
    {
        private readonly IUserService _userService;

        public UserController(IUserService userService)
        {
            _userService = userService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var users = await _userService.GetAllUsersAsync();
            return Ok(users);
        }

        [HttpGet("id")]

        public async Task <IActionResult> GetById(int id)
        {

            {
                var user = await _userService.GetUserByIdAsync(id);
                if (user == null) return NotFound();
                return Ok(user);
            }
        }

        [HttpPost]
        public async Task<IActionResult> Create([FromBody] CreateUserDto dto)
        {
            var newUser = await _userService.CreateUserAsync(dto);
            return CreatedAtAction(nameof(GetById), new { id = newUser.Id }, newUser);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, [FromBody] UpdateUserDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            try
            {
                var updatedUser = await _userService.UpdateUserAsync(id, dto);

                if (updatedUser == null)
                    return NotFound(new { message = "User not found" });

                return Ok(updatedUser);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var deleted = await _userService.DeleteUserAsync(id);
            if (!deleted) return NotFound();
            return NoContent();
        }

    }
}
