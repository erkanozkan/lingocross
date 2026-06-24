using LingoCross.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace LingoCross.Infrastructure.Persistence.Configurations;

public class GameConfiguration : IEntityTypeConfiguration<Game>
{
    public void Configure(EntityTypeBuilder<Game> builder)
    {
        builder.ToTable("games");

        builder.HasKey(g => g.Id);
        builder.Property(g => g.Id).HasDefaultValueSql("gen_random_uuid()");

        builder.Property(g => g.LessonId).IsRequired();
        builder.Property(g => g.Type).IsRequired();
        builder.Property(g => g.Title).IsRequired().HasMaxLength(200);

        builder.Property(g => g.IsPublished).IsRequired().HasDefaultValue(false);
        builder.Property(g => g.PublishedAt);

        builder.Property(g => g.CreatedAt).IsRequired();
        builder.Property(g => g.UpdatedAt).IsRequired();

        builder.HasIndex(g => g.LessonId);

        // Bir derste bir türden en çok bir oyun bulunur (ListOrCreate idempotansını destekler).
        builder.HasIndex(g => new { g.LessonId, g.Type }).IsUnique();

        builder.HasOne(g => g.Lesson)
            .WithMany(l => l.Games)
            .HasForeignKey(g => g.LessonId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}
