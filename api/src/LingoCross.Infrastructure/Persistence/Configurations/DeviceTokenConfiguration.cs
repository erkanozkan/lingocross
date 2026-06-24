using LingoCross.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace LingoCross.Infrastructure.Persistence.Configurations;

public class DeviceTokenConfiguration : IEntityTypeConfiguration<DeviceToken>
{
    public void Configure(EntityTypeBuilder<DeviceToken> builder)
    {
        builder.ToTable("device_tokens");

        builder.HasKey(t => t.Id);
        builder.Property(t => t.Id).HasDefaultValueSql("gen_random_uuid()");

        builder.Property(t => t.UserId).IsRequired();
        builder.Property(t => t.Token).IsRequired().HasMaxLength(512);
        builder.HasIndex(t => t.Token).IsUnique();

        builder.Property(t => t.Platform).IsRequired().HasMaxLength(16);

        builder.Property(t => t.CreatedAt).IsRequired();
        builder.Property(t => t.UpdatedAt).IsRequired();

        builder.HasOne(t => t.User)
            .WithMany()
            .HasForeignKey(t => t.UserId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}
