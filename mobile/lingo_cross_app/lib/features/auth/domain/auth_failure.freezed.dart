// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AuthFailure {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() invalidCredentials,
    required TResult Function() emailTaken,
    required TResult Function() wrongCurrentPassword,
    required TResult Function() network,
    required TResult Function() unexpected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? invalidCredentials,
    TResult? Function()? emailTaken,
    TResult? Function()? wrongCurrentPassword,
    TResult? Function()? network,
    TResult? Function()? unexpected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? invalidCredentials,
    TResult Function()? emailTaken,
    TResult Function()? wrongCurrentPassword,
    TResult Function()? network,
    TResult Function()? unexpected,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InvalidCredentials value) invalidCredentials,
    required TResult Function(EmailTaken value) emailTaken,
    required TResult Function(WrongCurrentPassword value) wrongCurrentPassword,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(UnexpectedFailure value) unexpected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InvalidCredentials value)? invalidCredentials,
    TResult? Function(EmailTaken value)? emailTaken,
    TResult? Function(WrongCurrentPassword value)? wrongCurrentPassword,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(UnexpectedFailure value)? unexpected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InvalidCredentials value)? invalidCredentials,
    TResult Function(EmailTaken value)? emailTaken,
    TResult Function(WrongCurrentPassword value)? wrongCurrentPassword,
    TResult Function(NetworkFailure value)? network,
    TResult Function(UnexpectedFailure value)? unexpected,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthFailureCopyWith<$Res> {
  factory $AuthFailureCopyWith(
    AuthFailure value,
    $Res Function(AuthFailure) then,
  ) = _$AuthFailureCopyWithImpl<$Res, AuthFailure>;
}

/// @nodoc
class _$AuthFailureCopyWithImpl<$Res, $Val extends AuthFailure>
    implements $AuthFailureCopyWith<$Res> {
  _$AuthFailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InvalidCredentialsImplCopyWith<$Res> {
  factory _$$InvalidCredentialsImplCopyWith(
    _$InvalidCredentialsImpl value,
    $Res Function(_$InvalidCredentialsImpl) then,
  ) = __$$InvalidCredentialsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InvalidCredentialsImplCopyWithImpl<$Res>
    extends _$AuthFailureCopyWithImpl<$Res, _$InvalidCredentialsImpl>
    implements _$$InvalidCredentialsImplCopyWith<$Res> {
  __$$InvalidCredentialsImplCopyWithImpl(
    _$InvalidCredentialsImpl _value,
    $Res Function(_$InvalidCredentialsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InvalidCredentialsImpl implements InvalidCredentials {
  const _$InvalidCredentialsImpl();

  @override
  String toString() {
    return 'AuthFailure.invalidCredentials()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InvalidCredentialsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() invalidCredentials,
    required TResult Function() emailTaken,
    required TResult Function() wrongCurrentPassword,
    required TResult Function() network,
    required TResult Function() unexpected,
  }) {
    return invalidCredentials();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? invalidCredentials,
    TResult? Function()? emailTaken,
    TResult? Function()? wrongCurrentPassword,
    TResult? Function()? network,
    TResult? Function()? unexpected,
  }) {
    return invalidCredentials?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? invalidCredentials,
    TResult Function()? emailTaken,
    TResult Function()? wrongCurrentPassword,
    TResult Function()? network,
    TResult Function()? unexpected,
    required TResult orElse(),
  }) {
    if (invalidCredentials != null) {
      return invalidCredentials();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InvalidCredentials value) invalidCredentials,
    required TResult Function(EmailTaken value) emailTaken,
    required TResult Function(WrongCurrentPassword value) wrongCurrentPassword,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(UnexpectedFailure value) unexpected,
  }) {
    return invalidCredentials(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InvalidCredentials value)? invalidCredentials,
    TResult? Function(EmailTaken value)? emailTaken,
    TResult? Function(WrongCurrentPassword value)? wrongCurrentPassword,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(UnexpectedFailure value)? unexpected,
  }) {
    return invalidCredentials?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InvalidCredentials value)? invalidCredentials,
    TResult Function(EmailTaken value)? emailTaken,
    TResult Function(WrongCurrentPassword value)? wrongCurrentPassword,
    TResult Function(NetworkFailure value)? network,
    TResult Function(UnexpectedFailure value)? unexpected,
    required TResult orElse(),
  }) {
    if (invalidCredentials != null) {
      return invalidCredentials(this);
    }
    return orElse();
  }
}

abstract class InvalidCredentials implements AuthFailure {
  const factory InvalidCredentials() = _$InvalidCredentialsImpl;
}

