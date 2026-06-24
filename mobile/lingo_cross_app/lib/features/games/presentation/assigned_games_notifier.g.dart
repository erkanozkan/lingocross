// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assigned_games_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$assignedGamesNotifierHash() =>
    r'6e751f111ab035112b1b3e0f7eeb9737aab0f5ed';

/// Öğrenciye atanmış (yayımlanmış) bulmacaları yöneten async notifier
/// (`GET /games/assigned`).
///
/// Öğrenci panelindeki "atanan bulmacalar" bölümünü besler; pull-to-refresh ve
/// öğretmen-yayını sonrası [refresh] ile yeniden yüklenir.
///
/// Copied from [AssignedGamesNotifier].
@ProviderFor(AssignedGamesNotifier)
final assignedGamesNotifierProvider = AutoDisposeAsyncNotifierProvider<
  AssignedGamesNotifier,
  List<AssignedGameDto>
>.internal(
  AssignedGamesNotifier.new,
  name: r'assignedGamesNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$assignedGamesNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AssignedGamesNotifier =
    AutoDisposeAsyncNotifier<List<AssignedGameDto>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
