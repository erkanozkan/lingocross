import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_cross_app/features/lessons/data/dtos/word_dtos.dart';
import 'package:lingo_cross_app/features/lessons/domain/word_source.dart';

void main() {
  group('WordSource eşlemesi (API int 1/2)', () {
    test('manual=1, ocr=2', () {
      expect(WordSource.manual.value, 1);
      expect(WordSource.ocr.value, 2);
      expect(WordSource.fromValue(1), WordSource.manual);
      expect(WordSource.fromValue(2), WordSource.ocr);
    });
  });

  group('AddWordRequest JSON (API sözleşmesi)', () {
    test('source int olarak, translations isPrimary ile serileşir', () {
      const request = AddWordRequest(
        term: 'environment',
        source: WordSource.manual,
        translations: [
          TranslationPayload(text: 'çevre', isPrimary: true),
          TranslationPayload(text: 'ortam', isPrimary: false),
        ],
        synonyms: ['doğa'],
      );

      final json = request.toJson();

      expect(json['term'], 'environment');
      expect(json['source'], 1); // Manual = 1 (string değil)
      expect(json['translations'], [
        {'text': 'çevre', 'isPrimary': true},
        {'text': 'ortam', 'isPrimary': false},
      ]);
      expect(json['synonyms'], ['doğa']);
    });

    test('source null ise null yazılır (opsiyonel)', () {
      const request = AddWordRequest(
        term: 'apple',
        translations: [TranslationPayload(text: 'elma', isPrimary: true)],
      );
      final json = request.toJson();
      expect(json['source'], isNull);
    });
  });

  group('WordDto JSON çözme (API yanıtı)', () {
    test('source int → enum, translations/synonyms parse edilir', () {
      final dto = WordDto.fromJson({
        'id': 'w1',
        'lessonId': 'l1',
        'term': 'book',
        'sortOrder': 0,
        'source': 2, // Ocr
        'translations': [
          {'id': 't1', 'text': 'kitap', 'isPrimary': true},
        ],
        'synonyms': [
          {'id': 's1', 'text': 'eser'},
        ],
        'createdAt': '2026-06-23T10:00:00Z',
        'updatedAt': '2026-06-23T10:00:00Z',
      });

      expect(dto.source, WordSource.ocr);
      expect(dto.translations.single.isPrimary, true);
      expect(dto.translations.single.text, 'kitap');
      expect(dto.synonyms.single.text, 'eser');
    });
  });
}
