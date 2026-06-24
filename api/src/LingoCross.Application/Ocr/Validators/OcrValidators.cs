using FluentValidation;
using LingoCross.Application.Ocr.Dtos;

namespace LingoCross.Application.Ocr.Validators;

public class OcrEnrichRequestValidator : AbstractValidator<OcrEnrichRequest>
{
    public OcrEnrichRequestValidator()
    {
        RuleFor(x => x.RawText)
            .NotEmpty().WithMessage("OCR metni boş olamaz.")
            .MaximumLength(5000).WithMessage("OCR metni 5000 karakteri aşamaz.");
        RuleFor(x => x.SourceLanguage).NotEmpty().MaximumLength(10);
        RuleFor(x => x.TargetLanguage).NotEmpty().MaximumLength(10);
    }
}
