using FluentValidation;
using Sasheco.Application.Sites;

namespace Sasheco.Application.Sites.Validators;

public class UpdateSiteLocationDtoValidator : AbstractValidator<UpdateSiteLocationDto>
{
    public UpdateSiteLocationDtoValidator()
    {
        RuleFor(x => x.LocationEn).NotEmpty().MaximumLength(500);
        RuleFor(x => x.LocationAr).NotEmpty().MaximumLength(500);
    }
}
