using LingoCross.Application.Enrollments.Dtos;
using LingoCross.Domain.Enums;

namespace LingoCross.Application.Enrollments;

/// <summary>
/// Öğretmen-öğrenci eşleşmesi (enrollment) yönetimi. Yetki/sahiplik kuralları bu katmanda
/// uygulanır: davet kodu yalnızca öğretmenin, katılım yalnızca öğrencinin işidir.
///
/// Katılım durumu kararı (M3): PM raporu olmadığından <c>JoinByCode</c> doğrudan
/// <see cref="EnrollmentStatus.Active"/> üretir — davet kodunun paylaşılması rıza sayılır.
/// Onay (Pending → Active) akışı ileride etkinleştirilebilsin diye <c>AcceptAsync</c> korunur.
/// </summary>
public interface IEnrollmentService
{
    /// <summary>Oturum açan öğretmenin davet kodunu döndürür; yoksa üretip kaydeder.</summary>
    Task<InviteCodeDto> GetOrCreateInviteCodeAsync(CancellationToken cancellationToken = default);

    /// <summary>Oturum açan öğretmen için yeni bir davet kodu üretip eskisinin yerine koyar.</summary>
    Task<InviteCodeDto> RegenerateInviteCodeAsync(CancellationToken cancellationToken = default);

    /// <summary>
    /// Öğrenci, davet koduyla bir öğretmene katılır. (teacher, student) çifti zaten varsa idempotent
    /// olarak mevcut eşleşmeyi döndürür; yoksa yeni bir Active eşleşme oluşturur.
    /// </summary>
    Task<EnrollmentDto> JoinByCodeAsync(JoinByCodeRequest request, CancellationToken cancellationToken = default);

    /// <summary>
    /// Oturum açan kullanıcının eşleşmeleri: öğretmen → öğrencileri, öğrenci → öğretmenleri.
    /// </summary>
    Task<IReadOnlyList<EnrollmentDto>> ListMineAsync(CancellationToken cancellationToken = default);

    /// <summary>
    /// (Pending akışı için) Öğretmen, kendisine ait bekleyen bir eşleşmeyi onaylar (Active yapar).
    /// Active'e doğrudan katılım kararı yürürlükteyken normal akışta çağrılmaz ama API yüzeyi korunur.
    /// </summary>
    Task<EnrollmentDto> AcceptAsync(Guid enrollmentId, CancellationToken cancellationToken = default);
}
