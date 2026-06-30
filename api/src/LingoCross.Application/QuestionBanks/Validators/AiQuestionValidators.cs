using FluentValidation;
using LingoCross.Application.QuestionBanks.Dtos;

namespace LingoCross.Application.QuestionBanks.Validators;

/// <summary>
/// AI soru üretimi gövdesi doğrulaması: grade 1–12, count 1–10, types boş olmayan ve desteklenen alt küme.
/// </summary>
public class GenerateAiQuestionsRequestValidator : AbstractValidator<GenerateAiQuestionsRequest>
{
    private static readonly string[] AllowedTypes = { "word_meaning", "fill_blank", "synonym" };

    public GenerateAiQuestionsRequestValidator()
    {
        RuleFor(x => x.Grade)
            .InclusiveBetween(1, 12).WithMessage("Sınıf düzeyi 1 ile 12 arasında olmalıdır.");

        RuleFor(x => x.Count)
            .InclusiveBetween(1, 10).WithMessage("Soru sayısı 1 ile 10 arasında olmalıdır.");

        RuleFor(x => x.Types)
            .NotEmpty().WithMessage("En az bir soru türü seçilmelidir.")
            .Must(types => types != null && types.All(t => AllowedTypes.Contains(t)))
            .WithMessage("Geçersiz soru türü. İzin verilenler: word_meaning, fill_blank, synonym.");
    }
}
