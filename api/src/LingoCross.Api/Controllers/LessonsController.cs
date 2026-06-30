using FluentValidation;
using LingoCross.Application.Lessons;
using LingoCross.Application.Lessons.Dtos;
using LingoCross.Application.QuestionBanks;
using LingoCross.Application.QuestionBanks.Dtos;
using LingoCross.Application.Words;
using LingoCross.Application.Words.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace LingoCross.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/lessons")]
public class LessonsController : ControllerBase
{
    private readonly ILessonService _lessonService;
    private readonly IWordService _wordService;
    private readonly IAiQuestionService _aiQuestionService;
    private readonly IServiceProvider _services;

    public LessonsController(
        ILessonService lessonService,
        IWordService wordService,
        IAiQuestionService aiQuestionService,
        IServiceProvider services)
    {
        _lessonService = lessonService;
        _wordService = wordService;
        _aiQuestionService = aiQuestionService;
        _services = services;
    }

    [Authorize(Roles = "Teacher")]
    [HttpPost]
    public async Task<ActionResult<LessonDto>> Create(CreateLessonRequest request, CancellationToken ct)
    {
        await ValidateAsync(request, ct);
        var lesson = await _lessonService.CreateAsync(request, ct);
        return CreatedAtAction(nameof(Get), new { id = lesson.Id }, lesson);
    }

    // Rol-duyarlı: öğretmen → kendi dersleri; öğrenci → enrolled (Active) + yayımlanmış dersler.
    [HttpGet]
    public async Task<ActionResult<IReadOnlyList<LessonDto>>> List(CancellationToken ct)
    {
        var lessons = await _lessonService.ListVisibleAsync(ct);
        return Ok(lessons);
    }

    [HttpGet("{id:guid}")]
    public async Task<ActionResult<LessonDto>> Get(Guid id, CancellationToken ct)
    {
        var lesson = await _lessonService.GetAsync(id, ct);
        return Ok(lesson);
    }

    [Authorize(Roles = "Teacher")]
    [HttpPut("{id:guid}")]
    public async Task<ActionResult<LessonDto>> Update(Guid id, UpdateLessonRequest request, CancellationToken ct)
    {
        await ValidateAsync(request, ct);
        var lesson = await _lessonService.UpdateAsync(id, request, ct);
        return Ok(lesson);
    }

    [Authorize(Roles = "Teacher")]
    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> Delete(Guid id, CancellationToken ct)
    {
        await _lessonService.DeleteAsync(id, ct);
        return NoContent();
    }

    [Authorize(Roles = "Teacher")]
    [HttpPost("{id:guid}/publish")]
    public async Task<ActionResult<LessonDto>> Publish(Guid id, CancellationToken ct)
    {
        var lesson = await _lessonService.PublishAsync(id, ct);
        return Ok(lesson);
    }

    // Yayından kaldır: Active → Draft (is_published=false). Öğrenci görünürlüğü kapanır.
    [Authorize(Roles = "Teacher")]
    [HttpPost("{id:guid}/unpublish")]
    public async Task<ActionResult<LessonDto>> Unpublish(Guid id, CancellationToken ct)
    {
        var lesson = await _lessonService.UnpublishAsync(id, ct);
        return Ok(lesson);
    }

    // Tamamlandı işaretle: Active → Completed (is_published=true kalır). Yalnız Active iken.
    [Authorize(Roles = "Teacher")]
    [HttpPost("{id:guid}/complete")]
    public async Task<ActionResult<LessonDto>> Complete(Guid id, CancellationToken ct)
    {
        var lesson = await _lessonService.CompleteAsync(id, ct);
        return Ok(lesson);
    }

    // --- Bir derse ait kelimeler (nested route) ---

    [HttpGet("{id:guid}/words")]
    public async Task<ActionResult<IReadOnlyList<WordDto>>> ListWords(Guid id, CancellationToken ct)
    {
        var words = await _wordService.ListByLessonAsync(id, ct);
        return Ok(words);
    }

    [Authorize(Roles = "Teacher")]
    [HttpPost("{id:guid}/words")]
    public async Task<ActionResult<WordDto>> AddWord(Guid id, AddWordRequest request, CancellationToken ct)
    {
        await ValidateAsync(request, ct);
        var word = await _wordService.AddAsync(id, request, ct);
        return CreatedAtAction(nameof(WordsController.Update), "Words", new { wordId = word.Id }, word);
    }

    // --- AI ile sınav sorusu üretimi (öğretmen) ---

    /// <summary>
    /// Bu dersi temel alıp AI ile çoktan seçmeli sınav soruları üretir ve teacher-owned bir konu başlığı
    /// olarak kaydeder. Üretim DTO'su döner (review ekranı). Ders sahibi değil → 404; &lt; 4 çevirili kelime → 400;
    /// geçersiz grade/count/types → 400; AI yapılandırılmamış → 503.
    /// </summary>
    [Authorize(Roles = "Teacher")]
    [HttpPost("{lessonId:guid}/ai-questions")]
    public async Task<ActionResult<AiQuestionsResultDto>> GenerateAiQuestions(
        Guid lessonId, GenerateAiQuestionsRequest request, CancellationToken ct)
    {
        await ValidateAsync(request, ct);
        var result = await _aiQuestionService.GenerateAsync(
            lessonId, request.Grade, request.Count, request.Types ?? Array.Empty<string>(), ct);
        return Ok(result);
    }

    private async Task ValidateAsync<T>(T instance, CancellationToken ct)
    {
        if (_services.GetService(typeof(IValidator<T>)) is not IValidator<T> validator)
        {
            return;
        }

        var result = await validator.ValidateAsync(instance, ct);
        if (!result.IsValid)
        {
            throw new ValidationException(result.Errors);
        }
    }
}
