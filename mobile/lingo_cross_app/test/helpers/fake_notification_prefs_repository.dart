import 'package:lingo_cross_app/features/notifications/data/dtos/notification_preferences_dto.dart';
import 'package:lingo_cross_app/features/notifications/data/notification_prefs_repository.dart';

/// Test'lerde ağ'a gitmeyen, bellek-içi bildirim tercihleri repository'si.
class FakeNotificationPrefsRepository implements NotificationPrefsRepository {
  FakeNotificationPrefsRepository({
    NotificationPreferencesDto? initial,
    this.failOnUpdate = false,
    this.failOnFetch = false,
  }) : _current = initial ?? NotificationPreferencesDto.defaults();

  NotificationPreferencesDto _current;
  bool failOnUpdate;
  bool failOnFetch;

  /// Son güncellenen değer (assertion için).
  NotificationPreferencesDto get current => _current;

  @override
  Future<NotificationPreferencesDto> fetch() async {
    if (failOnFetch) throw Exception('fetch failed');
    return _current;
  }

  @override
  Future<NotificationPreferencesDto> update(
    NotificationPreferencesDto prefs,
  ) async {
    if (failOnUpdate) throw Exception('update failed');
    _current = prefs;
    return _current;
  }
}
