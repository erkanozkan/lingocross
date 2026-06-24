import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../account/data/notification_prefs.dart';

part 'notification_preferences_dto.freezed.dart';
part 'notification_preferences_dto.g.dart';

/// Bildirim tercihleri — API `NotificationPreferencesDto`
/// (`GET|PUT /api/me/notification-preferences`).
///
/// Beş anahtar: ana anahtar (`master`), ödev/bulmaca atama (`assigned`),
/// ödev hatırlatması (`reminder`), sonuçlar (`results`), duyurular
/// (`announcements`). Backend ile aynı varsayılanlar: `announcements` hariç
/// hepsi `true`.
@freezed
class NotificationPreferencesDto with _$NotificationPreferencesDto {
  const NotificationPreferencesDto._();

  const factory NotificationPreferencesDto({
    @Default(true) bool master,
    @Default(true) bool assigned,
    @Default(true) bool reminder,
    @Default(true) bool results,
    @Default(false) bool announcements,
  }) = _NotificationPreferencesDto;

  factory NotificationPreferencesDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesDtoFromJson(json);

  /// Backend varsayılanları (hata/ilk yükleme öncesi güvenli başlangıç).
  factory NotificationPreferencesDto.defaults() =>
      const NotificationPreferencesDto();

  /// Bir [NotificationToggle] için güncel değeri okur.
  bool read(NotificationToggle toggle) => switch (toggle) {
        NotificationToggle.master => master,
        NotificationToggle.assigned => assigned,
        NotificationToggle.reminder => reminder,
        NotificationToggle.results => results,
        NotificationToggle.announcements => announcements,
      };

  /// Tüm anahtarları ekranın beklediği harita biçiminde döndürür.
  Map<NotificationToggle, bool> toToggleMap() => {
        for (final t in NotificationToggle.values) t: read(t),
      };

  /// Tek bir anahtarı güncelleyip yeni bir kopya döndürür.
  NotificationPreferencesDto withToggle(NotificationToggle toggle, bool value) {
    return switch (toggle) {
      NotificationToggle.master => copyWith(master: value),
      NotificationToggle.assigned => copyWith(assigned: value),
      NotificationToggle.reminder => copyWith(reminder: value),
      NotificationToggle.results => copyWith(results: value),
      NotificationToggle.announcements => copyWith(announcements: value),
    };
  }
}
