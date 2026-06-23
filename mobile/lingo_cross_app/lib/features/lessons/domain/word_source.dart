/// Bir kelimenin nasıl girildiğini belirtir. Sayısal değerler API ile birebir
/// eşleşir ve DEĞİŞTİRİLMEZ: Manual = 1, Ocr = 2
/// (bkz. LingoCross.Domain.Enums.WordSource).
enum WordSource {
  manual(1),
  ocr(2);

  const WordSource(this.value);

  final int value;

  static WordSource fromValue(int value) {
    return switch (value) {
      1 => WordSource.manual,
      2 => WordSource.ocr,
      _ => WordSource.manual,
    };
  }

  bool get isManual => this == WordSource.manual;
  bool get isOcr => this == WordSource.ocr;
}
