using LingoCross.Domain.Common;

namespace LingoCross.Domain.Entities;

/// <summary>
/// Bir öğretmenin adlandırılmış sınıfı (F4.3). Dersler öğretmen seviyesinde kalır; sınıflar
/// öğrenci gruplarını temsil eder ve oyunlar sınıflara atanır. Davet kodu (önceden öğretmen
/// seviyesindeydi) artık sınıf seviyesindedir: öğrenci bir sınıfa katılır. Arşivlenmiş sınıf
/// görünürlük vermez.
/// </summary>
public class Class : Entity
{
    public Guid TeacherId { get; set; }

    public User Teacher { get; set; } = null!;

    public string Name { get; set; } = string.Empty;

    /// <summary>Sınıfa katılım davet kodu; üretilmemişse null.</summary>
    public string? InviteCode { get; set; }

    public bool IsArchived { get; set; }

    public ICollection<ClassMember> Members { get; set; } = new List<ClassMember>();

    public ICollection<GameAssignment> Assignments { get; set; } = new List<GameAssignment>();
}
