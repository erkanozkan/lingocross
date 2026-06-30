import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_cross_app/features/games/domain/game_type.dart';
import 'package:lingo_cross_app/features/results/data/dtos/result_dtos.dart';

void main() {
  group('GameResultDto', () {
    test('JSON parse (API sözleşmesi — int gameType + ISO tarih)', () {
      final dto = GameResultDto.fromJson(<String, dynamic>{
        'id': 'r1',
        'sessionId': 's1',
        'gameId': 'g1',
        'gameType': 1, // WordMatching
        'lessonId': 'l1',
        'lessonTitle': 'Ünite 3',
        'durationMs': 252000,
        'totalItems': 20,
        'correctItems': 17,
        'score': 85,
        'sharedWithTeacher': false,
        'sharedAt': null,
        'createdAt': '2026-06-23T08:00:00Z',
      });

      expect(dto.gameType, GameType.wordMatching);
      expect(dto.score, 85);
      expect(dto.sharedWithTeacher, isFalse);
    });

    // REGRESYON: QuestionSet (çıkmış sorular) sonucunda backend lessonId:null +
    // lessonTitle=konu başlığı döner. lessonId zorunlu olsaydı parse patlar,
    // "Bitir"de hata verir ve oturum tamamlandığı için tekrar açılışta 409 olurdu.
    test('QuestionSet sonucu: lessonId null parse edilir', () {
      final dto = GameResultDto.fromJson(<String, dynamic>{
        'id': 'r9',
        'sessionId': 's9',
        'gameId': 'g9',
        'gameType': 3, // QuestionSet
        'lessonId': null,
        'lessonTitle': 'YDS Deneme Soruları',
        'durationMs': 120000,
        'totalItems': 10,
        'correctItems': 7,
        'score': 70,
        'sharedWithTeacher': false,
        'sharedAt': null,
        'createdAt': '2026-06-29T20:00:00Z',
      });

      expect(dto.gameType, GameType.questionSet);
      expect(dto.lessonId, isNull);
      expect(dto.lessonTitle, 'YDS Deneme Soruları');
      expect(dto.score, 70);
    });

    test('accuracyPercent skoru 0–100 aralığına sıkıştırır', () {
      expect(_result(score: 85).accuracyPercent, 85);
      expect(_result(score: 140).accuracyPercent, 100);
      expect(_result(score: -5).accuracyPercent, 0);
    });

    test('formattedDuration ms → MM:SS', () {
      expect(_result(durationMs: 252000).formattedDuration, '04:12');
      expect(_result(durationMs: 0).formattedDuration, '00:00');
      expect(_result(durationMs: 65000).formattedDuration, '01:05');
      // En yakın saniyeye yuvarlar.
      expect(_result(durationMs: 89600).formattedDuration, '01:30');
    });
  });

  test('SubmitResultRequest toJson alan adları API ile uyumlu', () {
    const req = SubmitResultRequest(
      durationMs: 1000,
      totalItems: 20,
      correctItems: 17,
    );
    expect(req.toJson(), {
      'durationMs': 1000,
      'totalItems': 20,
      'correctItems': 17,
    });
  });

  test('SubmitResultRequest items null iken JSON gövdesine yazılmaz', () {
    const req = SubmitResultRequest(
      durationMs: 1000,
      totalItems: 3,
      correctItems: 2,
    );
    expect(req.toJson().containsKey('items'), isFalse);
  });

  test('SubmitResultItem (F7.5) camelCase JSON; null studentAnswer korunur', () {
    const item = SubmitResultItem(
      ordinal: 0,
      term: 'apple',
      expectedAnswer: 'elma',
      studentAnswer: null,
      isCorrect: false,
    );
    expect(item.toJson(), {
      'ordinal': 0,
      'term': 'apple',
      'expectedAnswer': 'elma',
      'studentAnswer': null,
      'isCorrect': false,
    });
  });

  test('SubmitResultRequest items doluysa gövdeye eklenir', () {
    const req = SubmitResultRequest(
      durationMs: 1000,
      totalItems: 1,
      correctItems: 1,
      items: [
        SubmitResultItem(
          ordinal: 0,
          term: 'bread',
          expectedAnswer: 'ekmek',
          studentAnswer: 'ekmek',
          isCorrect: true,
        ),
      ],
    );
    final json = req.toJson();
    expect(json['items'], isA<List<dynamic>>());
    expect((json['items'] as List).length, 1);
  });

  group('GameResultDetailDto (GET /api/results/{id})', () {
    test('JSON parse — items dahil, studentAnswer null korunur', () {
      final dto = GameResultDetailDto.fromJson(<String, dynamic>{
        'id': 'r1',
        'gameId': 'g1',
        'gameType': 1, // WordMatching
        'lessonId': 'l1',
        'lessonTitle': 'Ünite 3',
        'durationMs': 252000,
        'totalItems': 3,
        'correctItems': 2,
        'score': 85,
        'sharedWithTeacher': true,
        'sharedAt': '2026-06-23T09:00:00Z',
        'createdAt': '2026-06-23T08:00:00Z',
        'items': [
          {
            'ordinal': 0,
            'term': 'apple',
            'expectedAnswer': 'elma',
            'studentAnswer': 'elma',
            'isCorrect': true,
          },
          {
            'ordinal': 1,
            'term': 'water',
            'expectedAnswer': 'su',
            'studentAnswer': null,
            'isCorrect': false,
          },
        ],
      });

      expect(dto.gameType, GameType.wordMatching);
      expect(dto.score, 85);
      expect(dto.hasItems, isTrue);
      expect(dto.items.length, 2);
      expect(dto.items[0].isCorrect, isTrue);
      expect(dto.items[1].studentAnswer, isNull);
      expect(dto.items[1].isCorrect, isFalse);
    });

    test('round-trip — fromJson → toJson alanları korur (studentAnswer null)', () {
      final source = <String, dynamic>{
        'id': 'r1',
        'gameId': 'g1',
        'gameType': 1,
        'lessonId': null,
        'lessonTitle': 'YDS',
        'durationMs': 120000,
        'totalItems': 1,
        'correctItems': 0,
        'score': 0,
        'sharedWithTeacher': false,
        'sharedAt': null,
        'createdAt': '2026-06-23T08:00:00Z',
        'items': [
          {
            'ordinal': 0,
            'term': 'pen',
            'expectedAnswer': 'kalem',
            'studentAnswer': null,
            'isCorrect': false,
          },
        ],
      };
      final json = GameResultDetailDto.fromJson(source).toJson();
      expect(json['lessonId'], isNull);
      expect((json['items'] as List).length, 1);
      final item = (json['items'] as List).first as Map<String, dynamic>;
      expect(item['studentAnswer'], isNull);
      expect(item['isCorrect'], isFalse);
    });

    test('items eksikse boş liste (eski sonuç) → hasItems false', () {
      final dto = GameResultDetailDto.fromJson(<String, dynamic>{
        'id': 'r1',
        'gameId': 'g1',
        'gameType': 1,
        'lessonId': 'l1',
        'lessonTitle': 'Ünite 3',
        'durationMs': 252000,
        'totalItems': 20,
        'correctItems': 17,
        'score': 85,
        'sharedWithTeacher': true,
        'sharedAt': null,
        'createdAt': '2026-06-23T08:00:00Z',
      });
      expect(dto.items, isEmpty);
      expect(dto.hasItems, isFalse);
    });
  });
}

GameResultDto _result({int score = 85, int durationMs = 1000}) => GameResultDto(
      id: 'r1',
      sessionId: 's1',
      gameId: 'g1',
      gameType: GameType.wordMatching,
      lessonId: 'l1',
      lessonTitle: 'Ünite 3',
      durationMs: durationMs,
      totalItems: 20,
      correctItems: 17,
      score: score,
      sharedWithTeacher: false,
      createdAt: DateTime(2026, 6, 23),
    );
