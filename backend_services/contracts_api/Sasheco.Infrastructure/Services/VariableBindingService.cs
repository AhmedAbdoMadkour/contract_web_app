using System.Text.RegularExpressions;
using Sasheco.Application.Interfaces;

namespace Sasheco.Infrastructure.Services;

public class VariableBindingService : IVariableBindingService
{
    public string BindVariables(string templateContent, object dataContext)
    {
        if (string.IsNullOrWhiteSpace(templateContent) || dataContext == null)
            return templateContent;

        // Matches placeholders like {Contract.TotalWithVat} or {Project.Name}
        var regex = new Regex(@"\{([a-zA-Z0-9_\.]+)\}");
        
        return regex.Replace(templateContent, match =>
        {
            var path = match.Groups[1].Value;
            var value = GetValueFromPath(dataContext, path);
            return value != null ? value.ToString() : match.Value;
        });
    }

    private object? GetValueFromPath(object dataContext, string path)
    {
        var properties = path.Split('.');
        object? currentObject = dataContext;

        foreach (var propName in properties)
        {
            if (currentObject == null) return null;

            var type = currentObject.GetType();
            var propertyInfo = type.GetProperty(propName, System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.IgnoreCase);
            
            if (propertyInfo == null) return null;

            currentObject = propertyInfo.GetValue(currentObject);
        }

        return currentObject;
    }
}
