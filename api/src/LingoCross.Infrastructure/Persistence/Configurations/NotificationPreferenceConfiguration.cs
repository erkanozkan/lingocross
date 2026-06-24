using LingoCross.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace LingoCross.Infrastructure.Persistence.Configurations;

public class NotificationPreferenceConfiguration : IEntityTypeConfiguration<NotificationPreference>
{
    public void Configure(EntityTypeBuilder<NotificationPreference> builder)
    {
        builder.ToTable("notification_preferences");

        builder.HasKey(p => p.Id);
        builder.Property(p => p.Id).HasDefaultValueSql("gen_random_uuid()");

        builder.Property(p => p.UserId).IsRequired();
        builder.HasIndex(p => p.UserId).IsUnique();

        builder.Property(p => p.Master).IsRequired().HasDefaultValue(true);
        builder.Property(p => p.Assigned).IsRequired().HasDefaultValue(true);
        builder.Property(p => p.Reminder).IsRequired().HasDefaultValue(true);
        builder.Property(p => p.Results).IsRequired().HasDefaultValue(true);
        builder.Property(p => p.Announcements).IsRequired().HasDefaultValue(false);

        builder.Property(p => p.CreatedAt).IsRequired();
        builder.Property(p => p.UpdatedAt).IsRequired();

        builder.HasOne(p => p.User)
            .WithMany()
            .HasForeignKey(p => p.UserId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}
