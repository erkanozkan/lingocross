namespace LingoCross.Application.Classes.Dtos;

/// <summary>Öğretmenin bir sınıfının özeti.</summary>
public record ClassDto(
    Guid Id,
    string Name,
    string? InviteCode,
    int StudentCount,
    DateTime CreatedAt);

/// <summary>Bir sınıfın detayı: özet + aktif üye öğrenciler.</summary>
public record ClassDetailDto(
    Guid Id,
    string Name,
    string? InviteCode,
    int StudentCount,
    IReadOnlyList<ClassMemberDto> Students);

/// <summary>Bir sınıf üyesi öğrencinin kimliği (öğretmen görünümü).</summary>
public record ClassMemberDto(
    Guid StudentId,
    string DisplayName,
    string Email);

/// <summary>Öğrencinin üye olduğu bir sınıf (öğrenci görünümü).</summary>
public record StudentClassDto(
    Guid ClassId,
    string ClassName,
    string TeacherName);

/// <summary>Sınıf oluşturma/güncelleme isteği.</summary>
public record SaveClassRequest(string Name);

/// <summary>Bir davet kodu yanıtı.</summary>
public record ClassInviteCodeDto(string Code);

/// <summary>Öğrencinin bir sınıfa katılma isteği.</summary>
public record JoinClassRequest(string Code);
