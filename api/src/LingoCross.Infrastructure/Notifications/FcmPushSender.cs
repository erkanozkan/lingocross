using FirebaseAdmin;
using FirebaseAdmin.Messaging;
using Google.Apis.Auth.OAuth2;
using LingoCross.Application.Notifications;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace LingoCross.Infrastructure.Notifications;

/// <summary>
/// <see cref="IPushSender"/>'i Firebase Cloud Messaging (HTTP v1) ile uygular. Yapılandırma
/// (<c>Firebase:ServiceAccountJson</c>) boş/null ise push DEVRE DIŞIDIR: <see cref="SendToTokensAsync"/>
/// no-op olarak boş liste döner ve başlangıçta bir uyarı loglanır. Singleton olarak kaydedilir
/// (FirebaseApp uygulama başına bir kez oluşturulur).
/// </summary>
public class FcmPushSender : IPushSender
{
    /// <summary>FCM tek istekte en fazla 500 mesaj kabul eder.</summary>
    private const int BatchSize = 500;

    private readonly ILogger<FcmPushSender> _logger;
    private readonly FirebaseMessaging? _messaging;

    public FcmPushSender(IConfiguration configuration, ILogger<FcmPushSender> logger)
    {
        _logger = logger;

        var json = configuration["Firebase:ServiceAccountJson"];
        if (string.IsNullOrWhiteSpace(json))
        {
            _logger.LogWarning(
                "Firebase:ServiceAccountJson ayarlı değil; push bildirimleri yapılandırılmadı (no-op).");
            _messaging = null;
            return;
        }

        try
        {
            // Uygulama başına tek FirebaseApp; varsa yeniden oluşturma.
            var app = FirebaseApp.DefaultInstance ?? FirebaseApp.Create(new AppOptions
            {
                Credential = GoogleCredential.FromJson(json),
            });

            _messaging = FirebaseMessaging.GetMessaging(app);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Firebase başlatılamadı; push bildirimleri devre dışı.");
            _messaging = null;
        }
    }

    public async Task<IReadOnlyList<string>> SendToTokensAsync(
        IReadOnlyList<string> tokens,
        string title,
        string body,
        IReadOnlyDictionary<string, string>? data,
        CancellationToken ct = default)
    {
        // Yapılandırılmadıysa veya gönderilecek token yoksa no-op.
        if (_messaging is null || tokens.Count == 0)
        {
            return [];
        }

        var notification = new Notification { Title = title, Body = body };
        var dataDict = data is null ? null : new Dictionary<string, string>(data);

        var invalid = new List<string>();

        foreach (var chunk in Chunk(tokens, BatchSize))
        {
            var messages = chunk
                .Select(token => new Message
                {
                    Token = token,
                    Notification = notification,
                    Data = dataDict,
                })
                .ToList();

            BatchResponse response;
            try
            {
                response = await _messaging.SendEachAsync(messages, ct);
            }
            catch (Exception ex)
            {
                // Toplu hata (ör. ağ/yetkilendirme): geçici kabul edilir, token silinmez.
                _logger.LogWarning(ex, "FCM toplu gönderim başarısız ({Count} token).", chunk.Count);
                continue;
            }

            for (var i = 0; i < response.Responses.Count; i++)
            {
                var item = response.Responses[i];
                if (item.IsSuccess)
                {
                    continue;
                }

                if (IsInvalidTokenError(item.Exception))
                {
                    invalid.Add(chunk[i]);
                }
            }
        }

        return invalid;
    }

    /// <summary>
    /// Token'ın kalıcı olarak geçersiz olduğunu (kayıttan silinmesi gerektiğini) belirten FCM hata
    /// kodları: kayıtsız token veya geçersiz argüman.
    /// </summary>
    private static bool IsInvalidTokenError(FirebaseMessagingException? ex)
        => ex is not null
            && ex.MessagingErrorCode is MessagingErrorCode.Unregistered or MessagingErrorCode.InvalidArgument;

    private static IEnumerable<List<string>> Chunk(IReadOnlyList<string> source, int size)
    {
        for (var i = 0; i < source.Count; i += size)
        {
            yield return source.Skip(i).Take(size).ToList();
        }
    }
}
