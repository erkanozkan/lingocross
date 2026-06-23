using FluentValidation;
using LingoCross.Application.Auth;
using LingoCross.Application.Enrollments;
using LingoCross.Application.Lessons;
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
        services.AddValidatorsFromAssembly(typeof(DependencyInjection).Assembly);

        return services;
    }
}
