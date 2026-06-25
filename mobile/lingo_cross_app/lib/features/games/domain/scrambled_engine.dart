import '../../results/data/dtos/result_dtos.dart';
import '../data/dtos/game_dtos.dart';

/// Scrambled (karışık harfler) oyununda tek bir kelime kartının saf durumu.
///
/// [scrambledLetters] karışık harf havuzu (tek karakterler). [built] öğrencinin
/// cevap yuvalarına yerleştirdiği harflerin [scrambledLetters] içindeki
/// indeksleridir (yerleştirme sırasıyla). Aynı havuz indeksi en çok bir kez
/// kullanılır; havuzda yerleştirilmemiş indeksler hâlâ seçilebilir.
class ScrambledCard {
  const ScrambledCard({
    required this.wordId,
    required this.term,
    required this.clue,
    required this.scrambledLetters,
    required this.built,
  });

  final String wordId;

  /// Doğru cevap (kaynak terim). Öğrenci bunu yeniden dizmeye çalışır.
  final String term;

  /// Hedef dildeki çeviri (ipucu olarak gösterilir).
  final String clue;

  /// Karışık harf havuzu (tek karakterler), sabit sıralı.
  final List<String> scrambledLetters;

  /// Cevaba yerleştirilen harflerin [scrambledLetters] içindeki indeksleri
  /// (yerleştirme sırasıyla).
  final List<int> built;

  /// Cevap yuvalarındaki harflerin birleştirilmiş hâli (ör. "apple").
  String get builtJoined => built.map((i) => scrambledLetters[i]).join();

  /// Bir havuz indeksi şu an cevaba yerleştirilmiş mi (havuzda tükenmiş sayılır).
  bool isLetterUsed(int letterIndex) => built.contains(letterIndex);

  /// Tüm harfler yerleştirildi mi (cevap doluysa).
  bool get isFilled => built.length >= scrambledLetters.length;

  /// Cevap, terimle (büyük/küçük harf duyarsız) eşit mi.
  bool get isCorrect => builtJoined.toLowerCase() == term.toLowerCase();

  ScrambledCard copyWith({List<int>? built}) => ScrambledCard(
        wordId: wordId,
        term: term,
        clue: clue,
        scrambledLetters: scrambledLetters,
        built: built ?? this.built,
      );
}

/// Scrambled (karışık harfler) oyununun saf (UI'siz) durum makinesi —
/// **serbest oyun**.
///
/// Her kelime için karışık harf havuzu verilir; öğrenci çeviri ipucu eşliğinde
/// harfleri **dokunarak** (tap-to-build) cevap yuvalarına dizer. Oyun boyunca
/// serbesttir; doğru/yanlış OYUN SIRASINDA gösterilmez (nötr). Skor yalnızca
/// "Bitir" anında, [correctCount] ile hesaplanır: her kartın dizdiği harf dizisi
/// terime **büyük/küçük harf duyarsız** eşitse doğru sayılır.
///
/// Değişmez/fonksiyonel: her mutasyon yeni bir [ScrambledEngine] döndürür.
class ScrambledEngine {
  const ScrambledEngine._({
    required this.cards,
    required this.activeIndex,
  });

  /// İçerikten oyun durumunu kurar. Harf havuzu içerikte verilen sırayla
  /// (karıştırma backend'de yapılır) korunur; istemci sırayı değiştirmez.
  factory ScrambledEngine.fromContent(ScrambledContent content) {
    final cards = [
      for (final item in content.items)
        ScrambledCard(
          wordId: item.wordId,
          term: item.answer,
          clue: item.clue,
          scrambledLetters: item.scrambledLetters.split(''),
          built: const [],
        ),
    ];
    return ScrambledEngine._(cards: cards, activeIndex: 0);
  }

  final List<ScrambledCard> cards;

  /// Aktif (görüntülenen) kartın indeksi.
  final int activeIndex;

  /// Toplam kelime sayısı — totalItems.
  int get total => cards.length;

  /// O an gösterilen kart (boş içerikte null).
  ScrambledCard? get activeCard =>
      cards.isEmpty ? null : cards[activeIndex];

  /// Cevabı tamamen dolu (tüm harfleri yerleştirilmiş) kart sayısı — ilerleme
  /// bunun üzerinden gösterilir (doğruluk gizli kalır).
  int get filledCount => cards.where((c) => c.isFilled).length;

  /// İlerleme oranı (0–1) — dolu kart / toplam.
  double get progress => total == 0 ? 0 : filledCount / total;

  /// "Bitir" anındaki doğru kelime sayısı (correctItems): dizilen harf dizisi
  /// terime (büyük/küçük harf duyarsız) eşit olan kartlar. Oyun sırasında
  /// gösterilmez; yalnız skorlama içindir.
  int get correctCount => cards.where((c) => c.isCorrect).length;

  ScrambledEngine _replaceActive(ScrambledCard card) {
    final next = [...cards];
    next[activeIndex] = card;
    return ScrambledEngine._(cards: next, activeIndex: activeIndex);
  }

  /// Havuzdaki [letterIndex] harfini aktif kartın cevabına ekler.
  ///
  /// Harf zaten yerleştirilmişse veya cevap doluysa no-op. Aksi halde harf
  /// cevap yuvalarının sonuna eklenir.
  ScrambledEngine placeLetter(int letterIndex) {
    final card = activeCard;
    if (card == null) return this;
    if (letterIndex < 0 || letterIndex >= card.scrambledLetters.length) {
      return this;
    }
    if (card.isLetterUsed(letterIndex) || card.isFilled) return this;
    return _replaceActive(card.copyWith(built: [...card.built, letterIndex]));
  }

  /// Aktif kartın cevabındaki [answerPos] konumundaki harfi geri alır (havuza
  /// döndürür). Geçersiz konum → no-op.
  ScrambledEngine removeAt(int answerPos) {
    final card = activeCard;
    if (card == null) return this;
    if (answerPos < 0 || answerPos >= card.built.length) return this;
    final built = [...card.built]..removeAt(answerPos);
    return _replaceActive(card.copyWith(built: built));
  }

  /// Aktif kart geçişi (kelimeler arası ileri/geri veya liste). Geçersiz indeks
  /// → no-op.
  ScrambledEngine selectWord(int index) {
    if (index < 0 || index >= cards.length || index == activeIndex) return this;
    return ScrambledEngine._(cards: cards, activeIndex: index);
  }

  /// "Bitir" anında her KELİME için kelime-bazlı sonuç dökümü (F7.5).
  ///
  /// - [SubmitResultItem.ordinal] = kelimenin sırası (0-tabanlı).
  /// - [SubmitResultItem.term] = kaynak terim (doğru cevap).
  /// - [SubmitResultItem.expectedAnswer] = aynı terim (beklenen cevap).
  /// - [SubmitResultItem.studentAnswer] = öğrencinin dizdiği harf dizisi;
  ///   hiç harf yerleştirmediyse null.
  /// - [SubmitResultItem.isCorrect] = dizilen cevap terime (büyük/küçük harf
  ///   duyarsız) eşit mi.
  List<SubmitResultItem> resultItems() {
    return [
      for (var i = 0; i < cards.length; i++)
        SubmitResultItem(
          ordinal: i,
          term: cards[i].term,
          expectedAnswer: cards[i].term,
          studentAnswer:
              cards[i].built.isEmpty ? null : cards[i].builtJoined,
          isCorrect: cards[i].isCorrect,
        ),
    ];
  }
}
