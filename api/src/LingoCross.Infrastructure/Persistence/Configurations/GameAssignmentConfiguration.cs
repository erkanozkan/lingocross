using LingoCross.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace LingoCross.Infrastructure.Persistence.Configurations;

public class GameAssignmentConfiguration : IEntityTypeConfiguration<GameAssignment>
{
    public void Configure(EntityTypeBuilder<GameAssignment> builder)
    {
        builder.ToTable("game_assignments");

        builder.HasKey(a => a.Id);
        builder.Property(a => a.Id).HasDefaultValueSql("gen_random_uuid()");

        builder.Property(a => a.GameId).IsRequired();
        builder.Property(a => a.ClassId).IsRequired();

        builder.Property(a => a.CreatedAt).IsRequired();
        builder.Property(a => a.UpdatedAt).IsRequired();

        // Bir oyun bir sınıfa yalnızca bir kez atanabilir.
        builder.HasIndex(a => new { a.GameId, a.ClassId }).IsUnique();

        // Bir sınıfın atamalarını hızlı listelemek için.
        builder.HasIndex(a => a.ClassId);

        builder.HasOne(a => a.Game)
            .WithMany(g => g.Assignments)
            .HasForeignKey(a => a.GameId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasOne(a => a.Class)
            .WithMany(c => c.Assignments)
            .HasForeignKey(a => a.ClassId)
            // games → game_assignments → classes ile classes → game_assignments çoklu cascade yolunu
            // engellemek için bu ucu Restrict bırakıyoruz (sınıf silme MVP'de yok; arşivleme var).
            .OnDelete(DeleteBehavior.Restrict);
    }
}
