using Sasheco.Domain.Entities;

namespace Sasheco.Application.Interfaces;

public interface IJwtService
{
    string GenerateToken(User user);
}
