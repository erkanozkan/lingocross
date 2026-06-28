using LingoCross.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace LingoCross.Infrastructure.Persistence.Configurations;

public class PasswordResetTokenConfiguration : IEntityTypeConfiguration<PasswordResetToken>
{
    public void Configure(EntityTypeBuilder<PasswordResetToken> builder)
    {
        builder.ToTable("password_reset_tokens");

        builder.HasKey(t => t.Id);
        builder.Property(t => t.Id).HasDefaultValueSql("gen_random_uuid()");

        builder.Property(t => t.UserId).IsRequired();
        builder.Property(t => t.TokenHash).IsRequired().HasMaxLength(128);
        builder.HasIndex(t => t.TokenHash).IsUnique();

        builder.Property(t => t.ExpiresAt).IsRequired();
        builder.Property(t => t.UsedAt);
        builder.Property(t => t.Attempts).IsRequired().HasDefaultValue(0);

        builder.Property(t => t.CreatedAt).IsRequired();
        builder.Property(t => t.UpdatedAt).IsRequired();

        builder.Ignore(t => t.IsUsable);

        builder.HasOne(t => t.User)
            .WithMany(u => u.PasswordResetTokens)
            .HasForeignKey(t => t.UserId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}
