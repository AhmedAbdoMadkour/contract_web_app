using MediatR;

namespace Sasheco.Application.Features.Vendors;

public record VendorDto(string Id, string Name, string ServiceType, int Rating, string Status);
public record GetVendorsQuery : IRequest<List<VendorDto>>;

public class GetVendorsHandler : IRequestHandler<GetVendorsQuery, List<VendorDto>>
{
    public Task<List<VendorDto>> Handle(GetVendorsQuery request, CancellationToken cancellationToken)
    {
        return Task.FromResult(new List<VendorDto> { new VendorDto("V-1", "Acme Corp", "Maintenance", 5, "Active") });
    }
}
