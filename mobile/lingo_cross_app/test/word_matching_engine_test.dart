import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_cross_app/features/games/data/dtos/game_dtos.dart';
import 'package:lingo_cross_app/features/games/domain/word_matching_engine.dart';

WordMatchingContent _content() => const WordMatchingContent(
      pairs: [
        MatchingPair(wordId: 'w1', term: 'apple', correctTranslation: 'elma'),
        MatchingPair(wordId: 'w2', term: 'book', correctTranslation: 'kitap'),
        MatchingPair(wordId: 'w3', term: 'water', correctTranslation: 'su'),
      ],
      distractors: ['yolculuk', 'sessizlik'],
    );

/// Sabit Random ile deterministik karıştırma (testlerde tekrarlanabilir).
WordMatchingEngine _engine() =>
    WordMatchingEngine.fromContent(_content(), random: Random(1));

int _termIndex(WordMatchingEngine e, String wordId) =>
    e.terms.indexWhere((t) => t.wordId == wordId);

int _translationIndex(WordMatchingEngine e, String text) =>
    e.translations.indexWhere((t) => t.text == text);

/// Bir terimi (wordId) bir karşılığa (text) serbestçe eşleştirir.
WordMatchingEngine _match(WordMatchingEngine e, String wordId, String text) {
  e = e.selectTerm(_termIndex(e, wordId));
  return e.matchTranslation(_translationIndex(e, text));
}

