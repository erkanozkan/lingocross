import 'dart:math';

import '../data/dtos/game_dtos.dart';

/// Bir terim kartının (sol sütun) durumu.
enum TermCardStatus { neutral, selected, matched }

/// Bir karşılık kartının (sağ sütun) durumu.
enum TranslationCardStatus { neutral, selected, matched, wrong }

/// Sol sütun (İngilizce terim) kartı.
class TermCard {
  const TermCard({
    required this.wordId,
    required this.term,
    required this.status,
  });

  final String wordId;
  final String term;
  final TermCardStatus status;

  TermCard copyWith({TermCardStatus? status}) => TermCard(
        wordId: wordId,
        term: term,
        status: status ?? this.status,
      );
}

/// Sağ sütun (Türkçe karşılık) kartı. Çeldiriciler [matchWordId] = null.
class TranslationCard {
  const TranslationCard({
    required this.text,
    required this.matchWordId,
    required this.status,
  });

  final String text;

  /// Bu karşılığın doğru olduğu terimin wordId'si; çeldiricide null.
  final String? matchWordId;
  final TranslationCardStatus status;

  bool get isDistractor => matchWordId == null;

  TranslationCard copyWith({TranslationCardStatus? status}) => TranslationCard(
        text: text,
        matchWordId: matchWordId,
        status: status ?? this.status,
      );
}

/// Bir karşılık seçimi sonucu.
enum MatchOutcome {
  /// Seçim henüz yapılmadı / önce terim seçilmeli (no-op).
  none,

  /// Doğru eşleşme; iki kart kalıcı "matched" oldu, ilerleme +1.
  correct,

  /// Yanlış eşleşme (çeldirici veya farklı terim); kart kırmızı flaş.
  wrong,
}

/// Kelime eşleştirme oyununun saf (UI'siz) durum makinesi.
///
/// Sol sütun = terimler (pairs[].term). Sağ sütun = tüm correctTranslation +
/// distractors, karıştırılmış. Önce bir terim, sonra bir karşılık seçilir;
/// `matchWordId` seçili terimin wordId'si ile eşleşirse doğru, aksi halde
/// (çeldirici dahil) yanlış sayılır. [Random] enjekte edilebilir (deterministik
/// test için).
class WordMatchingEngine {
  WordMatchingEngine._({
    required this.terms,
    required this.translations,
    required this.total,
    required this.matched,
    required this.selectedWordId,
  });

  /// İçeriğten oyun durumunu kurar; sağ sütun [random] ile karıştırılır.
  factory WordMatchingEngine.fromContent(
    WordMatchingContent content, {
    Random? random,
  }) {
    final rnd = random ?? Random();

    final terms = content.pairs
        .map((p) => TermCard(
              wordId: p.wordId,
              term: p.term,
              status: TermCardStatus.neutral,
            ))
        .toList();

    final translations = <TranslationCard>[
      for (final p in content.pairs)
        TranslationCard(
          text: p.correctTranslation,
          matchWordId: p.wordId,
          status: TranslationCardStatus.neutral,
        ),
      for (final d in content.distractors)
        TranslationCard(
          text: d,
          matchWordId: null,
          status: TranslationCardStatus.neutral,
        ),
    ]..shuffle(rnd);

    return WordMatchingEngine._(
      terms: terms,
      translations: translations,
      total: content.pairs.length,
      matched: 0,
      selectedWordId: null,
    );
  }

  final List<TermCard> terms;
  final List<TranslationCard> translations;

  /// Toplam doğru çift sayısı (sol sütundaki terim sayısı).
  final int total;

  /// Şu ana kadar doğru eşleştirilen çift sayısı.
  final int matched;

  /// O an seçili terimin wordId'si; seçim yoksa null.
  final String? selectedWordId;

  bool get isComplete => total > 0 && matched >= total;

  /// İlerleme oranı (0–1).
  double get progress => total == 0 ? 0 : matched / total;

  WordMatchingEngine _copy({
    List<TermCard>? terms,
    List<TranslationCard>? translations,
    int? matched,
    String? selectedWordId,
    bool clearSelection = false,
  }) {
    return WordMatchingEngine._(
      terms: terms ?? this.terms,
      translations: translations ?? this.translations,
      total: total,
      matched: matched ?? this.matched,
      selectedWordId:
          clearSelection ? null : (selectedWordId ?? this.selectedWordId),
    );
  }

