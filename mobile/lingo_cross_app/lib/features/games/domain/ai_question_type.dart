/// Yapay zekâ ile üretilecek çoktan seçmeli soru türleri (API kodlarıyla birebir).
///
/// API `types` alanı bu [code]'ları bekler ("word_meaning" | "fill_blank" |
/// "synonym"). Görünür adlar i18n'den çözülür (kod → l10n anahtarı).
enum AiQuestionType {
  /// Kelime-Anlam.
  wordMeaning('word_meaning'),

  /// Boşluk Doldurma.
  fillBlank('fill_blank'),

  /// Eş Anlam.
  synonym('synonym');

  const AiQuestionType(this.code);

  /// API'nin beklediği/döndürdüğü tür kodu.
  final String code;

  /// API kodundan enum'a; bilinmeyen kod `null` döner (review'da ham kod
  /// gösterilmez, etiket gizlenir).
  static AiQuestionType? fromCode(String code) {
    for (final t in AiQuestionType.values) {
      if (t.code == code) return t;
    }
    return null;
  }
}
