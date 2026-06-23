# ---------- Build aşaması ----------
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# NuGet kaynak yapılandırması (yalnızca nuget.org).
COPY NuGet.config ./

# Önce csproj'ları kopyalayıp restore et (katman önbelleği için).
COPY src/LingoCross.Api/LingoCross.Api.csproj src/LingoCross.Api/
COPY src/LingoCross.Application/LingoCross.Application.csproj src/LingoCross.Application/
COPY src/LingoCross.Domain/LingoCross.Domain.csproj src/LingoCross.Domain/
COPY src/LingoCross.Infrastructure/LingoCross.Infrastructure.csproj src/LingoCross.Infrastructure/
RUN dotnet restore src/LingoCross.Api/LingoCross.Api.csproj

# Kalan kaynakları kopyalayıp publish et.
COPY src/ src/
RUN dotnet publish src/LingoCross.Api/LingoCross.Api.csproj -c Release -o /app/publish /p:UseAppHost=false

# ---------- Runtime aşaması ----------
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
COPY --from=build /app/publish ./
# Railway PORT ortam değişkenini verir; Program.cs bunu okur.
ENV ASPNETCORE_ENVIRONMENT=Production
ENTRYPOINT ["dotnet", "LingoCross.Api.dll"]
