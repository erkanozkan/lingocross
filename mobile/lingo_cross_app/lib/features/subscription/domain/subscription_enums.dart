/// Abonelik plan/durum/dönem enum'ları (API ile birebir; sayısal değerler
/// kalıcı). Backend converter deseni (int enum) ile uyumludur.
///
/// MVP'de tek ücretli plan [SubscriptionPlan.premium]. [SubscriptionPlan.none]
/// ücretsiz (Free) kullanıcıyı temsil eder.
library;

/// Abonelik planı (API `SubscriptionPlan` enum'u). 0=None (Free), 1=Premium.
enum SubscriptionPlan {
  none(0),
  premium(1);

  const SubscriptionPlan(this.value);

  final int value;

  static SubscriptionPlan fromValue(int value) => switch (value) {
        1 => SubscriptionPlan.premium,
        _ => SubscriptionPlan.none,
      };
}

/// Abonelik durumu (API `SubscriptionStatus` enum'u).
/// 0 None, 1 Trial, 2 Active, 3 Expired, 4 Canceled.
enum SubscriptionStatus {
  none(0),
  trial(1),
  active(2),
  expired(3),
  canceled(4);

  const SubscriptionStatus(this.value);

  final int value;

  static SubscriptionStatus fromValue(int value) => switch (value) {
        1 => SubscriptionStatus.trial,
        2 => SubscriptionStatus.active,
        3 => SubscriptionStatus.expired,
        4 => SubscriptionStatus.canceled,
        _ => SubscriptionStatus.none,
      };
}

/// Faturalandırma dönemi (API `SubscriptionPeriod` enum'u).
/// 0 None, 1 Monthly, 2 Annual.
enum SubscriptionPeriod {
  none(0),
  monthly(1),
  annual(2);

  const SubscriptionPeriod(this.value);

  final int value;

  static SubscriptionPeriod fromValue(int value) => switch (value) {
        1 => SubscriptionPeriod.monthly,
        2 => SubscriptionPeriod.annual,
        _ => SubscriptionPeriod.none,
      };
}
