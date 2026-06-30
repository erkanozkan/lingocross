// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$subscriptionNotifierHash() =>
    r'e34a3dfc8ac33696259dc3d90ef23c13af6fd392';

/// Kullanıcının abonelik/entitlement durumunu yöneten async notifier.
///
/// - Açılışta: oturum açıksa `getMine()` ile yüklenir; değilse boş Free durumu.
/// - Auth state izlenir: login olunca yüklenir, logout olunca Free'ye temizlenir.
/// - [refresh] yeniden çeker; [activate]/[cancelStub] sonrası kendini tazeler.
///
/// `keepAlive`: oturum boyunca tek örnek; gated ekranlar bunu izler.
///
/// Copied from [SubscriptionNotifier].
@ProviderFor(SubscriptionNotifier)
final subscriptionNotifierProvider =
    AsyncNotifierProvider<SubscriptionNotifier, SubscriptionDto>.internal(
      SubscriptionNotifier.new,
      name: r'subscriptionNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$subscriptionNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SubscriptionNotifier = AsyncNotifier<SubscriptionDto>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
