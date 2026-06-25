import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_cross_app/features/games/data/dtos/game_dtos.dart';
import 'package:lingo_cross_app/features/games/domain/scrambled_engine.dart';

ScrambledContent _content() => const ScrambledContent(
      items: [
        ScrambledItem(
          wordId: 'w1',
          answer: 'apple',
          scrambledLetters: 'ppale',
          clue: 'elma',
        ),
        ScrambledItem(
          wordId: 'w2',
          answer: 'book',
          scrambledLetters: 'okbo',
          clue: 'kitap',
        ),
      ],
    );

ScrambledEngine _engine() => ScrambledEngine.fromContent(_content());

/// Aktif kartta verilen [word]'ü harf-harf havuzdan seçerek diz (ilk eşleşen
/// kullanılmamış indeks). Büyük/küçük harf duyarsız.
ScrambledEngine _build(ScrambledEngine e, String word) {
  for (final ch in word.split('')) {
    final card = e.activeCard!;
    final idx = [
      for (var i = 0; i < card.scrambledLetters.length; i++) i,
    ].firstWhere(
      (i) =>
          !card.isLetterUsed(i) &&
          card.scrambledLetters[i].toLowerCase() == ch.toLowerCase(),
      orElse: () => -1,
    );
    if (idx >= 0) e = e.placeLetter(idx);
  }
  return e;
}

void main() {
  group('ScrambledEngine kurulum', () {
    test('kartlar içerikten kurulur, harf havuzu split edilir', () {
      final e = _engine();
      expect(e.total, 2);
      expect(e.activeIndex, 0);
      expect(e.activeCard!.term, 'apple');
      expect(e.activeCard!.clue, 'elma');
      expect(e.activeCard!.scrambledLetters, ['p', 'p', 'a', 'l', 'e']);
      expect(e.activeCard!.built, isEmpty);
      expect(e.filledCount, 0);
      expect(e.correctCount, 0);
      expect(e.progress, 0);
    });
  });

  group('tap-to-build: placeLetter / removeAt', () {
    test('placeLetter cevaba ekler, kullanılan indeks tekrar seçilemez', () {
      var e = _engine();
      e = e.placeLetter(0); // 'p'
      expect(e.activeCard!.built, [0]);
      expect(e.activeCard!.builtJoined, 'p');
      expect(e.activeCard!.isLetterUsed(0), isTrue);
      // Aynı indeks tekrar → no-op.
      final e2 = e.placeLetter(0);
      expect(e2.activeCard!.built, [0]);
    });

    test('cevap dolunca placeLetter no-op', () {
      var e = _engine();
      // 5 harf yerleştir.
      for (var i = 0; i < 5; i++) {
        e = e.placeLetter(i);
      }
      expect(e.activeCard!.isFilled, isTrue);
      expect(e.activeCard!.built.length, 5);
      // Hepsi dolu — başka indeks zaten yok ama dolu kontrolü de korur.
      expect(e.placeLetter(0).activeCard!.built.length, 5);
    });

    test('removeAt yuvadan geri alır (havuza döner)', () {
      var e = _engine();
      e = e.placeLetter(0); // p
      e = e.placeLetter(2); // a
      expect(e.activeCard!.builtJoined, 'pa');
      e = e.removeAt(0); // ilk yuvadaki 'p' geri alınır
      expect(e.activeCard!.builtJoined, 'a');
      expect(e.activeCard!.isLetterUsed(0), isFalse);
      expect(e.activeCard!.isLetterUsed(2), isTrue);
    });

    test('geçersiz removeAt konumu → no-op', () {
      final e = _engine();
      expect(e.removeAt(0).activeCard!.built, isEmpty);
      expect(e.removeAt(-1).activeCard!.built, isEmpty);
    });
  });

  group('selectWord (kart geçişi)', () {
    test('aktif kart değişir, her kartın built bağımsız', () {
      var e = _engine();
      e = _build(e, 'apple'); // w1 dolu
      e = e.selectWord(1);
      expect(e.activeIndex, 1);
      expect(e.activeCard!.term, 'book');
      expect(e.activeCard!.built, isEmpty);
      // İlk karta dön — built korunmuş.
      e = e.selectWord(0);
      expect(e.activeCard!.builtJoined, 'apple');
    });

    test('geçersiz indeks veya aynı indeks → no-op', () {
      final e = _engine();
      expect(e.selectWord(5).activeIndex, 0);
      expect(e.selectWord(0).activeIndex, 0);
    });
  });

  group('correctCount (büyük/küçük harf duyarsız, yalnız "Bitir"de)', () {
    test('doğru diziliş → doğru, yanlış diziliş → yanlış', () {
      var e = _engine();
      e = _build(e, 'apple'); // doğru
      e = e.selectWord(1);
      e = _build(e, 'kobo'); // 'book' değil → yanlış (mevcut harflerle)
      expect(e.correctCount, 1);
      expect(e.filledCount, 2); // ikisi de dolu
    });

    test('case-insensitive: APPLE girişi apple terimine doğru sayılır', () {
      final content = const ScrambledContent(items: [
        ScrambledItem(
          wordId: 'w1',
          answer: 'Apple',
          scrambledLetters: 'APPLE',
          clue: 'elma',
        ),
      ]);
      var e = ScrambledEngine.fromContent(content);
      // Havuz büyük harf 'APPLE'; doğru sırada dizilirse "APPLE" == "Apple"
      // (case-insensitive) → doğru.
      e = e.placeLetter(0); // A
      e = e.placeLetter(1); // P
      e = e.placeLetter(2); // P
      e = e.placeLetter(3); // L
      e = e.placeLetter(4); // E
      expect(e.activeCard!.builtJoined, 'APPLE');
      expect(e.correctCount, 1);
    });

    test('boş cevap correctCount\'a dahil değil', () {
      final e = _engine();
      expect(e.correctCount, 0);
    });
  });

  group('resultItems (F7.5)', () {
    test('her kelime için item; doğru/yanlış/boş türetilir', () {
      var e = _engine();
      e = _build(e, 'apple'); // w1 doğru
      // w2 boş bırakılır.
      final items = e.resultItems();
      expect(items.length, 2);

      final apple = items[0];
      expect(apple.ordinal, 0);
      expect(apple.term, 'apple');
      expect(apple.expectedAnswer, 'apple');
      expect(apple.studentAnswer, 'apple');
      expect(apple.isCorrect, isTrue);

      final book = items[1];
      expect(book.ordinal, 1);
      expect(book.term, 'book');
      expect(book.expectedAnswer, 'book');
      expect(book.studentAnswer, isNull); // hiç harf yerleştirilmedi
      expect(book.isCorrect, isFalse);
    });
  });
}
