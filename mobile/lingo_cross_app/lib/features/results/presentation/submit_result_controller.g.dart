// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_result_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$submitResultControllerHash() =>
    r'37c8358f8f49596c31ee43feb76b319314ad52a5';

/// Oyun bitince sonuç gönderim akışı (öğrenci).
///
/// `POST /game-sessions/{sessionId}/result` ile süre + doğru/toplam gönderir;
/// başarıda hesaplanmış [GameResultDto] döner (rapor ekranına taşınır). Hata
/// [ResultsFailure] olarak `AsyncError`'a taşınır (UI i18n metnine çevirir, tekrar
/// dene sunar).
///
/// Copied from [SubmitResultController].
@ProviderFor(SubmitResultController)
final submitResultControllerProvider = AutoDisposeNotifierProvider<
  SubmitResultController,
  AsyncValue<GameResultDto?>
>.internal(
  SubmitResultController.new,
  name: r'submitResultControllerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$submitResultControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SubmitResultController =
    AutoDisposeNotifier<AsyncValue<GameResultDto?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
