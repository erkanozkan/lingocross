namespace LingoCross.Application.Notifications;

/// <summary>
/// Düşük seviyeli push gönderim soyutlaması (FCM gibi bir sağlayıcının arkasına alınır).
/// Yapılandırma yoksa uygulamalar no-op olarak boş liste döndürebilir.
/// </summary>
public interface IPushSender
{
    /// <summary>
    /// Verilen token'lara bir bildirim gönderir. Dönüş değeri, sağlayıcının artık geçersiz
    /// (kayıttan silinmesi gereken) bildirdiği token'ların listesidir; geçerli/geçici hata
    /// alan token'lar listeye eklenmez.
    /// </summary>
    Task<IReadOnlyList<string>> SendToTokensAsync(
        IReadOnlyList<string> tokens,
        string title,
        string body,
        IReadOnlyDictionary<string, string>? data,
        CancellationToken ct = default);
}
