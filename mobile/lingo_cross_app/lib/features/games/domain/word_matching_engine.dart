import 'dart:math';

import '../../results/data/dtos/result_dtos.dart';
import '../data/dtos/game_dtos.dart';

/// Bir terim kartının (sol sütun) durumu. Serbest oyunda doğruluk gösterilmez,
/// yalnız "nötr / seçili / eşleştirildi" (nötr renk) durumları vardır.
enum TermCardStatus { neutral, selected, matched }

/// Bir karşılık kartının (sağ sütun) durumu. Doğruluk oyun sırasında gizli;
/// sadece "nötr / seçili / eşleştirildi" (nötr renk).
enum TranslationCardStatus { neutral, selected, matched }

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

/// Kelime eşleştirme oyununun saf (UI'siz) durum makinesi — **serbest eşleştirme**.
///
/// Sol sütun = terimler (pairs[].term). Sağ sütun = tüm correctTranslation +
/// distractors, karıştırılmış. Öğrenci önce bir terim, sonra bir karşılık seçer
/// ve ikisi NÖTR renkte eşleştirilir; doğruluk OYUN SIRASINDA gösterilmez.
/// Var olan bir eşleştirme bozulup yeniden yapılabilir (terim/karşılık başka
/// eşleşmeye geçerse eski bağ çözülür). Skor yalnızca [score] çağrısıyla, "Bitir"
/// anında hesaplanır: terim ↔ doğru karşılık örtüşen çift sayısı.
///
/// [Random] enjekte edilebilir (deterministik test için).
class WordMatchingEngine {
  WordMatchingEngine._({
    required this.terms,
    required this.translations,
    required this.total,
    required this.selectedTermWordId,
    required Map<String, int> pairings,
  }) : _pairings = pairings;

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
      selectedTermWordId: null,
      pairings: const {},
    );
  }

  final List<TermCard> terms;
  final List<TranslationCard> translations;

  /// Toplam doğru çift sayısı (sol sütundaki terim sayısı) — totalItems.
  final int total;

  /// O an seçili terimin wordId'si; seçim yoksa null.
  final String? selectedTermWordId;

  /// Öğrencinin yaptığı eşleştirmeler: terim wordId → karşılık (translation) index.
  /// Doğruluk içermez; yalnız hangi terimin hangi karşılığa bağlandığı.
  final Map<String, int> _pairings;

  /// Yapılan eşleştirme sayısı (doğru/yanlış ayırt etmeden). İlerleme bunun
  /// üzerinden gösterilir (doğruluk gizli kalır).
  int get matched => _pairings.length;

  /// Tüm terimler bir karşılığa eşleştirildi mi (öğrenci "Bitir"ebilir).
  bool get isComplete => total > 0 && matched >= total;

  /// İlerleme oranı (0–1) — yapılan eşleştirme / toplam.
  double get progress => total == 0 ? 0 : matched / total;

  /// "Bitir" anındaki doğru eşleşme sayısı (correctItems): terim ↔ doğru
  /// karşılık örtüşen çiftler. Oyun sırasında çağrılmaz; skorlama içindir.
  int get score {
    var n = 0;
    for (final entry in _pairings.entries) {
      final wordId = entry.key;
      final translation = translations[entry.value];
      if (translation.matchWordId == wordId) n++;
    }
    return n;
  }

  WordMatchingEngine _copy({
    List<TermCard>? terms,
    List<TranslationCard>? translations,
    Map<String, int>? pairings,
    String? selectedTermWordId,
    bool clearSelection = false,
  }) {
    return WordMatchingEngine._(
      terms: terms ?? this.terms,
      translations: translations ?? this.translations,
      total: total,
      pairings: pairings ?? _pairings,
      selectedTermWordId: clearSelection
          ? null
          : (selectedTermWordId ?? this.selectedTermWordId),
    );
  }

  /// Görsel durumları [_pairings] + [selectedTermWordId] üzerinden yeniden kurar
  /// (eşleştirilmiş = matched, seçili = selected, diğeri = neutral).
  WordMatchingEngine _rebuild({
    required Map<String, int> pairings,
    required String? selectedTermWordId,
  }) {
    final matchedTranslationIndexes = pairings.values.toSet();
    final newTerms = [
      for (final t in terms)
        t.copyWith(
          status: pairings.containsKey(t.wordId)
              ? TermCardStatus.matched
              : (t.wordId == selectedTermWordId
                  ? TermCardStatus.selected
                  : TermCardStatus.neutral),
        ),
    ];
    final newTranslations = [
      for (var i = 0; i < translations.length; i++)
        translations[i].copyWith(
          status: matchedTranslationIndexes.contains(i)
              ? TranslationCardStatus.matched
              : TranslationCardStatus.neutral,
        ),
    ];
    return _copy(
      terms: newTerms,
      translations: newTranslations,
      pairings: pairings,
      selectedTermWordId: selectedTermWordId,
      clearSelection: selectedTermWordId == null,
    );
  }

  /// Bir terim kartına dokunuş (index ile).
  ///
  /// - Terim zaten eşleştirilmişse: eşleştirme BOZULUR (karşılık serbest kalır)
  ///   ve terim yeniden seçili olur (yeniden eşleştirilebilir).
  /// - Aksi halde terim seçili olur (önceki seçim sıfırlanır).
  WordMatchingEngine selectTerm(int index) {
    final target = terms[index];
    final pairings = Map<String, int>.from(_pairings);
    if (pairings.containsKey(target.wordId)) {
      pairings.remove(target.wordId);
    }
    return _rebuild(pairings: pairings, selectedTermWordId: target.wordId);
  }

  /// Bir karşılık kartına dokunuş (index ile).
  ///
  /// - Terim seçili değilse no-op.
  /// - Bu karşılık başka bir terime bağlıysa o bağ çözülür (tek karşılık → tek terim).
  /// - Seçili terim ↔ bu karşılık eşleştirilir (NÖTR renk, doğruluk gizli) ve
  ///   seçim çözülür.
  WordMatchingEngine matchTranslation(int index) {
    final wordId = selectedTermWordId;
    if (wordId == null) return this;

    final pairings = Map<String, int>.from(_pairings);
    // Aynı karşılık başka terime bağlıysa eski bağı çöz.
    pairings.removeWhere((_, translationIndex) => translationIndex == index);
    pairings[wordId] = index;

    return _rebuild(pairings: pairings, selectedTermWordId: null);
  }

  /// Bir karşılığın bağlı olduğu terimi çözer (karşılığa tekrar dokununca
  /// eşleştirmeyi geri almak için). Bağlı değilse no-op.
  WordMatchingEngine unmatchTranslation(int index) {
    if (!_pairings.values.contains(index)) return this;
    final pairings = Map<String, int>.from(_pairings)
      ..removeWhere((_, translationIndex) => translationIndex == index);
    return _rebuild(pairings: pairings, selectedTermWordId: selectedTermWordId);
  }

  /// Bir karşılık kartı şu an bir terime bağlı mı (matched görünür).
  bool isTranslationMatched(int index) => _pairings.values.contains(index);

  /// "Bitir" anında her TERİM için kelime-bazlı sonuç dökümü (F7.5).
  ///
  /// - [SubmitResultItem.ordinal] = terimin sol sütundaki sırası (0-tabanlı).
  /// - [SubmitResultItem.term] = kaynak (İngilizce) terim.
  /// - [SubmitResultItem.expectedAnswer] = o terimin doğru Türkçe karşılığı.
  /// - [SubmitResultItem.studentAnswer] = öğrencinin o terime eşleştirdiği
  ///   karşılığın metni; eşleştirme yapmadıysa null.
  /// - [SubmitResultItem.isCorrect] = öğrencinin eşleştirdiği karşılık doğru mu.
  ///
  /// Mevcut skorlama mantığı korunur; bu yalnız bitişte çağrılan türetimdir.
  List<SubmitResultItem> resultItems() {
    final items = <SubmitResultItem>[];
    for (var i = 0; i < terms.length; i++) {
      final term = terms[i];
      // Terimin doğru karşılığı: matchWordId == term.wordId olan çeviri.
      final expected = translations
          .firstWhere(
            (t) => t.matchWordId == term.wordId,
            orElse: () => const TranslationCard(
              text: '',
              matchWordId: null,
              status: TranslationCardStatus.neutral,
            ),
          )
          .text;
      final matchedIndex = _pairings[term.wordId];
      final studentAnswer =
          matchedIndex == null ? null : translations[matchedIndex].text;
      final isCorrect =
          matchedIndex != null && translations[matchedIndex].matchWordId == term.wordId;
      items.add(SubmitResultItem(
        ordinal: i,
        term: term.term,
        expectedAnswer: expected,
        studentAnswer: studentAnswer,
        isCorrect: isCorrect,
      ));
    }
    return items;
  }
}
