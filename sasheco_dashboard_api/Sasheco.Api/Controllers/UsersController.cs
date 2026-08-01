using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Sasheco.Application.DTOs;
using Sasheco.Domain.Entities;
using Sasheco.Domain.Interfaces;
using FluentValidation;
using System.Security.Claims;

namespace Sasheco.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class UsersController : ControllerBase
{
    private readonly IUserRepository _userRepository;
    private readonly IValidator<CreateUserRequest> _createUserValidator;
    private readonly Sasheco.Api.Services.ILocaleProvider _localeProvider;

    public UsersController(
        IUserRepository userRepository,
        IValidator<CreateUserRequest> createUserValidator,
        Sasheco.Api.Services.ILocaleProvider localeProvider)
    {
        _userRepository = userRepository;
        _createUserValidator = createUserValidator;
        _localeProvider = localeProvider;
    }

    [HttpPost]
    [Authorize(Roles = "Admin")]
    public async Task<IActionResult> CreateUser([FromBody] CreateUserRequest request)
    {
        var validationResult = await _createUserValidator.ValidateAsync(request);
        if (!validationResult.IsValid)
        {
            return BadRequest(validationResult.Errors);
        }

        var existingUser = await _userRepository.GetByEmployeeNumberAsync(request.EmployeeNumber);
        if (existingUser != null)
        {
            return Conflict(new { message = "Employee number already exists." });
        }

        var user = new User
        {
            Id = Guid.NewGuid(),
            EmployeeNumber = request.EmployeeNumber,
            Name = request.Name,
            PasswordHash = request.Password, // Should be hashed in production
            PositionEn = request.Position,
            PositionAr = request.Position,
            RoleId = request.RoleId
        };

        await _userRepository.AddAsync(user);

        var position = _localeProvider.IsArabic ? user.PositionAr : user.PositionEn;
        var userDto = new UserDto(user.Id, user.EmployeeNumber, user.Name, position, user.RoleId);
        return CreatedAtAction(nameof(GetPermissions), new { id = user.Id }, userDto);
    }

    [HttpGet("permissions")]
    [Authorize]
    public async Task<IActionResult> GetPermissions()
    {
        var userIdString = User.FindFirstValue(ClaimTypes.NameIdentifier);
        if (!Guid.TryParse(userIdString, out Guid userId))
        {
            return Unauthorized();
        }

        var permissions = await _userRepository.GetUserPermissionsAsync(userId);
        var permissionDtos = permissions.Select(p => new PermissionDto(
            p.Id, 
            _localeProvider.IsArabic ? p.NameAr : p.NameEn, 
            _localeProvider.IsArabic ? p.DescriptionAr : p.DescriptionEn));

        return Ok(permissionDtos);
    }
}
