using LingoCross.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace LingoCross.Infrastructure.Persistence.Configurations;

public class GameResultConfiguration : IEntityTypeConfiguration<GameResult>
{
    public void Configure(EntityTypeBuilder<GameResult> builder)
    {
        builder.ToTable("game_results");

        builder.HasKey(r => r.Id);
        builder.Property(r => r.Id).HasDefaultValueSql("gen_random_uuid()");

        builder.Property(r => r.SessionId).IsRequired();
        builder.Property(r => r.DurationMs).IsRequired();
        builder.Property(r => r.TotalItems).IsRequired();
        builder.Property(r => r.CorrectItems).IsRequired();
        builder.Property(r => r.Score).IsRequired();
        builder.Property(r => r.SharedWithTeacher).IsRequired();
        builder.Property(r => r.SharedAt);

        builder.Property(r => r.CreatedAt).IsRequired();
        builder.Property(r => r.UpdatedAt).IsRequired();

        // Oturum başına tek sonuç: session_id unique.
        builder.HasIndex(r => r.SessionId).IsUnique();

        builder.HasOne(r => r.Session)
            .WithOne(s => s.Result)
            .HasForeignKey<GameResult>(r => r.SessionId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}
