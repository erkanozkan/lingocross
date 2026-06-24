using FluentValidation;
using LingoCross.Application.Notifications.Dtos;

namespace LingoCross.Application.Notifications.Validators;

public class RegisterDeviceRequestValidator : AbstractValidator<RegisterDeviceRequest>
{
    private static readonly string[] AllowedPlatforms = ["ios", "android"];

    public RegisterDeviceRequestValidator()
    {
        RuleFor(x => x.Token)
            .NotEmpty().WithMessage("Token zorunludur.")
            .MaximumLength(512).WithMessage("Token en fazla 512 karakter olabilir.");

        RuleFor(x => x.Platform)
            .NotEmpty().WithMessage("Platform zorunludur.")
            .Must(p => p is not null && AllowedPlatforms.Contains(p.Trim().ToLowerInvariant()))
            .WithMessage("Platform yalnızca 'ios' veya 'android' olabilir.");
    }
}
