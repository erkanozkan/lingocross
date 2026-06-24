using LingoCross.Application.Classes.Dtos;
using LingoCross.Domain.Entities;

namespace LingoCross.Application.Classes;

/// <summary>
/// Adlandırılmış sınıflar (F4.3). Sınıflar öğretmen seviyesinde gruplardır; davet kodu sınıf
/// seviyesindedir ve öğrenci bir sınıfa katılır. Sahiplik/yetki kuralları bu katmanda uygulanır:
/// tüm sınıf işlemleri yalnızca sahibi öğretmenindir (aksi 404), öğrenci uçları yalnız öğrencidir.
/// </summary>
public interface IClassService
{
    /// <summary>Öğretmen yeni bir sınıf oluşturur; oluştururken bir davet kodu üretilir.</summary>
    Task<ClassDto> CreateAsync(SaveClassRequest request, CancellationToken cancellationToken = default);

    /// <summary>Öğretmenin arşivlenmemiş sınıfları (her birinde aktif üye sayısı).</summary>
    Task<IReadOnlyList<ClassDto>> ListMineAsync(CancellationToken cancellationToken = default);

    /// <summary>Sınıf detayı (aktif üyelerle). Sahibi olmayan/yok olan sınıf → 404.</summary>
    Task<ClassDetailDto> GetAsync(Guid classId, CancellationToken cancellationToken = default);

    /// <summary>Sınıf adını günceller. Sahibi olmayan/yok olan sınıf → 404.</summary>
    Task<ClassDto> UpdateAsync(Guid classId, SaveClassRequest request, CancellationToken cancellationToken = default);

    /// <summary>Sınıfı arşivler (is_archived=true). Arşivli sınıf görünürlük vermez. Sahibi değilse 404.</summary>
    Task ArchiveAsync(Guid classId, CancellationToken cancellationToken = default);

    /// <summary>Sınıfın davet kodunu döndürür; yoksa üretip kaydeder. Sahibi değilse 404.</summary>
    Task<ClassInviteCodeDto> GetOrCreateInviteCodeAsync(Guid classId, CancellationToken cancellationToken = default);

    /// <summary>Sınıf için yeni bir davet kodu üretip eskisinin yerine koyar. Sahibi değilse 404.</summary>
    Task<ClassInviteCodeDto> RegenerateInviteCodeAsync(Guid classId, CancellationToken cancellationToken = default);

    /// <summary>Bir öğrenciyi sınıftan çıkarır (üyeliği siler). Sahibi değilse 404.</summary>
    Task RemoveStudentAsync(Guid classId, Guid studentId, CancellationToken cancellationToken = default);

    /// <summary>Öğrencinin aktif üye olduğu (arşivlenmemiş) sınıflar.</summary>
    Task<IReadOnlyList<StudentClassDto>> ListForStudentAsync(CancellationToken cancellationToken = default);

    /// <summary>
    /// Öğrenci, davet koduyla bir sınıfa katılır (idempotent). Kod trim+upper edilir; arşivli ya da
    /// geçersiz kod → 404. Eski TestFlight sürümleri için ayrıca enrollment köprüsü EnrollmentService
    /// tarafında ele alınır; burası yalnız sınıf üyeliği oluşturur.
    /// </summary>
    Task<StudentClassDto> JoinByCodeAsync(JoinClassRequest request, CancellationToken cancellationToken = default);

    /// <summary>
    /// (Köprü) Normalize edilmiş (trim+upper) bir koda sahip katılınabilir (arşivlenmemiş) sınıfı
    /// öğretmeniyle birlikte getirir; yoksa null. EnrollmentService köprüsü tarafından kullanılır.
    /// </summary>
    Task<Class?> FindJoinableClassByCodeAsync(string normalizedCode, CancellationToken cancellationToken);

    /// <summary>
    /// (Köprü) (class, student) için Active üyelik yoksa oluşturur (idempotent). EnrollmentService
    /// köprüsü tarafından kullanılır.
    /// </summary>
    Task EnsureClassMembershipAsync(Guid classId, Guid studentId, CancellationToken cancellationToken);
}
