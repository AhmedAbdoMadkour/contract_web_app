using Microsoft.AspNetCore.Http;
using Sasheco.Application.Interfaces;
using System.Linq;

namespace Sasheco.Api.Services;

public class LocaleService : ILocaleService
{
    private readonly IHttpContextAccessor _httpContextAccessor;

    public LocaleService(IHttpContextAccessor httpContextAccessor)
    {
        _httpContextAccessor = httpContextAccessor;
    }

    public string GetCurrentLocale()
    {
        var request = _httpContextAccessor.HttpContext?.Request;
        if (request != null && request.Headers.TryGetValue("Accept-Language", out var languages))
        {
            var firstLang = languages.FirstOrDefault();
            if (!string.IsNullOrEmpty(firstLang))
            {
                // Basic parsing to get 'en', 'ar', etc.
                var locale = firstLang.Split(',').FirstOrDefault()?.Split(';').FirstOrDefault()?.Trim();
                if (!string.IsNullOrEmpty(locale))
                    return locale;
            }
        }
        return "en"; // default locale
    }
}
