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

    public static AppException BadRequest(string message) => new(400, message);

    public static AppException Unauthorized(string message) => new(401, message);

    public static AppException NotFound(string message) => new(404, message);

    public static AppException Conflict(string message) => new(409, message);
}
