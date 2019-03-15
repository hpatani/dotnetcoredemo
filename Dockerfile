FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /app

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY ["DotNetCoreDemo/DotNetCoreDemo.csproj", "DotNetCoreDemo/"]
RUN dotnet restore "DotNetCoreDemo/DotNetCoreDemo.csproj"
COPY . .
WORKDIR "/src/DotNetCoreDemo"
RUN dotnet build "DotNetCoreDemo.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "DotNetCoreDemo.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "DotNetCoreDemo.dll"]
