import '../data/dtos/subscription_dtos.dart';

/// [SubscriptionDto] üzerinden UI'ın proaktif kilit kararlarını veren yardımcı
/// extension.
///
/// Tüm kararlar "best-effort UX"tir; reaktif 402 her durumda güvenlik ağıdır.
/// Premium ([SubscriptionDto.isPremium]) veya -1 (sınırsız) → her zaman izin.
extension Entitlement on SubscriptionDto {
  /// OCR (kameradan tarama) kilitli mi. Tek premium özellik budur.
  bool get ocrLocked => !isPremium && !ocrEnabled;

  /// Bulmaca/oyun oluşturma kilitli mi. Artık ücretsiz (backend de serbest
  /// bıraktı) → her zaman kilitsiz. (Geriye dönük çağrı uyumluluğu için tutulur.)
  bool get puzzleCreateLocked => false;

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
  ///
  /// Not: Öğrenci tamamen ücretsiz — backend free öğrenciye `maxTeachers = -1`
  /// (`unlimitedTeachers`) verir, dolayısıyla bu metot pratikte her zaman true
  /// döner. Sonlu bir limit verilirse (`unlimitedTeachers` false) sayıya bakılır.
  bool canJoinAnotherTeacher(int currentDistinctTeacherCount) {
    if (isPremium || unlimitedTeachers) return true;
    return currentDistinctTeacherCount < maxTeachers;
  }
}
