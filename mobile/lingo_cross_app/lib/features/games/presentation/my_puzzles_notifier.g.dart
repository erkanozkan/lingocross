// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_puzzles_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myPuzzlesNotifierHash() => r'48b2d3b93ea6895487fd5d39eef34b7fa5e2a5b6';

/// Öğretmenin "Bulmacalarım" listesini yöneten async notifier
/// (`GET /api/teachers/me/games`).
///
/// Ekran `AsyncValue` üzerinden loading/error/data durumlarını çözer.
/// Paylaşım sonrası [refresh] ile yeniden yüklenir (solveCount/atama güncel).
///
/// Copied from [MyPuzzlesNotifier].
@ProviderFor(MyPuzzlesNotifier)
final myPuzzlesNotifierProvider = AutoDisposeAsyncNotifierProvider<
  MyPuzzlesNotifier,
  List<TeacherPuzzleDto>
>.internal(
  MyPuzzlesNotifier.new,
  name: r'myPuzzlesNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$myPuzzlesNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MyPuzzlesNotifier = AutoDisposeAsyncNotifier<List<TeacherPuzzleDto>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
