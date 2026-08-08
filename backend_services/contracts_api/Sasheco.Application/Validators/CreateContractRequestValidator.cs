using FluentValidation;
using Sasheco.Application.DTOs;

namespace Sasheco.Application.Validators;

public class CreateContractRequestValidator : AbstractValidator<CreateContractRequest>
{
    public CreateContractRequestValidator()
    {
        RuleFor(x => x.ProjectId).NotEmpty().WithMessage("Project ID is required.");
        RuleFor(x => x.VendorId).NotEmpty().WithMessage("Vendor ID is required.");
        RuleFor(x => x.TermsAndConditions).NotEmpty().WithMessage("Terms and conditions are required.");
    }
}
