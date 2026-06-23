using LingoCross.Domain.Enums;

namespace LingoCross.Application.Enrollments.Dtos;

/// <summary>Öğrencinin davet koduyla bir öğretmene katılma isteği.</summary>
public record JoinByCodeRequest(string Code);

/// <summary>Öğretmenin davet kodu (öğretmen paneli için).</summary>
public record InviteCodeDto(string Code);

/// <summary>
/// Bir eşleşme kaydı. Karşı tarafın kimlik bilgileri rol bağlamına göre doldurulur: öğretmen
/// listelerken counterpart öğrenci, öğrenci listelerken counterpart öğretmendir.
/// </summary>
public record EnrollmentDto(
    Guid Id,
    Guid TeacherId,
    Guid StudentId,
    EnrollmentStatus Status,
    Guid CounterpartUserId,
    string CounterpartDisplayName,
    string CounterpartEmail,
    DateTime CreatedAt,
    DateTime UpdatedAt);
