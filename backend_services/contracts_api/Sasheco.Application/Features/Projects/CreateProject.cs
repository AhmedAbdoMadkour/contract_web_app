using MediatR;

namespace Sasheco.Application.Features.Projects;

public record CreateProjectCommand(string Name, string SiteId, decimal Budget, string Timeline) : IRequest<string>;

public class CreateProjectHandler : IRequestHandler<CreateProjectCommand, string>
{
    public Task<string> Handle(CreateProjectCommand request, CancellationToken cancellationToken)
    {
        return Task.FromResult("Project created successfully with ID: P-1001");
    }
}
