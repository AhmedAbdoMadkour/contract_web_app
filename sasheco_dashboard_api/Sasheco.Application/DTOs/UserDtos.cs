namespace Sasheco.Application.DTOs;

public record CreateUserRequest(string EmployeeNumber, string Name, string Password, string Position, Guid RoleId);
public record UserDto(Guid Id, string EmployeeNumber, string Name, string Position, Guid RoleId);
public record PermissionDto(Guid Id, string Name, string Description);
