using FluentValidation;
using LingoCross.Application.Lessons.Dtos;

namespace LingoCross.Application.Lessons.Validators;

public class CreateLessonRequestValidator : AbstractValidator<CreateLessonRequest>
{
    public CreateLessonRequestValidator()
    {
        RuleFor(x => x.Title).NotEmpty().MaximumLength(200);
        RuleFor(x => x.Description).MaximumLength(2000);
        RuleFor(x => x.SourceLanguage).MaximumLength(8).When(x => x.SourceLanguage is not null);
        RuleFor(x => x.TargetLanguage).MaximumLength(8).When(x => x.TargetLanguage is not null);
    }
}

public class UpdateLessonRequestValidator : AbstractValidator<UpdateLessonRequest>
{
    public UpdateLessonRequestValidator()
    {
        RuleFor(x => x.Title).NotEmpty().MaximumLength(200);
        RuleFor(x => x.Description).MaximumLength(2000);
        RuleFor(x => x.SourceLanguage).MaximumLength(8).When(x => x.SourceLanguage is not null);
        RuleFor(x => x.TargetLanguage).MaximumLength(8).When(x => x.TargetLanguage is not null);
    }
}
