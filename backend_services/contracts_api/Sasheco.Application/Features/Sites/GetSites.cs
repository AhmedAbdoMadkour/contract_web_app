using MediatR;

namespace Sasheco.Application.Features.Sites;

public record SiteDto(string Id, string Name, string Location, int ActiveProjectsCount);
public record GetSitesQuery : IRequest<List<SiteDto>>;

public class GetSitesHandler : IRequestHandler<GetSitesQuery, List<SiteDto>>
{
    public Task<List<SiteDto>> Handle(GetSitesQuery request, CancellationToken cancellationToken)
    {
        return Task.FromResult(new List<SiteDto> { new SiteDto("S-1", "Site A", "NY", 3) });
    }
}
