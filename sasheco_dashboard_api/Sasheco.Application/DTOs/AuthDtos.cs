namespace Sasheco.Application.DTOs;

public record LoginRequest(string EmployeeNumber, string Password);
public record LoginResponse(string Token, UserDto User);

public record ChangePasswordRequest(string Email, string CurrentPassword, string NewPassword);

