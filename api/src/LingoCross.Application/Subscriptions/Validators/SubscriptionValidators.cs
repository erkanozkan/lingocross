using FluentValidation;
using LingoCross.Application.Subscriptions.Dtos;

namespace LingoCross.Application.Subscriptions.Validators;

public class ActivateStubRequestValidator : AbstractValidator<ActivateStubRequest>
{
    public ActivateStubRequestValidator()
    {
        // Deneme değilse dönem (aylık/yıllık) zorunludur.
        RuleFor(x => x.Period)
            .NotNull()
            .When(x => !x.Trial)
            .WithMessage("Deneme dışı abonelik için dönem (aylık/yıllık) zorunludur.");

        RuleFor(x => x.Period)
            .IsInEnum()
            .When(x => x.Period.HasValue)
            .WithMessage("Geçersiz abonelik dönemi.");
    }
}
