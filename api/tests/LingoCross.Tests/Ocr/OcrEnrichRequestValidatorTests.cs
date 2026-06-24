using LingoCross.Application.Ocr.Dtos;
using LingoCross.Application.Ocr.Validators;

namespace LingoCross.Tests.Ocr;

public class OcrEnrichRequestValidatorTests
{
    private readonly OcrEnrichRequestValidator _validator = new();

    [Fact]
    public async Task Valid_Request_Passes()
    {
        var result = await _validator.ValidateAsync(new OcrEnrichRequest("happy mutlu"));
        Assert.True(result.IsValid);
    }

    [Fact]
    public async Task Empty_RawText_Fails()
    {
        var result = await _validator.ValidateAsync(new OcrEnrichRequest("   "));
        Assert.False(result.IsValid);
        Assert.Contains(result.Errors, e => e.PropertyName == nameof(OcrEnrichRequest.RawText));
    }

    [Fact]
    public async Task RawText_Over5000Chars_Fails()
    {
        var result = await _validator.ValidateAsync(new OcrEnrichRequest(new string('a', 5001)));
        Assert.False(result.IsValid);
        Assert.Contains(result.Errors, e => e.PropertyName == nameof(OcrEnrichRequest.RawText));
    }
}
