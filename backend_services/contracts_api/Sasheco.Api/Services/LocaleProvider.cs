using Microsoft.AspNetCore.Http;
using System.Linq;

namespace Sasheco.Api.Services;

public interface ILocaleProvider
{
    bool IsArabic { get; }
}

public class LocaleProvider : ILocaleProvider
{
    private readonly IHttpContextAccessor _httpContextAccessor;

    public LocaleProvider(IHttpContextAccessor httpContextAccessor)
    {
        _httpContextAccessor = httpContextAccessor;
    }

    public bool IsArabic
    {
        get
        {
            var request = _httpContextAccessor.HttpContext?.Request;
            if (request == null) return false;

            var acceptLanguage = request.Headers["Accept-Language"].ToString();
            return acceptLanguage.Contains("ar", System.StringComparison.OrdinalIgnoreCase);
        }
    }
}
