using LingoCross.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace LingoCross.Infrastructure.Persistence.Configurations;

public class GameResultItemConfiguration : IEntityTypeConfiguration<GameResultItem>
{
    public void Configure(EntityTypeBuilder<GameResultItem> builder)
    {
        builder.ToTable("game_result_items");

        builder.HasKey(i => i.Id);
        builder.Property(i => i.Id).HasDefaultValueSql("gen_random_uuid()");

        builder.Property(i => i.ResultId).IsRequired();
        builder.Property(i => i.Ordinal).IsRequired();
        builder.Property(i => i.Term).IsRequired().HasMaxLength(200);
        builder.Property(i => i.ExpectedAnswer).IsRequired().HasMaxLength(200);
        builder.Property(i => i.StudentAnswer).HasMaxLength(200);
        builder.Property(i => i.IsCorrect).IsRequired();

        builder.Property(i => i.CreatedAt).IsRequired();
        builder.Property(i => i.UpdatedAt).IsRequired();

        // Sonuç başına kalemler, ordinal sırasıyla erişilir.
        builder.HasIndex(i => new { i.ResultId, i.Ordinal });

        builder.HasOne(i => i.Result)
            .WithMany(r => r.Items)
            .HasForeignKey(i => i.ResultId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}
