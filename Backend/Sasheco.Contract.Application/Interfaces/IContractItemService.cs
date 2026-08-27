using Sasheco.Contract.Domain.Entities;

namespace Sasheco.Contract.Application.Interfaces;

public interface IContractItemService
{
    Task<ContractItem> AddItemAsync(Guid contractId, ContractItem item);
    Task<IEnumerable<ContractItem>> AddItemsBulkAsync(Guid contractId, Stream fileStream, string fileName);
}
