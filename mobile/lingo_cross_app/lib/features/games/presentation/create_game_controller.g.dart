// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_game_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$createGameControllerHash() =>
    r'aa097f6d016811ce0e82177c8078010ec782f6c8';

/// Öğretmen "Yeni Bulmaca Oluştur" akışı (`POST /lessons/{id}/games`).
///
/// Seçilen oyun türü ve ders için oyun oluşturup yayınlar. Başarıda dönen
/// [GameDto] döner; hata [state]'e `AsyncError` (GamesFailure) olarak taşınır —
/// ekran i18n metnine çevirir. Yetersiz kelime (400) →
/// [GamesFailure.insufficientWords].
///
/// Copied from [CreateGameController].
@ProviderFor(CreateGameController)
final createGameControllerProvider = AutoDisposeNotifierProvider<
  CreateGameController,
  AsyncValue<GameDto?>
>.internal(
  CreateGameController.new,
  name: r'createGameControllerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$createGameControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CreateGameController = AutoDisposeNotifier<AsyncValue<GameDto?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
