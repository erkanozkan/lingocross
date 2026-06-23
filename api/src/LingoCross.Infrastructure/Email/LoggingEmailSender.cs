using LingoCross.Application.Common.Email;
using Microsoft.Extensions.Logging;

namespace LingoCross.Infrastructure.Email;

/// <summary>
/// Geliştirme için stub e-posta gönderici: gerçek SMTP yerine log'a yazar.
/// MVP'de transactional sağlayıcı (Resend/SendGrid/Mailgun) ile değiştirilecek.
/// </summary>
public class LoggingEmailSender : IEmailSender
{
    private readonly ILogger<LoggingEmailSender> _logger;

    public LoggingEmailSender(ILogger<LoggingEmailSender> logger)
    {
        _logger = logger;
    }

    public Task SendPasswordResetAsync(string toEmail, string resetToken, CancellationToken cancellationToken = default)
    {
        _logger.LogInformation(
            "[DEV EMAIL] Şifre sıfırlama -> {Email} | reset token: {ResetToken}",
            toEmail, resetToken);
        return Task.CompletedTask;
    }
}
