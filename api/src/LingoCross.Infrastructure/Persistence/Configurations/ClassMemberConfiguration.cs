using LingoCross.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace LingoCross.Infrastructure.Persistence.Configurations;

public class ClassMemberConfiguration : IEntityTypeConfiguration<ClassMember>
{
    public void Configure(EntityTypeBuilder<ClassMember> builder)
    {
        builder.ToTable("class_members");

        builder.HasKey(m => m.Id);
        builder.Property(m => m.Id).HasDefaultValueSql("gen_random_uuid()");

        builder.Property(m => m.ClassId).IsRequired();
        builder.Property(m => m.StudentId).IsRequired();
        builder.Property(m => m.Status).IsRequired();

        builder.Property(m => m.CreatedAt).IsRequired();
        builder.Property(m => m.UpdatedAt).IsRequired();

        // Aynı öğrenci bir sınıfa yalnızca bir kez üye olabilir.
        builder.HasIndex(m => new { m.ClassId, m.StudentId }).IsUnique();

        // Öğrencinin üyeliklerini hızlı listelemek için.
        builder.HasIndex(m => m.StudentId);

        builder.HasOne(m => m.Class)
            .WithMany(c => c.Members)
            .HasForeignKey(m => m.ClassId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasOne(m => m.Student)
            .WithMany(u => u.ClassMemberships)
            .HasForeignKey(m => m.StudentId)
            // users tarafına çoklu cascade yolunu engellemek için Restrict (Enrollment deseniyle aynı).
            .OnDelete(DeleteBehavior.Restrict);
    }
}
