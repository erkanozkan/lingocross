using System.Text;
using LingoCross.Api.Infrastructure;
using LingoCross.Application;
using LingoCross.Infrastructure;
using LingoCross.Infrastructure.Auth;
using LingoCross.Infrastructure.Persistence;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;

var builder = WebApplication.CreateBuilder(args);

// Railway, dinlenecek portu PORT ortam değişkeniyle verir.
var port = Environment.GetEnvironmentVariable("PORT");
if (!string.IsNullOrWhiteSpace(port))
{
    builder.WebHost.UseUrls($"http://0.0.0.0:{port}");
}

// --- Servisler ---
builder.Services.AddInfrastructure(builder.Configuration);
builder.Services.AddApplication();

// Geçerli isteğin kimliği (JWT claim'lerinden) — servis katmanı sahiplik kontrolü için kullanır.
builder.Services.AddHttpContextAccessor();
builder.Services.AddScoped<LingoCross.Application.Common.Security.ICurrentUser, LingoCross.Api.Infrastructure.HttpCurrentUser>();

// JWT bearer kimlik doğrulama (bizim kendi token'larımız, HS256).
var jwtOptions = builder.Configuration.GetSection(JwtOptions.SectionName).Get<JwtOptions>() ?? new JwtOptions();

// Secret yoksa/çok kısaysa açılışta net bir hata ver — yoksa boş imza anahtarı her
// istekte (sağlık ucu dahil) opak 500'e yol açar. HS256 için ≥32 bayt gerekir.
if (Encoding.UTF8.GetByteCount(jwtOptions.Secret) < 32)
{
    throw new InvalidOperationException(
        "Jwt:Secret tanımlı değil veya 32 bayttan kısa. Railway'de Jwt__Secret ortam " +
        "değişkenini ayarlayın (üret: openssl rand -base64 48).");
}

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidIssuer = jwtOptions.Issuer,
            ValidateAudience = true,
            ValidAudience = jwtOptions.Audience,
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtOptions.Secret)),
            ValidateLifetime = true,
            ClockSkew = TimeSpan.FromSeconds(30),
        };
    });
builder.Services.AddAuthorization();

// Hata yönetimi: ProblemDetails + merkezi exception handler.
builder.Services.AddProblemDetails();
builder.Services.AddExceptionHandler<AppExceptionHandler>();

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddCors(options =>
{
    options.AddPolicy("mobile", policy =>
        policy.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod());
});

var app = builder.Build();

// --- Pipeline ---
app.UseExceptionHandler();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// Production dahil her ortamda bekleyen EF migration'larını uygula.
await using (var scope = app.Services.CreateAsyncScope())
{
    var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    await db.Database.MigrateAsync();
}

app.UseCors("mobile");

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

// Railway / izleme için sağlık ucu.
app.MapGet("/health", () => Results.Ok(new { status = "ok", service = "lingocross-api" }));

app.Run();

// Integration testlerinin WebApplicationFactory ile erişebilmesi için.
public partial class Program;
