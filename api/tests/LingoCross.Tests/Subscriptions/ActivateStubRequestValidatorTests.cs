using LingoCross.Application.Subscriptions.Dtos;
using LingoCross.Application.Subscriptions.Validators;
using LingoCross.Domain.Enums;

namespace LingoCross.Tests.Subscriptions;

/// <summary>F8.1 — ActivateStub doğrulaması: Trial=false iken Period zorunludur.</summary>
public class ActivateStubRequestValidatorTests
{
    private readonly ActivateStubRequestValidator _validator = new();

    [Fact]
    public void NonTrial_WithoutPeriod_IsInvalid()
    {
        var result = _validator.Validate(new ActivateStubRequest(null, Trial: false));
        Assert.False(result.IsValid);
    }

    [Fact]
    public void NonTrial_WithPeriod_IsValid()
    {
        var result = _validator.Validate(new ActivateStubRequest(SubscriptionPeriod.Monthly, Trial: false));
        Assert.True(result.IsValid);
    }

    [Fact]
    public void Trial_WithoutPeriod_IsValid()
    {
        var result = _validator.Validate(new ActivateStubRequest(null, Trial: true));
        Assert.True(result.IsValid);
    }
}
