import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';

/// Cihaz push token'larını backend'e kaydeden/silen repository.
///
/// `POST /api/devices` body `{ token, platform }` → token'ı kaydeder/günceller.
/// `DELETE /api/devices/{token}` → logout'ta token'ı kaldırır.
/// Bearer token interceptor tarafından eklenir. Çağrılar best-effort'tur;
/// servis katmanı hataları yutar (UI'yı bozmaz).
class DeviceRepository {
  DeviceRepository(this._dio);

  final Dio _dio;

  String get _base => AppConfig.apiPrefix;

  /// FCM token'ını kaydeder (iOS). Hatalar yukarı fırlatılır; servis yutar.
  Future<void> register({required String token, String platform = 'ios'}) async {
    await _dio.post<dynamic>(
      '$_base/devices',
      data: {'token': token, 'platform': platform},
    );
  }

  /// Logout'ta token'ı kaldırır. Hatalar yukarı fırlatılır; servis yutar.
  Future<void> unregister(String token) async {
    await _dio.delete<dynamic>('$_base/devices/$token');
  }
}

final deviceRepositoryProvider = Provider<DeviceRepository>((ref) {
  return DeviceRepository(ref.watch(dioProvider));
});