/// @nodoc
abstract class _$$EmailTakenImplCopyWith<$Res> {
  factory _$$EmailTakenImplCopyWith(
    _$EmailTakenImpl value,
    $Res Function(_$EmailTakenImpl) then,
  ) = __$$EmailTakenImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$EmailTakenImplCopyWithImpl<$Res>
    extends _$AuthFailureCopyWithImpl<$Res, _$EmailTakenImpl>
    implements _$$EmailTakenImplCopyWith<$Res> {
  __$$EmailTakenImplCopyWithImpl(
    _$EmailTakenImpl _value,
    $Res Function(_$EmailTakenImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$EmailTakenImpl implements EmailTaken {
  const _$EmailTakenImpl();

  @override
  String toString() {
    return 'AuthFailure.emailTaken()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$EmailTakenImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() invalidCredentials,
    required TResult Function() emailTaken,
    required TResult Function() wrongCurrentPassword,
    required TResult Function() network,
    required TResult Function() unexpected,
  }) {
    return emailTaken();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? invalidCredentials,
    TResult? Function()? emailTaken,
    TResult? Function()? wrongCurrentPassword,
    TResult? Function()? network,
    TResult? Function()? unexpected,
  }) {
    return emailTaken?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? invalidCredentials,
    TResult Function()? emailTaken,
    TResult Function()? wrongCurrentPassword,
    TResult Function()? network,
    TResult Function()? unexpected,
    required TResult orElse(),
  }) {
    if (emailTaken != null) {
      return emailTaken();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InvalidCredentials value) invalidCredentials,
    required TResult Function(EmailTaken value) emailTaken,
    required TResult Function(WrongCurrentPassword value) wrongCurrentPassword,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(UnexpectedFailure value) unexpected,
  }) {
    return emailTaken(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InvalidCredentials value)? invalidCredentials,
    TResult? Function(EmailTaken value)? emailTaken,
    TResult? Function(WrongCurrentPassword value)? wrongCurrentPassword,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(UnexpectedFailure value)? unexpected,
  }) {
    return emailTaken?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InvalidCredentials value)? invalidCredentials,
    TResult Function(EmailTaken value)? emailTaken,
    TResult Function(WrongCurrentPassword value)? wrongCurrentPassword,
    TResult Function(NetworkFailure value)? network,
    TResult Function(UnexpectedFailure value)? unexpected,
    required TResult orElse(),
  }) {
    if (emailTaken != null) {
      return emailTaken(this);
    }
    return orElse();
  }
}

abstract class EmailTaken implements AuthFailure {
  const factory EmailTaken() = _$EmailTakenImpl;
}

/// @nodoc
abstract class _$$WrongCurrentPasswordImplCopyWith<$Res> {
  factory _$$WrongCurrentPasswordImplCopyWith(
    _$WrongCurrentPasswordImpl value,
    $Res Function(_$WrongCurrentPasswordImpl) then,
  ) = __$$WrongCurrentPasswordImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$WrongCurrentPasswordImplCopyWithImpl<$Res>
    extends _$AuthFailureCopyWithImpl<$Res, _$WrongCurrentPasswordImpl>
    implements _$$WrongCurrentPasswordImplCopyWith<$Res> {
  __$$WrongCurrentPasswordImplCopyWithImpl(
    _$WrongCurrentPasswordImpl _value,
    $Res Function(_$WrongCurrentPasswordImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$WrongCurrentPasswordImpl implements WrongCurrentPassword {
  const _$WrongCurrentPasswordImpl();

  @override
  String toString() {
    return 'AuthFailure.wrongCurrentPassword()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WrongCurrentPasswordImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() invalidCredentials,
    required TResult Function() emailTaken,
    required TResult Function() wrongCurrentPassword,
    required TResult Function() network,
    required TResult Function() unexpected,
  }) {
    return wrongCurrentPassword();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? invalidCredentials,
    TResult? Function()? emailTaken,
    TResult? Function()? wrongCurrentPassword,
    TResult? Function()? network,
    TResult? Function()? unexpected,
  }) {
    return wrongCurrentPassword?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? invalidCredentials,
    TResult Function()? emailTaken,
    TResult Function()? wrongCurrentPassword,
    TResult Function()? network,
    TResult Function()? unexpected,
    required TResult orElse(),
  }) {
    if (wrongCurrentPassword != null) {
      return wrongCurrentPassword();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InvalidCredentials value) invalidCredentials,
    required TResult Function(EmailTaken value) emailTaken,
    required TResult Function(WrongCurrentPassword value) wrongCurrentPassword,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(UnexpectedFailure value) unexpected,
  }) {
    return wrongCurrentPassword(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InvalidCredentials value)? invalidCredentials,
    TResult? Function(EmailTaken value)? emailTaken,
    TResult? Function(WrongCurrentPassword value)? wrongCurrentPassword,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(UnexpectedFailure value)? unexpected,
  }) {
    return wrongCurrentPassword?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InvalidCredentials value)? invalidCredentials,
    TResult Function(EmailTaken value)? emailTaken,
    TResult Function(WrongCurrentPassword value)? wrongCurrentPassword,
    TResult Function(NetworkFailure value)? network,
    TResult Function(UnexpectedFailure value)? unexpected,
    required TResult orElse(),
  }) {
    if (wrongCurrentPassword != null) {
      return wrongCurrentPassword(this);
    }
    return orElse();
  }
}

abstract class WrongCurrentPassword implements AuthFailure {
  const factory WrongCurrentPassword() = _$WrongCurrentPasswordImpl;
}

