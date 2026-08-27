using Sasheco.Contract.Domain.Entities;

namespace Sasheco.Contract.Domain.Interfaces;

public interface IContractItemRepository
{
    Task<ContractItem> AddAsync(ContractItem item);
    Task<IEnumerable<ContractItem>> AddRangeAsync(IEnumerable<ContractItem> items);
}
