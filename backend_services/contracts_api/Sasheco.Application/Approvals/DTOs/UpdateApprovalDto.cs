namespace Sasheco.Application.Approvals.DTOs
{
    public class UpdateApprovalDto
    {
        public string Status { get; set; } = string.Empty; // Pending, Approved, Rejected
        public string? Comments { get; set; }
    }
}
