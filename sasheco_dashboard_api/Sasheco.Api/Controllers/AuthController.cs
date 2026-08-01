using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Sasheco.Application.DTOs;
using Sasheco.Application.Interfaces;
using Sasheco.Domain.Interfaces;
using FluentValidation;

namespace Sasheco.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly IUserRepository _userRepository;
    private readonly IJwtService _jwtService;
    private readonly IValidator<LoginRequest> _loginValidator;
    private readonly Sasheco.Api.Services.ILocaleProvider _localeProvider;

    public AuthController(
        IUserRepository userRepository, 
        IJwtService jwtService,
        IValidator<LoginRequest> loginValidator,
        Sasheco.Api.Services.ILocaleProvider localeProvider)
    {
        _userRepository = userRepository;
        _jwtService = jwtService;
        _loginValidator = loginValidator;
        _localeProvider = localeProvider;
    }

    [HttpPost("login")]
    [AllowAnonymous]
    public async Task<IActionResult> Login([FromBody] LoginRequest request)
    {
        var validationResult = await _loginValidator.ValidateAsync(request);
        if (!validationResult.IsValid)
        {
            return BadRequest(validationResult.Errors);
        }

        var user = await _userRepository.GetByEmployeeNumberAsync(request.EmployeeNumber);

        if (user == null || !BCrypt.Net.BCrypt.Verify(request.Password, user.PasswordHash))
        {
            return Unauthorized(new { message = "Invalid credentials" });
        }

        var token = _jwtService.GenerateToken(user);
        
        var position = _localeProvider.IsArabic ? user.PositionAr : user.PositionEn;
        var userDto = new UserDto(user.Id, user.EmployeeNumber, user.Name, position, user.RoleId);
        var response = new LoginResponse(token, userDto);

        return Ok(response);
    }
}
