import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Push altyapısının (FCM) ince soyutlaması.
///
/// `firebase_messaging` doğrudan platform kanalına gittiği için test'lerde
/// kullanılamaz; servis bu arayüze bağlanır, üretimde [FirebasePushClient]
/// gerçek FCM'i sarar.
abstract class PushMessagingClient {
  /// iOS bildirim izni ister; izin verildiyse `true`.
  Future<bool> requestPermission();

  /// iOS foreground gösterim seçeneklerini ayarlar (alert/badge/sound).
  Future<void> setForegroundPresentationOptions();

  /// Güncel FCM token (alınamazsa `null`).
  Future<String?> getToken();

  /// Token yenilendiğinde tetiklenen akış.
  Stream<String> get onTokenRefresh;

  /// Foreground'da gelen mesaj akışı.
  Stream<RemoteMessage> get onMessage;

  /// (Best-effort) Cihazdaki token'ı siler — logout sonrası yeni token üretir.
  Future<void> deleteToken();
}

/// `firebase_messaging` tabanlı gerçek istemci (iOS APNs → FCM).
class FirebasePushClient implements PushMessagingClient {
  FirebasePushClient([FirebaseMessaging? messaging])
      : _messaging = messaging ?? FirebaseMessaging.instance;

  final FirebaseMessaging _messaging;

  @override
  Future<bool> requestPermission() async {
    final settings = await _messaging.requestPermission();
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  @override
  Future<void> setForegroundPresentationOptions() {
    return _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  @override
  Future<String?> getToken() => _messaging.getToken();

  @override
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  @override
  Stream<RemoteMessage> get onMessage => FirebaseMessaging.onMessage;

  @override
  Future<void> deleteToken() => _messaging.deleteToken();
}

final pushMessagingClientProvider = Provider<PushMessagingClient>((ref) {
  return FirebasePushClient();
});
