using FluentValidation;
using LingoCross.Application.Results.Dtos;

namespace LingoCross.Application.Results.Validators;

/// <summary>F7.5: tek bir kelime-bazlı kalem kuralları (Items doluysa uygulanır).</summary>
public class SubmitResultItemValidator : AbstractValidator<SubmitResultItem>
{
    public SubmitResultItemValidator()
    {
        RuleFor(x => x.Ordinal).GreaterThanOrEqualTo(0);
        RuleFor(x => x.Term).NotEmpty().MaximumLength(200);
        RuleFor(x => x.ExpectedAnswer).NotEmpty().MaximumLength(200);
        RuleFor(x => x.StudentAnswer).MaximumLength(200).When(x => x.StudentAnswer is not null);
    }
}

/// <summary>
/// Sonuç gönderimi kuralları. <see cref="SubmitResultRequest.Items"/> opsiyoneldir (null/boş
/// geçerli); verildiyse her kalem doğrulanır.
/// </summary>
public class SubmitResultRequestValidator : AbstractValidator<SubmitResultRequest>
{
    public SubmitResultRequestValidator()
    {
        RuleForEach(x => x.Items).SetValidator(new SubmitResultItemValidator()).When(x => x.Items is not null);
    }
}
