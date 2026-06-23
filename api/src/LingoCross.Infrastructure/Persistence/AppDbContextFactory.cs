using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace LingoCross.Infrastructure.Persistence;

/// <summary>
/// `dotnet ef migrations add` gibi tasarım-zamanı komutlarının DbContext'i
/// API projesini çalıştırmadan oluşturabilmesi için kullanılır.
/// Bağlantı dizesini LINGOCROSS_DESIGN_CONNECTION ortam değişkeninden,
/// yoksa lokal docker-compose varsayılanından alır.
/// </summary>
public class AppDbContextFactory : IDesignTimeDbContextFactory<AppDbContext>
{
    public AppDbContext CreateDbContext(string[] args)
    {
        var connectionString =
            Environment.GetEnvironmentVariable("LINGOCROSS_DESIGN_CONNECTION")
            ?? "Host=localhost;Port=5432;Database=lingocross;Username=lingocross;Password=lingocross";

        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseNpgsql(connectionString, npgsql =>
                npgsql.MigrationsAssembly(typeof(AppDbContext).Assembly.FullName))
            .UseSnakeCaseNamingConvention()
            .Options;

        return new AppDbContext(options);
    }
}
