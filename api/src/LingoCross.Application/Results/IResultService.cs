using LingoCross.Application.Results.Dtos;

namespace LingoCross.Application.Results;

/// <summary>
/// Oyun sonuçlarının kaydı, öğretmenle paylaşımı ve öğrencinin geçmişi (M5, öğrenci tarafı).
/// Sahiplik kuralları bu katmanda uygulanır: öğrenci yalnızca kendi oturum/sonucu üzerinde
/// işlem yapabilir; aksi 404. Öğretmen takip görünümü M6 kapsamındadır.
/// </summary>
public interface IResultService
{
    /// <summary>
    /// Tamamlanan bir oyun oturumu için sonuç kaydeder. Oturumun sahibi öğrenci olmalı ve
    /// InProgress durumda bulunmalıdır; aksi 404/409. Başarı puanı (0–100 doğruluk yüzdesi)
    /// hesaplanır, oturum Completed'a alınır ve completed_at set edilir. Oturum başına tek sonuç:
    /// daha önce sonuç gönderilmişse aynı sonuç idempotent biçimde döndürülür.
    /// </summary>
    Task<GameResultDto> SubmitResultAsync(Guid sessionId, SubmitResultRequest request, CancellationToken cancellationToken = default);

    /// <summary>
    /// Bir sonucu öğretmenle paylaşır (shared_with_teacher=true, shared_at set). Sonucun sahibi
    /// öğrenci olmalıdır; aksi 404. Zaten paylaşılmışsa idempotenttir.
    /// </summary>
    Task<GameResultDto> ShareWithTeacherAsync(Guid resultId, CancellationToken cancellationToken = default);

    /// <summary>Geçerli öğrencinin geçmiş sonuçları (ders/oyun özetiyle), yeniden eskiye.</summary>
    Task<IReadOnlyList<GameResultDto>> ListMineAsync(CancellationToken cancellationToken = default);

    /// <summary>
    /// Geçerli öğrencinin profil istatistikleri (F3.1): tamamlanmış sonuç sayısı ve ortalama
    /// başarı puanı. Sonuç yoksa 0/0. Yalnızca kendi sonuçları sayılır.
    /// </summary>
    Task<StudentStatsDto> GetMyStatsAsync(CancellationToken cancellationToken = default);

    /// <summary>
    /// Geçerli öğrencinin "Gelişim Özeti" zengin istatistiği (F3.1+): oynanan oyun sayısı, ortalama
    /// doğruluk, 7 günlük doğruluk trendi, haftalık dakika/hedef ve günlük seri (streak). Yalnızca
    /// kendi sonuçları sayılır; sonuç yoksa sayısal alanlar 0, trend null.
    /// </summary>
    Task<StudentProgressDto> GetMyProgressAsync(CancellationToken cancellationToken = default);
}
