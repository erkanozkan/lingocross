import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_cross_app/features/account/data/notification_prefs.dart';
import 'package:lingo_cross_app/features/notifications/data/dtos/notification_preferences_dto.dart';

void main() {
  test('Varsayılanlar: Duyurular hariç hepsi açık', () {
    final d = NotificationPreferencesDto.defaults();
    expect(d.master, true);
    expect(d.assigned, true);
    expect(d.reminder, true);
    expect(d.results, true);
    expect(d.announcements, false);
  });

  test('fromJson/toJson round-trip', () {
    const json = {
      'master': true,
      'assigned': false,
      'reminder': true,
      'results': false,
      'announcements': true,
    };
    final dto = NotificationPreferencesDto.fromJson(json);
    expect(dto.assigned, false);
    expect(dto.announcements, true);
    expect(dto.toJson(), json);
  });

  test('read() ve withToggle() her anahtarı doğru eşler', () {
    var dto = NotificationPreferencesDto.defaults();
    for (final t in NotificationToggle.values) {
      final flipped = !dto.read(t);
      dto = dto.withToggle(t, flipped);
      expect(dto.read(t), flipped, reason: 'toggle: $t');
    }
  });

  test('toToggleMap() tüm anahtarları içerir', () {
    final map = NotificationPreferencesDto.defaults().toToggleMap();
    expect(map.keys.toSet(), NotificationToggle.values.toSet());
    expect(map[NotificationToggle.announcements], false);
  });
}
