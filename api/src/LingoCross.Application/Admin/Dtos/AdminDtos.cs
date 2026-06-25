namespace LingoCross.Application.Admin.Dtos;

/// <summary>Admin giriş isteği (back office).</summary>
public record AdminLoginRequest(string Email, string Password);

/// <summary>Admin giriş sonucu: imzalı access token + son kullanma anı.</summary>
public record AdminLoginResult(string Token, DateTime ExpiresAt);

/// <summary>
/// Genel bakış metrikleri (salt-okur). Kullanıcı/içerik/etkileşim sayıları + abonelik kırılımı +
/// aktif öğrenci pencereleri.
/// </summary>
public record OverviewDto(
    int TeacherCount,
    int StudentCount,
    int TotalUsers,
    int ActiveClasses,
    int Lessons,
    int Words,
    int PublishedGames,
    int Sessions,
    int Results,
    double? AverageScore,
    SubscriptionBreakdownDto Subscriptions,
    int ActiveStudents7d,
    int ActiveStudents30d);

/// <summary>Abonelik durum kırılımı (premium = Active/Trial ve süresi geçmemiş).</summary>
public record SubscriptionBreakdownDto(
    int PremiumActive,
    int Trial,
    int Canceled,
    int Expired,
    int Free);

/// <summary>Tek bir günlük zaman serisi noktası (UTC gün, sayı).</summary>
public record TimeseriesPointDto(DateOnly Date, int Count);

/// <summary>Bir metriğin günlük zaman serisi (boş günler 0 ile doldurulmuş).</summary>
public record TimeseriesDto(string Metric, int Days, IReadOnlyList<TimeseriesPointDto> Points);

/// <summary>Oyun türü dağılımının tek bir kalemi (oturum sayısı bazında).</summary>
public record GameTypeCountDto(string Type, int Sessions);

/// <summary>Etkileşim metrikleri: tür dağılımı, ortalama skor, paylaşılan sonuç oranı.</summary>
public record EngagementDto(
    IReadOnlyList<GameTypeCountDto> GameTypes,
    double? AverageScore,
    int TotalResults,
    int SharedResults,
    double SharedRate);

/// <summary>Abonelik durum/kaynak kırılımı + yeni abonelik zaman serisi.</summary>
public record SubscriptionsDto(
    SubscriptionBreakdownDto StatusBreakdown,
    IReadOnlyList<GameTypeCountDto> BySource,
    TimeseriesDto NewSubscriptions);

/// <summary>Son kaydolan kullanıcı özeti.</summary>
public record RecentUserDto(string DisplayName, string Email, string Role, DateTime CreatedAt);

/// <summary>Son oyun sonucu özeti.</summary>
public record RecentResultDto(string StudentName, string LessonTitle, int Score, DateTime CreatedAt);

/// <summary>Son kayıtlar görünümü: yeni kullanıcılar + yeni sonuçlar.</summary>
public record RecentDto(
    IReadOnlyList<RecentUserDto> Users,
    IReadOnlyList<RecentResultDto> Results);
