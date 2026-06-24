// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$localeControllerHash() => r'aab1215b5fa10e4969cfffaea785e616afb34d49';

/// Aktif UI [Locale]'ini tutan controller (Riverpod 2.x codegen, keepAlive).
///
/// Açılışta cihaz dili / saklı override / backend tercihine göre çözülür;
/// kullanıcı Dil Tercihi ekranından değiştirir. Seçim cihazda (shared_prefs)
/// saklanır + best-effort backend'e yazılır.
///
/// Copied from [LocaleController].
@ProviderFor(LocaleController)
final localeControllerProvider =
    NotifierProvider<LocaleController, Locale>.internal(
      LocaleController.new,
      name: r'localeControllerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$localeControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LocaleController = Notifier<Locale>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
