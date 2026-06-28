namespace LingoCross.Application.Common.Email;

/// <summary>E-posta gönderim soyutlaması. Geliştirmede log'a yazan stub ile uygulanır.</summary>
public interface IEmailSender
{
    /// <summary><paramref name="code"/> kullanıcıya gönderilen 6 haneli düz şifre sıfırlama kodudur.</summary>
    Task SendPasswordResetAsync(string toEmail, string code, CancellationToken cancellationToken = default);
}
