using MediatR;

namespace Sasheco.Application.Features.Finance;

public record ProcessPaymentCommand(decimal Amount, string InvoiceId, string PaymentMethod) : IRequest<string>;

public class ProcessPaymentHandler : IRequestHandler<ProcessPaymentCommand, string>
{
    public Task<string> Handle(ProcessPaymentCommand request, CancellationToken cancellationToken)
    {
        return Task.FromResult("Payment processed successfully for Invoice: " + request.InvoiceId);
    }
}
