/// ML Kit Text Recognition'ın döndürdüğü ham satırları kelime adaylarına
/// dönüştüren saf (yan-etkisiz) mantık. UI'dan ayrıdır → birim testi yazılabilir.
///
/// Kurallar (ux-spec §7):
/// - Baş/son boşluk kırpılır.
/// - Tamamen boş satırlar atılır.
/// - Çok kısa (< 2 karakter) satırlar `tooShort` ile işaretlenir (silinmez;
///   öğretmen karar verir).
/// - Kâğıtta "terim - karşılık" formatı varsa ayraç (`-`, `:`, `=`, tab) ile
///   bölünür → karşılık otomatik ön-doldurulur (öğretmen düzeltir).
library;

/// Bir OCR satırından türetilmiş kelime adayı.
class OcrCandidate {
  const OcrCandidate({
    required this.term,
    this.meaning,
    this.tooShort = false,
  });

  /// Terim (kaynak dil). Boş olmaz (boş satırlar zaten elenir).
  final String term;

  /// Ayraçtan ayrıştırılmış olası karşılık. Yoksa null.
  final String? meaning;

  /// Terim < 2 karakter ise true (gözden geçirmede vurgulanır).
  final bool tooShort;

  OcrCandidate copyWith({String? term, String? meaning, bool? tooShort}) {
    return OcrCandidate(
      term: term ?? this.term,
      meaning: meaning ?? this.meaning,
      tooShort: tooShort ?? this.tooShort,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is OcrCandidate &&
      other.term == term &&
      other.meaning == meaning &&
      other.tooShort == tooShort;

  @override
  int get hashCode => Object.hash(term, meaning, tooShort);

  @override
  String toString() =>
      'OcrCandidate(term: $term, meaning: $meaning, tooShort: $tooShort)';
}

/// Terim ile karşılığı ayıran olası ayraçlar (öncelik sırasız; ilk eşleşen).
final RegExp _separator = RegExp(r'\s*[\-:=\t–—]\s*');

/// Ham OCR satırlarını temizlenmiş [OcrCandidate] listesine çevirir.
///
/// [rawLines] genelde `RecognizedText.blocks` içindeki tüm `TextLine.text`
/// değerleridir. Satır içi `\n` da güvenlik için bölünür.
List<OcrCandidate> parseOcrLines(Iterable<String> rawLines) {
  final candidates = <OcrCandidate>[];
  for (final raw in rawLines) {
    for (final piece in raw.split('\n')) {
      final candidate = _parseLine(piece);
      if (candidate != null) candidates.add(candidate);
    }
  }
  return candidates;
}

OcrCandidate? _parseLine(String line) {
  final trimmed = line.trim();
  if (trimmed.isEmpty) return null;

  // "terim - karşılık" formatını yakala (yalnız ilk ayraçta böl).
  final match = _separator.firstMatch(trimmed);
  if (match != null && match.start > 0) {
    final term = trimmed.substring(0, match.start).trim();
    final meaning = trimmed.substring(match.end).trim();
    if (term.isNotEmpty) {
      return OcrCandidate(
        term: term,
        meaning: meaning.isEmpty ? null : meaning,
        tooShort: term.length < 2,
      );
    }
  }

  return OcrCandidate(term: trimmed, tooShort: trimmed.length < 2);
}
