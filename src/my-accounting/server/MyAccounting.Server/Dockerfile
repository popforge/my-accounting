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

# Runtime officiel ASP.NET pour éviter la dépendance à une image de base privée introuvable.
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "MyAccounting.Server.dll"]