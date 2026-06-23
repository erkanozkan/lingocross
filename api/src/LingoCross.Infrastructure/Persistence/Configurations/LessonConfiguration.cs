using LingoCross.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace LingoCross.Infrastructure.Persistence.Configurations;

public class LessonConfiguration : IEntityTypeConfiguration<Lesson>
{
    public void Configure(EntityTypeBuilder<Lesson> builder)
    {
        builder.ToTable("lessons");

        builder.HasKey(l => l.Id);
        builder.Property(l => l.Id).HasDefaultValueSql("gen_random_uuid()");

        builder.Property(l => l.TeacherId).IsRequired();
        builder.Property(l => l.Title).IsRequired().HasMaxLength(200);
        builder.Property(l => l.Description).HasMaxLength(2000);

        builder.Property(l => l.SourceLanguage).IsRequired().HasMaxLength(8).HasDefaultValue("en");
        builder.Property(l => l.TargetLanguage).IsRequired().HasMaxLength(8).HasDefaultValue("tr");

        builder.Property(l => l.IsPublished).IsRequired().HasDefaultValue(false);

        builder.Property(l => l.CreatedAt).IsRequired();
        builder.Property(l => l.UpdatedAt).IsRequired();

        builder.HasIndex(l => l.TeacherId);

        builder.HasOne(l => l.Teacher)
            .WithMany(u => u.Lessons)
            .HasForeignKey(l => l.TeacherId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}
