using LingoCross.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace LingoCross.Infrastructure.Persistence.Configurations;

public class ClassConfiguration : IEntityTypeConfiguration<Class>
{
    public void Configure(EntityTypeBuilder<Class> builder)
    {
        builder.ToTable("classes");

        builder.HasKey(c => c.Id);
        builder.Property(c => c.Id).HasDefaultValueSql("gen_random_uuid()");

        builder.Property(c => c.TeacherId).IsRequired();
        builder.Property(c => c.Name).IsRequired().HasMaxLength(64);

        builder.Property(c => c.InviteCode).HasMaxLength(32);
        // users.invite_code ile aynı desen: yalnız null olmayan kodlar arasında benzersizlik.
        builder.HasIndex(c => c.InviteCode).IsUnique().HasFilter("invite_code IS NOT NULL");

        builder.Property(c => c.IsArchived).IsRequired().HasDefaultValue(false);

        builder.Property(c => c.CreatedAt).IsRequired();
        builder.Property(c => c.UpdatedAt).IsRequired();

        builder.HasIndex(c => c.TeacherId);

        builder.HasOne(c => c.Teacher)
            .WithMany(u => u.Classes)
            .HasForeignKey(c => c.TeacherId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}
