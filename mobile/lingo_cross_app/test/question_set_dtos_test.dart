import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_cross_app/features/games/data/dtos/game_dtos.dart';
import 'package:lingo_cross_app/features/games/domain/game_type.dart';

void main() {
  group('QuestionSet DTO json round-trip (camelCase)', () {
    test('QuestionChoice / QuestionItem / QuestionSetContent', () {
      final json = {
        'questions': [
          {
            'questionId': 'q1',
            'stem': 'Hangisi doğru?',
            'choices': [
              {'optionId': 'q1a', 'label': 'A', 'text': 'Birinci'},
              {'optionId': 'q1b', 'label': 'B', 'text': 'İkinci'},
            ],
            'correctOptionId': 'q1b',
            'explanation': 'B doğru.',
          },
        ],
      };

      final content = QuestionSetContent.fromJson(json);
      expect(content.questions.length, 1);
      final q = content.questions.first;
      expect(q.questionId, 'q1');
      expect(q.stem, 'Hangisi doğru?');
      expect(q.choices.length, 2);
      expect(q.choices[0].optionId, 'q1a');
      expect(q.choices[0].label, 'A');
      expect(q.choices[1].text, 'İkinci');
      expect(q.correctOptionId, 'q1b');
      expect(q.explanation, 'B doğru.');

      // round-trip
      expect(QuestionSetContent.fromJson(content.toJson()), content);
    });

    test('explanation opsiyonel (null) parse edilir', () {
      final q = QuestionItem.fromJson({
        'questionId': 'q9',
        'stem': 's',
        'choices': const [],
        'correctOptionId': 'x',
      });
      expect(q.explanation, isNull);
    });

    test('StartGameSessionResponse questionSet alanını taşır', () {
      final json = {
        'session': {
          'id': 'sess-1',
          'gameId': 'g1',
          'studentId': 's1',
          'status': 1,
          'startedAt': '2026-06-23T00:00:00.000',
        },
        'type': GameType.questionSet.value,
        'questionSet': {
          'questions': [
            {
              'questionId': 'q1',
              'stem': 'Soru?',
              'choices': [
                {'optionId': 'q1a', 'label': 'A', 'text': 'A'},
              ],
              'correctOptionId': 'q1a',
            },
          ],
        },
      };
      final res = StartGameSessionResponse.fromJson(json);
      expect(res.type, GameType.questionSet);
      expect(res.questionSet, isNotNull);
      expect(res.questionSet!.questions.length, 1);
      expect(res.wordMatching, isNull);
    });

    test('GameAssignmentsDto classIds round-trip', () {
      final dto = GameAssignmentsDto.fromJson({
        'classIds': ['c1', 'c2'],
      });
      expect(dto.classIds, ['c1', 'c2']);
      expect(GameAssignmentsDto.fromJson(dto.toJson()), dto);
      // classIds yoksa boş listeye düşer.
      expect(GameAssignmentsDto.fromJson(const {}).classIds, isEmpty);
    });

    test('QuestionTopicDto parse (questionCount + opsiyonel description)', () {
      final dto = QuestionTopicDto.fromJson({
        'id': 't1',
        'title': 'Tenses',
        'questionCount': 10,
      });
      expect(dto.id, 't1');
      expect(dto.title, 'Tenses');
      expect(dto.description, isNull);
      expect(dto.questionCount, 10);
    });
  });
}
