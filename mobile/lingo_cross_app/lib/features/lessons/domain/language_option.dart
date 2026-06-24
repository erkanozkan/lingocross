import '../../../core/l10n/gen/app_localizations.dart';

/// Ders dil çifti seçenekleri. Veri modeli ISO kodu (`en`, `tr`, `de`, `es`,
/// `fr`, `it`) saklar; UI dilden bağımsızdır. Görünen ad lokalizedir
/// ([label]) — sabit string yoktur.
enum LanguageOption {
  en('en'),
  tr('tr'),
  de('de'),
  es('es'),
  fr('fr'),
  it('it');

  const LanguageOption(this.code);

  final String code;

  /// Yeni ders varsayılan kaynak/hedef dili (ISO kodu).
  static const String defaultSource = 'en';
  static const String defaultTarget = 'tr';

  /// Bilinmeyen/null kod → [en] (güvenli geri düşüş). Büyük/küçük harf duyarsız.
  static LanguageOption fromCode(String? code) {
    return switch (code?.toLowerCase()) {
      'en' => LanguageOption.en,
      'tr' => LanguageOption.tr,
      'de' => LanguageOption.de,
      'es' => LanguageOption.es,
      'fr' => LanguageOption.fr,
      'it' => LanguageOption.it,
      _ => LanguageOption.en,
    };
  }

  /// Lokalize dil adı (örn. tr locale'de "Almanca", en locale'de "German").
  String label(AppLocalizations l10n) => switch (this) {
        LanguageOption.en => l10n.langNameEnglish,
        LanguageOption.tr => l10n.langNameTurkish,
        LanguageOption.de => l10n.langNameGerman,
        LanguageOption.es => l10n.langNameSpanish,
        LanguageOption.fr => l10n.langNameFrench,
        LanguageOption.it => l10n.langNameItalian,
      };
}

/// ISO kodunu kısa görüntü etiketine çevirir (örn. "EN", "TR").
String languageShortLabel(String code) => code.toUpperCase();
