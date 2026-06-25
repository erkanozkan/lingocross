using FluentValidation;
using LingoCross.Application.Admin;
using LingoCross.Application.Auth;
using LingoCross.Application.Classes;
using LingoCross.Application.Common.Persistence;
using LingoCross.Application.Common.Security;
using LingoCross.Application.Enrollments;
using LingoCross.Application.Games;
using LingoCross.Application.Lessons;
using LingoCross.Application.Notifications;
using LingoCross.Application.Results;
using LingoCross.Application.Subscriptions;
using LingoCross.Application.Teachers;
using LingoCross.Application.Words;
using Microsoft.Extensions.DependencyInjection;

namespace LingoCross.Application;

public static class DependencyInjection
{
    public static IServiceCollection AddApplication(this IServiceCollection services)
    {
        services.AddScoped<IAuthService, AuthService>();
        services.AddScoped<IWordService, WordService>();
        services.AddScoped<IEnrollmentService, EnrollmentService>();
        // ClassService/LessonService'in opsiyonel IEntitlementService parametresi gerçek servisle
        // doldurulsun diye (üretimde limit enforcement çalışsın) açık factory ile kaydedilir. Testler
        // limit dışı senaryolarda parametreyi null bırakıp Premium gibi davranabilir.
        services.AddScoped<IEntitlementService, EntitlementService>();
        services.AddScoped<IClassService>(sp =>
            new ClassService(
                sp.GetRequiredService<IAppDbContext>(),
                sp.GetRequiredService<ICurrentUser>(),
                sp.GetRequiredService<IEntitlementService>()));
        services.AddScoped<ILessonService>(sp =>
            new LessonService(
                sp.GetRequiredService<IAppDbContext>(),
                sp.GetRequiredService<ICurrentUser>(),
                sp.GetRequiredService<IEntitlementService>()));
        // GameService'in opsiyonel Random parametresi DI tarafından çözülmez; üretimde
        // Random.Shared kullanılması için açık factory ile kaydedilir (testler kendi Random'ını verir).
        services.AddScoped<PushDispatcher>();
        services.AddScoped<IGameService>(sp =>
            new GameService(
                sp.GetRequiredService<IAppDbContext>(),
                sp.GetRequiredService<ICurrentUser>(),
                random: null,
                push: sp.GetRequiredService<PushDispatcher>()));
        services.AddScoped<IResultService>(sp =>
            new ResultService(
                sp.GetRequiredService<IAppDbContext>(),
                sp.GetRequiredService<ICurrentUser>(),
                sp.GetRequiredService<PushDispatcher>()));
        services.AddScoped<ITeacherTrackingService, TeacherTrackingService>();
        services.AddScoped<IDeviceService, DeviceService>();
        services.AddScoped<INotificationPreferenceService, NotificationPreferenceService>();
        services.AddScoped<ISubscriptionService, SubscriptionService>();
        // Back office (salt-okur admin uçları + tek-admin env girişi).
        services.AddScoped<IAdminAuthService, AdminAuthService>();
        services.AddScoped<IAdminMetricsService, AdminMetricsService>();
        services.AddValidatorsFromAssembly(typeof(DependencyInjection).Assembly);

        return services;
    }
}
