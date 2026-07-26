using MediatR;

namespace Sasheco.Application.Features.Permissions;

public record AddUserCommand(string Name, string Role) : IRequest<string>;

public class AddUserHandler : IRequestHandler<AddUserCommand, string>
{
    public Task<string> Handle(AddUserCommand request, CancellationToken cancellationToken)
    {
        return Task.FromResult("User added successfully");
    }
}
