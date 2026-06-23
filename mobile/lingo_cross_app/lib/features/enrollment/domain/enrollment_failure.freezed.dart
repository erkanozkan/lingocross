// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'enrollment_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$EnrollmentFailure {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() network,
    required TResult Function() invalidCode,
    required TResult Function() expiredCode,
    required TResult Function() forbidden,
    required TResult Function() unexpected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? network,
    TResult? Function()? invalidCode,
    TResult? Function()? expiredCode,
    TResult? Function()? forbidden,
    TResult? Function()? unexpected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? network,
    TResult Function()? invalidCode,
    TResult Function()? expiredCode,
    TResult Function()? forbidden,
    TResult Function()? unexpected,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Network value) network,
    required TResult Function(_InvalidCode value) invalidCode,
    required TResult Function(_ExpiredCode value) expiredCode,
    required TResult Function(_Forbidden value) forbidden,
    required TResult Function(_Unexpected value) unexpected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Network value)? network,
    TResult? Function(_InvalidCode value)? invalidCode,
    TResult? Function(_ExpiredCode value)? expiredCode,
    TResult? Function(_Forbidden value)? forbidden,
    TResult? Function(_Unexpected value)? unexpected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Network value)? network,
    TResult Function(_InvalidCode value)? invalidCode,
    TResult Function(_ExpiredCode value)? expiredCode,
    TResult Function(_Forbidden value)? forbidden,
    TResult Function(_Unexpected value)? unexpected,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EnrollmentFailureCopyWith<$Res> {
  factory $EnrollmentFailureCopyWith(
    EnrollmentFailure value,
    $Res Function(EnrollmentFailure) then,
  ) = _$EnrollmentFailureCopyWithImpl<$Res, EnrollmentFailure>;
}

/// @nodoc
class _$EnrollmentFailureCopyWithImpl<$Res, $Val extends EnrollmentFailure>
    implements $EnrollmentFailureCopyWith<$Res> {
  _$EnrollmentFailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EnrollmentFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$NetworkImplCopyWith<$Res> {
  factory _$$NetworkImplCopyWith(
    _$NetworkImpl value,
    $Res Function(_$NetworkImpl) then,
  ) = __$$NetworkImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NetworkImplCopyWithImpl<$Res>
    extends _$EnrollmentFailureCopyWithImpl<$Res, _$NetworkImpl>
    implements _$$NetworkImplCopyWith<$Res> {
  __$$NetworkImplCopyWithImpl(
    _$NetworkImpl _value,
    $Res Function(_$NetworkImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EnrollmentFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$NetworkImpl implements _Network {
  const _$NetworkImpl();

  @override
  String toString() {
    return 'EnrollmentFailure.network()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$NetworkImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() network,
    required TResult Function() invalidCode,
    required TResult Function() expiredCode,
    required TResult Function() forbidden,
    required TResult Function() unexpected,
  }) {
    return network();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? network,
    TResult? Function()? invalidCode,
    TResult? Function()? expiredCode,
    TResult? Function()? forbidden,
    TResult? Function()? unexpected,
  }) {
    return network?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? network,
    TResult Function()? invalidCode,
    TResult Function()? expiredCode,
    TResult Function()? forbidden,
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
    required TResult Function(_Network value) network,
    required TResult Function(_InvalidCode value) invalidCode,
    required TResult Function(_ExpiredCode value) expiredCode,
    required TResult Function(_Forbidden value) forbidden,
    required TResult Function(_Unexpected value) unexpected,
  }) {
    return network(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Network value)? network,
    TResult? Function(_InvalidCode value)? invalidCode,
    TResult? Function(_ExpiredCode value)? expiredCode,
    TResult? Function(_Forbidden value)? forbidden,
    TResult? Function(_Unexpected value)? unexpected,
  }) {
    return network?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Network value)? network,
    TResult Function(_InvalidCode value)? invalidCode,
    TResult Function(_ExpiredCode value)? expiredCode,
    TResult Function(_Forbidden value)? forbidden,
    TResult Function(_Unexpected value)? unexpected,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(this);
    }
    return orElse();
  }
}

abstract class _Network implements EnrollmentFailure {
  const factory _Network() = _$NetworkImpl;
}

