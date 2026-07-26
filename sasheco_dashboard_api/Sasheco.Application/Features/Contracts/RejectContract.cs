using MediatR;

namespace Sasheco.Application.Features.Contracts;

public record RejectContractCommand(string ContractId) : IRequest<string>;

public class RejectContractHandler : IRequestHandler<RejectContractCommand, string>
{
    public Task<string> Handle(RejectContractCommand request, CancellationToken cancellationToken)
    {
        return Task.FromResult("Contract rejected");
    }
}
