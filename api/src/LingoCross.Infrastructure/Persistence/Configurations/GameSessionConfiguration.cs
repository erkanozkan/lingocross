using LingoCross.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace LingoCross.Infrastructure.Persistence.Configurations;

public class GameSessionConfiguration : IEntityTypeConfiguration<GameSession>
{
    public void Configure(EntityTypeBuilder<GameSession> builder)
    {
        builder.ToTable("game_sessions");

        builder.HasKey(s => s.Id);
        builder.Property(s => s.Id).HasDefaultValueSql("gen_random_uuid()");

        builder.Property(s => s.GameId).IsRequired();
        builder.Property(s => s.StudentId).IsRequired();
        builder.Property(s => s.Status).IsRequired();
        builder.Property(s => s.StartedAt).IsRequired();
        builder.Property(s => s.CompletedAt);

        builder.Property(s => s.CreatedAt).IsRequired();
        builder.Property(s => s.UpdatedAt).IsRequired();

        builder.HasIndex(s => s.GameId);
        builder.HasIndex(s => s.StudentId);

        builder.HasOne(s => s.Game)
            .WithMany(g => g.Sessions)
            .HasForeignKey(s => s.GameId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasOne(s => s.Student)
            .WithMany(u => u.GameSessions)
            .HasForeignKey(s => s.StudentId)
            // games → lessons → users ve game_sessions → users çoklu cascade yolunu engellemek için
            // bu uç Restrict bırakılır (Enrollment desenindeki gibi).
            .OnDelete(DeleteBehavior.Restrict);
    }
}
