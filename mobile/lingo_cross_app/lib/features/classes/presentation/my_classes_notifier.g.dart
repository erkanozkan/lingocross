// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_classes_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myClassesNotifierHash() => r'949f47088ea252b0738cbfac40678b6597a0de6d';

/// Öğrencinin katıldığı sınıfları yöneten async notifier
/// (`GET /api/classes/me`).
///
/// Copied from [MyClassesNotifier].
@ProviderFor(MyClassesNotifier)
final myClassesNotifierProvider = AutoDisposeAsyncNotifierProvider<
  MyClassesNotifier,
  List<ClassMembershipDto>
>.internal(
  MyClassesNotifier.new,
  name: r'myClassesNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$myClassesNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MyClassesNotifier =
    AutoDisposeAsyncNotifier<List<ClassMembershipDto>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
