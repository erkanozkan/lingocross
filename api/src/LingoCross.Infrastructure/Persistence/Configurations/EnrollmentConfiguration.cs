using LingoCross.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace LingoCross.Infrastructure.Persistence.Configurations;

public class EnrollmentConfiguration : IEntityTypeConfiguration<Enrollment>
{
    public void Configure(EntityTypeBuilder<Enrollment> builder)
    {
        builder.ToTable("enrollments");

        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).HasDefaultValueSql("gen_random_uuid()");

        builder.Property(e => e.TeacherId).IsRequired();
        builder.Property(e => e.StudentId).IsRequired();
        builder.Property(e => e.Status).IsRequired();

        builder.Property(e => e.CreatedAt).IsRequired();
        builder.Property(e => e.UpdatedAt).IsRequired();

        // Aynı öğretmen-öğrenci çifti yalnızca bir kez eşleşebilir.
        builder.HasIndex(e => new { e.TeacherId, e.StudentId }).IsUnique();

        // Öğrencinin eşleşmelerini hızlı listelemek için.
        builder.HasIndex(e => e.StudentId);

        builder.HasOne(e => e.Teacher)
            .WithMany(u => u.TeacherEnrollments)
            .HasForeignKey(e => e.TeacherId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasOne(e => e.Student)
            .WithMany(u => u.StudentEnrollments)
            .HasForeignKey(e => e.StudentId)
            // Aynı users tablosuna iki FK olduğundan, çoklu cascade yolunu (multiple cascade
            // paths) engellemek için bu ucu Restrict bırakıyoruz.
            .OnDelete(DeleteBehavior.Restrict);
    }
}
