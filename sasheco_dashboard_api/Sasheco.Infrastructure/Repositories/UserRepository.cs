using Microsoft.EntityFrameworkCore;
using Sasheco.Domain.Entities;
using Sasheco.Domain.Interfaces;
using Sasheco.Infrastructure.Data;

namespace Sasheco.Infrastructure.Repositories;

public class UserRepository : Repository<User>, IUserRepository
{
    public UserRepository(SashecoDbContext context) : base(context)
    {
    }

    public async Task<User?> GetByEmployeeNumberAsync(string identifier, CancellationToken cancellationToken = default)
    {
        return await _dbSet
            .Include(u => u.Role)
            .FirstOrDefaultAsync(u => u.EmployeeNumber == identifier || u.Name == identifier || u.Email == identifier, cancellationToken);
    }

    public async Task<User?> GetByEmailAsync(string email, CancellationToken cancellationToken = default)
    {
        return await _dbSet
            .FirstOrDefaultAsync(u => u.Email == email, cancellationToken);
    }

    public async Task<IEnumerable<Permission>> GetUserPermissionsAsync(Guid userId, CancellationToken cancellationToken = default)
    {
        var user = await _dbSet
            .Include(u => u.Role)
            .ThenInclude(r => r!.RolePermissions)
            .ThenInclude(rp => rp.Permission)
            .FirstOrDefaultAsync(u => u.Id == userId, cancellationToken);

        if (user?.Role == null) return Enumerable.Empty<Permission>();

        return user.Role.RolePermissions.Select(rp => rp.Permission!).Where(p => p != null);
    }
}