/// @nodoc
abstract class _$$NetworkFailureImplCopyWith<$Res> {
  factory _$$NetworkFailureImplCopyWith(
    _$NetworkFailureImpl value,
    $Res Function(_$NetworkFailureImpl) then,
  ) = __$$NetworkFailureImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NetworkFailureImplCopyWithImpl<$Res>
    extends _$AuthFailureCopyWithImpl<$Res, _$NetworkFailureImpl>
    implements _$$NetworkFailureImplCopyWith<$Res> {
  __$$NetworkFailureImplCopyWithImpl(
    _$NetworkFailureImpl _value,
    $Res Function(_$NetworkFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$NetworkFailureImpl implements NetworkFailure {
  const _$NetworkFailureImpl();

  @override
  String toString() {
    return 'AuthFailure.network()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$NetworkFailureImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() invalidCredentials,
    required TResult Function() emailTaken,
    required TResult Function() wrongCurrentPassword,
    required TResult Function() network,
    required TResult Function() unexpected,
  }) {
    return network();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? invalidCredentials,
    TResult? Function()? emailTaken,
    TResult? Function()? wrongCurrentPassword,
    TResult? Function()? network,
    TResult? Function()? unexpected,
  }) {
    return network?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? invalidCredentials,
    TResult Function()? emailTaken,
    TResult Function()? wrongCurrentPassword,
    TResult Function()? network,
    TResult Function()? unexpected,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InvalidCredentials value) invalidCredentials,
    required TResult Function(EmailTaken value) emailTaken,
    required TResult Function(WrongCurrentPassword value) wrongCurrentPassword,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(UnexpectedFailure value) unexpected,
  }) {
    return network(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InvalidCredentials value)? invalidCredentials,
    TResult? Function(EmailTaken value)? emailTaken,
    TResult? Function(WrongCurrentPassword value)? wrongCurrentPassword,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(UnexpectedFailure value)? unexpected,
  }) {
    return network?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InvalidCredentials value)? invalidCredentials,
    TResult Function(EmailTaken value)? emailTaken,
    TResult Function(WrongCurrentPassword value)? wrongCurrentPassword,
    TResult Function(NetworkFailure value)? network,
    TResult Function(UnexpectedFailure value)? unexpected,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(this);
    }
    return orElse();
  }
}

abstract class NetworkFailure implements AuthFailure {
  const factory NetworkFailure() = _$NetworkFailureImpl;
}

/// @nodoc
abstract class _$$UnexpectedFailureImplCopyWith<$Res> {
  factory _$$UnexpectedFailureImplCopyWith(
    _$UnexpectedFailureImpl value,
    $Res Function(_$UnexpectedFailureImpl) then,
  ) = __$$UnexpectedFailureImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UnexpectedFailureImplCopyWithImpl<$Res>
    extends _$AuthFailureCopyWithImpl<$Res, _$UnexpectedFailureImpl>
    implements _$$UnexpectedFailureImplCopyWith<$Res> {
  __$$UnexpectedFailureImplCopyWithImpl(
    _$UnexpectedFailureImpl _value,
    $Res Function(_$UnexpectedFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UnexpectedFailureImpl implements UnexpectedFailure {
  const _$UnexpectedFailureImpl();

  @override
  String toString() {
    return 'AuthFailure.unexpected()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UnexpectedFailureImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() invalidCredentials,
    required TResult Function() emailTaken,
    required TResult Function() wrongCurrentPassword,
    required TResult Function() network,
    required TResult Function() unexpected,
  }) {
    return unexpected();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? invalidCredentials,
    TResult? Function()? emailTaken,
    TResult? Function()? wrongCurrentPassword,
    TResult? Function()? network,
    TResult? Function()? unexpected,
  }) {
    return unexpected?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? invalidCredentials,
    TResult Function()? emailTaken,
    TResult Function()? wrongCurrentPassword,
    TResult Function()? network,
    TResult Function()? unexpected,
    required TResult orElse(),
  }) {
    if (unexpected != null) {
      return unexpected();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InvalidCredentials value) invalidCredentials,
    required TResult Function(EmailTaken value) emailTaken,
    required TResult Function(WrongCurrentPassword value) wrongCurrentPassword,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(UnexpectedFailure value) unexpected,
  }) {
    return unexpected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InvalidCredentials value)? invalidCredentials,
    TResult? Function(EmailTaken value)? emailTaken,
    TResult? Function(WrongCurrentPassword value)? wrongCurrentPassword,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(UnexpectedFailure value)? unexpected,
  }) {
    return unexpected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InvalidCredentials value)? invalidCredentials,
    TResult Function(EmailTaken value)? emailTaken,
    TResult Function(WrongCurrentPassword value)? wrongCurrentPassword,
    TResult Function(NetworkFailure value)? network,
    TResult Function(UnexpectedFailure value)? unexpected,
    required TResult orElse(),
  }) {
    if (unexpected != null) {
      return unexpected(this);
    }
    return orElse();
  }
}

abstract class UnexpectedFailure implements AuthFailure {
  const factory UnexpectedFailure() = _$UnexpectedFailureImpl;
}
