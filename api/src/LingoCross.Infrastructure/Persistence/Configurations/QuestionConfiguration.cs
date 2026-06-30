using LingoCross.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace LingoCross.Infrastructure.Persistence.Configurations;

public class QuestionConfiguration : IEntityTypeConfiguration<Question>
{
    public void Configure(EntityTypeBuilder<Question> builder)
    {
        builder.ToTable("questions");

        builder.HasKey(q => q.Id);
        builder.Property(q => q.Id).HasDefaultValueSql("gen_random_uuid()");

        builder.Property(q => q.QuestionTopicId).IsRequired();
        builder.Property(q => q.Stem).IsRequired().HasMaxLength(4000);
        builder.Property(q => q.Kind).HasMaxLength(40);
        builder.Property(q => q.Explanation).HasMaxLength(4000);
        builder.Property(q => q.Ordinal).IsRequired().HasDefaultValue(0);
        builder.Property(q => q.SourceRef).HasMaxLength(200);

        builder.Property(q => q.CreatedAt).IsRequired();
        builder.Property(q => q.UpdatedAt).IsRequired();

        builder.HasIndex(q => q.QuestionTopicId);

        builder.HasMany(q => q.Options)
            .WithOne(o => o.Question)
            .HasForeignKey(o => o.QuestionId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}
