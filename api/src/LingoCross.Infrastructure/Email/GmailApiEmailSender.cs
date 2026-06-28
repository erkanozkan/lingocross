using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using LingoCross.Application.Common.Email;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace LingoCross.Infrastructure.Email;

/// <summary>
/// Gmail API (HTTPS/443) üzerinden e-posta gönderir. Railway giden SMTP portlarını
/// (25/465/587) blokladığı için SMTP yerine kullanılır. Akış:
/// <list type="number">
///   <item>Servis hesabı anahtarından RS256 imzalı, <see cref="GmailOptions.SenderEmail"/>'i
///   impersonate eden (<c>sub</c>) ve <c>gmail.send</c> scope'lu bir OAuth2 JWT üretilir.</item>
///   <item>JWT, <c>jwt-bearer</c> grant ile erişim jetonuna takas edilir (kısa süre cache'lenir).</item>
///   <item>RFC 2822 MIME mesajı base64url'lenip <c>users/{sender}/messages/send</c>'e POST edilir.</item>
/// </list>
/// Workspace Admin'de servis hesabının client ID'sine <c>https://www.googleapis.com/auth/gmail.send</c>
/// scope'uyla domain-wide delegation verilmiş olmalıdır. Gönderim hatası yutulur (loglanır) ki
/// forgot-password ucu enumeration sızdırmadan 200 dönebilsin.
/// </summary>
public class GmailApiEmailSender : IEmailSender
{
    private const string GmailSendScope = "https://www.googleapis.com/auth/gmail.send";
    private const string DefaultTokenUri = "https://oauth2.googleapis.com/token";
    private const string JwtBearerGrant = "urn:ietf:params:oauth:grant-type:jwt-bearer";

    private readonly IHttpClientFactory _httpClientFactory;
    private readonly GmailOptions _options;
    private readonly ILogger<GmailApiEmailSender> _logger;

    // OAuth2 erişim jetonu çağrılar arası paylaşılır (Play doğrulayıcısından ayrı: farklı scope/sub).
    private static readonly object TokenLock = new();
    private static string? _cachedAccessToken;
    private static DateTimeOffset _cachedTokenExpiry = DateTimeOffset.MinValue;

    public GmailApiEmailSender(
        IHttpClientFactory httpClientFactory,
        IOptions<GmailOptions> options,
        ILogger<GmailApiEmailSender> logger)
    {
        _httpClientFactory = httpClientFactory;
        _options = options.Value;
        _logger = logger;
    }

    public async Task SendPasswordResetAsync(string toEmail, string code, CancellationToken cancellationToken = default)
    {
        const string subject = "LingoCross şifre sıfırlama kodu";
        var body = $"Şifre sıfırlama kodunuz: {code}\n\n"
                 + "Kod 15 dakika geçerlidir. Bu isteği siz yapmadıysanız bu e-postayı yok sayın.";

        try
        {
            using var keyDoc = JsonDocument.Parse(_options.ServiceAccountJson);
            var key = keyDoc.RootElement;
            var clientEmail = key.TryGetProperty("client_email", out var e) ? e.GetString() : null;
            var privateKey = key.TryGetProperty("private_key", out var p) ? p.GetString() : null;
            var tokenUri = key.TryGetProperty("token_uri", out var t) ? t.GetString() : null;
            tokenUri = string.IsNullOrWhiteSpace(tokenUri) ? DefaultTokenUri : tokenUri;

            if (string.IsNullOrWhiteSpace(clientEmail) || string.IsNullOrWhiteSpace(privateKey))
            {
                _logger.LogError("Gmail gönderimi: servis hesabı anahtarı geçersiz (client_email/private_key yok).");
                return;
            }

            var accessToken = await GetAccessTokenAsync(clientEmail, privateKey, tokenUri, cancellationToken);

            var raw = Base64UrlEncode(Encoding.UTF8.GetBytes(BuildMimeMessage(toEmail, subject, body)));

            var http = _httpClientFactory.CreateClient();
            var url = "https://gmail.googleapis.com/gmail/v1/users/"
                + $"{Uri.EscapeDataString(_options.SenderEmail)}/messages/send";

            using var request = new HttpRequestMessage(HttpMethod.Post, url);
            request.Headers.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", accessToken);
            request.Content = new StringContent(
                JsonSerializer.Serialize(new { raw }), Encoding.UTF8, "application/json");

            using var response = await http.SendAsync(request, cancellationToken);
            if (!response.IsSuccessStatusCode)
            {
                var detail = await response.Content.ReadAsStringAsync(cancellationToken);
                _logger.LogError(
                    "Gmail API şifre sıfırlama e-postası gönderilemedi -> {Email}. Durum={Status}, Yanıt={Detail}",
                    toEmail, (int)response.StatusCode, detail);
            }
        }
        catch (Exception ex)
        {
            // Gönderim hatasını yut: enumeration sızdırmamak için akış 200 dönmeli.
            _logger.LogError(ex, "Gmail API şifre sıfırlama e-postası gönderilemedi -> {Email}", toEmail);
        }
    }

