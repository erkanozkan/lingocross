import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import 'dtos/notification_preferences_dto.dart';

/// Bildirim tercihleriyle konuşan repository (backend kaynaklı).
///
/// `GET /api/me/notification-preferences` → tercihleri okur.
/// `PUT /api/me/notification-preferences` → tüm gövdeyi günceller.
/// Bearer token interceptor tarafından eklenir; 401'de refresh edilir.
class NotificationPrefsRepository {
  NotificationPrefsRepository(this._dio);

  final Dio _dio;

  String get _base => AppConfig.apiPrefix;

  /// Geçerli kullanıcının bildirim tercihlerini getirir.
  Future<NotificationPreferencesDto> fetch() async {
    final res = await _dio.get<Map<String, dynamic>>(
      '$_base/me/notification-preferences',
    );
    return NotificationPreferencesDto.fromJson(res.data!);
  }

  /// Tercihlerin tamamını günceller; güncellenmiş hâli döner.
  Future<NotificationPreferencesDto> update(
    NotificationPreferencesDto prefs,
  ) async {
    final res = await _dio.put<Map<String, dynamic>>(
      '$_base/me/notification-preferences',
      data: prefs.toJson(),
    );
    // Backend güncellenmiş gövdeyi döndürür; boş/null gelirse gönderileni kullan.
    final data = res.data;
    if (data == null || data.isEmpty) return prefs;
    return NotificationPreferencesDto.fromJson(data);
  }
}

final notificationPrefsRepositoryProvider =
    Provider<NotificationPrefsRepository>((ref) {
  return NotificationPrefsRepository(ref.watch(dioProvider));
});
