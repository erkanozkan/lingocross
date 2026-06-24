using LingoCross.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace LingoCross.Infrastructure.Persistence.Configurations;

public class SubscriptionConfiguration : IEntityTypeConfiguration<Subscription>
{
    public void Configure(EntityTypeBuilder<Subscription> builder)
    {
        builder.ToTable("subscriptions");

        builder.HasKey(s => s.Id);
        builder.Property(s => s.Id).HasDefaultValueSql("gen_random_uuid()");

        builder.Property(s => s.UserId).IsRequired();
        builder.HasIndex(s => s.UserId).IsUnique();

        builder.Property(s => s.Plan).IsRequired();
        builder.Property(s => s.Status).IsRequired();
        builder.Property(s => s.Period);
        builder.Property(s => s.Source).IsRequired();

        builder.Property(s => s.StartedAt).IsRequired();
        builder.Property(s => s.ExpiresAt);

        builder.Property(s => s.StoreTransactionId).HasMaxLength(256);
        builder.Property(s => s.LatestReceiptRef).HasMaxLength(256);

        builder.Property(s => s.CreatedAt).IsRequired();
        builder.Property(s => s.UpdatedAt).IsRequired();

        builder.HasOne(s => s.User)
            .WithOne()
            .HasForeignKey<Subscription>(s => s.UserId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}
