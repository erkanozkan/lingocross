import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_cross_app/features/games/data/dtos/game_dtos.dart';
import 'package:lingo_cross_app/features/games/domain/crossword_engine.dart';
import 'package:lingo_cross_app/features/games/domain/game_type.dart';

/// Test bulmacası: kesişen iki kelime, ortak başlangıç hücresi (0,0)="C".
/// across 1: "CAT"  → (0,0)(0,1)(0,2)
/// down   2: "COW"  → (0,0)(1,0)(2,0)
const _content = CrosswordContent(
  rows: 3,
  cols: 3,
  entries: [
    CrosswordEntry(
      number: 1,
      answer: 'CAT',
      clue: 'kedi',
      row: 0,
      col: 0,
      direction: CrosswordDirection.across,
      length: 3,
    ),
    CrosswordEntry(
      number: 2,
      answer: 'COW',
      clue: 'inek',
      row: 0,
      col: 0,
      direction: CrosswordDirection.down,
      length: 3,
    ),
  ],
);

void main() {
  group('ızgara kurulumu', () {
    test('doldurulabilir ve blok hücreler doğru işaretlenir', () {
      final e = CrosswordEngine.fromContent(_content);

      // across CAT (satır 0) + down COW (sütun 0) dışındaki hücreler blok.
      expect(e.cellAt(0, 0).isFillable, isTrue);
      expect(e.cellAt(0, 1).isFillable, isTrue);
      expect(e.cellAt(0, 2).isFillable, isTrue);
      expect(e.cellAt(1, 0).isFillable, isTrue);
      expect(e.cellAt(2, 0).isFillable, isTrue);
      // (1,1) hiçbir kelimeye ait değil → blok.
      expect(e.cellAt(1, 1).isBlock, isTrue);
      expect(e.cellAt(2, 2).isBlock, isTrue);
    });

    test('başlangıç hücresi her iki kelimenin numarasını da içerebilir', () {
      final e = CrosswordEngine.fromContent(_content);
      // (0,0)'dan iki kelime başlar; köşe numarası son yazılan (down=2).
      // Önemli olan numara dolu ve hücrenin iki eksende de girişi var.
      expect(e.cellAt(0, 0).number, isNotNull);
      expect(e.cellAt(0, 0).acrossEntryIndex, 0);
      expect(e.cellAt(0, 0).downEntryIndex, 1);
    });

    test('kesişen hücrede çözüm harfi tutarlı', () {
      final e = CrosswordEngine.fromContent(_content);
      expect(e.cellAt(0, 0).solution, 'C');
      expect(e.cellAt(0, 1).solution, 'A');
      expect(e.cellAt(1, 0).solution, 'O');
    });

    test('across/down indeksleri numara sırasında', () {
      final e = CrosswordEngine.fromContent(_content);
      expect(e.acrossIndices, [0]);
      expect(e.downIndices, [1]);
    });
  });

  group('seçim ve yön', () {
    test('blok hücre seçilemez (no-op)', () {
      final e = CrosswordEngine.fromContent(_content).selectCell(1, 1);
      expect(e.hasSelection, isFalse);
    });

    test('kesişen hücreye tekrar dokunuş yönü değiştirir', () {
      var e = CrosswordEngine.fromContent(_content).selectCell(0, 0);
      expect(e.axis, CrosswordAxis.across);
      e = e.selectCell(0, 0);
      expect(e.axis, CrosswordAxis.down);
      e = e.selectCell(0, 0);
      expect(e.axis, CrosswordAxis.across);
    });

    test('ipucuna odak başlangıç hücresini + yönü ayarlar', () {
      final e = CrosswordEngine.fromContent(_content).focusEntry(1);
      expect(e.activeRow, 0);
      expect(e.activeCol, 0);
      expect(e.axis, CrosswordAxis.down);
      expect(e.activeEntryIndex, 1);
    });
  });

  group('harf gir / sil', () {
    test('harf girince imleç sonraki hücreye taşınır (büyük harfe normalize)', () {
      var e = CrosswordEngine.fromContent(_content).focusEntry(0); // across CAT
      e = e.enterLetter('c');
      expect(e.letterAt(0, 0), 'C');
      // İmleç sonraki across hücreye (0,1).
      expect(e.activeRow, 0);
      expect(e.activeCol, 1);
    });

    test('kelime sonunda imleç ilerlemez', () {
      var e = CrosswordEngine.fromContent(_content).focusEntry(0);
      e = e.enterLetter('C').enterLetter('A').enterLetter('T');
      expect(e.letterAt(0, 2), 'T');
      expect(e.activeCol, 2); // son hücrede kalır
    });

    test('sil: dolu hücreyi temizler; boşsa öncekine geçip temizler', () {
      var e = CrosswordEngine.fromContent(_content).focusEntry(0);
      e = e.enterLetter('C').enterLetter('A'); // imleç (0,2)'de
      // (0,2) boş → sil önceki (0,1)'e geçip onu temizler.
      e = e.deleteLetter();
      expect(e.letterAt(0, 1), '');
      expect(e.activeCol, 1);
      // (0,1) artık boş ve aktif → tekrar sil (0,0)'a geçip temizler.
      e = e.deleteLetter();
      expect(e.letterAt(0, 0), '');
      expect(e.activeCol, 0);
    });

    test('kesişen hücreye girilen harf iki kelimede paylaşılır', () {
      var e = CrosswordEngine.fromContent(_content).focusEntry(1); // down COW
      e = e.enterLetter('C'); // (0,0)
      // Aynı hücre across kelimenin de ilk harfi.
      expect(e.letterAt(0, 0), 'C');
    });
  });

  group('doğruluk ve skor', () {
    test('eksik kelime incomplete', () {
      var e = CrosswordEngine.fromContent(_content).focusEntry(0);
      e = e.enterLetter('C');
      expect(e.statusOf(0), EntryStatus.incomplete);
    });

    test('yanlış dolu kelime wrong', () {
      var e = CrosswordEngine.fromContent(_content).focusEntry(0);
      e = e.enterLetter('C').enterLetter('X').enterLetter('T');
      expect(e.statusOf(0), EntryStatus.wrong);
    });

    test('doğru kelime correct + skor sayımı', () {
      var e = CrosswordEngine.fromContent(_content).focusEntry(0); // CAT
      e = e.enterLetter('C').enterLetter('A').enterLetter('T');
      expect(e.statusOf(0), EntryStatus.correct);
      expect(e.correctCount, 1);
      expect(e.totalCount, 2);
      expect(e.isComplete, isFalse);
    });

    test('tüm kelimeler doğru → isComplete + progress=1', () {
      var e = CrosswordEngine.fromContent(_content);
      // CAT: (0,0)C (0,1)A (0,2)T ; COW: (0,0)C (1,0)O (2,0)W
      e = e.focusEntry(0).enterLetter('C').enterLetter('A').enterLetter('T');
      e = e.focusEntry(1).enterLetter('C').enterLetter('O').enterLetter('W');
      expect(e.correctCount, 2);
      expect(e.isComplete, isTrue);
      expect(e.progress, 1.0);
      expect(e.allCellsFilled, isTrue);
    });

    test('allCellsFilled yanlış harflerle de true olabilir', () {
      var e = CrosswordEngine.fromContent(_content);
      e = e.focusEntry(0).enterLetter('X').enterLetter('X').enterLetter('X');
      e = e.focusEntry(1).enterLetter('X').enterLetter('X').enterLetter('X');
      expect(e.allCellsFilled, isTrue);
      expect(e.isComplete, isFalse);
      expect(e.correctCount, 0);
    });
  });

  group('resultItems (F7.5) — kelime-bazlı döküm', () {
    test('term=ipucu, doğru/yanlış/boş türetilir', () {
      // across CAT doğru doldurulur; down COW boş bırakılır (yalnız C ortak).
      var e = CrosswordEngine.fromContent(_content).focusEntry(0); // across
      e = e.enterLetter('C').enterLetter('A').enterLetter('T');

      final items = e.resultItems();
      expect(items.length, 2);

      final across = items[0];
      expect(across.ordinal, 0);
      expect(across.term, 'kedi'); // ipucu
      expect(across.expectedAnswer, 'CAT');
      expect(across.studentAnswer, 'CAT');
      expect(across.isCorrect, isTrue);

      final down = items[1];
      expect(down.ordinal, 1);
      expect(down.term, 'inek');
      expect(down.expectedAnswer, 'COW');
      // down sadece kesişen 'C' dolu; studentAnswer = 'C' (boş değil) ama yanlış.
      expect(down.studentAnswer, 'C');
      expect(down.isCorrect, isFalse);
    });

    test('hiç harf girilmemiş kelimede studentAnswer null', () {
      final e = CrosswordEngine.fromContent(_content);
      final items = e.resultItems();
      expect(items.every((i) => i.studentAnswer == null), isTrue);
      expect(items.every((i) => i.isCorrect == false), isTrue);
    });
  });
}
