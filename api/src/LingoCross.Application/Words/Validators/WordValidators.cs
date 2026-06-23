using FluentValidation;
using LingoCross.Application.Words.Dtos;

namespace LingoCross.Application.Words.Validators;

public class TranslationPayloadValidator : AbstractValidator<TranslationPayload>
{
    public TranslationPayloadValidator()
    {
        RuleFor(x => x.Text).NotEmpty().MaximumLength(200);
    }
}

public class AddWordRequestValidator : AbstractValidator<AddWordRequest>
{
    public AddWordRequestValidator()
    {
        RuleFor(x => x.Term).NotEmpty().MaximumLength(200);
        RuleFor(x => x.SortOrder).GreaterThanOrEqualTo(0).When(x => x.SortOrder.HasValue);
        RuleFor(x => x.Translations).NotEmpty().WithMessage("En az bir çeviri gereklidir.");
        RuleForEach(x => x.Translations).SetValidator(new TranslationPayloadValidator());
        RuleForEach(x => x.Synonyms).NotEmpty().MaximumLength(200).When(x => x.Synonyms is not null);
    }
}

public class UpdateWordRequestValidator : AbstractValidator<UpdateWordRequest>
{
    public UpdateWordRequestValidator()
    {
        RuleFor(x => x.Term).NotEmpty().MaximumLength(200);
        RuleFor(x => x.SortOrder).GreaterThanOrEqualTo(0).When(x => x.SortOrder.HasValue);
        RuleFor(x => x.Translations).NotEmpty().WithMessage("En az bir çeviri gereklidir.");
        RuleForEach(x => x.Translations).SetValidator(new TranslationPayloadValidator());
        RuleForEach(x => x.Synonyms).NotEmpty().MaximumLength(200).When(x => x.Synonyms is not null);
    }
}
