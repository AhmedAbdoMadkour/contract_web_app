using Sasheco.Domain.Entities;

namespace Sasheco.Domain.Interfaces;

public interface IUserRepository : IRepository<User>
{
    Task<User?> GetByEmployeeNumberAsync(string employeeNumber, CancellationToken cancellationToken = default);
    Task<User?> GetByEmailAsync(string email, CancellationToken cancellationToken = default);
    Task<IEnumerable<Permission>> GetUserPermissionsAsync(Guid userId, CancellationToken cancellationToken = default);
}
