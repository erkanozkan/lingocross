using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using LingoCross.Application.Common.Security;
using LingoCross.Domain.Enums;

namespace LingoCross.Api.Infrastructure;

/// <summary>
/// Geçerli isteğin kimliğini JWT claim'lerinden okur ('sub' ve role). Auth ile tutarlı olması
/// için 'sub' yoksa NameIdentifier'a düşer.
/// </summary>
public class HttpCurrentUser : ICurrentUser
{
    private readonly IHttpContextAccessor _accessor;

    public HttpCurrentUser(IHttpContextAccessor accessor)
    {
        _accessor = accessor;
    }

    public Guid? UserId
    {
        get
        {
            var principal = _accessor.HttpContext?.User;
            var sub = principal?.FindFirstValue(JwtRegisteredClaimNames.Sub)
                ?? principal?.FindFirstValue(ClaimTypes.NameIdentifier);
            return Guid.TryParse(sub, out var id) ? id : null;
        }
    }

    public UserRole? Role
    {
        get
        {
            var role = _accessor.HttpContext?.User?.FindFirstValue(ClaimTypes.Role);
            return Enum.TryParse<UserRole>(role, ignoreCase: true, out var parsed) ? parsed : null;
        }
    }

    public bool IsAuthenticated => UserId is not null;
}
