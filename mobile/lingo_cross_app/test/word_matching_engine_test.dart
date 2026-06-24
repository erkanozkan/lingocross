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

void main() {
  group('WordMatchingEngine kurulum', () {
    test('sol sütun terimleri, sağ sütun çeviri + çeldirici içerir', () {
      final e = _engine();
      expect(e.terms.length, 3);
      // 3 doğru çeviri + 2 çeldirici = 5 karşılık.
      expect(e.translations.length, 5);
      expect(e.total, 3);
      expect(e.matched, 0);
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

  group('doğru eşleşme', () {
    test('terim seç → doğru karşılık → matched + ilerleme +1', () {
      var e = _engine();
      e = e.selectTerm(_termIndex(e, 'w1'));
      expect(e.selectedWordId, 'w1');

      final idx = _translationIndex(e, 'elma');
      expect(e.evaluateTranslation(idx), MatchOutcome.correct);

      e = e.applyCorrect(idx);
      expect(e.matched, 1);
      expect(e.selectedWordId, isNull);
      expect(e.terms[_termIndex(e, 'w1')].status, TermCardStatus.matched);
      expect(e.translations[idx].status, TranslationCardStatus.matched);
      expect(e.progress, closeTo(1 / 3, 1e-9));
    });

    test('tüm çiftler eşleşince isComplete=true', () {
      var e = _engine();
      for (final id in ['w1', 'w2', 'w3']) {
        e = e.selectTerm(_termIndex(e, id));
        final correct = e.translations
            .indexWhere((t) => t.matchWordId == id);
        expect(e.evaluateTranslation(correct), MatchOutcome.correct);
        e = e.applyCorrect(correct);
      }
      expect(e.matched, 3);
      expect(e.isComplete, isTrue);
      expect(e.progress, 1.0);
    });
  });

  group('yanlış eşleşme', () {
    test('farklı terimin çevirisi → wrong, ilerleme artmaz', () {
      var e = _engine();
      e = e.selectTerm(_termIndex(e, 'w1')); // apple
      final wrongIdx = _translationIndex(e, 'kitap'); // w2'nin çevirisi
      expect(e.evaluateTranslation(wrongIdx), MatchOutcome.wrong);

      e = e.markWrong(wrongIdx);
      expect(e.translations[wrongIdx].status, TranslationCardStatus.wrong);

      e = e.resetSelection();
      expect(e.selectedWordId, isNull);
      expect(e.matched, 0);
      expect(e.translations[wrongIdx].status, TranslationCardStatus.neutral);
    });

    test('çeldirici seçimi → wrong (hiçbir terimle eşleşmez)', () {
      var e = _engine();
      e = e.selectTerm(_termIndex(e, 'w1'));
      final distractorIdx = _translationIndex(e, 'yolculuk');
      expect(e.evaluateTranslation(distractorIdx), MatchOutcome.wrong);
    });

    test('terim seçilmeden karşılık dokunuşu → none (no-op)', () {
      final e = _engine();
      expect(e.evaluateTranslation(0), MatchOutcome.none);
    });

    test('yanlış deneme doğru eşleşmiş kartları bozmaz', () {
      var e = _engine();
      // Önce w1'i doğru eşleştir.
      e = e.selectTerm(_termIndex(e, 'w1'));
      e = e.applyCorrect(_translationIndex(e, 'elma'));
      final matchedIdx = _translationIndex(e, 'elma');

      // Sonra w2 için yanlış dene.
      e = e.selectTerm(_termIndex(e, 'w2'));
      e = e.markWrong(_translationIndex(e, 'su'));
      e = e.resetSelection();

      expect(e.matched, 1);
      expect(e.translations[matchedIdx].status, TranslationCardStatus.matched);
      expect(e.terms[_termIndex(e, 'w1')].status, TermCardStatus.matched);
    });
  });

  group('seçim davranışı', () {
    test('yeni terim seçimi öncekini sıfırlar (tek seçim)', () {
      var e = _engine();
      e = e.selectTerm(_termIndex(e, 'w1'));
      e = e.selectTerm(_termIndex(e, 'w2'));
      expect(e.selectedWordId, 'w2');
      expect(e.terms[_termIndex(e, 'w1')].status, TermCardStatus.neutral);
      expect(e.terms[_termIndex(e, 'w2')].status, TermCardStatus.selected);
    });
  });
}
