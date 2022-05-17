FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 5000

ENV ASPNETCORE_URLS=http://*:5000

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["weatherforecast.csproj", "./"]
RUN dotnet restore "weatherforecast.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "weatherforecast.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "weatherforecast.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "weatherforecast.dll"]
