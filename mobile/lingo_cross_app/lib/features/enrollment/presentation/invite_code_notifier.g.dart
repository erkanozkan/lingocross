// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_code_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$inviteCodeNotifierHash() =>
    r'd6900d24030f60ad794fa1971a65098497b29bb0';

/// Öğretmenin davet kodunu yöneten async notifier
/// (`GET /api/teachers/me/invite-code`). [regenerate] yeni kod üretir
/// (`POST .../regenerate`) ve state'i günceller.
///
/// Copied from [InviteCodeNotifier].
@ProviderFor(InviteCodeNotifier)
final inviteCodeNotifierProvider = AutoDisposeAsyncNotifierProvider<
  InviteCodeNotifier,
  InviteCodeDto
>.internal(
  InviteCodeNotifier.new,
  name: r'inviteCodeNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$inviteCodeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$InviteCodeNotifier = AutoDisposeAsyncNotifier<InviteCodeDto>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
