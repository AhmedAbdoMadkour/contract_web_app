using MediatR;

namespace Sasheco.Application.Features.Contracts;

public record ApproveContractCommand(string ContractId) : IRequest<string>;

public class ApproveContractHandler : IRequestHandler<ApproveContractCommand, string>
{
    public Task<string> Handle(ApproveContractCommand request, CancellationToken cancellationToken)
    {
        return Task.FromResult("Contract approved");
    }
}
