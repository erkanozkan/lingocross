// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'results_history_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$resultsHistoryNotifierHash() =>
    r'4990aad5da7d91ef4679d4dfbaf0aae20d35276b';

/// Öğrencinin geçmiş sonuçları (`GET /results/me`).
///
/// En yeni → en eski sıralı liste (repository sıralar). Boş/yükleniyor/hata
/// durumları ekranda `AsyncValue` üzerinden ele alınır.
///
/// Copied from [ResultsHistoryNotifier].
@ProviderFor(ResultsHistoryNotifier)
final resultsHistoryNotifierProvider = AutoDisposeAsyncNotifierProvider<
  ResultsHistoryNotifier,
  List<GameResultDto>
>.internal(
  ResultsHistoryNotifier.new,
  name: r'resultsHistoryNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$resultsHistoryNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ResultsHistoryNotifier =
    AutoDisposeAsyncNotifier<List<GameResultDto>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
