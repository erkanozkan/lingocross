using LingoCross.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace LingoCross.Infrastructure.Persistence.Configurations;

public class WordTranslationConfiguration : IEntityTypeConfiguration<WordTranslation>
{
    public void Configure(EntityTypeBuilder<WordTranslation> builder)
    {
        builder.ToTable("word_translations");

        builder.HasKey(t => t.Id);
        builder.Property(t => t.Id).HasDefaultValueSql("gen_random_uuid()");

        builder.Property(t => t.WordId).IsRequired();
        builder.Property(t => t.Text).IsRequired().HasMaxLength(200);
        builder.Property(t => t.IsPrimary).IsRequired().HasDefaultValue(false);

        builder.Property(t => t.CreatedAt).IsRequired();
        builder.Property(t => t.UpdatedAt).IsRequired();

        builder.HasIndex(t => t.WordId);

        builder.HasOne(t => t.Word)
            .WithMany(w => w.Translations)
            .HasForeignKey(t => t.WordId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}
