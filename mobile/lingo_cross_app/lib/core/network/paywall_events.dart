import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 402 (subscription_required) yanıtlarını paywall'a köprüleyen olay yayını.
///
/// [EntitlementInterceptor] bir 402 yakaladığında [trigger] ile özelliği yayar;
/// router kurulurken [stream] dinlenir ve paywall ekranı push edilir. Provider
/// ile interceptor/router arasındaki döngüyü kırar (SessionEvents deseni gibi).
class PaywallEvents {
  final StreamController<String> _controller =
      StreamController<String>.broadcast();

  /// Verilen [feature] için paywall'ı tetikler ("ocr", "class_limit", ...).
  void trigger(String feature) {
    if (_controller.isClosed) return;
    _controller.add(feature);
  }

  /// Paywall tetikleyici özelliklerin akışı (broadcast).
  Stream<String> get stream => _controller.stream;

  void dispose() => _controller.close();
}

final paywallEventsProvider = Provider<PaywallEvents>((ref) {
  final events = PaywallEvents();
  ref.onDispose(events.dispose);
  return events;
});
