// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_prefs_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationPrefsNotifierHash() =>
    r'dabbd94e07ebc7e779eeea1e45e58933fb20af40';

/// Bildirim tercihleri (`GET|PUT /api/me/notification-preferences`).
///
/// Açılışta GET ile yükler; bir toggle değiştiğinde iyimser (optimistic)
/// günceller ve PUT eder. PUT başarısız olursa eski değere geri döner ve
/// hatayı yukarı fırlatır (ekran SnackBar gösterir). Yükleniyor/hata/veri
/// durumları ekranda `AsyncValue` ile ele alınır.
///
/// Copied from [NotificationPrefsNotifier].
@ProviderFor(NotificationPrefsNotifier)
final notificationPrefsNotifierProvider = AutoDisposeAsyncNotifierProvider<
  NotificationPrefsNotifier,
  NotificationPreferencesDto
>.internal(
  NotificationPrefsNotifier.new,
  name: r'notificationPrefsNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$notificationPrefsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationPrefsNotifier =
    AutoDisposeAsyncNotifier<NotificationPreferencesDto>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
