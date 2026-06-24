using LingoCross.Application.Teachers.Dtos;

namespace LingoCross.Application.Teachers;

/// <summary>
/// Öğretmen takip görünümü (F2.3). Öğretmen yalnızca kendi <b>Active</b> eşleşmeli öğrencilerinin,
/// yalnızca <b>paylaşılmış</b> (shared_with_teacher=true) sonuçlarını görür. Sahiplik/gizlilik
/// kuralları bu katmanda uygulanır; paylaşılmamış sonuçlar sızmaz. Yeni tablo yoktur — mevcut
/// game_results → game_sessions → student → enrollments join'i kullanılır.
/// </summary>
public interface ITeacherTrackingService
{
    /// <summary>
    /// Geçerli öğretmenin <b>Active</b> eşleşmeli öğrencileri + her biri için özet: paylaşılan sonuç
    /// sayısı, ortalama skor (yalnız paylaşılan sonuçlar üzerinden; hiç yoksa null) ve son aktivite
    /// (en son paylaşılan sonucun zamanı; hiç yoksa null). Görünen ada göre sıralı.
    /// </summary>
    Task<IReadOnlyList<StudentSummaryDto>> ListMyStudentsAsync(CancellationToken cancellationToken = default);

    /// <summary>
    /// Verilen öğrencinin, geçerli öğretmenle <b>paylaştığı</b> sonuçları (ders/oyun özetiyle),
    /// yeniden eskiye. Öğrenci bu öğretmene Active eşleşmeli değilse 404. Paylaşılmamış sonuçlar dönmez.
    /// </summary>
    Task<IReadOnlyList<SharedResultDto>> GetStudentSharedResultsAsync(Guid studentId, CancellationToken cancellationToken = default);

    /// <summary>
    /// Verilen öğrencinin, geçerli öğretmenle <b>paylaştığı</b> tek bir sonucunun kelime-bazlı
    /// detayını döndürür (F7.5). Öğrenci bu öğretmene Active eşleşmeli olmalı; sonuç o öğrenciye ait
    /// ve paylaşılmış (shared_with_teacher=true) olmalıdır; aksi 404. Kalemler Ordinal sırasında;
    /// eski sonuçlarda boş liste.
    /// </summary>
    Task<StudentResultDetailDto> GetStudentResultDetailAsync(Guid studentId, Guid resultId, CancellationToken cancellationToken = default);

    /// <summary>
    /// Geçerli öğretmenin profil istatistikleri (F7): arşivlenmemiş sınıf sayısı, sınıflarındaki
    /// distinct Active öğrenci sayısı ve son 7 günün haftalık ödev beklenen/tamamlanan sayıları
    /// (+ tamamlanma oranı). Sahiplik bu katmanda uygulanır; yalnız kendi verisi.
    /// </summary>
    Task<TeacherStatsDto> GetMyStatsAsync(CancellationToken cancellationToken = default);
}
