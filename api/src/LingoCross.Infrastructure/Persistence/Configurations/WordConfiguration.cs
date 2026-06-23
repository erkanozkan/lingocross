using LingoCross.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace LingoCross.Infrastructure.Persistence.Configurations;

public class WordConfiguration : IEntityTypeConfiguration<Word>
{
    public void Configure(EntityTypeBuilder<Word> builder)
    {
        builder.ToTable("words");

        builder.HasKey(w => w.Id);
        builder.Property(w => w.Id).HasDefaultValueSql("gen_random_uuid()");

        builder.Property(w => w.LessonId).IsRequired();
        builder.Property(w => w.Term).IsRequired().HasMaxLength(200);
        builder.Property(w => w.SortOrder).IsRequired();
        builder.Property(w => w.Source).IsRequired();

        builder.Property(w => w.CreatedAt).IsRequired();
        builder.Property(w => w.UpdatedAt).IsRequired();

        builder.HasIndex(w => w.LessonId);

        builder.HasOne(w => w.Lesson)
            .WithMany(l => l.Words)
            .HasForeignKey(w => w.LessonId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}
