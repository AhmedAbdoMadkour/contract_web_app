using MediatR;

namespace Sasheco.Application.Features.Permissions;

public record UserDto(string Id, string Name, string Role);
public record GetPermissionsQuery : IRequest<List<UserDto>>;

public class GetPermissionsHandler : IRequestHandler<GetPermissionsQuery, List<UserDto>>
{
    public Task<List<UserDto>> Handle(GetPermissionsQuery request, CancellationToken cancellationToken)
    {
        return Task.FromResult(new List<UserDto> { new UserDto("1", "Alice", "Admin"), new UserDto("2", "Bob", "User") });
    }
}
