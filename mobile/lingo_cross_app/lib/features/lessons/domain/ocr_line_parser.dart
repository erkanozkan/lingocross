/// Gözden geçirme ekranında düzenlenen kelime adayı modeli (saf, yan-etkisiz).
///
/// Adaylar artık bulut AI görüntü-okuma yanıtından üretilir
/// ([enrichedWordsToCandidates]); cihaz-içi metin tanıma kaldırıldı.
library;

/// Bir kelime adayı (terim + olası karşılık + eşanlamlar).
class OcrCandidate {
  const OcrCandidate({
    required this.term,
    this.meaning,
    this.tooShort = false,
    this.synonyms = const [],
  });

  /// Terim (kaynak dil). Boş olmaz (boş adaylar elenir).
  final String term;

  /// Olası karşılık (hedef dil). Yoksa null.
  final String? meaning;

  /// Terim < 2 karakter ise true (gözden geçirmede vurgulanır).
  final bool tooShort;

  /// Bulut AI'dan gelen eşanlamlar.
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
