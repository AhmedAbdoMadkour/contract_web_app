using MediatR;

namespace Sasheco.Application.Features.Sites;

public record CreateSiteCommand(string Name, string Location, int ActiveProjectsCount) : IRequest<string>;

public class CreateSiteHandler : IRequestHandler<CreateSiteCommand, string>
{
    public Task<string> Handle(CreateSiteCommand request, CancellationToken cancellationToken)
    {
        return Task.FromResult("Site created successfully");
    }
}
