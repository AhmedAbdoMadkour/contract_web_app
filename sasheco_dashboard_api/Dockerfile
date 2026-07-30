FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copy csproj files and restore
COPY ["Sasheco.Api/Sasheco.Api.csproj", "Sasheco.Api/"]
COPY ["Sasheco.Application/Sasheco.Application.csproj", "Sasheco.Application/"]
COPY ["Sasheco.Domain/Sasheco.Domain.csproj", "Sasheco.Domain/"]
COPY ["Sasheco.Infrastructure/Sasheco.Infrastructure.csproj", "Sasheco.Infrastructure/"]
RUN dotnet restore "Sasheco.Api/Sasheco.Api.csproj"

# Copy the rest of the code
COPY . .
WORKDIR "/src/Sasheco.Api"
RUN dotnet build "Sasheco.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Sasheco.Api.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Sasheco.Api.dll"]
