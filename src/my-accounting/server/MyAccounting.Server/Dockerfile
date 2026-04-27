FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
COPY . .
# Authentification GitHub Packages via BuildKit secret (injecté par le workflow CI)
RUN --mount=type=secret,id=nuget_token \
    dotnet nuget add source https://nuget.pkg.github.com/popforge/index.json \
        --name popforge-nuget \
        --username popforge \
        --password "$(cat /run/secrets/nuget_token)" \
        --store-password-in-clear-text && \
    dotnet restore "MyAccounting.Server.csproj"
RUN dotnet publish "MyAccounting.Server.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Hérite de ghcr.io/popforge/base-api — voir Popforge.Shared/docker/base-api/
FROM ghcr.io/popforge/base-api:10.0 AS final
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "MyAccounting.Server.dll"]