using FluentValidation;
using Sasheco.Application.DTOs;

namespace Sasheco.Application.Validators;

public class LoginRequestValidator : AbstractValidator<LoginRequest>
{
    public LoginRequestValidator()
    {
        RuleFor(x => x.EmployeeNumber).NotEmpty().WithMessage("Employee number is required.");
        RuleFor(x => x.Password).NotEmpty().WithMessage("Password is required.");
    }
}
