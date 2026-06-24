import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';

import '../domain/ocr_line_parser.dart';

/// Cihaz-içi dil tespitine göre OCR adaylarını "terim = kaynak dil (İngilizce),
/// karşılık = hedef dil (Türkçe)" yönüne çeviren katman.
///
/// OCR satır ayrıştırıcısı sıra-bazlıdır (ayraçtan önce = terim). Ama öğretmen
/// kâğıda "elma - apple" yazarsa terim Türkçe, karşılık İngilizce çıkar. Bu
/// sınıf iki tarafın dilini ML Kit ile tespit edip yalnız `tr → en` durumunda
/// takas yapar; diğer tüm belirsiz/eşit/farklı kombinasyonlarda dokunmaz.

/// Saf (ML Kit'siz) karar fonksiyonu — birim testi yazılabilir.
///
/// SADECE terim Türkçe (`tr`) ve karşılık İngilizce (`en`) tespit edildiğinde
/// `true` döner; eşit diller, `und` (belirsiz), `null` veya başka kombinasyonlar
/// için `false`. Yani yalnız "yanlış yönde" girilmiş satırlar takas edilir.
bool shouldSwapForLanguages(String? termLang, String? meaningLang) {
  return termLang == 'tr' && meaningLang == 'en';
}

/// ML Kit `LanguageIdentifier`'ı sarmalayan, test edilebilir yönlendirici.
///
/// ML Kit'e doğrudan bağımlı olmamak için tek-metin dil tespiti bir
/// `Future<String> Function(String)` callback'i ([identify]) olarak enjekte
/// edilir. Varsayılan gerçek ML Kit `identifyLanguage`'tır; testte sahte bir
/// fonksiyon verilebilir.
class OcrLanguageOrienter {
  /// [identify] verilirse ML Kit hiç kullanılmaz (test için). Verilmezse
  /// gerçek ML Kit `LanguageIdentifier` oluşturulur ve `dispose()`'da kapatılır.
  factory OcrLanguageOrienter({
    Future<String> Function(String text)? identify,
  }) {
    if (identify != null) {
      return OcrLanguageOrienter._(identify: identify, identifier: null);
    }
    final identifier = LanguageIdentifier(confidenceThreshold: 0.5);
    return OcrLanguageOrienter._(
      identify: identifier.identifyLanguage,
      identifier: identifier,
    );
  }

  OcrLanguageOrienter._({
    required Future<String> Function(String text) identify,
    required LanguageIdentifier? identifier,
  })  : _identify = identify,
        _identifier = identifier;

  final LanguageIdentifier? _identifier;
  final Future<String> Function(String text) _identify;

  /// Her aday için, term VE meaning dolu ise iki tarafın dilini tespit eder ve
  /// [shouldSwapForLanguages] `true` ise term ↔ meaning takas eder
  /// (`tooShort` yeni term'e göre yeniden hesaplanır). meaning'i boş/null olan
  /// adaylar olduğu gibi döner.
  Future<List<OcrCandidate>> orient(List<OcrCandidate> candidates) async {
    final result = <OcrCandidate>[];
    for (final c in candidates) {
      final meaning = c.meaning;
      if (meaning == null || meaning.trim().isEmpty || c.term.trim().isEmpty) {
        result.add(c);
        continue;
      }

      final termLang = await _identify(c.term);
      final meaningLang = await _identify(meaning);

      if (shouldSwapForLanguages(termLang, meaningLang)) {
        result.add(
          OcrCandidate(
            term: meaning,
            meaning: c.term,
            tooShort: meaning.trim().length < 2,
          ),
        );
      } else {
        result.add(c);
      }
    }
    return result;
  }

  Future<void> dispose() async {
    await _identifier?.close();
  }
}
