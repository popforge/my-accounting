FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
COPY . .
RUN dotnet restore "MyAccounting.Server.csproj"
RUN dotnet publish "MyAccounting.Server.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Hérite de ghcr.io/popforge/base-api — voir Popforge.Shared/docker/base-api/
FROM ghcr.io/popforge/base-api:10.0 AS final
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "MyAccounting.Server.dll"]