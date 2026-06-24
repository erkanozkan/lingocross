using System.Reflection;
using LingoCross.Api.Controllers;
using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Ocr;
using LingoCross.Application.Ocr.Dtos;
using LingoCross.Application.Subscriptions;
using LingoCross.Tests.Subscriptions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace LingoCross.Tests.Ocr;

/// <summary>
/// OcrController: yetki kapısının (yalnız Teacher) doğru tanımlandığını ve servise doğru
/// delege edip 200 + gövde döndürdüğünü doğrular. Sahiplik/role enforcement çalışma anında
/// [Authorize] tarafından yapılır; burada attribute'ün varlığı kontrol edilir.
/// </summary>
public class OcrControllerTests
{
    [Fact]
    public void Controller_RequiresTeacherRole()
    {
        var attr = typeof(OcrController).GetCustomAttribute<AuthorizeAttribute>();

        Assert.NotNull(attr);
        Assert.Equal("Teacher", attr!.Roles);
    }

    [Fact]
    public async Task Enrich_AsPremium_DelegatesToService_AndReturns200()
    {
        var expected = new OcrEnrichResponse(new[]
        {
            new EnrichedWord("happy", "mutlu", new[] { "glad" }),
        });
        var controller = new OcrController(
            new FakeService(expected),
            new FakeEntitlementService { Premium = true },
            new EmptyServiceProvider());

        var result = await controller.Enrich(new OcrEnrichRequest("happy mutlu"), default);

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        var body = Assert.IsType<OcrEnrichResponse>(ok.Value);
        Assert.Same(expected, body);
    }

    [Fact]
    public async Task Enrich_AsFreeTeacher_Throws402_WithOcrFeature()
    {
        var expected = new OcrEnrichResponse(Array.Empty<EnrichedWord>());
        var controller = new OcrController(
            new FakeService(expected),
            new FakeEntitlementService { Premium = false },
            new EmptyServiceProvider());

        var ex = await Assert.ThrowsAsync<AppException>(
            () => controller.Enrich(new OcrEnrichRequest("happy mutlu"), default));

        Assert.Equal(402, ex.StatusCode);
        Assert.Equal("subscription_required", ex.Code);
        Assert.Equal("ocr", ex.Feature);
    }

    private sealed class FakeService : IOcrEnrichmentService
    {
        private readonly OcrEnrichResponse _response;

        public FakeService(OcrEnrichResponse response) => _response = response;

        public Task<OcrEnrichResponse> EnrichAsync(OcrEnrichRequest request, CancellationToken cancellationToken = default)
            => Task.FromResult(_response);
    }

    private sealed class EmptyServiceProvider : IServiceProvider
    {
        public object? GetService(Type serviceType) => null;
    }
}
