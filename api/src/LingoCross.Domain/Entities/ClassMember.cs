using LingoCross.Domain.Common;
using LingoCross.Domain.Enums;

namespace LingoCross.Domain.Entities;

/// <summary>
/// Bir öğrencinin bir sınıftaki üyeliği (F4.3). (class_id, student_id) çifti benzersizdir.
/// Aktif (Active) üyelik, öğrencinin o sınıfa atanmış yayınlı oyunlara erişmesini sağlar.
/// </summary>
public class ClassMember : Entity
{
    public Guid ClassId { get; set; }

    public Class Class { get; set; } = null!;

    public Guid StudentId { get; set; }

    public User Student { get; set; } = null!;

    public ClassMemberStatus Status { get; set; } = ClassMemberStatus.Active;
}
