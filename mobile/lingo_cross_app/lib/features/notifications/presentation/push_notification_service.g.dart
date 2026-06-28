// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_notification_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pushNotificationServiceHash() =>
    r'b02eb945f633c869445bd332d154ae0e52b51df1';

/// Push bildirim kaydını oturum durumuna bağlayan servis.
///
/// - Oturum AÇILDIĞINDA: izin ister → foreground gösterimini ayarlar → FCM
///   token alır → `POST /api/devices` ile kaydeder → `onTokenRefresh` dinler →
///   `onMessage` (foreground) ile SnackBar gösterir.
/// - Oturum KAPANDIĞINDA: `DELETE /api/devices/{token}` (best-effort) + token'ı
///   siler ki bir sonraki kullanıcı yeni token alsın.
///
/// Tüm ağ çağrıları best-effort'tur: hata yutulur + log'lanır, UI bozulmaz.
/// `keepAlive`: oturum boyunca yaşar, dinleyicileri korur.
///
/// Copied from [PushNotificationService].
@ProviderFor(PushNotificationService)
final pushNotificationServiceProvider =
    NotifierProvider<PushNotificationService, void>.internal(
      PushNotificationService.new,
      name: r'pushNotificationServiceProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$pushNotificationServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PushNotificationService = Notifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
