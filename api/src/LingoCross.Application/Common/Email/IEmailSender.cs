namespace LingoCross.Application.Common.Email;

/// <summary>E-posta gönderim soyutlaması. Geliştirmede log'a yazan stub ile uygulanır.</summary>
public interface IEmailSender
{
    Task SendPasswordResetAsync(string toEmail, string resetToken, CancellationToken cancellationToken = default);
}
