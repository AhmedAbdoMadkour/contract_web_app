using Sasheco.Domain.Entities;
using System.Collections.Generic;
using System.Linq;

namespace Sasheco.Application.Extensions;

public static class TranslationExtensions
{
    public static T ApplyTranslations<T>(this T entity, IEnumerable<Translation> translations, string locale) where T : class
    {
        if (entity == null || translations == null || string.IsNullOrEmpty(locale) || locale == "en")
        {
            return entity;
        }

        var entityType = typeof(T).Name;
        
        // Find ID property
        var idProperty = typeof(T).GetProperty("Id");
        if (idProperty == null) return entity;

        var entityId = idProperty.GetValue(entity)?.ToString();
        if (string.IsNullOrEmpty(entityId)) return entity;

        var relevantTranslations = translations.Where(t => 
            t.EntityType == entityType && 
            t.EntityId == entityId && 
            t.Locale == locale);

        foreach (var translation in relevantTranslations)
        {
            var property = typeof(T).GetProperty(translation.FieldName);
            if (property != null && property.CanWrite)
            {
                // We assume translated fields are strings for now
                if (property.PropertyType == typeof(string))
                {
                    property.SetValue(entity, translation.Content);
                }
            }
        }

        return entity;
    }

    public static IEnumerable<T> ApplyTranslations<T>(this IEnumerable<T> entities, IEnumerable<Translation> translations, string locale) where T : class
    {
        if (entities == null || translations == null || string.IsNullOrEmpty(locale) || locale == "en")
        {
            return entities;
        }

        foreach (var entity in entities)
        {
            entity.ApplyTranslations(translations, locale);
        }

        return entities;
    }
}
