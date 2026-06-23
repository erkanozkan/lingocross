// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authNotifierHash() => r'7a0c4465d9b912b6e75b6ee99904a17ab6f5622d';

/// Oturum state'ini yöneten Riverpod 2.x notifier (codegen).
///
/// - Açılışta secure storage'da token varsa `authenticated` kabul edilir
///   (kullanıcı bilgisi token yenileme/`/me` ile M2'de zenginleştirilebilir).
/// - login/register başarıda token'lar saklanır, state `authenticated` olur.
/// - 401 refresh kalıcı başarısız olursa (SessionEvents) state
///   `unauthenticated`'a düşer ve router giriş ekranına yönlendirir.
///
/// Copied from [AuthNotifier].
@ProviderFor(AuthNotifier)
final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>.internal(
  AuthNotifier.new,
  name: r'authNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthNotifier = Notifier<AuthState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
