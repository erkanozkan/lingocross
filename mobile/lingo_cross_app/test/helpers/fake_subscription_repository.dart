import 'package:lingo_cross_app/features/subscription/data/dtos/subscription_dtos.dart';
import 'package:lingo_cross_app/features/subscription/data/subscription_repository.dart';
import 'package:lingo_cross_app/features/subscription/domain/subscription_enums.dart';

/// Testlerde gerçek Dio yerine kullanılan sahte subscription repository.
class FakeSubscriptionRepository implements SubscriptionRepository {
  FakeSubscriptionRepository({SubscriptionDto? initial})
      : current = initial ?? freeSubscription();

  SubscriptionDto current;
  Object? activateError;

  int getMineCount = 0;
  int activateCount = 0;
  int cancelCount = 0;
  int verifyAppleCount = 0;
  ActivateStubRequest? lastActivateRequest;
  String? lastReceiptData;

  /// verifyApple başarısız olsun istenirse atanır (örn. doğrulama reddi).
  Object? verifyAppleError;

  @override
  Future<SubscriptionDto> getMine() async {
    getMineCount++;
    return current;
  }

  @override
  Future<SubscriptionDto> activateStub(ActivateStubRequest request) async {
    activateCount++;
    lastActivateRequest = request;
    if (activateError != null) throw activateError!;
    current = premiumSubscription();
    return current;
  }

  @override
  Future<SubscriptionDto> verifyApple(String receiptData) async {
    verifyAppleCount++;
    lastReceiptData = receiptData;
    if (verifyAppleError != null) throw verifyAppleError!;
    current = premiumSubscription();
    return current;
  }

  @override
  Future<SubscriptionDto> cancel() async {
    cancelCount++;
    current = freeSubscription();
    return current;
  }
}

SubscriptionDto freeSubscription({
  int maxClasses = 2,
  int maxLessons = 5,
  int maxTeachers = 1,
  bool ocrEnabled = false,
}) {
  return SubscriptionDto(
    plan: SubscriptionPlan.none,
    status: SubscriptionStatus.none,
    period: SubscriptionPeriod.none,
    isPremium: false,
    maxClasses: maxClasses,
    maxLessons: maxLessons,
    maxTeachers: maxTeachers,
    ocrEnabled: ocrEnabled,
  );
}

SubscriptionDto premiumSubscription() {
  return const SubscriptionDto(
    plan: SubscriptionPlan.premium,
    status: SubscriptionStatus.active,
    period: SubscriptionPeriod.annual,
    isPremium: true,
    maxClasses: -1,
    maxLessons: -1,
    maxTeachers: -1,
    ocrEnabled: true,
  );
}