/// @nodoc
abstract class _$$InvalidCodeImplCopyWith<$Res> {
  factory _$$InvalidCodeImplCopyWith(
    _$InvalidCodeImpl value,
    $Res Function(_$InvalidCodeImpl) then,
  ) = __$$InvalidCodeImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InvalidCodeImplCopyWithImpl<$Res>
    extends _$EnrollmentFailureCopyWithImpl<$Res, _$InvalidCodeImpl>
    implements _$$InvalidCodeImplCopyWith<$Res> {
  __$$InvalidCodeImplCopyWithImpl(
    _$InvalidCodeImpl _value,
    $Res Function(_$InvalidCodeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EnrollmentFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InvalidCodeImpl implements _InvalidCode {
  const _$InvalidCodeImpl();

  @override
  String toString() {
    return 'EnrollmentFailure.invalidCode()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InvalidCodeImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() network,
    required TResult Function() invalidCode,
    required TResult Function() expiredCode,
    required TResult Function() forbidden,
    required TResult Function() unexpected,
  }) {
    return invalidCode();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? network,
    TResult? Function()? invalidCode,
    TResult? Function()? expiredCode,
    TResult? Function()? forbidden,
    TResult? Function()? unexpected,
  }) {
    return invalidCode?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? network,
    TResult Function()? invalidCode,
    TResult Function()? expiredCode,
    TResult Function()? forbidden,
    TResult Function()? unexpected,
    required TResult orElse(),
  }) {
    if (invalidCode != null) {
      return invalidCode();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Network value) network,
    required TResult Function(_InvalidCode value) invalidCode,
    required TResult Function(_ExpiredCode value) expiredCode,
    required TResult Function(_Forbidden value) forbidden,
    required TResult Function(_Unexpected value) unexpected,
  }) {
    return invalidCode(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Network value)? network,
    TResult? Function(_InvalidCode value)? invalidCode,
    TResult? Function(_ExpiredCode value)? expiredCode,
    TResult? Function(_Forbidden value)? forbidden,
    TResult? Function(_Unexpected value)? unexpected,
  }) {
    return invalidCode?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Network value)? network,
    TResult Function(_InvalidCode value)? invalidCode,
    TResult Function(_ExpiredCode value)? expiredCode,
    TResult Function(_Forbidden value)? forbidden,
    TResult Function(_Unexpected value)? unexpected,
    required TResult orElse(),
  }) {
    if (invalidCode != null) {
      return invalidCode(this);
    }
    return orElse();
  }
}

abstract class _InvalidCode implements EnrollmentFailure {
  const factory _InvalidCode() = _$InvalidCodeImpl;
}

/// @nodoc
abstract class _$$ExpiredCodeImplCopyWith<$Res> {
  factory _$$ExpiredCodeImplCopyWith(
    _$ExpiredCodeImpl value,
    $Res Function(_$ExpiredCodeImpl) then,
  ) = __$$ExpiredCodeImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ExpiredCodeImplCopyWithImpl<$Res>
    extends _$EnrollmentFailureCopyWithImpl<$Res, _$ExpiredCodeImpl>
    implements _$$ExpiredCodeImplCopyWith<$Res> {
  __$$ExpiredCodeImplCopyWithImpl(
    _$ExpiredCodeImpl _value,
    $Res Function(_$ExpiredCodeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EnrollmentFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ExpiredCodeImpl implements _ExpiredCode {
  const _$ExpiredCodeImpl();

  @override
  String toString() {
    return 'EnrollmentFailure.expiredCode()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ExpiredCodeImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() network,
    required TResult Function() invalidCode,
    required TResult Function() expiredCode,
    required TResult Function() forbidden,
    required TResult Function() unexpected,
  }) {
    return expiredCode();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? network,
    TResult? Function()? invalidCode,
    TResult? Function()? expiredCode,
    TResult? Function()? forbidden,
    TResult? Function()? unexpected,
  }) {
    return expiredCode?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? network,
    TResult Function()? invalidCode,
    TResult Function()? expiredCode,
    TResult Function()? forbidden,
    TResult Function()? unexpected,
    required TResult orElse(),
  }) {
    if (expiredCode != null) {
      return expiredCode();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Network value) network,
    required TResult Function(_InvalidCode value) invalidCode,
    required TResult Function(_ExpiredCode value) expiredCode,
    required TResult Function(_Forbidden value) forbidden,
    required TResult Function(_Unexpected value) unexpected,
  }) {
    return expiredCode(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Network value)? network,
    TResult? Function(_InvalidCode value)? invalidCode,
    TResult? Function(_ExpiredCode value)? expiredCode,
    TResult? Function(_Forbidden value)? forbidden,
    TResult? Function(_Unexpected value)? unexpected,
  }) {
    return expiredCode?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Network value)? network,
    TResult Function(_InvalidCode value)? invalidCode,
    TResult Function(_ExpiredCode value)? expiredCode,
    TResult Function(_Forbidden value)? forbidden,
    TResult Function(_Unexpected value)? unexpected,
    required TResult orElse(),
  }) {
    if (expiredCode != null) {
      return expiredCode(this);
    }
    return orElse();
  }
}

abstract class _ExpiredCode implements EnrollmentFailure {
  const factory _ExpiredCode() = _$ExpiredCodeImpl;
}

