using Sasheco.Contract.Domain.Entities;
using Sasheco.Contract.Domain.Interfaces;

namespace Sasheco.Contract.Infrastructure.Data.Repositories;

public class ContractItemRepository : IContractItemRepository
{
    private readonly ApplicationDbContext _context;

    public ContractItemRepository(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<ContractItem> AddAsync(ContractItem item)
    {
        _context.ContractItems.Add(item);
        await _context.SaveChangesAsync();
        return item;
    }

    public async Task<IEnumerable<ContractItem>> AddRangeAsync(IEnumerable<ContractItem> items)
    {
        _context.ContractItems.AddRange(items);
        await _context.SaveChangesAsync();
        return items;
    }
}
