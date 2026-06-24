import '../../../core/l10n/gen/app_localizations.dart';

/// Bir dersin yaşam döngüsü durumu — API `LessonStatus` ile birebir (int değerler
/// kalıcı; DEĞİŞTİRİLMEZ). Öğrenci görünürlüğü ayrı `isPublished` ile yönetilir:
/// Active ve Completed yayımlanmış, Draft yayımlanmamıştır.
enum LessonStatus {
  /// Taslak — yayımlanmamış (is_published=false).
  draft(1),

  /// Aktif — yayımlanmış, öğrenciye görünür.
  active(2),

  /// Tamamlandı — yayımlanmış kalır, "tamamlandı" işaretli.
  completed(3);

  const LessonStatus(this.value);

  final int value;

  static LessonStatus fromValue(int value) {
    return switch (value) {
      1 => LessonStatus.draft,
      2 => LessonStatus.active,
      3 => LessonStatus.completed,
      _ => LessonStatus.draft,
    };
  }

  /// Türkçe görüntü etiketi (Taslak/Aktif/Tamamlandı).
  String label(AppLocalizations l10n) => switch (this) {
        LessonStatus.draft => l10n.lessonStatusDraft,
        LessonStatus.active => l10n.lessonStatusActive,
        LessonStatus.completed => l10n.lessonStatusCompleted,
      };

  /// Büyük harf rozet etiketi (Türkçe casing — Dart `toUpperCase()` İ'yi bozar).
  String labelUpper(AppLocalizations l10n) => switch (this) {
        LessonStatus.draft => l10n.lessonStatusDraftUpper,
        LessonStatus.active => l10n.lessonStatusActiveUpper,
        LessonStatus.completed => l10n.lessonStatusCompletedUpper,
      };
}
