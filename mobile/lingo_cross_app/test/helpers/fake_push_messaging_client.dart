import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lingo_cross_app/features/notifications/data/push_messaging_client.dart';

/// Test'lerde Firebase platform kanalına gitmeyen sahte push istemcisi.
class FakePushMessagingClient implements PushMessagingClient {
  FakePushMessagingClient({
    this.permissionGranted = true,
    String? token = 'fake-fcm-token',
  }) : _token = token;

  bool permissionGranted;
  String? _token;

  int permissionRequests = 0;
  int foregroundOptionCalls = 0;
  int deleteTokenCalls = 0;

  final _tokenRefreshController = StreamController<String>.broadcast();
  final _messageController = StreamController<RemoteMessage>.broadcast();

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    return permissionGranted;
  }

  @override
  Future<void> setForegroundPresentationOptions() async {
    foregroundOptionCalls++;
  }

  @override
  Future<String?> getToken() async => _token;

  @override
  Stream<String> get onTokenRefresh => _tokenRefreshController.stream;

  @override
  Stream<RemoteMessage> get onMessage => _messageController.stream;

  @override
  Future<void> deleteToken() async {
    deleteTokenCalls++;
    _token = null;
  }

  /// Test sürücüsü: token yenilemesini tetikler.
  void emitTokenRefresh(String token) => _tokenRefreshController.add(token);

  void dispose() {
    _tokenRefreshController.close();
    _messageController.close();
  }
}
