using LingoCross.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace LingoCross.Infrastructure.Persistence.Configurations;

public class QuestionTopicConfiguration : IEntityTypeConfiguration<QuestionTopic>
{
    public void Configure(EntityTypeBuilder<QuestionTopic> builder)
    {
        builder.ToTable("question_topics");

        builder.HasKey(t => t.Id);
        builder.Property(t => t.Id).HasDefaultValueSql("gen_random_uuid()");

        builder.Property(t => t.Title).IsRequired().HasMaxLength(200);
        builder.Property(t => t.Slug).IsRequired().HasMaxLength(120);
        builder.Property(t => t.Description).HasMaxLength(2000);
        builder.Property(t => t.IsActive).IsRequired().HasDefaultValue(true);
        builder.Property(t => t.SortOrder).IsRequired().HasDefaultValue(0);

        // AI üretimi alanları (global başlıklarda null).
        builder.Property(t => t.TeacherId);
        builder.Property(t => t.LessonId);
        builder.Property(t => t.Grade);

        builder.Property(t => t.CreatedAt).IsRequired();
        builder.Property(t => t.UpdatedAt).IsRequired();

        // İdempotent import: slug benzersiz.
        builder.HasIndex(t => t.Slug).IsUnique();

        // Öğretmenin AI setlerini hızlı listelemek için.
        builder.HasIndex(t => t.TeacherId);

        // Sahip öğretmen (nullable FK). Öğretmen silinirse setleri serbestçe silinmez → Restrict.
        builder.HasOne<User>()
            .WithMany()
            .HasForeignKey(t => t.TeacherId)
            .OnDelete(DeleteBehavior.Restrict);

        // Temel alınan ders (nullable FK). Ders silinince başlık öksüz kalmasın → set null.
        builder.HasOne<Lesson>()
            .WithMany()
            .HasForeignKey(t => t.LessonId)
            .OnDelete(DeleteBehavior.SetNull);

        builder.HasMany(t => t.Questions)
            .WithOne(q => q.QuestionTopic)
            .HasForeignKey(q => q.QuestionTopicId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}
