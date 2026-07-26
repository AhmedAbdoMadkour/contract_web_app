using FluentValidation;
using Sasheco.Application.Engineering.DTOs;

namespace Sasheco.Application.Engineering.Validators;

public class UpdateProjectStatusRequestValidator : AbstractValidator<UpdateProjectStatusRequest>
{
    public UpdateProjectStatusRequestValidator()
    {
        RuleFor(x => x.Status).NotEmpty().MaximumLength(50);
    }
}
