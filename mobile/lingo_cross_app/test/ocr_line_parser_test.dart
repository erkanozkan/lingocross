import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_cross_app/features/lessons/domain/ocr_line_parser.dart';

void main() {
  group('parseOcrLines', () {
    test('boş ve yalnız-boşluk satırları eler', () {
      final result = parseOcrLines(['', '   ', '\t', 'environment']);
      expect(result, [const OcrCandidate(term: 'environment')]);
    });

    test('baş/son boşlukları kırpar', () {
      final result = parseOcrLines(['  apple  ']);
      expect(result.single.term, 'apple');
    });

    test('çok kısa (< 2 karakter) satırı tooShort işaretler ama silmez', () {
      final result = parseOcrLines(['a', 'go']);
      expect(result.length, 2);
      expect(result[0].term, 'a');
      expect(result[0].tooShort, isTrue);
      expect(result[1].term, 'go');
      expect(result[1].tooShort, isFalse);
    });

    test('"terim - karşılık" formatını ayraçla böler', () {
      final result = parseOcrLines([
        'environment - çevre',
        'apple : elma',
        'book = kitap',
        'house\tev',
      ]);
      expect(result[0], const OcrCandidate(term: 'environment', meaning: 'çevre'));
      expect(result[1], const OcrCandidate(term: 'apple', meaning: 'elma'));
      expect(result[2], const OcrCandidate(term: 'book', meaning: 'kitap'));
      expect(result[3], const OcrCandidate(term: 'house', meaning: 'ev'));
    });

    test('ayraç yoksa yalnız terim doldurulur, karşılık null', () {
      final result = parseOcrLines(['environment']);
      expect(result.single.term, 'environment');
      expect(result.single.meaning, isNull);
    });

    test('yalnız ilk ayraçta böler (karşılıkta ayraç kalabilir)', () {
      final result = parseOcrLines(['well-being - sağlık']);
      // İlk ayraç "well" ile "being..." arasındadır.
      expect(result.single.term, 'well');
      expect(result.single.meaning, 'being - sağlık');
    });

    test('satır içi \\n karakterini ayrı adaylara böler', () {
      final result = parseOcrLines(['apple\nbanana']);
      expect(result.map((c) => c.term), ['apple', 'banana']);
    });

    test('ayraç başta ise terim olarak kabul edilir (boş terim üretmez)', () {
      final result = parseOcrLines(['- çevre']);
      expect(result.single.term, '- çevre');
      expect(result.single.meaning, isNull);
    });

    test('ayraçtan sonra karşılık boşsa null kalır', () {
      final result = parseOcrLines(['environment -']);
      expect(result.single.term, 'environment');
      expect(result.single.meaning, isNull);
    });
  });
}
