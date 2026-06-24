using FluentValidation;
using LingoCross.Application.Classes.Dtos;

namespace LingoCross.Application.Classes.Validators;

public class SaveClassRequestValidator : AbstractValidator<SaveClassRequest>
{
    public SaveClassRequestValidator()
    {
        RuleFor(x => x.Name)
            .NotEmpty().WithMessage("Sınıf adı zorunludur.")
            .MaximumLength(64).WithMessage("Sınıf adı en fazla 64 karakter olabilir.");
    }
}

public class JoinClassRequestValidator : AbstractValidator<JoinClassRequest>
{
    public JoinClassRequestValidator()
    {
        RuleFor(x => x.Code)
            .NotEmpty().WithMessage("Davet kodu zorunludur.")
            .MaximumLength(32).WithMessage("Davet kodu en fazla 32 karakter olabilir.");
    }
}
