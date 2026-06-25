using FluentValidation;
using LingoCross.Application.Ocr.Dtos;

namespace LingoCross.Application.Ocr.Validators;

public class OcrEnrichRequestValidator : AbstractValidator<OcrEnrichRequest>
{
    // ~8 MB base64 ≈ 6 MB ikili görüntü; makul bir üst sınır.
    private const int MaxImageBase64Length = 8_000_000;

    private static readonly string[] AllowedMediaTypes = { "image/jpeg", "image/png" };

    public OcrEnrichRequestValidator()
    {
        RuleFor(x => x.ImageBase64)
            .NotEmpty().WithMessage("Görüntü boş olamaz.")
            .MaximumLength(MaxImageBase64Length).WithMessage("Görüntü çok büyük.");
        RuleFor(x => x.MediaType)
            .NotEmpty()
            .Must(mt => AllowedMediaTypes.Contains(mt))
            .WithMessage("Görüntü türü image/jpeg veya image/png olmalıdır.");
        RuleFor(x => x.SourceLanguage).NotEmpty().MaximumLength(10);
        RuleFor(x => x.TargetLanguage).NotEmpty().MaximumLength(10);
    }
}
