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

    // REGRESYON: Backend Free kullanıcı için `period: null` döner (0 DEĞİL).
    // Eski converter `int` beklediği için `null as int` parse'ı patlatıyordu →
    // getMine() hataya düşüyor, Free kullanıcı kilitsiz görünüyor, bulmaca
    // sihirbazı açılıyor ve paywall ancak sonda 402 ile çıkıyordu. Gerçek
    // prod payload'ı (period null, expiresAt yok) sorunsuz çözülmeli.
    test('Free (GERÇEK prod payload): period null → none, parse patlamaz', () {
      final dto = SubscriptionDto.fromJson({
        'plan': 1, // backend Free yanıtında plan=1 döner; isPremium otoritedir
        'status': 0,
        'period': null, // <-- kritik: Free'de null
        'expiresAt': null,
        'isPremium': false,
        'maxClasses': 2,
        'maxLessons': 5,
        'maxTeachers': 1,
        'ocrEnabled': false,
      });

      expect(dto.period, SubscriptionPeriod.none);
      expect(dto.isPremium, false);
      expect(dto.puzzleCreateLocked, true); // Free → bulmaca oluşturma kilitli
      expect(dto.ocrLocked, true);
    });

    test('Premium toJson/fromJson round-trip: period korunur', () {
      const original = SubscriptionDto(
        plan: SubscriptionPlan.premium,
        status: SubscriptionStatus.active,
        period: SubscriptionPeriod.monthly,
        isPremium: true,
        maxClasses: -1,
        maxLessons: -1,
        maxTeachers: -1,
        ocrEnabled: true,
      );
      final round = SubscriptionDto.fromJson(original.toJson());
      expect(round.period, SubscriptionPeriod.monthly);
      expect(round.puzzleCreateLocked, false);
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
        // Öğrenci tamamen ücretsiz: free öğrenciye maxTeachers=-1 (sınırsız).
        'maxTeachers': -1,
        'ocrEnabled': false,
      });
      expect(free.canCreateClass(0), true);
      expect(free.canCreateClass(1), false); // limit doldu
      expect(free.canCreateLesson(2), true);
      expect(free.canCreateLesson(3), false);
      // Öğretmen katılımı sınırsız: her zaman katılabilir.
      expect(free.unlimitedTeachers, true);
      expect(free.canJoinAnotherTeacher(0), true);
      expect(free.canJoinAnotherTeacher(1), true);
      expect(free.canJoinAnotherTeacher(99), true);
    });

    test('Sonlu maxTeachers limiti: sayıya göre kısıtlanır', () {
      final limited = SubscriptionDto.fromJson({
        'plan': 0,
        'status': 0,
        'period': 0,
        'isPremium': false,
        'maxClasses': 1,
        'maxLessons': 3,
        'maxTeachers': 1,
        'ocrEnabled': false,
      });
      expect(limited.unlimitedTeachers, false);
      expect(limited.canJoinAnotherTeacher(0), true);
      expect(limited.canJoinAnotherTeacher(1), false);
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