  /// Bir terim kartına dokunuş (index ile). Eşleşmiş kart no-op.
  /// Sol sütunda tek seçim: yeni seçim öncekini sıfırlar.
  WordMatchingEngine selectTerm(int index) {
    final target = terms[index];
    if (target.status == TermCardStatus.matched) return this;

    final newTerms = [
      for (final t in terms)
        t.status == TermCardStatus.matched
            ? t
            : t.copyWith(
                status: t.wordId == target.wordId
                    ? TermCardStatus.selected
                    : TermCardStatus.neutral,
              ),
    ];
    // Önceki yanlış/seçili karşılıkları nötrle (matched korunur).
    final newTranslations = [
      for (final tr in translations)
        tr.status == TranslationCardStatus.matched
            ? tr
            : tr.copyWith(status: TranslationCardStatus.neutral),
    ];

    return _copy(
      terms: newTerms,
      translations: newTranslations,
      selectedWordId: target.wordId,
    );
  }

  /// Bir karşılık kartına dokunuşun sonucunu hesaplar (state'i değiştirmez).
  ///
  /// - Terim seçili değilse → [MatchOutcome.none].
  /// - Kart zaten eşleşmişse → [MatchOutcome.none].
  /// - matchWordId == selectedWordId → [MatchOutcome.correct].
  /// - aksi halde (çeldirici dahil) → [MatchOutcome.wrong].
  MatchOutcome evaluateTranslation(int index) {
    if (selectedWordId == null) return MatchOutcome.none;
    final card = translations[index];
    if (card.status == TranslationCardStatus.matched) return MatchOutcome.none;
    return card.matchWordId == selectedWordId
        ? MatchOutcome.correct
        : MatchOutcome.wrong;
  }

  /// Doğru eşleşmeyi uygular: seçili terim + bu karşılık "matched", +1 ilerleme,
  /// seçim çözülür. Sonuç [MatchOutcome.correct] olduğunda çağrılmalıdır.
  WordMatchingEngine applyCorrect(int translationIndex) {
    final wordId = selectedWordId;
    if (wordId == null) return this;

    final newTerms = [
      for (final t in terms)
        t.wordId == wordId
            ? t.copyWith(status: TermCardStatus.matched)
            : t.copyWith(
                status: t.status == TermCardStatus.matched
                    ? TermCardStatus.matched
                    : TermCardStatus.neutral,
              ),
    ];
    final newTranslations = [
      for (var i = 0; i < translations.length; i++)
        i == translationIndex
            ? translations[i].copyWith(status: TranslationCardStatus.matched)
            : (translations[i].status == TranslationCardStatus.matched
                ? translations[i]
                : translations[i]
                    .copyWith(status: TranslationCardStatus.neutral)),
    ];

    return _copy(
      terms: newTerms,
      translations: newTranslations,
      matched: matched + 1,
      clearSelection: true,
    );
  }

  /// Yanlış karşılığı geçici "wrong" işaretler (kırmızı flaş + shake için).
  WordMatchingEngine markWrong(int translationIndex) {
    final newTranslations = [
      for (var i = 0; i < translations.length; i++)
        i == translationIndex
            ? translations[i].copyWith(status: TranslationCardStatus.wrong)
            : translations[i],
    ];
    return _copy(translations: newTranslations);
  }

  /// Yanlış denemeyi sıfırlar: seçilen terim çözülür, "wrong"/"selected"
  /// karşılıklar nötr'e döner (matched korunur).
  WordMatchingEngine resetSelection() {
    final newTerms = [
      for (final t in terms)
        t.status == TermCardStatus.matched
            ? t
            : t.copyWith(status: TermCardStatus.neutral),
    ];
    final newTranslations = [
      for (final tr in translations)
        tr.status == TranslationCardStatus.matched
            ? tr
            : tr.copyWith(status: TranslationCardStatus.neutral),
    ];
    return _copy(
      terms: newTerms,
      translations: newTranslations,
      clearSelection: true,
    );
  }
}
