using FluentValidation;
using LingoCross.Application.Words;
using LingoCross.Application.Words.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace LingoCross.Api.Controllers;

[ApiController]
[Authorize(Roles = "Teacher")]
[Route("api/words")]
public class WordsController : ControllerBase
{
    private readonly IWordService _wordService;
    private readonly IServiceProvider _services;

    public WordsController(IWordService wordService, IServiceProvider services)
    {
        _wordService = wordService;
        _services = services;
    }

    [HttpPut("{wordId:guid}")]
    public async Task<ActionResult<WordDto>> Update(Guid wordId, UpdateWordRequest request, CancellationToken ct)
    {
        await ValidateAsync(request, ct);
        var word = await _wordService.UpdateAsync(wordId, request, ct);
        return Ok(word);
    }

    [HttpDelete("{wordId:guid}")]
    public async Task<IActionResult> Delete(Guid wordId, CancellationToken ct)
    {
        await _wordService.DeleteAsync(wordId, ct);
        return NoContent();
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