/// @nodoc
abstract class _$$ForbiddenImplCopyWith<$Res> {
  factory _$$ForbiddenImplCopyWith(
    _$ForbiddenImpl value,
    $Res Function(_$ForbiddenImpl) then,
  ) = __$$ForbiddenImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ForbiddenImplCopyWithImpl<$Res>
    extends _$EnrollmentFailureCopyWithImpl<$Res, _$ForbiddenImpl>
    implements _$$ForbiddenImplCopyWith<$Res> {
  __$$ForbiddenImplCopyWithImpl(
    _$ForbiddenImpl _value,
    $Res Function(_$ForbiddenImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EnrollmentFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ForbiddenImpl implements _Forbidden {
  const _$ForbiddenImpl();

  @override
  String toString() {
    return 'EnrollmentFailure.forbidden()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ForbiddenImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() network,
    required TResult Function() invalidCode,
    required TResult Function() expiredCode,
    required TResult Function() forbidden,
    required TResult Function() unexpected,
  }) {
    return forbidden();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? network,
    TResult? Function()? invalidCode,
    TResult? Function()? expiredCode,
    TResult? Function()? forbidden,
    TResult? Function()? unexpected,
  }) {
    return forbidden?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? network,
    TResult Function()? invalidCode,
    TResult Function()? expiredCode,
    TResult Function()? forbidden,
    TResult Function()? unexpected,
    required TResult orElse(),
  }) {
    if (forbidden != null) {
      return forbidden();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Network value) network,
    required TResult Function(_InvalidCode value) invalidCode,
    required TResult Function(_ExpiredCode value) expiredCode,
    required TResult Function(_Forbidden value) forbidden,
    required TResult Function(_Unexpected value) unexpected,
  }) {
    return forbidden(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Network value)? network,
    TResult? Function(_InvalidCode value)? invalidCode,
    TResult? Function(_ExpiredCode value)? expiredCode,
    TResult? Function(_Forbidden value)? forbidden,
    TResult? Function(_Unexpected value)? unexpected,
  }) {
    return forbidden?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Network value)? network,
    TResult Function(_InvalidCode value)? invalidCode,
    TResult Function(_ExpiredCode value)? expiredCode,
    TResult Function(_Forbidden value)? forbidden,
    TResult Function(_Unexpected value)? unexpected,
    required TResult orElse(),
  }) {
    if (forbidden != null) {
      return forbidden(this);
    }
    return orElse();
  }
}

abstract class _Forbidden implements EnrollmentFailure {
  const factory _Forbidden() = _$ForbiddenImpl;
}

/// @nodoc
abstract class _$$UnexpectedImplCopyWith<$Res> {
  factory _$$UnexpectedImplCopyWith(
    _$UnexpectedImpl value,
    $Res Function(_$UnexpectedImpl) then,
  ) = __$$UnexpectedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UnexpectedImplCopyWithImpl<$Res>
    extends _$EnrollmentFailureCopyWithImpl<$Res, _$UnexpectedImpl>
    implements _$$UnexpectedImplCopyWith<$Res> {
  __$$UnexpectedImplCopyWithImpl(
    _$UnexpectedImpl _value,
    $Res Function(_$UnexpectedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EnrollmentFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UnexpectedImpl implements _Unexpected {
  const _$UnexpectedImpl();

  @override
  String toString() {
    return 'EnrollmentFailure.unexpected()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UnexpectedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() network,
    required TResult Function() invalidCode,
    required TResult Function() expiredCode,
    required TResult Function() forbidden,
    required TResult Function() unexpected,
  }) {
    return unexpected();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? network,
    TResult? Function()? invalidCode,
    TResult? Function()? expiredCode,
    TResult? Function()? forbidden,
    TResult? Function()? unexpected,
  }) {
    return unexpected?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? network,
    TResult Function()? invalidCode,
    TResult Function()? expiredCode,
    TResult Function()? forbidden,
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
    required TResult Function(_Network value) network,
    required TResult Function(_InvalidCode value) invalidCode,
    required TResult Function(_ExpiredCode value) expiredCode,
    required TResult Function(_Forbidden value) forbidden,
    required TResult Function(_Unexpected value) unexpected,
  }) {
    return unexpected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Network value)? network,
    TResult? Function(_InvalidCode value)? invalidCode,
    TResult? Function(_ExpiredCode value)? expiredCode,
    TResult? Function(_Forbidden value)? forbidden,
    TResult? Function(_Unexpected value)? unexpected,
  }) {
    return unexpected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Network value)? network,
    TResult Function(_InvalidCode value)? invalidCode,
    TResult Function(_ExpiredCode value)? expiredCode,
    TResult Function(_Forbidden value)? forbidden,
    TResult Function(_Unexpected value)? unexpected,
    required TResult orElse(),
  }) {
    if (unexpected != null) {
      return unexpected(this);
    }
    return orElse();
  }
}

abstract class _Unexpected implements EnrollmentFailure {
  const factory _Unexpected() = _$UnexpectedImpl;
}
