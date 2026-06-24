using FluentValidation;
using LingoCross.Application.Auth;
using LingoCross.Application.Common.Persistence;
using LingoCross.Application.Common.Security;
using LingoCross.Application.Enrollments;
using LingoCross.Application.Games;
using LingoCross.Application.Lessons;
using LingoCross.Application.Results;
using LingoCross.Application.Words;
using Microsoft.Extensions.DependencyInjection;

namespace LingoCross.Application;

public static class DependencyInjection
{
    public static IServiceCollection AddApplication(this IServiceCollection services)
    {
        services.AddScoped<IAuthService, AuthService>();
        services.AddScoped<ILessonService, LessonService>();
        services.AddScoped<IWordService, WordService>();
        services.AddScoped<IEnrollmentService, EnrollmentService>();
        // GameService'in opsiyonel Random parametresi DI tarafından çözülmez; üretimde
        // Random.Shared kullanılması için açık factory ile kaydedilir (testler kendi Random'ını verir).
        services.AddScoped<IGameService>(sp =>
            new GameService(sp.GetRequiredService<IAppDbContext>(), sp.GetRequiredService<ICurrentUser>()));
        services.AddScoped<IResultService, ResultService>();
        services.AddValidatorsFromAssembly(typeof(DependencyInjection).Assembly);

        return services;
    }
}
