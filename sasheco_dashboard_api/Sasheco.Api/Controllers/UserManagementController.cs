using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Sasheco.Application.UserManagement.DTOs;
using Sasheco.Domain.Entities;
using Sasheco.Infrastructure.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace Sasheco.Api.Controllers
{
    [ApiController]
    [Route("api/user_management")]
    [Authorize(Policy = "RequireAdminRole")]
    public class UserManagementController : ControllerBase
    {
        private readonly SashecoDbContext _context;

        public UserManagementController(SashecoDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<UserDTO>>> GetAllUsers(CancellationToken cancellationToken)
        {
            var users = await _context.Users
                .Include(u => u.Role)
                .Select(u => new UserDTO
                {
                    Id = u.Id,
                    Email = u.Email,
                    FirstName = u.FirstName,
                    LastName = u.LastName,
                    Role = u.Role != null ? u.Role.Name : string.Empty,
                    IsActive = u.IsActive,
                    CreatedAt = u.CreatedAt
                })
                .ToListAsync(cancellationToken);
            
            return Ok(users);
        }

        [HttpGet("{id:guid}")]
        public async Task<ActionResult<UserDTO>> GetUserById(Guid id, CancellationToken cancellationToken)
        {
            var user = await _context.Users
                .Include(u => u.Role)
                .Where(u => u.Id == id)
                .Select(u => new UserDTO
                {
                    Id = u.Id,
                    Email = u.Email,
                    FirstName = u.FirstName,
                    LastName = u.LastName,
                    Role = u.Role != null ? u.Role.Name : string.Empty,
                    IsActive = u.IsActive,
                    CreatedAt = u.CreatedAt
                })
                .FirstOrDefaultAsync(cancellationToken);
            
            if (user == null) return NotFound();

            return Ok(user);
        }

        [HttpPost]
        public async Task<ActionResult<UserDTO>> CreateUser([FromBody] CreateUserDTO createUserDto, CancellationToken cancellationToken)
        {
            var role = await _context.Roles.FirstOrDefaultAsync(r => r.Name == createUserDto.Role, cancellationToken);
            
            var user = new User
            {
                Id = Guid.NewGuid(),
                Email = createUserDto.Email,
                FirstName = createUserDto.FirstName,
                LastName = createUserDto.LastName,
                Name = $"{createUserDto.FirstName} {createUserDto.LastName}",
                PasswordHash = BCrypt.Net.BCrypt.HashPassword(createUserDto.Password),
                IsActive = true,
                CreatedAt = DateTime.UtcNow
            };

            if (role == null)
            {
                role = await _context.Roles.FirstOrDefaultAsync(cancellationToken);
            }

            if (role != null)
            {
                user.RoleId = role.Id;
            }

            _context.Users.Add(user);
            await _context.SaveChangesAsync(cancellationToken);

            var dto = new UserDTO
            {
                Id = user.Id,
                Email = user.Email,
                FirstName = user.FirstName,
                LastName = user.LastName,
                Role = role != null ? role.Name : string.Empty,
                IsActive = user.IsActive,
                CreatedAt = user.CreatedAt
            };
            
            return CreatedAtAction(nameof(GetUserById), new { id = user.Id }, dto);
        }

        [HttpPut("{id:guid}")]
        public async Task<IActionResult> UpdateUser(Guid id, [FromBody] UpdateUserDTO updateUserDto, CancellationToken cancellationToken)
        {
            var user = await _context.Users.Include(u => u.Role).FirstOrDefaultAsync(u => u.Id == id, cancellationToken);
            if (user == null) return NotFound();

            if (!string.IsNullOrEmpty(updateUserDto.FirstName)) user.FirstName = updateUserDto.FirstName;
            if (!string.IsNullOrEmpty(updateUserDto.LastName)) user.LastName = updateUserDto.LastName;
            user.Name = $"{user.FirstName} {user.LastName}";

            if (updateUserDto.IsActive.HasValue)
            {
                user.IsActive = updateUserDto.IsActive.Value;
            }

            if (!string.IsNullOrEmpty(updateUserDto.Role))
            {
                var role = await _context.Roles.FirstOrDefaultAsync(r => r.Name == updateUserDto.Role, cancellationToken);
                if (role != null)
                {
                    user.RoleId = role.Id;
                }
            }

            await _context.SaveChangesAsync(cancellationToken);
            return NoContent();
        }

        [HttpDelete("{id:guid}")]
        public async Task<IActionResult> DeleteUser(Guid id, CancellationToken cancellationToken)
        {
            var user = await _context.Users.FindAsync(new object[] { id }, cancellationToken);
            if (user == null) return NotFound();

            _context.Users.Remove(user);
            await _context.SaveChangesAsync(cancellationToken);

            return NoContent();
        }
    }
}
