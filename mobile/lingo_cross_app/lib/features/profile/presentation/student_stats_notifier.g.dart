// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_stats_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$studentStatsNotifierHash() =>
    r'e53a1ccaa48b945eea20901a98cc818445ab105a';

/// Öğrenci profil istatistikleri (`GET /students/me/stats`).
///
/// Yükleniyor/hata/veri durumları ekranda `AsyncValue` ile ele alınır.
///
/// Copied from [StudentStatsNotifier].
@ProviderFor(StudentStatsNotifier)
final studentStatsNotifierProvider = AutoDisposeAsyncNotifierProvider<
  StudentStatsNotifier,
  StudentStatsDto
>.internal(
  StudentStatsNotifier.new,
  name: r'studentStatsNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$studentStatsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StudentStatsNotifier = AutoDisposeAsyncNotifier<StudentStatsDto>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
