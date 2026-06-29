import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_cross_app/features/profile/data/dtos/student_progress_dto.dart';

void main() {
  group('StudentProgressDto', () {
    test('camelCase JSON round-trip korunur', () {
      const json = {
        'gamesPlayed': 24,
        'averageAccuracy': 88,
        'accuracyTrendDelta': 2,
        'weeklyMinutes': 320,
        'weeklyGoalMinutes': 500,
        'streakDays': 7,
      };
      final dto = StudentProgressDto.fromJson(json);

      expect(dto.gamesPlayed, 24);
      expect(dto.averageAccuracy, 88);
      expect(dto.accuracyTrendDelta, 2);
      expect(dto.weeklyMinutes, 320);
      expect(dto.weeklyGoalMinutes, 500);
      expect(dto.streakDays, 7);

      expect(dto.toJson(), json);
    });

    test('accuracyTrendDelta null parse edilir', () {
      final dto = StudentProgressDto.fromJson(const {
        'gamesPlayed': 0,
        'averageAccuracy': 0,
        'accuracyTrendDelta': null,
        'weeklyMinutes': 0,
        'weeklyGoalMinutes': 500,
        'streakDays': 0,
      });
      expect(dto.accuracyTrendDelta, isNull);
    });

    test('accuracyPercent 0–100 aralığına sıkışır', () {
      expect(_p(averageAccuracy: 150).accuracyPercent, 100);
      expect(_p(averageAccuracy: -10).accuracyPercent, 0);
      expect(_p(averageAccuracy: 77).accuracyPercent, 77);
    });

    test('weeklyProgress 0.0–1.0 aralığına clamp edilir', () {
      expect(_p(weeklyMinutes: 250, weeklyGoalMinutes: 500).weeklyProgress,
          closeTo(0.5, 1e-9));
      expect(_p(weeklyMinutes: 600, weeklyGoalMinutes: 500).weeklyProgress, 1.0);
      expect(_p(weeklyMinutes: 10, weeklyGoalMinutes: 0).weeklyProgress, 0.0);
    });

    test('remainingMinutes negatif olmaz', () {
      expect(_p(weeklyMinutes: 320, weeklyGoalMinutes: 500).remainingMinutes,
          180);
      expect(
          _p(weeklyMinutes: 600, weeklyGoalMinutes: 500).remainingMinutes, 0);
    });
  });
}

StudentProgressDto _p({
  int gamesPlayed = 1,
  int averageAccuracy = 50,
  int? accuracyTrendDelta,
  int weeklyMinutes = 0,
  int weeklyGoalMinutes = 500,
  int streakDays = 0,
}) =>
    StudentProgressDto(
      gamesPlayed: gamesPlayed,
      averageAccuracy: averageAccuracy,
      accuracyTrendDelta: accuracyTrendDelta,
      weeklyMinutes: weeklyMinutes,
      weeklyGoalMinutes: weeklyGoalMinutes,
      streakDays: streakDays,
    );
