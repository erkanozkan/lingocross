// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classes_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$classesNotifierHash() => r'7e050173bad8050c6fe5e3083d0de7f309c3d427';

/// Öğretmenin sınıf listesini yöneten async notifier (`GET /api/classes`).
///
/// Copied from [ClassesNotifier].
@ProviderFor(ClassesNotifier)
final classesNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ClassesNotifier, List<ClassDto>>.internal(
      ClassesNotifier.new,
      name: r'classesNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$classesNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ClassesNotifier = AutoDisposeAsyncNotifier<List<ClassDto>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
