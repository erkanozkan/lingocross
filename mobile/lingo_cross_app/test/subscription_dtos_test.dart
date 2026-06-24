import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_cross_app/features/subscription/data/dtos/subscription_dtos.dart';
import 'package:lingo_cross_app/features/subscription/domain/entitlement.dart';
import 'package:lingo_cross_app/features/subscription/domain/subscription_enums.dart';

void main() {
  group('SubscriptionDto JSON çözme (API sözleşmesi)', () {
    test('Premium: -1 limitler sınırsız + isPremium true', () {
      final dto = SubscriptionDto.fromJson({
        'plan': 1, // Premium
        'status': 2, // Active
        'period': 2, // Annual
        'expiresAt': '2027-06-24T00:00:00Z',
        'isPremium': true,
        'maxClasses': -1,
        'maxLessons': -1,
        'maxTeachers': -1,
        'ocrEnabled': true,
      });

      expect(dto.plan, SubscriptionPlan.premium);
      expect(dto.status, SubscriptionStatus.active);
      expect(dto.period, SubscriptionPeriod.annual);
      expect(dto.isPremium, true);
      expect(dto.unlimitedClasses, true);
      expect(dto.unlimitedLessons, true);
      expect(dto.unlimitedTeachers, true);
      expect(dto.ocrEnabled, true);
      expect(dto.expiresAt, DateTime.utc(2027, 6, 24));
    });

    test('Free: limitli + isPremium false', () {
      final dto = SubscriptionDto.fromJson({
        'plan': 0, // None
        'status': 0, // None
        'period': 0, // None
        'expiresAt': null,
        'isPremium': false,
        'maxClasses': 1,
        'maxLessons': 3,
        'maxTeachers': 1,
        'ocrEnabled': false,
      });

      expect(dto.plan, SubscriptionPlan.none);
      expect(dto.isPremium, false);
      expect(dto.unlimitedClasses, false);
      expect(dto.unlimitedLessons, false);
      expect(dto.unlimitedTeachers, false);
      expect(dto.maxLessons, 3);
      expect(dto.expiresAt, isNull);
    });
  });

  group('ActivateStubRequest JSON (API sözleşmesi)', () {
    test('aylık: period=1, trial=false', () {
      final json = const ActivateStubRequest(period: 1).toJson();
      expect(json['period'], 1);
      expect(json['trial'], false);
    });

    test('yıllık: period=2', () {
      final json = const ActivateStubRequest(period: 2).toJson();
      expect(json['period'], 2);
    });

    test('deneme: period=null, trial=true', () {
      final json = const ActivateStubRequest(trial: true).toJson();
      expect(json['period'], isNull);
      expect(json['trial'], true);
    });
  });

  group('Entitlement helper (proaktif kilit kararları)', () {
    test('Free: ocrLocked true; Premium: false', () {
      final free = SubscriptionDto.fromJson({
        'plan': 0,
        'status': 0,
        'period': 0,
        'isPremium': false,
        'maxClasses': 1,
        'maxLessons': 3,
        'maxTeachers': 1,
        'ocrEnabled': false,
      });
      expect(free.ocrLocked, true);

      final premium = SubscriptionDto.fromJson({
        'plan': 1,
        'status': 2,
        'period': 2,
        'isPremium': true,
        'maxClasses': -1,
        'maxLessons': -1,
        'maxTeachers': -1,
        'ocrEnabled': true,
      });
      expect(premium.ocrLocked, false);
    });

    test('Free: limitte canCreateClass/Lesson false, altında true', () {
      final free = SubscriptionDto.fromJson({
        'plan': 0,
        'status': 0,
        'period': 0,
        'isPremium': false,
        'maxClasses': 1,
        'maxLessons': 3,
        'maxTeachers': 1,
        'ocrEnabled': false,
      });
      expect(free.canCreateClass(0), true);
      expect(free.canCreateClass(1), false); // limit doldu
      expect(free.canCreateLesson(2), true);
      expect(free.canCreateLesson(3), false);
      expect(free.canJoinAnotherTeacher(0), true);
      expect(free.canJoinAnotherTeacher(1), false);
    });

    test('Premium / -1: her zaman izin', () {
      final premium = SubscriptionDto.fromJson({
        'plan': 1,
        'status': 2,
        'period': 2,
        'isPremium': true,
        'maxClasses': -1,
        'maxLessons': -1,
        'maxTeachers': -1,
        'ocrEnabled': true,
      });
      expect(premium.canCreateClass(99), true);
      expect(premium.canCreateLesson(99), true);
      expect(premium.canJoinAnotherTeacher(99), true);
    });
  });
}
