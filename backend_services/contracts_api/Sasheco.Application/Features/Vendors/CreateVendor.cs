using MediatR;

namespace Sasheco.Application.Features.Vendors;

public record CreateVendorCommand(string Name, string ServiceType, int Rating, string Status) : IRequest<string>;

public class CreateVendorHandler : IRequestHandler<CreateVendorCommand, string>
{
    public Task<string> Handle(CreateVendorCommand request, CancellationToken cancellationToken)
    {
        return Task.FromResult("Vendor created successfully");
    }
}
