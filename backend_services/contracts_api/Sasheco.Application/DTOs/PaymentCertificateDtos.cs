using Sasheco.Domain.Enums;

namespace Sasheco.Application.DTOs;

public record PaymentCertificateDto(
    Guid Id,
    Guid ContractId,
    string ReferenceNumber,
    DateTime IssueDate,
    string Description,
    decimal TotalAmount,
    PaymentCertificateStatus Status,
    string Notes,
    List<PaymentCertificateItemDto> Items,
    List<PaymentCertificateApprovalDto> Approvals
);

public record PaymentCertificateItemDto(
    Guid Id,
    Guid ContractItemId,
    string Description,
    decimal Quantity,
    decimal UnitPrice,
    decimal TotalPrice
);

public record PaymentCertificateApprovalDto(
    Guid Id,
    Guid ApproverId,
    ApprovalRole Role,
    bool? IsApproved,
    string Comments,
    DateTime ApprovalDate
);

public record CreatePaymentCertificateRequest(
    Guid ContractId,
    string ReferenceNumber,
    string Description,
    string Notes
);

public record UpdatePaymentCertificateItemsRequest(
    List<PaymentCertificateItemRequest> Items
);

public record PaymentCertificateItemRequest(
    Guid ContractItemId,
    string Description,
    decimal Quantity,
    decimal UnitPrice
);

public record ApprovePaymentCertificateRequest(
    ApprovalRole Role,
    bool IsApproved,
    string Comments
);
