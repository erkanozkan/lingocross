import '../../results/data/dtos/result_dtos.dart';
import '../data/dtos/game_dtos.dart';

/// Çıkmış Sorular (çoktan seçmeli) oyununda tek bir soru kartının saf durumu.
///
/// [choices] A–E sırasında şıklar (içerikte verilen sırayla korunur; istemci
/// sırayı değiştirmez). [selectedOptionId] öğrencinin seçtiği şıkkın kimliği;
/// henüz seçim yapılmadıysa null. [correctOptionId] doğru şıkkın kimliği
/// (skorlama istemcide bununla yapılır; oyun sırasında gösterilmez).
class QuestionSetCard {
  const QuestionSetCard({
    required this.questionId,
    required this.stem,
    required this.choices,
    required this.correctOptionId,
    required this.explanation,
    required this.selectedOptionId,
  });

  final String questionId;

  /// Soru kökü.
  final String stem;

  /// A–E sırasında şıklar.
  final List<QuestionChoice> choices;

  /// Doğru şıkkın kimliği (gizli; yalnız skorlama içindir).
  final String correctOptionId;

  /// Opsiyonel açıklama (oyun sırasında gösterilmez).
  final String? explanation;

  /// Öğrencinin seçtiği şıkkın kimliği; seçim yoksa null.
  final String? selectedOptionId;

  /// Bu soru cevaplandı mı (bir şık seçildi mi).
  bool get isAnswered => selectedOptionId != null;

  /// Seçim doğru mu (yalnız "Bitir" anında skorlamada kullanılır).
  bool get isCorrect =>
      selectedOptionId != null && selectedOptionId == correctOptionId;

  /// Doğru şık (içerikte garanti edilir; bulunamazsa null savunması).
  QuestionChoice? get correctChoice {
    for (final c in choices) {
      if (c.optionId == correctOptionId) return c;
    }
    return null;
  }

  /// Seçili şık (varsa).
  QuestionChoice? get selectedChoice {
    final id = selectedOptionId;
    if (id == null) return null;
    for (final c in choices) {
      if (c.optionId == id) return c;
    }
    return null;
  }

  QuestionSetCard copyWith({String? selectedOptionId}) => QuestionSetCard(
        questionId: questionId,
        stem: stem,
        choices: choices,
        correctOptionId: correctOptionId,
        explanation: explanation,
        selectedOptionId: selectedOptionId ?? this.selectedOptionId,
      );
}

/// Çıkmış Sorular (çoktan seçmeli) oyununun saf (UI'siz) durum makinesi.
///
/// 10 soru tek tek çözülür (A–E tek seçim). Oyun boyunca serbest; doğru/yanlış
/// OYUN SIRASINDA gösterilmez (nötr). Skor yalnızca "Bitir" anında,
/// [correctCount] ile hesaplanır: her sorunun seçili şıkkı doğru şıkka eşitse
/// doğru sayılır. Skorlama tamamen İSTEMCİDE'dir.
///
/// Değişmez/fonksiyonel: her mutasyon yeni bir [QuestionSetEngine] döndürür.
class QuestionSetEngine {
  const QuestionSetEngine._({
    required this.cards,
    required this.activeIndex,
  });

  /// İçerikten oyun durumunu kurar. Şık sırası içerikte verilen sırayla
  /// (A–E) korunur; istemci sırayı değiştirmez.
  factory QuestionSetEngine.fromContent(QuestionSetContent content) {
    final cards = [
      for (final q in content.questions)
        QuestionSetCard(
          questionId: q.questionId,
          stem: q.stem,
          choices: q.choices,
          correctOptionId: q.correctOptionId,
          explanation: q.explanation,
          selectedOptionId: null,
        ),
    ];
    return QuestionSetEngine._(cards: cards, activeIndex: 0);
  }

  final List<QuestionSetCard> cards;

  /// Aktif (görüntülenen) sorunun indeksi.
  final int activeIndex;

  /// Toplam soru sayısı — totalItems.
  int get total => cards.length;

  /// O an gösterilen soru (boş içerikte null).
  QuestionSetCard? get activeCard => cards.isEmpty ? null : cards[activeIndex];

  /// Cevaplanmış (bir şık seçilmiş) soru sayısı — ilerleme bunun üzerinden
  /// gösterilir (doğruluk gizli kalır).
  int get answeredCount => cards.where((c) => c.isAnswered).length;

  /// İlerleme oranı (0–1) — cevaplanmış soru / toplam.
  double get progress => total == 0 ? 0 : answeredCount / total;

  /// İlk soruda mıyız (önceki yok).
  bool get isFirst => activeIndex <= 0;

  /// Son soruda mıyız (sonraki yok).
  bool get isLast => activeIndex >= total - 1;

  /// "Bitir" anındaki doğru soru sayısı (correctItems): seçili şıkkı doğru
  /// şıkka eşit olan sorular. Oyun sırasında gösterilmez; yalnız skorlama için.
  int get correctCount => cards.where((c) => c.isCorrect).length;

  QuestionSetEngine _replaceActive(QuestionSetCard card) {
    final next = [...cards];
    next[activeIndex] = card;
    return QuestionSetEngine._(cards: next, activeIndex: activeIndex);
  }

  /// Aktif soruda [optionId] şıkkını seçer (tek seçim; öncekinin yerini alır).
  /// Geçersiz şık (içerikte yok) → no-op.
  QuestionSetEngine selectOption(String optionId) {
    final card = activeCard;
    if (card == null) return this;
    if (!card.choices.any((c) => c.optionId == optionId)) return this;
    return _replaceActive(card.copyWith(selectedOptionId: optionId));
  }

  /// Sonraki soruya geçer (son soruda no-op).
  QuestionSetEngine next() {
    if (isLast) return this;
    return QuestionSetEngine._(cards: cards, activeIndex: activeIndex + 1);
  }

  /// Önceki soruya geçer (ilk soruda no-op).
  QuestionSetEngine prev() {
    if (isFirst) return this;
    return QuestionSetEngine._(cards: cards, activeIndex: activeIndex - 1);
  }

  /// Belirli bir soruya geçer (geçersiz/aynı indeks → no-op).
  QuestionSetEngine selectQuestion(int index) {
    if (index < 0 || index >= cards.length || index == activeIndex) return this;
    return QuestionSetEngine._(cards: cards, activeIndex: index);
  }

  /// "Bitir" anında her SORU için soru-bazlı sonuç dökümü (F7.5).
  ///
  /// - [SubmitResultItem.ordinal] = sorunun sırası (0-tabanlı).
  /// - [SubmitResultItem.term] = soru kökü (stem).
  /// - [SubmitResultItem.expectedAnswer] = doğru şıkkın metni.
  /// - [SubmitResultItem.studentAnswer] = seçili şıkkın metni; seçim yoksa null.
  /// - [SubmitResultItem.isCorrect] = seçim doğru şıkka eşit mi.
  List<SubmitResultItem> resultItems() {
    return [
      for (var i = 0; i < cards.length; i++)
        SubmitResultItem(
          ordinal: i,
          term: cards[i].stem,
          expectedAnswer: cards[i].correctChoice?.text ?? '',
          studentAnswer: cards[i].selectedChoice?.text,
          isCorrect: cards[i].isCorrect,
        ),
    ];
  }
}
