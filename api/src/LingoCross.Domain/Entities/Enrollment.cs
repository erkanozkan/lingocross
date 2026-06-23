using LingoCross.Domain.Common;
using LingoCross.Domain.Enums;

namespace LingoCross.Domain.Entities;

/// <summary>
/// Bir öğretmen ile bir öğrenci arasındaki eşleşme. Öğrenci, öğretmenin davet kodunu girerek
/// katılır. Aktif (Active) bir eşleşme, öğrencinin o öğretmenin yayımlanmış derslerine erişmesini
/// sağlar. (teacher_id, student_id) çifti benzersizdir.
/// </summary>
public class Enrollment : Entity
{
    public Guid TeacherId { get; set; }

    public User Teacher { get; set; } = null!;

    public Guid StudentId { get; set; }

    public User Student { get; set; } = null!;

    public EnrollmentStatus Status { get; set; }
}
