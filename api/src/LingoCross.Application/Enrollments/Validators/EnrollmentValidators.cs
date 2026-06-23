using FluentValidation;
using LingoCross.Application.Enrollments.Dtos;

namespace LingoCross.Application.Enrollments.Validators;

public class JoinByCodeRequestValidator : AbstractValidator<JoinByCodeRequest>
{
    public JoinByCodeRequestValidator()
    {
        RuleFor(x => x.Code)
            .NotEmpty().WithMessage("Davet kodu zorunludur.")
            .MaximumLength(32).WithMessage("Davet kodu en fazla 32 karakter olabilir.");
    }
}
