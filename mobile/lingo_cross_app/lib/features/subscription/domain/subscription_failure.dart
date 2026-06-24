import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_failure.freezed.dart';

/// Abonelik işlemlerinde sunum katmanına taşınan hata türleri.
///
/// Repository [DioException]'ı bu tiplere indirger; ekranlar `.when`/`maybeWhen`
/// ile i18n metnini çözer. [purchaseDisabled] stub satın almanın kapalı olduğu
/// (503) durumdur — "satın alma kapalı (test)" mesajı gösterilir.
@freezed
class SubscriptionFailure with _$SubscriptionFailure {
  /// Ağ / bağlantı hatası (timeout, no response).
  const factory SubscriptionFailure.network() = _Network;

  /// Stub satın alma şu an kapalı (503) — test ortamı.
  const factory SubscriptionFailure.purchaseDisabled() = _PurchaseDisabled;

  /// Yetkisiz / yasak (401/403).
  const factory SubscriptionFailure.forbidden() = _Forbidden;

  /// Beklenmeyen sunucu hatası.
  const factory SubscriptionFailure.unexpected() = _Unexpected;
}
