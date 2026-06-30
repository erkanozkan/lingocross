using LingoCross.Application.Admin;
using LingoCross.Application.Common.Email;
using LingoCross.Application.Common.Persistence;
using LingoCross.Application.Common.Security;
using LingoCross.Application.Notifications;
using LingoCross.Application.Ocr;
using LingoCross.Infrastructure.Auth;
using LingoCross.Infrastructure.Email;
using LingoCross.Infrastructure.Notifications;
using LingoCross.Application.Subscriptions;
using LingoCross.Infrastructure.Ocr;
using LingoCross.Infrastructure.Persistence;
using LingoCross.Infrastructure.Subscriptions;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;

namespace LingoCross.Infrastructure;

public static class DependencyInjection
{
    public static IServiceCollection AddInfrastructure(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        var connectionString = ResolveConnectionString(configuration)
            ?? throw new InvalidOperationException(
                "Veritabanı bağlantısı tanımlı değil. ConnectionStrings__Default (Npgsql) veya DATABASE_URL (postgres://) ayarlayın.");

        services.AddDbContext<AppDbContext>(options =>
            options.UseNpgsql(connectionString, npgsql =>
                npgsql.MigrationsAssembly(typeof(AppDbContext).Assembly.FullName))
                .UseSnakeCaseNamingConvention());

        services.AddScoped<IAppDbContext>(sp => sp.GetRequiredService<AppDbContext>());

        // Auth servisleri
        services.Configure<JwtOptions>(configuration.GetSection(JwtOptions.SectionName));
        services.AddSingleton<IPasswordHasher, BCryptPasswordHasher>();
        services.AddSingleton<ITokenService, JwtTokenService>();

        // E-posta gönderimi: Gmail API (HTTPS) — Railway giden SMTP portlarını (587/465) bloklar.
        // Gmail ayarları (ServiceAccountJson + SenderEmail) doluysa Workspace üzerinden gerçek
        // gönderim; aksi halde geliştirme için log'a yazan stub.
        services.Configure<GmailOptions>(configuration.GetSection(GmailOptions.SectionName));
        var gmail = configuration.GetSection(GmailOptions.SectionName).Get<GmailOptions>() ?? new GmailOptions();
        if (gmail.IsConfigured)
        {
            services.AddScoped<IEmailSender, GmailApiEmailSender>();
        }
        else
        {
            services.AddScoped<IEmailSender, LoggingEmailSender>();
        }

        // OCR zenginleştirme (Claude). Anahtar yoksa servis 503 fırlatır; mobil yerel ayrıştırmaya düşer.
        services.AddScoped<IOcrEnrichmentService, ClaudeOcrEnrichmentService>();

        // AI ile sınav sorusu üretimi (Claude metin → JSON). Anahtar yoksa servis 503 fırlatır.
        services.AddScoped<LingoCross.Application.Games.IClaudeQuestionGenerator, Games.ClaudeQuestionGenerator>();

        // Push gönderimi (FCM). Firebase:ServiceAccountJson boşsa no-op; FirebaseApp singleton.
        services.AddSingleton<IPushSender, FcmPushSender>();

        // Abonelik/entitlement ayarları (Free limitleri, stub anahtarı, trial süresi).
        services.Configure<SubscriptionOptions>(configuration.GetSection(SubscriptionOptions.SectionName));

        // Back office tek-admin girişi. Email/Password boşsa admin girişi devre dışıdır (servis 503).
        services.Configure<AdminOptions>(configuration.GetSection(AdminOptions.SectionName));

        // Apple IAP makbuz doğrulama. SharedSecret yoksa servis katmanı 503 döner.
        services.Configure<AppleOptions>(configuration.GetSection(AppleOptions.SectionName));
        services.AddHttpClient();
        services.AddScoped<IAppleReceiptVerifier, AppleReceiptVerifier>();

        // Google Play IAP doğrulama. ServiceAccountJson/PackageName yoksa servis katmanı 503 döner.
        services.Configure<GoogleOptions>(configuration.GetSection(GoogleOptions.SectionName));
        services.AddScoped<IGoogleReceiptVerifier, GoogleReceiptVerifier>();

        return services;
    }

    /// <summary>
    /// Bağlantı dizesini çözer: önce ConnectionStrings:Default (Npgsql key-value),
    /// yoksa Railway/Heroku tarzı DATABASE_URL (postgres://user:pass@host:port/db)
    /// Npgsql formatına çevrilir. İkisi de yoksa null.
    /// </summary>
    public static string? ResolveConnectionString(IConfiguration configuration)
    {
        var fromConfig = configuration.GetConnectionString("Default");
        if (!string.IsNullOrWhiteSpace(fromConfig))
        {
            return fromConfig;
        }

        var url = configuration["DATABASE_URL"];
        if (string.IsNullOrWhiteSpace(url))
        {
            return null;
        }

        return ConvertDatabaseUrl(url);
    }

    /// <summary>postgres://user:pass@host:port/db[?params] → Npgsql key-value.</summary>
    public static string ConvertDatabaseUrl(string databaseUrl)
    {
        var uri = new Uri(databaseUrl);
        var userInfo = uri.UserInfo.Split(':', 2);
        var username = Uri.UnescapeDataString(userInfo[0]);
        var password = userInfo.Length > 1 ? Uri.UnescapeDataString(userInfo[1]) : string.Empty;
        var database = uri.AbsolutePath.TrimStart('/');
        var port = uri.Port > 0 ? uri.Port : 5432;

        return $"Host={uri.Host};Port={port};Database={database};Username={username};" +
               $"Password={password};SSL Mode=Require;Trust Server Certificate=true";
    }
}
