namespace LingoCross.Application.Common.Security;

/// <summary>Şifre hash'leme/doğrulama soyutlaması. Infrastructure'da BCrypt ile uygulanır.</summary>
public interface IPasswordHasher
{
    string Hash(string password);

    bool Verify(string password, string hash);
}
