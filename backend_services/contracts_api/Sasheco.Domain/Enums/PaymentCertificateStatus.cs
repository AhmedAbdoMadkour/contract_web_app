namespace Sasheco.Domain.Enums;

public enum PaymentCertificateStatus
{
    Draft,
    PendingEngineeringApproval,
    PendingSiteApproval,
    PendingFinanceApproval,
    Approved,
    Paid,
    Rejected
}
