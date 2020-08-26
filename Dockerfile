FROM streetcred/dotnet-indy:1.14.2 AS base
WORKDIR /app

FROM streetcred/dotnet-indy:1.14.2 AS build
WORKDIR /src
COPY [".", "."]

WORKDIR /src/mediator
RUN dotnet restore "MediatorAgent.csproj"

COPY ["mediator", "."]
COPY ["pool_transactions_genesis_local_dev", "./pool_genesis.txn"]
RUN dotnet build "MediatorAgent.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "MediatorAgent.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .

ENTRYPOINT ["dotnet", "MediatorAgent.dll"]