// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_puzzle_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharePuzzleControllerHash() =>
    r'3e985478da98b2a4cdeba64b48901d593ea86251';

/// Tek bir bulmacayı (yeniden) paylaşan/yayınlayan controller
/// (`POST /api/games/{id}/share`, idempotent).
///
/// Hangi karttan tetiklendiğini ayırmaya gerek yok: sonuç bool olarak döner;
/// ekran başarıda snackbar gösterir + listeyi yeniler. Hata `state.error`'da
/// (GamesFailure) tutulur, ekran i18n mesajına çevirir.
///
/// Copied from [SharePuzzleController].
@ProviderFor(SharePuzzleController)
final sharePuzzleControllerProvider =
    AutoDisposeAsyncNotifierProvider<SharePuzzleController, void>.internal(
      SharePuzzleController.new,
      name: r'sharePuzzleControllerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$sharePuzzleControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SharePuzzleController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
