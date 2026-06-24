// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'students_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$studentsNotifierHash() => r'f1c3ccba0648bdffb60438127fcb62282dbb011a';

/// Öğretmenin öğrenci özetleri (`GET /teachers/me/students`).
///
/// Ada göre alfabetik sıralı (repository sıralar). Boş/yükleniyor/hata
/// durumları ekranda `AsyncValue` üzerinden ele alınır.
///
/// Copied from [StudentsNotifier].
@ProviderFor(StudentsNotifier)
final studentsNotifierProvider = AutoDisposeAsyncNotifierProvider<
  StudentsNotifier,
  List<StudentSummaryDto>
>.internal(
  StudentsNotifier.new,
  name: r'studentsNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$studentsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StudentsNotifier = AutoDisposeAsyncNotifier<List<StudentSummaryDto>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
