namespace LingoCross.Application.Common.Exceptions;

/// <summary>
/// Beklenen (iş kuralı kaynaklı) hata. İlişkili HTTP durum kodu taşır ve API katmanında
/// ProblemDetails'e çevrilir.
/// </summary>
public class AppException : Exception
{
    public AppException(int statusCode, string message) : base(message)
    {
        StatusCode = statusCode;
    }

    public int StatusCode { get; }

    /// <summary>
    /// İstemcinin programatik olarak ayırt edebileceği makine-okunur hata kodu (ör.
    /// "subscription_required"). Doluysa ProblemDetails'in "code" uzantısına yazılır.
    /// </summary>
    public string? Code { get; init; }

    /// <summary>
    /// 402 (ödeme gerekli) durumunda hangi premium özelliğin kilitli olduğunu belirten anahtar
    /// (ör. "ocr", "class_limit"). Doluysa ProblemDetails'in "feature" uzantısına yazılır.
    /// </summary>
    public string? Feature { get; init; }

    public static AppException BadRequest(string message) => new(400, message);

    public static AppException Unauthorized(string message) => new(401, message);

    public static AppException NotFound(string message) => new(404, message);

    public static AppException Conflict(string message) => new(409, message);

    /// <summary>
    /// Premium gerektiren bir özelliğe Free kullanıcı eriştiğinde fırlatılır. HTTP 402 +
    /// code="subscription_required" + ilgili feature anahtarı taşır.
    /// </summary>
    public static AppException PaymentRequired(string message, string feature)
        => new(402, message) { Code = "subscription_required", Feature = feature };
}
