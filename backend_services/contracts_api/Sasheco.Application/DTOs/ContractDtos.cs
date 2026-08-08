namespace Sasheco.Application.DTOs;

public record CreateContractRequest(Guid ProjectId, Guid VendorId, string TermsAndConditions);
public record ContractSummaryDto(Guid Id, Guid ProjectId, Guid VendorId, string Status);
