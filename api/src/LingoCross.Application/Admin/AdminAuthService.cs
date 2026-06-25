using System.Security.Cryptography;
using System.Text;
using LingoCross.Application.Admin.Dtos;
using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Common.Security;
using Microsoft.Extensions.Options;

namespace LingoCross.Application.Admin;

/// <summary>
/// Tek-admin girişini doğrular. E-posta (trim + case-insensitive) ve parola sabit-zamanlı
/// karşılaştırılır; sızıntıyı azaltmak için eşleşme tek bir sonuç olarak değerlendirilir.
/// </summary>
public class AdminAuthService : IAdminAuthService
{
    private readonly AdminOptions _options;
    private readonly ITokenService _tokenService;

    public AdminAuthService(IOptions<AdminOptions> options, ITokenService tokenService)
    {
        _options = options.Value;
        _tokenService = tokenService;
    }

    public AdminLoginResult Login(string email, string password)
    {
        if (string.IsNullOrWhiteSpace(_options.Email) || string.IsNullOrWhiteSpace(_options.Password))
        {
            throw new AppException(503, "Admin yapılandırılmamış.");
        }

        var emailMatch = FixedTimeEquals(
            (email ?? string.Empty).Trim().ToLowerInvariant(),
            _options.Email.Trim().ToLowerInvariant());
        var passwordMatch = FixedTimeEquals(password ?? string.Empty, _options.Password);

        // İki karşılaştırma da yapıldıktan sonra tek karar — erken çıkışla zamanlama sızdırmaz.
        if (!(emailMatch & passwordMatch))
        {
            throw AppException.Unauthorized("E-posta veya parola hatalı.");
        }

        var token = _tokenService.CreateAdminToken(_options.TokenHours);
        return new AdminLoginResult(token.Token, token.ExpiresAt);
    }

    /// <summary>Sabit-zamanlı string karşılaştırması (uzunluk farkından erken çıkmaz).</summary>
    private static bool FixedTimeEquals(string a, string b)
    {
        var bytesA = Encoding.UTF8.GetBytes(a);
        var bytesB = Encoding.UTF8.GetBytes(b);
        return CryptographicOperations.FixedTimeEquals(bytesA, bytesB);
    }
}
