using FluentValidation;
using LingoCross.Application.Auth.Dtos;
using LingoCross.Domain.Enums;

namespace LingoCross.Application.Auth.Validators;

public class RegisterRequestValidator : AbstractValidator<RegisterRequest>
{
    public RegisterRequestValidator()
    {
        RuleFor(x => x.Email).NotEmpty().EmailAddress().MaximumLength(256);
        RuleFor(x => x.Password).NotEmpty().MinimumLength(8).MaximumLength(128);
        RuleFor(x => x.DisplayName).NotEmpty().MaximumLength(128);
        RuleFor(x => x.Role).Must(r => r == UserRole.Teacher || r == UserRole.Student)
            .WithMessage("Rol öğretmen veya öğrenci olmalıdır.");
    }
}

public class LoginRequestValidator : AbstractValidator<LoginRequest>
{
    public LoginRequestValidator()
    {
        RuleFor(x => x.Email).NotEmpty().EmailAddress();
        RuleFor(x => x.Password).NotEmpty();
    }
}

public class RefreshRequestValidator : AbstractValidator<RefreshRequest>
{
    public RefreshRequestValidator()
    {
        RuleFor(x => x.RefreshToken).NotEmpty();
    }
}

public class LogoutRequestValidator : AbstractValidator<LogoutRequest>
{
    public LogoutRequestValidator()
    {
        RuleFor(x => x.RefreshToken).NotEmpty();
    }
}

public class ForgotPasswordRequestValidator : AbstractValidator<ForgotPasswordRequest>
{
    public ForgotPasswordRequestValidator()
    {
        RuleFor(x => x.Email).NotEmpty().EmailAddress();
    }
}

public class ResetPasswordRequestValidator : AbstractValidator<ResetPasswordRequest>
{
    public ResetPasswordRequestValidator()
    {
        RuleFor(x => x.Email).NotEmpty().EmailAddress();
        RuleFor(x => x.Code).NotEmpty().Matches("^[0-9]{6}$")
            .WithMessage("Kod 6 haneli olmalıdır.");
        RuleFor(x => x.NewPassword).NotEmpty().MinimumLength(8).MaximumLength(128);
    }
}

public class UpdateProfileRequestValidator : AbstractValidator<UpdateProfileRequest>
{
    public UpdateProfileRequestValidator()
    {
        RuleFor(x => x.DisplayName)
            .Must(d => !string.IsNullOrWhiteSpace(d))
            .WithMessage("Ad boş olamaz.")
            .MaximumLength(80);

        // Opsiyonel: gönderilirse yalnız "tr"/"en"; boş/null kabul (servis tarafı yok sayar).
        RuleFor(x => x.PreferredLocale)
            .Must(l => l is not null
                && (string.Equals(l.Trim(), "tr", StringComparison.OrdinalIgnoreCase)
                    || string.Equals(l.Trim(), "en", StringComparison.OrdinalIgnoreCase)))
            .WithMessage("Dil yalnızca tr veya en olabilir.")
            .When(x => !string.IsNullOrWhiteSpace(x.PreferredLocale));
    }
}

public class ChangePasswordRequestValidator : AbstractValidator<ChangePasswordRequest>
{
    public ChangePasswordRequestValidator()
    {
        RuleFor(x => x.CurrentPassword).NotEmpty();
        RuleFor(x => x.NewPassword).NotEmpty().MinimumLength(8).MaximumLength(128);
    }
}
