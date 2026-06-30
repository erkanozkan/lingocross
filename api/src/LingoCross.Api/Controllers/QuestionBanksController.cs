using LingoCross.Application.Games.Dtos;
using LingoCross.Application.QuestionBanks;
using LingoCross.Application.QuestionBanks.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace LingoCross.Api.Controllers;

/// <summary>
/// Faz 2 — "Çıkmış Sorular" konu başlıkları (öğretmen yüzü). Öğretmen atanabilir başlıkları listeler ve
/// bir başlığı kendi sınıf(lar)ına atar (set semantiği). Sorular GLOBAL'dir; başlık bir derse bağlı değildir.
/// Erişim/sahiplik servis katmanında uygulanır (aksi 403/404).
/// </summary>
[ApiController]
[Authorize(Roles = "Teacher")]
[Route("api/question-topics")]
public class QuestionBanksController : ControllerBase
{
    private readonly IQuestionBankService _service;
    private readonly IAiQuestionService _aiQuestionService;

    public QuestionBanksController(IQuestionBankService service, IAiQuestionService aiQuestionService)
    {
        _service = service;
        _aiQuestionService = aiQuestionService;
    }

    /// <summary>Atanabilir (aktif) konu başlıklarını listeler.</summary>
    [HttpGet("")]
    public async Task<ActionResult<IReadOnlyList<QuestionTopicSummaryDto>>> ListTopics(CancellationToken ct)
        => Ok(await _service.ListTopicsAsync(ct));

    /// <summary>
    /// Bir konu başlığını öğretmenin sınıf(lar)ına SET semantiğiyle atar (gönderilen liste nihaidir).
    /// Nihai atanmış sınıf kimliklerini döner. Başlık/sınıf sahibi değilse 404.
    /// </summary>
    [HttpPost("{topicId:guid}/assignments")]
    public async Task<ActionResult<GameAssignmentsDto>> SetAssignments(
        Guid topicId, [FromBody] SetGameAssignmentsRequest request, CancellationToken ct)
        => Ok(await _service.SetTopicAssignmentsAsync(topicId, request.ClassIds ?? Array.Empty<Guid>(), ct));

    /// <summary>Bir konu başlığının atandığı sınıf kimliklerini döner. Başlık yoksa 404.</summary>
    [HttpGet("{topicId:guid}/assignments")]
    public async Task<ActionResult<GameAssignmentsDto>> GetAssignments(Guid topicId, CancellationToken ct)
        => Ok(await _service.GetTopicAssignmentsAsync(topicId, ct));

    /// <summary>
    /// Bir AI başlığındaki tek bir soruyu (şıklarıyla cascade) siler. Review ekranındaki çöp ikonu için.
    /// Başlık öğretmene ait değilse 404; başarıda 204.
    /// </summary>
    [HttpDelete("{topicId:guid}/questions/{questionId:guid}")]
    public async Task<IActionResult> DeleteQuestion(Guid topicId, Guid questionId, CancellationToken ct)
    {
        await _aiQuestionService.DeleteQuestionAsync(topicId, questionId, ct);
        return NoContent();
    }
}
