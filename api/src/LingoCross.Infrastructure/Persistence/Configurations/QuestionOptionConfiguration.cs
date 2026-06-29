using LingoCross.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace LingoCross.Infrastructure.Persistence.Configurations;

public class QuestionOptionConfiguration : IEntityTypeConfiguration<QuestionOption>
{
    public void Configure(EntityTypeBuilder<QuestionOption> builder)
    {
        builder.ToTable("question_options");

        builder.HasKey(o => o.Id);
        builder.Property(o => o.Id).HasDefaultValueSql("gen_random_uuid()");

        builder.Property(o => o.QuestionId).IsRequired();
        builder.Property(o => o.Position).IsRequired();
        builder.Property(o => o.Text).IsRequired().HasMaxLength(2000);
        builder.Property(o => o.IsCorrect).IsRequired().HasDefaultValue(false);

        builder.Property(o => o.CreatedAt).IsRequired();
        builder.Property(o => o.UpdatedAt).IsRequired();

        builder.HasIndex(o => o.QuestionId);

        // Bir soruda her ÖSYM pozisyonu (A–E) bir kez bulunur.
        builder.HasIndex(o => new { o.QuestionId, o.Position }).IsUnique();
    }
}
