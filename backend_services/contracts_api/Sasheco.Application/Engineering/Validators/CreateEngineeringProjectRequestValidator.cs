using FluentValidation;
using Sasheco.Application.Engineering.DTOs;

namespace Sasheco.Application.Engineering.Validators;

public class CreateEngineeringProjectRequestValidator : AbstractValidator<CreateEngineeringProjectRequest>
{
    public CreateEngineeringProjectRequestValidator()
    {
        RuleFor(x => x.NameEn)
            .NotEmpty().WithMessage("English Name is required.")
            .MaximumLength(100).WithMessage("English Name cannot exceed 100 characters.");
            
        RuleFor(x => x.NameAr)
            .NotEmpty().WithMessage("Arabic Name is required.")
            .MaximumLength(100).WithMessage("Arabic Name cannot exceed 100 characters.");

        RuleFor(x => x.DescriptionEn)
            .MaximumLength(1000).WithMessage("English Description cannot exceed 1000 characters.");
            
        RuleFor(x => x.DescriptionAr)
            .MaximumLength(1000).WithMessage("Arabic Description cannot exceed 1000 characters.");
            
        RuleFor(x => x.StartDate).NotEmpty();
    }
}
