import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_cross_app/features/games/data/dtos/game_dtos.dart';
import 'package:lingo_cross_app/features/games/domain/question_set_engine.dart';

QuestionSetContent _content() => const QuestionSetContent(
      questions: [
        QuestionItem(
          questionId: 'q1',
          stem: 'Soru 1?',
          choices: [
            QuestionChoice(optionId: 'q1a', label: 'A', text: 'A1'),
            QuestionChoice(optionId: 'q1b', label: 'B', text: 'B1'),
            QuestionChoice(optionId: 'q1c', label: 'C', text: 'C1'),
          ],
          correctOptionId: 'q1b',
          explanation: 'Çünkü B doğru.',
        ),
        QuestionItem(
          questionId: 'q2',
          stem: 'Soru 2?',
          choices: [
            QuestionChoice(optionId: 'q2a', label: 'A', text: 'A2'),
            QuestionChoice(optionId: 'q2b', label: 'B', text: 'B2'),
          ],
          correctOptionId: 'q2a',
        ),
      ],
    );

QuestionSetEngine _engine() => QuestionSetEngine.fromContent(_content());

void main() {
  group('QuestionSetEngine kurulum', () {
    test('kartlar içerikten kurulur, ilk soru aktif', () {
      final e = _engine();
      expect(e.total, 2);
      expect(e.activeIndex, 0);
      expect(e.activeCard!.questionId, 'q1');
      expect(e.activeCard!.stem, 'Soru 1?');
      expect(e.activeCard!.choices.length, 3);
      expect(e.activeCard!.selectedOptionId, isNull);
      expect(e.answeredCount, 0);
      expect(e.correctCount, 0);
      expect(e.progress, 0);
      expect(e.isFirst, isTrue);
      expect(e.isLast, isFalse);
    });
  });

  group('selectOption (tek seçim)', () {
    test('şık seçilir; tekrar seçim öncekinin yerini alır', () {
      var e = _engine();
      e = e.selectOption('q1a');
      expect(e.activeCard!.selectedOptionId, 'q1a');
      expect(e.activeCard!.isAnswered, isTrue);
      expect(e.answeredCount, 1);
      // Aynı kartta başka şık → tek seçim, öncekini değiştirir.
      e = e.selectOption('q1b');
      expect(e.activeCard!.selectedOptionId, 'q1b');
      expect(e.answeredCount, 1);
    });

    test('geçersiz şık (içerikte yok) → no-op', () {
      final e = _engine().selectOption('yok');
      expect(e.activeCard!.selectedOptionId, isNull);
      expect(e.answeredCount, 0);
    });
  });

  group('next / prev / selectQuestion', () {
    test('next sonraki soruya geçer, seçim bağımsız korunur', () {
      var e = _engine();
      e = e.selectOption('q1b'); // 1. soru cevaplandı
      e = e.next();
      expect(e.activeIndex, 1);
      expect(e.isLast, isTrue);
      expect(e.activeCard!.selectedOptionId, isNull);
      // İlk soruya dön — seçim korunmuş.
      e = e.prev();
      expect(e.activeIndex, 0);
      expect(e.activeCard!.selectedOptionId, 'q1b');
    });

    test('son soruda next, ilk soruda prev → no-op', () {
      final e = _engine();
      expect(e.prev().activeIndex, 0);
      expect(e.next().next().activeIndex, 1); // ikinci kez no-op
    });

    test('selectQuestion geçerli/geçersiz/aynı indeks', () {
      final e = _engine();
      expect(e.selectQuestion(1).activeIndex, 1);
      expect(e.selectQuestion(5).activeIndex, 0);
      expect(e.selectQuestion(0).activeIndex, 0);
    });
  });

  group('progress / answeredCount', () {
    test('cevaplanan soru oranı', () {
      var e = _engine();
      expect(e.progress, 0);
      e = e.selectOption('q1a');
      expect(e.answeredCount, 1);
      expect(e.progress, 0.5);
      e = e.next().selectOption('q2a');
      expect(e.answeredCount, 2);
      expect(e.progress, 1.0);
    });
  });

  group('correctCount (yalnız "Bitir"de, oyun sırasında gizli)', () {
    test('doğru seçim doğru, yanlış seçim yanlış, boş yanlış', () {
      var e = _engine();
      e = e.selectOption('q1b'); // doğru (q1b)
      e = e.next().selectOption('q2b'); // yanlış (doğru q2a)
      expect(e.correctCount, 1);
    });

    test('hiç cevap yoksa correctCount 0', () {
      expect(_engine().correctCount, 0);
    });
  });

  group('resultItems (F7.5)', () {
    test('her soru için item; term=stem, expected=doğru metin', () {
      var e = _engine();
      e = e.selectOption('q1b'); // doğru → text 'B1'
      // 2. soru boş bırakılır.
      final items = e.resultItems();
      expect(items.length, 2);

      final first = items[0];
      expect(first.ordinal, 0);
      expect(first.term, 'Soru 1?');
      expect(first.expectedAnswer, 'B1');
      expect(first.studentAnswer, 'B1');
      expect(first.isCorrect, isTrue);

      final second = items[1];
      expect(second.ordinal, 1);
      expect(second.term, 'Soru 2?');
      expect(second.expectedAnswer, 'A2');
      expect(second.studentAnswer, isNull); // seçim yok
      expect(second.isCorrect, isFalse);
    });

    test('yanlış seçim studentAnswer doldurur, isCorrect false', () {
      var e = _engine();
      e = e.next().selectOption('q2b'); // yanlış (doğru q2a)
      final items = e.resultItems();
      expect(items[1].studentAnswer, 'B2');
      expect(items[1].expectedAnswer, 'A2');
      expect(items[1].isCorrect, isFalse);
    });
  });
}
