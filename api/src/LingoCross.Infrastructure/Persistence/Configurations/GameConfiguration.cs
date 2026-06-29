using LingoCross.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace LingoCross.Infrastructure.Persistence.Configurations;

public class GameConfiguration : IEntityTypeConfiguration<Game>
{
    public void Configure(EntityTypeBuilder<Game> builder)
    {
        // Faz 2: ders-tabanlı oyunlar (LessonId dolu) veya konu-başlığı-tabanlı QuestionSet oyunları
        // (QuestionTopicId dolu) için tam biri set olur (DB CHECK + app invariant ile korunur).
        builder.ToTable("games", t =>
            t.HasCheckConstraint(
                "ck_games_lesson_xor_topic",
                "(lesson_id IS NULL) <> (question_topic_id IS NULL)"));

        builder.HasKey(g => g.Id);
        builder.Property(g => g.Id).HasDefaultValueSql("gen_random_uuid()");

        // Artık nullable: QuestionSet oyununda LessonId null, QuestionTopicId dolu.
        builder.Property(g => g.LessonId);
        builder.Property(g => g.QuestionTopicId);
        builder.Property(g => g.Type).IsRequired();
        builder.Property(g => g.Title).IsRequired().HasMaxLength(200);

        builder.Property(g => g.IsPublished).IsRequired().HasDefaultValue(false);
        builder.Property(g => g.PublishedAt);

        builder.Property(g => g.CreatedAt).IsRequired();
        builder.Property(g => g.UpdatedAt).IsRequired();

        builder.HasIndex(g => g.LessonId);
        builder.HasIndex(g => g.QuestionTopicId);

        // Bir derste bir türden en çok bir oyun bulunur (ListOrCreate idempotansını destekler).
        // LessonId artık nullable olduğundan filtreli benzersizlik (QuestionSet satırları hariç).
        builder.HasIndex(g => new { g.LessonId, g.Type })
            .IsUnique()
            .HasFilter("lesson_id IS NOT NULL");

        // Bir konu başlığında bir türden en çok bir oyun bulunur (QuestionSet upsert idempotansı).
        builder.HasIndex(g => new { g.QuestionTopicId, g.Type })
            .IsUnique()
            .HasFilter("question_topic_id IS NOT NULL");

        builder.HasOne(g => g.Lesson)
            .WithMany(l => l.Games)
            .HasForeignKey(g => g.LessonId)
            .OnDelete(DeleteBehavior.Cascade);

        // QuestionSet oyunu konu başlığına bağlıdır; başlık silinmek istenirse engellenir (Restrict).
        builder.HasOne(g => g.QuestionTopic)
            .WithMany()
            .HasForeignKey(g => g.QuestionTopicId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
