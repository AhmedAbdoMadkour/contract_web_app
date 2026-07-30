using FluentValidation;
using Sasheco.Application.DTOs;

namespace Sasheco.Application.Validators;

public class CreateUserRequestValidator : AbstractValidator<CreateUserRequest>
{
    public CreateUserRequestValidator()
    {
        RuleFor(x => x.EmployeeNumber).NotEmpty().WithMessage("Employee number is required.");
        RuleFor(x => x.Name).NotEmpty().WithMessage("Name is required.");
        RuleFor(x => x.Password).NotEmpty().MinimumLength(6).WithMessage("Password must be at least 6 characters.");
        RuleFor(x => x.RoleId).NotEmpty().WithMessage("Role is required.");
    }
}
