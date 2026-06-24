import 'package:dio/dio.dart';

import 'paywall_events.dart';

/// 402 (Payment Required) yanıtlarını paywall'a köprüleyen interceptor.
///
/// Backend, kilitli bir özelliğe erişimde ProblemDetails gövdesinde düz alanlar
/// döner: `{"code": "subscription_required", "feature": "ocr"|"class_limit"|...}`.
/// Bu interceptor 402'de [feature]'ı okuyup [PaywallEvents.trigger] ile yayar,
/// ardından hatayı yine yukarı geçirir (`handler.next`) — böylece çağıran kod
/// da uygun hatayı görür. AuthInterceptor'dan SONRA eklenir.
class EntitlementInterceptor extends Interceptor {
  EntitlementInterceptor(this._paywallEvents);

  final PaywallEvents _paywallEvents;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 402) {
      final data = err.response?.data;
      String feature = 'unknown';
      if (data is Map) {
        final raw = data['feature'];
        if (raw is String && raw.isNotEmpty) feature = raw;
      }
      _paywallEvents.trigger(feature);
    }
    handler.next(err);
  }
}
