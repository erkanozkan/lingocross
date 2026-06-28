import '../data/dtos/subscription_dtos.dart';

/// [SubscriptionDto] üzerinden UI'ın proaktif kilit kararlarını veren yardımcı
/// extension.
///
/// Tüm kararlar "best-effort UX"tir; reaktif 402 her durumda güvenlik ağıdır.
/// Premium ([SubscriptionDto.isPremium]) veya -1 (sınırsız) → her zaman izin.
extension Entitlement on SubscriptionDto {
  /// OCR (kameradan tarama) kilitli mi.
  bool get ocrLocked => !isPremium && !ocrEnabled;

  /// Bulmaca/oyun oluşturma kilitli mi (Premium-only özellik). Free kullanıcı
  /// için her zaman kilitli; backend de oluşturmada 402 (puzzle_create) döner.
  bool get puzzleCreateLocked => !isPremium;

  /// Mevcut [currentCount] sınıf varken yeni sınıf oluşturulabilir mi.
  bool canCreateClass(int currentCount) {
    if (isPremium || unlimitedClasses) return true;
    return currentCount < maxClasses;
  }

  /// Mevcut [currentCount] ders varken yeni ders oluşturulabilir mi.
  bool canCreateLesson(int currentCount) {
    if (isPremium || unlimitedLessons) return true;
    return currentCount < maxLessons;
  }

  /// Öğrencinin halihazırda [currentDistinctTeacherCount] farklı öğretmeni
  /// varken başka bir öğretmene (sınıfa) katılabilir mi.
  bool canJoinAnotherTeacher(int currentDistinctTeacherCount) {
    if (isPremium || unlimitedTeachers) return true;
    return currentDistinctTeacherCount < maxTeachers;
  }
}
