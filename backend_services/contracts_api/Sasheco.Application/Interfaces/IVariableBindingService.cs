namespace Sasheco.Application.Interfaces;

public interface IVariableBindingService
{
    string BindVariables(string templateContent, object dataContext);
}
