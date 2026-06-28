import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/subscription_enums.dart';

part 'subscription_dtos.freezed.dart';
part 'subscription_dtos.g.dart';

/// API'deki int `SubscriptionPlan` değerini ([SubscriptionPlan]) enum'una çevirir.
class SubscriptionPlanConverter implements JsonConverter<SubscriptionPlan, int> {
  const SubscriptionPlanConverter();

  @override
  SubscriptionPlan fromJson(int json) => SubscriptionPlan.fromValue(json);

  @override
  int toJson(SubscriptionPlan object) => object.value;
}

/// API'deki int `SubscriptionStatus` değerini ([SubscriptionStatus]) enum'una çevirir.
class SubscriptionStatusConverter
    implements JsonConverter<SubscriptionStatus, int> {
  const SubscriptionStatusConverter();

  @override
  SubscriptionStatus fromJson(int json) => SubscriptionStatus.fromValue(json);

  @override
  int toJson(SubscriptionStatus object) => object.value;
}

/// API'deki int `SubscriptionPeriod` değerini ([SubscriptionPeriod]) enum'una çevirir.
class SubscriptionPeriodConverter
    implements JsonConverter<SubscriptionPeriod, int> {
  const SubscriptionPeriodConverter();

  @override
  SubscriptionPeriod fromJson(int json) => SubscriptionPeriod.fromValue(json);

  @override
  int toJson(SubscriptionPeriod object) => object.value;
}

/// Kullanıcının abonelik/entitlement durumu (SubscriptionDto) — API ile birebir.
///
/// `GET /api/subscription/me` ve `activate`/`cancel` yanıtlarında döner.
///
/// **Sınırsız konvansiyonu:** [maxClasses]/[maxLessons]/[maxTeachers] = -1 ise
/// ilgili limit sınırsızdır (Premium). [isPremium] sunucu tarafından hesaplanan
/// nihai erişim bayrağıdır.
@freezed
class SubscriptionDto with _$SubscriptionDto {
  const SubscriptionDto._();

  const factory SubscriptionDto({
    @SubscriptionPlanConverter() required SubscriptionPlan plan,
    @SubscriptionStatusConverter() required SubscriptionStatus status,
    @SubscriptionPeriodConverter() required SubscriptionPeriod period,
    DateTime? expiresAt,
    required bool isPremium,
    required int maxClasses,
    required int maxLessons,
    required int maxTeachers,
    required bool ocrEnabled,
  }) = _SubscriptionDto;

  factory SubscriptionDto.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionDtoFromJson(json);

  /// Sınıf limiti sınırsız mı (Premium konvansiyonu: -1).
  bool get unlimitedClasses => maxClasses < 0;

  /// Ders limiti sınırsız mı (-1).
  bool get unlimitedLessons => maxLessons < 0;

  /// Öğretmen (öğrencinin katılabileceği) limiti sınırsız mı (-1).
  bool get unlimitedTeachers => maxTeachers < 0;
}

/// Stub satın alma (aktivasyon) isteği — `POST /api/subscription/activate`.
///
/// [period] 1=Monthly, 2=Annual veya trial için null. [trial] true ise deneme
/// başlatılır (period genelde null).
@freezed
class ActivateStubRequest with _$ActivateStubRequest {
  const factory ActivateStubRequest({
    int? period,
    @Default(false) bool trial,
  }) = _ActivateStubRequest;

  factory ActivateStubRequest.fromJson(Map<String, dynamic> json) =>
      _$ActivateStubRequestFromJson(json);
}

/// Apple makbuz doğrulama isteği — `POST /api/subscription/apple/verify`.
///
/// [receiptData] StoreKit'in döndürdüğü base64 makbuz
/// (`PurchaseDetails.verificationData.serverVerificationData`).
@freezed
class AppleVerifyRequest with _$AppleVerifyRequest {
  const factory AppleVerifyRequest({
    required String receiptData,
  }) = _AppleVerifyRequest;

  factory AppleVerifyRequest.fromJson(Map<String, dynamic> json) =>
      _$AppleVerifyRequestFromJson(json);
}

/// Google Play satın alma doğrulama isteği —
/// `POST /api/subscription/google/verify`.
///
/// [purchaseToken] Google Play'in döndürdüğü satın alma token'ı (Android'de
/// `PurchaseDetails.verificationData.serverVerificationData`). [productId]
/// abonelik ürün kimliği (`PurchaseDetails.productID`).
@freezed
class GoogleVerifyRequest with _$GoogleVerifyRequest {
  const factory GoogleVerifyRequest({
    required String purchaseToken,
    required String productId,
  }) = _GoogleVerifyRequest;

  factory GoogleVerifyRequest.fromJson(Map<String, dynamic> json) =>
      _$GoogleVerifyRequestFromJson(json);
}
