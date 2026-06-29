// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_progress_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$studentProgressNotifierHash() =>
    r'77f69b72562bf23dd3227860dda2f576b1c1ee92';

/// Öğrenci gelişim özeti (`GET /students/me/progress`).
///
/// Öğrenci panelindeki "Gelişim Özeti" bentosunu besler. Yükleniyor/hata/veri
/// durumları ekranda `AsyncValue` ile ele alınır; pull-to-refresh ile [refresh].
///
/// Copied from [StudentProgressNotifier].
@ProviderFor(StudentProgressNotifier)
final studentProgressNotifierProvider = AutoDisposeAsyncNotifierProvider<
  StudentProgressNotifier,
  StudentProgressDto
>.internal(
  StudentProgressNotifier.new,
  name: r'studentProgressNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$studentProgressNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StudentProgressNotifier =
    AutoDisposeAsyncNotifier<StudentProgressDto>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
