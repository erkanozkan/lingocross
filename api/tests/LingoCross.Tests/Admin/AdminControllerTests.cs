using System.Reflection;
using LingoCross.Api.Controllers;
using LingoCross.Application.Admin;
using LingoCross.Application.Admin.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace LingoCross.Tests.Admin;

/// <summary>
/// AdminController yetki kapısı: login [AllowAnonymous], geri kalan tüm uçlar
/// [Authorize(Roles="Admin")]. Bu attribute zinciri çalışma anında Admin rollü token dışındaki
/// (Teacher/Student) token'ların 403 almasını ve token'sız isteğin 401 almasını sağlar. login
/// servise delege edip 200 döner.
/// </summary>
public class AdminControllerTests
{
    [Theory]
    [InlineData(nameof(AdminController.Overview))]
    [InlineData(nameof(AdminController.Timeseries))]
    [InlineData(nameof(AdminController.Engagement))]
    [InlineData(nameof(AdminController.Subscriptions))]
    [InlineData(nameof(AdminController.Recent))]
    public void DataEndpoints_RequireAdminRole(string methodName)
    {
        var method = typeof(AdminController).GetMethod(methodName)!;
        var attr = method.GetCustomAttribute<AuthorizeAttribute>();

        Assert.NotNull(attr);
        Assert.Equal("Admin", attr!.Roles);
    }

    [Fact]
    public void Login_AllowsAnonymous()
    {
        var method = typeof(AdminController).GetMethod(nameof(AdminController.Login))!;
        Assert.NotNull(method.GetCustomAttribute<AllowAnonymousAttribute>());
        Assert.Null(method.GetCustomAttribute<AuthorizeAttribute>());
    }

    [Fact]
    public void Login_DelegatesToService_AndReturns200()
    {
        var expected = new AdminLoginResult("token-abc", DateTime.UtcNow.AddHours(8));
        var controller = new AdminController(new FakeAuth(expected), new FakeMetrics());

        var result = controller.Login(new AdminLoginRequest("a@b.com", "pw"));

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        var body = Assert.IsType<AdminLoginResult>(ok.Value);
        Assert.Same(expected, body);
    }

    private sealed class FakeAuth : IAdminAuthService
    {
        private readonly AdminLoginResult _result;
        public FakeAuth(AdminLoginResult result) => _result = result;
        public AdminLoginResult Login(string email, string password) => _result;
    }

    private sealed class FakeMetrics : IAdminMetricsService
    {
        public Task<OverviewDto> GetOverviewAsync(CancellationToken ct = default) => throw new NotImplementedException();
        public Task<TimeseriesDto> GetTimeseriesAsync(string metric, int days, CancellationToken ct = default) => throw new NotImplementedException();
        public Task<EngagementDto> GetEngagementAsync(CancellationToken ct = default) => throw new NotImplementedException();
        public Task<SubscriptionsDto> GetSubscriptionsAsync(int days, CancellationToken ct = default) => throw new NotImplementedException();
        public Task<RecentDto> GetRecentAsync(int take, CancellationToken ct = default) => throw new NotImplementedException();
    }
}
