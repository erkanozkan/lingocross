// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_game_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$startGameControllerHash() =>
    r'dde97ee919d65290d59b590d4eec7275934c39fd';

/// Atanan bir bulmaca için oturum başlatma akışı (öğrenci).
///
/// F2.2: oyunlar artık öğretmen tarafından açıkça oluşturulup yayınlanır; eski
/// "oynarken otomatik üretim" (lessonId → games) akışı kaldırıldı. Öğrenci bir
/// bulmacaya dokununca doğrudan `POST /games/{gameId}/sessions` ile oturum +
/// içerik alınır. Hata [GamesFailure] olarak `AsyncError`'a taşınır (UI i18n
/// metnine çevirir).
///
/// Copied from [StartGameController].
@ProviderFor(StartGameController)
final startGameControllerProvider = AutoDisposeNotifierProvider<
  StartGameController,
  AsyncValue<StartGameSessionResponse?>
>.internal(
  StartGameController.new,
  name: r'startGameControllerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$startGameControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StartGameController =
    AutoDisposeNotifier<AsyncValue<StartGameSessionResponse?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
