using LingoCross.Application.Ocr.Dtos;
using LingoCross.Application.Ocr.Validators;

namespace LingoCross.Tests.Ocr;

public class OcrEnrichRequestValidatorTests
{
    private const string SampleImage = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==";

    private readonly OcrEnrichRequestValidator _validator = new();

    [Fact]
    public async Task Valid_Request_Passes()
    {
        var result = await _validator.ValidateAsync(new OcrEnrichRequest(SampleImage, "image/jpeg"));
        Assert.True(result.IsValid);
    }

    [Fact]
    public async Task Png_MediaType_Passes()
    {
        var result = await _validator.ValidateAsync(new OcrEnrichRequest(SampleImage, "image/png"));
        Assert.True(result.IsValid);
    }

    [Fact]
    public async Task Empty_Image_Fails()
    {
        var result = await _validator.ValidateAsync(new OcrEnrichRequest("   "));
        Assert.False(result.IsValid);
        Assert.Contains(result.Errors, e => e.PropertyName == nameof(OcrEnrichRequest.ImageBase64));
    }

    [Fact]
    public async Task Unsupported_MediaType_Fails()
    {
        var result = await _validator.ValidateAsync(new OcrEnrichRequest(SampleImage, "image/gif"));
        Assert.False(result.IsValid);
        Assert.Contains(result.Errors, e => e.PropertyName == nameof(OcrEnrichRequest.MediaType));
    }
}
