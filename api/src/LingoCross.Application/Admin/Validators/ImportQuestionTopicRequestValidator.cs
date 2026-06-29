using FluentValidation;
using LingoCross.Application.Admin.Dtos;

namespace LingoCross.Application.Admin.Validators;

/// <summary>
/// Faz 2 — admin import gövdesinin yüzeysel doğrulaması (boş/uzunluk). İş-kuralı invariant'ı (her soru
/// tam 5 şık + tam 1 doğru) <see cref="QuestionImportService"/> içinde transaction ile korunur.
/// </summary>
public class ImportQuestionTopicRequestValidator : AbstractValidator<ImportQuestionTopicRequest>
{
    public ImportQuestionTopicRequestValidator()
    {
        RuleFor(x => x.Slug)
            .NotEmpty().WithMessage("Slug zorunludur.")
            .MaximumLength(120).WithMessage("Slug en fazla 120 karakter olabilir.");

        RuleFor(x => x.Title)
            .NotEmpty().WithMessage("Başlık zorunludur.")
            .MaximumLength(200).WithMessage("Başlık en fazla 200 karakter olabilir.");

        RuleFor(x => x.Description)
            .MaximumLength(2000).WithMessage("Açıklama en fazla 2000 karakter olabilir.");

        RuleFor(x => x.Questions)
            .NotEmpty().WithMessage("En az bir soru gerekir.");

        RuleForEach(x => x.Questions).ChildRules(q =>
        {
            q.RuleFor(x => x.Stem)
                .NotEmpty().WithMessage("Soru kökü zorunludur.")
                .MaximumLength(4000).WithMessage("Soru kökü en fazla 4000 karakter olabilir.");

            q.RuleFor(x => x.Explanation)
                .MaximumLength(4000).WithMessage("Açıklama en fazla 4000 karakter olabilir.");

            q.RuleFor(x => x.SourceRef)
                .MaximumLength(200).WithMessage("Kaynak referansı en fazla 200 karakter olabilir.");

            q.RuleFor(x => x.Options)
                .NotEmpty().WithMessage("Soru şıkları zorunludur.");

            q.RuleForEach(x => x.Options).ChildRules(o =>
            {
                o.RuleFor(x => x.Text)
                    .NotEmpty().WithMessage("Şık metni zorunludur.")
                    .MaximumLength(2000).WithMessage("Şık metni en fazla 2000 karakter olabilir.");
            });
        });
    }
}
