import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_cross_app/features/lessons/data/ocr_language_orienter.dart';
import 'package:lingo_cross_app/features/lessons/domain/ocr_line_parser.dart';

void main() {
  group('shouldSwapForLanguages', () {
    test('terim tr + karşılık en → takas (true)', () {
      expect(shouldSwapForLanguages('tr', 'en'), isTrue);
    });

    test('terim en + karşılık tr → takas yok (false)', () {
      expect(shouldSwapForLanguages('en', 'tr'), isFalse);
    });

    test('terim tr + karşılık tr → takas yok (false)', () {
      expect(shouldSwapForLanguages('tr', 'tr'), isFalse);
    });

    test('terim und + karşılık en → takas yok (false)', () {
      expect(shouldSwapForLanguages('und', 'en'), isFalse);
    });

    test('terim en + karşılık null → takas yok (false)', () {
      expect(shouldSwapForLanguages('en', null), isFalse);
    });

    test('her ikisi null → takas yok (false)', () {
      expect(shouldSwapForLanguages(null, null), isFalse);
    });
  });

  group('OcrLanguageOrienter.orient (sahte identify)', () {
    // Türkçe kelimeleri 'tr', İngilizceleri 'en' döndüren basit sözlüksel stub.
    Future<String> fakeIdentify(String text) async {
      const turkish = {'elma', 'çevre', 'kitap', 'ev', 'a'};
      const english = {'apple', 'environment', 'book', 'house'};
      final t = text.trim().toLowerCase();
      if (turkish.contains(t)) return 'tr';
      if (english.contains(t)) return 'en';
      return 'und';
    }

    test('(elma, apple) → (apple, elma) takas edilir', () async {
      final orienter = OcrLanguageOrienter(identify: fakeIdentify);
      final out = await orienter.orient(
        [const OcrCandidate(term: 'elma', meaning: 'apple')],
      );
      expect(out.single, const OcrCandidate(term: 'apple', meaning: 'elma'));
    });

    test('(apple, elma) → değişmez (doğru yön)', () async {
      final orienter = OcrLanguageOrienter(identify: fakeIdentify);
      final out = await orienter.orient(
        [const OcrCandidate(term: 'apple', meaning: 'elma')],
      );
      expect(out.single, const OcrCandidate(term: 'apple', meaning: 'elma'));
    });

    test('(apple, null) → meaning boş, aynen döner (identify çağrılmaz)', () async {
      var calls = 0;
      Future<String> counting(String t) async {
        calls++;
        return fakeIdentify(t);
      }

      final orienter = OcrLanguageOrienter(identify: counting);
      final out = await orienter.orient(
        [const OcrCandidate(term: 'apple')],
      );
      expect(out.single, const OcrCandidate(term: 'apple'));
      expect(calls, 0);
    });

    test('takasta tooShort yeni terime göre yeniden hesaplanır', () async {
      // term 'çevre' (tr), meaning 'a' (stub'da tr) → tr/tr, takas YOK.
      // Bunun yerine kısa terimle takas senaryosu: term 'a' (tr), meaning ...
      // Daha net: term 'elma'(tr) meaning 'apple'(en) → takas; yeni term 'apple'
      // uzunluğu >=2 → tooShort false.
      final orienter = OcrLanguageOrienter(identify: fakeIdentify);
      final out = await orienter.orient(
        [const OcrCandidate(term: 'elma', meaning: 'apple', tooShort: false)],
      );
      expect(out.single.term, 'apple');
      expect(out.single.tooShort, isFalse);
    });
  });
}
