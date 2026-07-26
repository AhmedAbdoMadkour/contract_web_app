using System;

namespace Sasheco.Application.Approvals.DTOs
{
    public class CreateApprovalDto
    {
        public string Title { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public string RequestedBy { get; set; } = string.Empty;
    }
}