    /// <summary>Geçerli cache'lenmiş jeton varsa onu, yoksa servis hesabıyla yeni jeton döndürür.</summary>
    private async Task<string> GetAccessTokenAsync(string clientEmail, string privateKey, string tokenUri, CancellationToken cancellationToken)
    {
        lock (TokenLock)
        {
            if (_cachedAccessToken is not null && _cachedTokenExpiry > DateTimeOffset.UtcNow.AddSeconds(60))
            {
                return _cachedAccessToken;
            }
        }

        var jwt = BuildSignedJwt(clientEmail, privateKey, tokenUri);

        var http = _httpClientFactory.CreateClient();
        using var content = new FormUrlEncodedContent(new[]
        {
            new KeyValuePair<string, string>("grant_type", JwtBearerGrant),
            new KeyValuePair<string, string>("assertion", jwt),
        });

        using var response = await http.PostAsync(tokenUri, content, cancellationToken);
        response.EnsureSuccessStatusCode();

        await using var stream = await response.Content.ReadAsStreamAsync(cancellationToken);
        using var doc = await JsonDocument.ParseAsync(stream, cancellationToken: cancellationToken);
        var root = doc.RootElement;

        var accessToken = root.TryGetProperty("access_token", out var at) ? at.GetString() : null;
        var expiresIn = root.TryGetProperty("expires_in", out var ex) && ex.TryGetInt32(out var s) ? s : 3600;

        if (string.IsNullOrWhiteSpace(accessToken))
        {
            throw new HttpRequestException("OAuth2 yanıtı access_token içermiyor.");
        }

        lock (TokenLock)
        {
            _cachedAccessToken = accessToken;
            _cachedTokenExpiry = DateTimeOffset.UtcNow.AddSeconds(expiresIn);
        }

        return accessToken;
    }

    /// <summary>
    /// Servis hesabı akışı için RS256 imzalı JWT üretir. <c>sub</c> ile gönderen kullanıcıyı
    /// impersonate eder (domain-wide delegation gerektirir), scope yalnızca <c>gmail.send</c>.
    /// </summary>
    private string BuildSignedJwt(string clientEmail, string privateKey, string tokenUri)
    {
        var now = DateTimeOffset.UtcNow;

        var header = new Dictionary<string, object?> { ["alg"] = "RS256", ["typ"] = "JWT" };
        var claims = new Dictionary<string, object?>
        {
            ["iss"] = clientEmail,
            ["sub"] = _options.SenderEmail,
            ["scope"] = GmailSendScope,
            ["aud"] = tokenUri,
            ["iat"] = now.ToUnixTimeSeconds(),
            ["exp"] = now.AddHours(1).ToUnixTimeSeconds(),
        };

        var signingInput = $"{Base64UrlEncode(JsonSerializer.SerializeToUtf8Bytes(header))}."
            + Base64UrlEncode(JsonSerializer.SerializeToUtf8Bytes(claims));

        using var rsa = RSA.Create();
        rsa.ImportFromPem(privateKey);
        var signature = rsa.SignData(
            Encoding.ASCII.GetBytes(signingInput), HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);

        return $"{signingInput}.{Base64UrlEncode(signature)}";
    }

    /// <summary>RFC 2822 MIME mesajı. Konu RFC 2047 (UTF-8 encoded-word), gövde base64/UTF-8.</summary>
    private string BuildMimeMessage(string toEmail, string subject, string body)
    {
        var encodedSubject = $"=?UTF-8?B?{Convert.ToBase64String(Encoding.UTF8.GetBytes(subject))}?=";
        var encodedBody = Convert.ToBase64String(Encoding.UTF8.GetBytes(body));

        var sb = new StringBuilder();
        sb.Append("From: ").Append(_options.FromName).Append(" <").Append(_options.SenderEmail).Append(">\r\n");
        sb.Append("To: ").Append(toEmail).Append("\r\n");
        sb.Append("Subject: ").Append(encodedSubject).Append("\r\n");
        sb.Append("MIME-Version: 1.0\r\n");
        sb.Append("Content-Type: text/plain; charset=\"UTF-8\"\r\n");
        sb.Append("Content-Transfer-Encoding: base64\r\n");
        sb.Append("\r\n");
        sb.Append(encodedBody);
        return sb.ToString();
    }

    /// <summary>base64url (dolgusuz, <c>-_</c> alfabesi).</summary>
    private static string Base64UrlEncode(byte[] bytes) =>
        Convert.ToBase64String(bytes).TrimEnd('=').Replace('+', '-').Replace('/', '_');
}
