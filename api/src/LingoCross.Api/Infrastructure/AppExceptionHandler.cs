using FluentValidation;
using LingoCross.Application.Common.Exceptions;
using Microsoft.AspNetCore.Diagnostics;
using Microsoft.AspNetCore.Mvc;

namespace LingoCross.Api.Infrastructure;

/// <summary>
/// Uygulama ve doğrulama hatalarını RFC7807 ProblemDetails yanıtlarına çevirir.
/// </summary>
public class AppExceptionHandler : IExceptionHandler
{
    private readonly IProblemDetailsService _problemDetailsService;
    private readonly ILogger<AppExceptionHandler> _logger;

    public AppExceptionHandler(IProblemDetailsService problemDetailsService, ILogger<AppExceptionHandler> logger)
    {
        _problemDetailsService = problemDetailsService;
        _logger = logger;
    }

    public async ValueTask<bool> TryHandleAsync(
        HttpContext httpContext,
        Exception exception,
        CancellationToken cancellationToken)
    {
        ProblemDetails problemDetails;

        switch (exception)
        {
            case ValidationException validationException:
                var errors = validationException.Errors
                    .GroupBy(e => e.PropertyName)
                    .ToDictionary(g => g.Key, g => g.Select(e => e.ErrorMessage).ToArray());
                problemDetails = new ValidationProblemDetails(errors)
                {
                    Status = StatusCodes.Status400BadRequest,
                    Title = "Doğrulama hatası.",
                };
                break;

            case AppException appException:
                problemDetails = new ProblemDetails
                {
                    Status = appException.StatusCode,
                    Title = appException.Message,
                };
                if (!string.IsNullOrEmpty(appException.Code))
                {
                    problemDetails.Extensions["code"] = appException.Code;
                }
                if (!string.IsNullOrEmpty(appException.Feature))
                {
                    problemDetails.Extensions["feature"] = appException.Feature;
                }
                break;

            default:
                _logger.LogError(exception, "İşlenmemiş hata.");
                problemDetails = new ProblemDetails
                {
                    Status = StatusCodes.Status500InternalServerError,
                    Title = "Beklenmeyen bir hata oluştu.",
                };
                break;
        }

        httpContext.Response.StatusCode = problemDetails.Status ?? StatusCodes.Status500InternalServerError;

        return await _problemDetailsService.TryWriteAsync(new ProblemDetailsContext
        {
            HttpContext = httpContext,
            Exception = exception,
            ProblemDetails = problemDetails,
        });
    }
}
