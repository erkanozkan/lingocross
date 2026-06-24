import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_cross_app/core/storage/token_storage.dart';
import 'package:lingo_cross_app/features/auth/data/auth_repository.dart';
import 'package:lingo_cross_app/features/auth/presentation/auth_notifier.dart';
import 'package:lingo_cross_app/features/notifications/data/device_repository.dart';
import 'package:lingo_cross_app/features/notifications/data/push_messaging_client.dart';
import 'package:lingo_cross_app/features/notifications/presentation/push_notification_service.dart';

import 'helpers/fake_auth_repository.dart';
import 'helpers/fake_device_repository.dart';
import 'helpers/fake_push_messaging_client.dart';
import 'helpers/fake_secure_storage.dart';

ProviderContainer _container({
  required FakePushMessagingClient client,
  required FakeDeviceRepository devices,
  required FakeSecureStorage storage,
}) {
  final container = ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
      secureStorageProvider.overrideWithValue(storage),
      pushMessagingClientProvider.overrideWithValue(client),
      deviceRepositoryProvider.overrideWithValue(devices),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Oturum açıkken izin ister, foreground ayarlar ve token kaydeder',
      () async {
    final client = FakePushMessagingClient();
    final devices = FakeDeviceRepository();
    final storage = FakeSecureStorage({
      'lc_access_token': 'a',
      'lc_refresh_token': 'r',
    });
    final container =
        _container(client: client, devices: devices, storage: storage);

    // Auth restore (token var → authenticated) tamamlansın.
    container.read(authNotifierProvider);
    container.read(pushNotificationServiceProvider.notifier).ensureInitialized();

    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(container.read(authNotifierProvider).isAuthenticated, true);
    expect(client.permissionRequests, 1);
    expect(client.foregroundOptionCalls, 1);
    expect(devices.registered, ['fake-fcm-token']);
  });

  test('Token yenilenince yeniden kaydeder', () async {
    final client = FakePushMessagingClient();
    final devices = FakeDeviceRepository();
    final storage = FakeSecureStorage({
      'lc_access_token': 'a',
      'lc_refresh_token': 'r',
    });
    final container =
        _container(client: client, devices: devices, storage: storage);

    container.read(authNotifierProvider);
    container.read(pushNotificationServiceProvider.notifier).ensureInitialized();
    await Future<void>.delayed(const Duration(milliseconds: 50));

    client.emitTokenRefresh('new-token');
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(devices.registered, contains('new-token'));
  });

  test('İzin verilmezse token kaydetmez', () async {
    final client = FakePushMessagingClient(permissionGranted: false);
    final devices = FakeDeviceRepository();
    final storage = FakeSecureStorage({
      'lc_access_token': 'a',
      'lc_refresh_token': 'r',
    });
    final container =
        _container(client: client, devices: devices, storage: storage);

    container.read(authNotifierProvider);
    container.read(pushNotificationServiceProvider.notifier).ensureInitialized();
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(client.permissionRequests, 1);
    expect(devices.registered, isEmpty);
  });

  test('Logout token\'ı backend\'den siler ve yereli temizler', () async {
    final client = FakePushMessagingClient();
    final devices = FakeDeviceRepository();
    final storage = FakeSecureStorage({
      'lc_access_token': 'a',
      'lc_refresh_token': 'r',
    });
    final container =
        _container(client: client, devices: devices, storage: storage);

    container.read(authNotifierProvider);
    container.read(pushNotificationServiceProvider.notifier).ensureInitialized();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(devices.registered, ['fake-fcm-token']);

    await container.read(authNotifierProvider.notifier).logout();
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(devices.unregistered, ['fake-fcm-token']);
    expect(client.deleteTokenCalls, 1);
  });

  test('Kayıt hatası yutulur (UI bozulmaz)', () async {
    final client = FakePushMessagingClient();
    final devices = FakeDeviceRepository()..failRegister = true;
    final storage = FakeSecureStorage({
      'lc_access_token': 'a',
      'lc_refresh_token': 'r',
    });
    final container =
        _container(client: client, devices: devices, storage: storage);

    container.read(authNotifierProvider);
    // Hata fırlatmamalı.
    container.read(pushNotificationServiceProvider.notifier).ensureInitialized();
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(devices.registered, isEmpty);
    expect(container.read(authNotifierProvider).isAuthenticated, true);
  });
}
