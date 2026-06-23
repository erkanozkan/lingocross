using LingoCross.Domain.Enums;

namespace LingoCross.Application.Common.Security;

/// <summary>
/// Geçerli isteğin kimliği. Değerler JWT claim'lerinden ('sub', 'role') türetilir.
/// Servisler sahiplik kontrolü için kullanıcı id'sini buradan alır; HttpContext'e bağımlı olmaz.
/// </summary>
public interface ICurrentUser
{
    /// <summary>Oturum açmışsa kullanıcı id'si ('sub' claim'i), aksi halde null.</summary>
    Guid? UserId { get; }

    /// <summary>Oturum açmışsa rolü, aksi halde null.</summary>
    UserRole? Role { get; }

    bool IsAuthenticated { get; }
}