void main() {
  group('WordMatchingEngine kurulum', () {
    test('sol sütun terimleri, sağ sütun çeviri + çeldirici içerir', () {
      final e = _engine();
      expect(e.terms.length, 3);
      // 3 doğru çeviri + 2 çeldirici = 5 karşılık.
      expect(e.translations.length, 5);
      expect(e.total, 3);
      expect(e.matched, 0);
      expect(e.score, 0);
      expect(e.isComplete, isFalse);
      expect(e.progress, 0);
    });

    test('çeldiriciler hiçbir terimle eşleşmez (matchWordId null)', () {
      final e = _engine();
      final distractors =
          e.translations.where((t) => t.isDistractor).map((t) => t.text);
      expect(distractors, containsAll(<String>['yolculuk', 'sessizlik']));
    });
  });

  group('serbest eşleştirme — doğruluk oyun sırasında gizli', () {
    test('terim seç → karşılık → matched (nötr), ilerleme +1, skor gizli değil',
        () {
      var e = _engine();
      e = e.selectTerm(_termIndex(e, 'w1'));
      expect(e.selectedTermWordId, 'w1');
      expect(e.terms[_termIndex(e, 'w1')].status, TermCardStatus.selected);

      final idx = _translationIndex(e, 'elma');
      e = e.matchTranslation(idx);

      expect(e.matched, 1); // ilerleme = yapılan eşleştirme
      expect(e.selectedTermWordId, isNull); // seçim çözüldü
      expect(e.terms[_termIndex(e, 'w1')].status, TermCardStatus.matched);
      expect(e.translations[idx].status, TranslationCardStatus.matched);
      expect(e.isTranslationMatched(idx), isTrue);
      expect(e.progress, closeTo(1 / 3, 1e-9));
      // Karşılık statüsünde doğru/yanlış AYRIMI YOK (nötr "matched").
    });

    test('yanlış eşleştirme de "matched" (nötr) gösterilir, ilerleme artar', () {
      // apple ↔ kitap (yanlış) eşleştir; oyun sırasında bu görünmemeli.
      var e = _match(_engine(), 'w1', 'kitap');
      expect(e.matched, 1);
      // Statü yine nötr "matched" — kırmızı/yanlış statüsü yok.
      final idx = _translationIndex(e, 'kitap');
      expect(e.translations[idx].status, TranslationCardStatus.matched);
    });

    test('çeldirici de serbestçe eşleştirilebilir (oyun sırasında engel yok)',
        () {
      var e = _match(_engine(), 'w1', 'yolculuk');
      expect(e.matched, 1);
      expect(e.isTranslationMatched(_translationIndex(e, 'yolculuk')), isTrue);
    });

    test('terim seçilmeden karşılığa dokunuş → no-op', () {
      final e = _engine();
      final e2 = e.matchTranslation(0);
      expect(e2.matched, 0);
    });

    test('tüm terimler eşleşince isComplete=true', () {
      var e = _engine();
      e = _match(e, 'w1', 'elma');
      e = _match(e, 'w2', 'kitap');
      e = _match(e, 'w3', 'su');
      expect(e.matched, 3);
      expect(e.isComplete, isTrue);
      expect(e.progress, 1.0);
    });
  });

  group('yeniden eşleştirme / bozma', () {
    test('eşleştirilmiş terime tekrar dokunma bağı bozar ve yeniden seçer', () {
      var e = _match(_engine(), 'w1', 'elma');
      expect(e.matched, 1);
      e = e.selectTerm(_termIndex(e, 'w1'));
      expect(e.matched, 0); // bağ çözüldü
      expect(e.selectedTermWordId, 'w1'); // yeniden seçili
    });

    test('bir karşılık başka terime bağlanınca eski terimin bağı çözülür', () {
      var e = _engine();
      e = _match(e, 'w1', 'elma'); // w1 → elma
      e = _match(e, 'w2', 'elma'); // w2 → elma (w1 serbest kalır)
      expect(e.matched, 1);
      expect(e.terms[_termIndex(e, 'w1')].status, TermCardStatus.neutral);
      expect(e.terms[_termIndex(e, 'w2')].status, TermCardStatus.matched);
    });

    test('bağlı karşılığa tekrar dokunma (seçim yokken) eşleştirmeyi geri alır',
        () {
      var e = _match(_engine(), 'w1', 'elma');
      final idx = _translationIndex(e, 'elma');
      e = e.unmatchTranslation(idx);
      expect(e.matched, 0);
      expect(e.isTranslationMatched(idx), isFalse);
    });
  });

  group('skorlama (yalnız "Bitir" anında)', () {
    test('bir doğru + bir yanlış eşleştirme → score=1, total=3', () {
      var e = _engine();
      e = _match(e, 'w1', 'elma'); // doğru
      e = _match(e, 'w2', 'su'); // yanlış (su = w3)
      expect(e.matched, 2);
      expect(e.total, 3);
      expect(e.score, 1); // yalnız w1 doğru
    });

    test('tümü doğru → score=total', () {
      var e = _engine();
      e = _match(e, 'w1', 'elma');
      e = _match(e, 'w2', 'kitap');
      e = _match(e, 'w3', 'su');
      expect(e.score, 3);
    });

    test('çeldiriciye eşleştirme skorda yanlış sayılır', () {
      var e = _match(_engine(), 'w1', 'yolculuk');
      expect(e.matched, 1);
      expect(e.score, 0);
    });
  });

  group('seçim davranışı', () {
    test('yeni terim seçimi öncekini sıfırlar (tek seçim)', () {
      var e = _engine();
      e = e.selectTerm(_termIndex(e, 'w1'));
      e = e.selectTerm(_termIndex(e, 'w2'));
      expect(e.selectedTermWordId, 'w2');
      expect(e.terms[_termIndex(e, 'w1')].status, TermCardStatus.neutral);
      expect(e.terms[_termIndex(e, 'w2')].status, TermCardStatus.selected);
    });
  });

  group('resultItems (F7.5) — kelime-bazlı döküm', () {
    test('her terim için item; doğru/yanlış/boş türetilir', () {
      var e = _engine();
      // w1 doğru, w2 yanlış (su çeldirici değil ama w3 cevabı), w3 boş.
      e = _match(e, 'w1', 'elma'); // doğru
      e = _match(e, 'w2', 'su'); // yanlış (kitap olmalıydı)

      final items = e.resultItems();
      expect(items.length, 3);

      final apple = items.firstWhere((i) => i.term == 'apple');
      expect(apple.ordinal, _termIndex(e, 'w1'));
      expect(apple.expectedAnswer, 'elma');
      expect(apple.studentAnswer, 'elma');
      expect(apple.isCorrect, isTrue);

      final book = items.firstWhere((i) => i.term == 'book');
      expect(book.expectedAnswer, 'kitap');
      expect(book.studentAnswer, 'su');
      expect(book.isCorrect, isFalse);

      final water = items.firstWhere((i) => i.term == 'water');
      expect(water.expectedAnswer, 'su');
      expect(water.studentAnswer, isNull); // eşleştirilmedi
      expect(water.isCorrect, isFalse);
    });
  });
}
