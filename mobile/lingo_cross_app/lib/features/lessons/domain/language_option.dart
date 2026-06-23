import '../../../core/l10n/gen/app_localizations.dart';

/// M2 dil seçenekleri. Veri modeli ISO kodu (`en`, `tr`) saklar; UI dilden
/// bağımsız. Liste kısa: İngilizce, Türkçe (DESIGN/ürün İngilizce↔Türkçe odaklı).
enum LanguageOption {
  en('en'),
  tr('tr');

  const LanguageOption(this.code);

  final String code;

  static const String defaultSource = 'en';
  static const String defaultTarget = 'tr';

  static LanguageOption fromCode(String? code) {
    return switch (code) {
      'en' => LanguageOption.en,
      'tr' => LanguageOption.tr,
      _ => LanguageOption.en,
    };
  }

  String label(AppLocalizations l10n) => switch (this) {
        LanguageOption.en => l10n.langEnglish,
        LanguageOption.tr => l10n.langTurkish,
      };
}

/// ISO kodunu kısa görüntü etiketine çevirir (örn. "EN", "TR").
String languageShortLabel(String code) => code.toUpperCase();
