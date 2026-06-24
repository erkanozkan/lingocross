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
    this.synonyms = const [],
  });

  /// Terim (kaynak dil). Boş olmaz (boş satırlar zaten elenir).
  final String term;

  /// Ayraçtan ayrıştırılmış olası karşılık. Yoksa null.
  final String? meaning;

  /// Terim < 2 karakter ise true (gözden geçirmede vurgulanır).
  final bool tooShort;

  /// Bulut AI zenginleştirmesinden gelen eşanlamlar (yerel ayrıştırmada boş).
  final List<String> synonyms;

  OcrCandidate copyWith({
    String? term,
    String? meaning,
    bool? tooShort,
    List<String>? synonyms,
  }) {
    return OcrCandidate(
      term: term ?? this.term,
      meaning: meaning ?? this.meaning,
      tooShort: tooShort ?? this.tooShort,
      synonyms: synonyms ?? this.synonyms,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is OcrCandidate &&
      other.term == term &&
      other.meaning == meaning &&
      other.tooShort == tooShort &&
      _listEquals(other.synonyms, synonyms);

  @override
  int get hashCode =>
      Object.hash(term, meaning, tooShort, Object.hashAll(synonyms));

  @override
  String toString() =>
      'OcrCandidate(term: $term, meaning: $meaning, tooShort: $tooShort, '
      'synonyms: $synonyms)';
}

bool _listEquals(List<String> a, List<String> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
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
