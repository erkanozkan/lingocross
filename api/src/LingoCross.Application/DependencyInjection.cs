using FluentValidation;
using LingoCross.Application.Auth;
using Microsoft.Extensions.DependencyInjection;

namespace LingoCross.Application;

public static class DependencyInjection
{
    public static IServiceCollection AddApplication(this IServiceCollection services)
    {
        services.AddScoped<IAuthService, AuthService>();
        services.AddValidatorsFromAssembly(typeof(DependencyInjection).Assembly);

        return services;
    }
}
