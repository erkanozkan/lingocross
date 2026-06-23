using Microsoft.EntityFrameworkCore;

namespace LingoCross.Infrastructure.Persistence;

/// <summary>
/// Uygulamanın EF Core veritabanı bağlamı. Entity'ler M1+ aşamasında eklenecek.
/// snake_case isimlendirme ve diğer yapılandırmalar OnModelCreating içinde toplanır.
/// </summary>
public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
    {
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Aynı assembly'deki tüm IEntityTypeConfiguration sınıflarını uygula.
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(AppDbContext).Assembly);
    }
}
