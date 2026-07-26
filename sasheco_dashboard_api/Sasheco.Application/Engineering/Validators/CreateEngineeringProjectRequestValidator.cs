using FluentValidation;
using Sasheco.Application.Engineering.DTOs;

namespace Sasheco.Application.Engineering.Validators;

public class CreateEngineeringProjectRequestValidator : AbstractValidator<CreateEngineeringProjectRequest>
{
    public CreateEngineeringProjectRequestValidator()
    {
        RuleFor(x => x.NameEn).NotEmpty().MaximumLength(200);
        RuleFor(x => x.NameAr).NotEmpty().MaximumLength(200);
        RuleFor(x => x.StartDate).NotEmpty();
    }
}
