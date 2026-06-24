// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_stats_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$teacherStatsNotifierHash() =>
    r'6eabbbbc6e99852eaba78f61f990a778c79ffda6';

/// Öğretmen profil istatistikleri (`GET /teachers/me/stats`).
///
/// Yükleniyor/hata/veri durumları ekranda `AsyncValue` ile ele alınır.
///
/// Copied from [TeacherStatsNotifier].
@ProviderFor(TeacherStatsNotifier)
final teacherStatsNotifierProvider = AutoDisposeAsyncNotifierProvider<
  TeacherStatsNotifier,
  TeacherStatsDto
>.internal(
  TeacherStatsNotifier.new,
  name: r'teacherStatsNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$teacherStatsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TeacherStatsNotifier = AutoDisposeAsyncNotifier<TeacherStatsDto>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
