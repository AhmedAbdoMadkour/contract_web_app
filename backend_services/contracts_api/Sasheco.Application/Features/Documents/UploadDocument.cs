using MediatR;

namespace Sasheco.Application.Features.Documents;

public record UploadDocumentCommand(string FileName, byte[] Content) : IRequest<DocumentResponseDto>;
public record DocumentResponseDto(string DocumentId, string Status);

public class UploadDocumentHandler : IRequestHandler<UploadDocumentCommand, DocumentResponseDto>
{
    public Task<DocumentResponseDto> Handle(UploadDocumentCommand request, CancellationToken cancellationToken)
    {
        return Task.FromResult(new DocumentResponseDto("DOC-202", "Uploaded"));
    }
}
