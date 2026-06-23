using LingoCross.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace LingoCross.Infrastructure.Persistence.Configurations;

public class WordSynonymConfiguration : IEntityTypeConfiguration<WordSynonym>
{
    public void Configure(EntityTypeBuilder<WordSynonym> builder)
    {
        builder.ToTable("word_synonyms");

        builder.HasKey(s => s.Id);
        builder.Property(s => s.Id).HasDefaultValueSql("gen_random_uuid()");

        builder.Property(s => s.WordId).IsRequired();
        builder.Property(s => s.Text).IsRequired().HasMaxLength(200);

        builder.Property(s => s.CreatedAt).IsRequired();
        builder.Property(s => s.UpdatedAt).IsRequired();

        builder.HasIndex(s => s.WordId);

        builder.HasOne(s => s.Word)
            .WithMany(w => w.Synonyms)
            .HasForeignKey(s => s.WordId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}
