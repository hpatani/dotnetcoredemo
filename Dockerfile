FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /app

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY ["DotNetCoreDemo/DotNetCoreDemo.csproj", "DotNetCoreDemo/"] # Replace this with your application name and respective path
RUN dotnet restore "DotNetCoreDemo/DotNetCoreDemo.csproj" # Replace this with your application name and respective path
COPY . .
WORKDIR "/src/DotNetCoreDemo" ## Replace this with your application name and respective path
RUN dotnet build "DotNetCoreDemo.csproj" -c Release -o /app # Replace this with your application name and respective path

FROM build AS publish
RUN dotnet publish "DotNetCoreDemo.csproj" -c Release -o /app # Replace this with your application name and respective path

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "DotNetCoreDemo.dll"] # Replace this with your application name and respective path
