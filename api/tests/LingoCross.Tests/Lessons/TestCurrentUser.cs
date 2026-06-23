using LingoCross.Application.Common.Security;
using LingoCross.Domain.Enums;

namespace LingoCross.Tests.Lessons;

/// <summary>Servis testlerinde geçerli isteğin kimliğini taklit eder.</summary>
internal sealed class TestCurrentUser : ICurrentUser
{
    public TestCurrentUser(Guid? userId, UserRole? role)
    {
        UserId = userId;
        Role = role;
    }

    public Guid? UserId { get; }

    public UserRole? Role { get; }

    public bool IsAuthenticated => UserId is not null;

    public static TestCurrentUser Teacher(Guid id) => new(id, UserRole.Teacher);

    public static TestCurrentUser Student(Guid id) => new(id, UserRole.Student);
}
