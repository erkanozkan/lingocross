import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../storage/token_storage.dart';
import 'auth_interceptor.dart';
import 'entitlement_interceptor.dart';
import 'paywall_events.dart';

/// Oturum sonlandığında (refresh kalıcı başarısız) tetiklenen olay deposu.
///
/// AuthNotifier bunu dinleyip state'i `unauthenticated`'a çeker; router guard
/// giriş ekranına yönlendirir. Provider ile interceptor arasındaki döngüyü kırar.
class SessionEvents {
  final List<void Function()> _listeners = [];

  void addListener(void Function() listener) => _listeners.add(listener);

  void removeListener(void Function() listener) => _listeners.remove(listener);

  void notifyExpired() {
    for (final listener in List.of(_listeners)) {
      listener();
    }
  }
}

final sessionEventsProvider = Provider<SessionEvents>((ref) => SessionEvents());

/// Auth interceptor'lı uygulama Dio'su.
final dioProvider = Provider<Dio>((ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);
  final sessionEvents = ref.watch(sessionEventsProvider);
  final paywallEvents = ref.watch(paywallEventsProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      contentType: Headers.jsonContentType,
    ),
  );

  dio.interceptors.add(
    AuthInterceptor(
      tokenStorage: tokenStorage,
      onSessionExpired: sessionEvents.notifyExpired,
    ),
  );

  // 402 → paywall köprüsü. AuthInterceptor'dan SONRA eklenir ki 401 refresh
  // akışı önce çalışsın; 402 yalnız entitlement eksikliğinde gelir.
  dio.interceptors.add(EntitlementInterceptor(paywallEvents));

  return dio;
});
