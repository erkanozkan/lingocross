import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';

import '../domain/ocr_line_parser.dart';

/// Cihaz-içi dil tespitine göre OCR adaylarını dersin "terim = kaynak dil,
/// karşılık = hedef dil" yönüne çeviren katman.
///
/// OCR satır ayrıştırıcısı sıra-bazlıdır (ayraçtan önce = terim). Ama öğretmen
/// kâğıda satırı ters yazarsa (örn. en→tr derste "elma - apple") terim hedef
/// dilde, karşılık kaynak dilde çıkar. Bu sınıf iki tarafın dilini ML Kit ile
/// tespit edip yalnız satır AÇIKÇA ters yönde (terim=hedef, karşılık=kaynak)
/// olduğunda takas yapar; F9.2 ile ders dil çifti artık açık olduğundan yön
/// dersten gelir, ML Kit yalnız bu ters-yön tespiti için bilgi sağlar.

/// Saf (ML Kit'siz) karar fonksiyonu — birim testi yazılabilir.
///
/// SADECE tespit edilen terim dili dersin HEDEF dili ([targetLang]) ve karşılık
/// dili dersin KAYNAK dili ([sourceLang]) ise `true` döner; yani satır ters
/// yöndedir ve takas gerekir. Eşit diller, `und` (belirsiz), `null` veya yön
/// zaten doğru olan kombinasyonlarda `false`. [sourceLang]/[targetLang]
/// verilmezse geriye dönük uyumluluk için en→tr varsayılır.
bool shouldSwapForLanguages(
  String? termLang,
  String? meaningLang, {
  String sourceLang = 'en',
  String targetLang = 'tr',
}) {
  // Aynı çift (örn. dersi yok sayan eşit diller) için takas anlamsız.
  if (sourceLang == targetLang) return false;
  return termLang == targetLang && meaningLang == sourceLang;
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
  ///
  /// [sourceLang]/[targetLang] dersin dil çiftidir (ISO kodu, F9.2). Satır
  /// yalnız açıkça ters yöndeyse (terim=hedef, karşılık=kaynak) takas edilir.
  /// Verilmezse geriye dönük uyumluluk için en→tr varsayılır.
  Future<List<OcrCandidate>> orient(
    List<OcrCandidate> candidates, {
    String sourceLang = 'en',
    String targetLang = 'tr',
  }) async {
    final result = <OcrCandidate>[];
    for (final c in candidates) {
      final meaning = c.meaning;
      if (meaning == null || meaning.trim().isEmpty || c.term.trim().isEmpty) {
        result.add(c);
        continue;
      }

      final termLang = await _identify(c.term);
      final meaningLang = await _identify(meaning);

      if (shouldSwapForLanguages(
        termLang,
        meaningLang,
        sourceLang: sourceLang,
        targetLang: targetLang,
      )) {
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
