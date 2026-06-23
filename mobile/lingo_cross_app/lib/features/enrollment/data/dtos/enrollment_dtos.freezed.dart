// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'enrollment_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

JoinByCodeRequest _$JoinByCodeRequestFromJson(Map<String, dynamic> json) {
  return _JoinByCodeRequest.fromJson(json);
}

/// @nodoc
mixin _$JoinByCodeRequest {
  String get code => throw _privateConstructorUsedError;

  /// Serializes this JoinByCodeRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JoinByCodeRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JoinByCodeRequestCopyWith<JoinByCodeRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JoinByCodeRequestCopyWith<$Res> {
  factory $JoinByCodeRequestCopyWith(
    JoinByCodeRequest value,
    $Res Function(JoinByCodeRequest) then,
  ) = _$JoinByCodeRequestCopyWithImpl<$Res, JoinByCodeRequest>;
  @useResult
  $Res call({String code});
}

/// @nodoc
class _$JoinByCodeRequestCopyWithImpl<$Res, $Val extends JoinByCodeRequest>
    implements $JoinByCodeRequestCopyWith<$Res> {
  _$JoinByCodeRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JoinByCodeRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? code = null}) {
    return _then(
      _value.copyWith(
            code:
                null == code
                    ? _value.code
                    : code // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$JoinByCodeRequestImplCopyWith<$Res>
    implements $JoinByCodeRequestCopyWith<$Res> {
  factory _$$JoinByCodeRequestImplCopyWith(
    _$JoinByCodeRequestImpl value,
    $Res Function(_$JoinByCodeRequestImpl) then,
  ) = __$$JoinByCodeRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String code});
}

/// @nodoc
class __$$JoinByCodeRequestImplCopyWithImpl<$Res>
    extends _$JoinByCodeRequestCopyWithImpl<$Res, _$JoinByCodeRequestImpl>
    implements _$$JoinByCodeRequestImplCopyWith<$Res> {
  __$$JoinByCodeRequestImplCopyWithImpl(
    _$JoinByCodeRequestImpl _value,
    $Res Function(_$JoinByCodeRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JoinByCodeRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? code = null}) {
    return _then(
      _$JoinByCodeRequestImpl(
        code:
            null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$JoinByCodeRequestImpl implements _JoinByCodeRequest {
  const _$JoinByCodeRequestImpl({required this.code});

  factory _$JoinByCodeRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$JoinByCodeRequestImplFromJson(json);

  @override
  final String code;

  @override
  String toString() {
    return 'JoinByCodeRequest(code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JoinByCodeRequestImpl &&
            (identical(other.code, code) || other.code == code));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code);

  /// Create a copy of JoinByCodeRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JoinByCodeRequestImplCopyWith<_$JoinByCodeRequestImpl> get copyWith =>
      __$$JoinByCodeRequestImplCopyWithImpl<_$JoinByCodeRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$JoinByCodeRequestImplToJson(this);
  }
}

abstract class _JoinByCodeRequest implements JoinByCodeRequest {
  const factory _JoinByCodeRequest({required final String code}) =
      _$JoinByCodeRequestImpl;

  factory _JoinByCodeRequest.fromJson(Map<String, dynamic> json) =
      _$JoinByCodeRequestImpl.fromJson;

  @override
  String get code;

  /// Create a copy of JoinByCodeRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JoinByCodeRequestImplCopyWith<_$JoinByCodeRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InviteCodeDto _$InviteCodeDtoFromJson(Map<String, dynamic> json) {
  return _InviteCodeDto.fromJson(json);
}

/// @nodoc
mixin _$InviteCodeDto {
  String get code => throw _privateConstructorUsedError;

  /// Serializes this InviteCodeDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InviteCodeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InviteCodeDtoCopyWith<InviteCodeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InviteCodeDtoCopyWith<$Res> {
  factory $InviteCodeDtoCopyWith(
    InviteCodeDto value,
    $Res Function(InviteCodeDto) then,
  ) = _$InviteCodeDtoCopyWithImpl<$Res, InviteCodeDto>;
  @useResult
  $Res call({String code});
}

/// @nodoc
class _$InviteCodeDtoCopyWithImpl<$Res, $Val extends InviteCodeDto>
    implements $InviteCodeDtoCopyWith<$Res> {
  _$InviteCodeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InviteCodeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? code = null}) {
    return _then(
      _value.copyWith(
            code:
                null == code
                    ? _value.code
                    : code // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InviteCodeDtoImplCopyWith<$Res>
    implements $InviteCodeDtoCopyWith<$Res> {
  factory _$$InviteCodeDtoImplCopyWith(
    _$InviteCodeDtoImpl value,
    $Res Function(_$InviteCodeDtoImpl) then,
  ) = __$$InviteCodeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String code});
}

/// @nodoc
class __$$InviteCodeDtoImplCopyWithImpl<$Res>
    extends _$InviteCodeDtoCopyWithImpl<$Res, _$InviteCodeDtoImpl>
    implements _$$InviteCodeDtoImplCopyWith<$Res> {
  __$$InviteCodeDtoImplCopyWithImpl(
    _$InviteCodeDtoImpl _value,
    $Res Function(_$InviteCodeDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InviteCodeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? code = null}) {
    return _then(
      _$InviteCodeDtoImpl(
        code:
            null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InviteCodeDtoImpl implements _InviteCodeDto {
  const _$InviteCodeDtoImpl({required this.code});

  factory _$InviteCodeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$InviteCodeDtoImplFromJson(json);

  @override
  final String code;

  @override
  String toString() {
    return 'InviteCodeDto(code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InviteCodeDtoImpl &&
            (identical(other.code, code) || other.code == code));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code);

  /// Create a copy of InviteCodeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InviteCodeDtoImplCopyWith<_$InviteCodeDtoImpl> get copyWith =>
      __$$InviteCodeDtoImplCopyWithImpl<_$InviteCodeDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InviteCodeDtoImplToJson(this);
  }
}

abstract class _InviteCodeDto implements InviteCodeDto {
  const factory _InviteCodeDto({required final String code}) =
      _$InviteCodeDtoImpl;

  factory _InviteCodeDto.fromJson(Map<String, dynamic> json) =
      _$InviteCodeDtoImpl.fromJson;

  @override
  String get code;

  /// Create a copy of InviteCodeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InviteCodeDtoImplCopyWith<_$InviteCodeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EnrollmentDto _$EnrollmentDtoFromJson(Map<String, dynamic> json) {
  return _EnrollmentDto.fromJson(json);
}

/// @nodoc
mixin _$EnrollmentDto {
  String get id => throw _privateConstructorUsedError;
  String get teacherId => throw _privateConstructorUsedError;
  String get studentId => throw _privateConstructorUsedError;
  @EnrollmentStatusConverter()
  EnrollmentStatus get status => throw _privateConstructorUsedError;
  String get counterpartUserId => throw _privateConstructorUsedError;
  String get counterpartDisplayName => throw _privateConstructorUsedError;
  String get counterpartEmail => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this EnrollmentDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EnrollmentDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EnrollmentDtoCopyWith<EnrollmentDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EnrollmentDtoCopyWith<$Res> {
  factory $EnrollmentDtoCopyWith(
    EnrollmentDto value,
    $Res Function(EnrollmentDto) then,
  ) = _$EnrollmentDtoCopyWithImpl<$Res, EnrollmentDto>;
  @useResult
  $Res call({
    String id,
    String teacherId,
    String studentId,
    @EnrollmentStatusConverter() EnrollmentStatus status,
    String counterpartUserId,
    String counterpartDisplayName,
    String counterpartEmail,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$EnrollmentDtoCopyWithImpl<$Res, $Val extends EnrollmentDto>
    implements $EnrollmentDtoCopyWith<$Res> {
  _$EnrollmentDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EnrollmentDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? teacherId = null,
    Object? studentId = null,
    Object? status = null,
    Object? counterpartUserId = null,
    Object? counterpartDisplayName = null,
    Object? counterpartEmail = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            teacherId:
                null == teacherId
                    ? _value.teacherId
                    : teacherId // ignore: cast_nullable_to_non_nullable
                        as String,
            studentId:
                null == studentId
                    ? _value.studentId
                    : studentId // ignore: cast_nullable_to_non_nullable
                        as String,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as EnrollmentStatus,
            counterpartUserId:
                null == counterpartUserId
                    ? _value.counterpartUserId
                    : counterpartUserId // ignore: cast_nullable_to_non_nullable
                        as String,
            counterpartDisplayName:
                null == counterpartDisplayName
                    ? _value.counterpartDisplayName
                    : counterpartDisplayName // ignore: cast_nullable_to_non_nullable
                        as String,
            counterpartEmail:
                null == counterpartEmail
                    ? _value.counterpartEmail
                    : counterpartEmail // ignore: cast_nullable_to_non_nullable
                        as String,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            updatedAt:
                null == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EnrollmentDtoImplCopyWith<$Res>
    implements $EnrollmentDtoCopyWith<$Res> {
  factory _$$EnrollmentDtoImplCopyWith(
    _$EnrollmentDtoImpl value,
    $Res Function(_$EnrollmentDtoImpl) then,
  ) = __$$EnrollmentDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String teacherId,
    String studentId,
    @EnrollmentStatusConverter() EnrollmentStatus status,
    String counterpartUserId,
    String counterpartDisplayName,
    String counterpartEmail,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$EnrollmentDtoImplCopyWithImpl<$Res>
    extends _$EnrollmentDtoCopyWithImpl<$Res, _$EnrollmentDtoImpl>
    implements _$$EnrollmentDtoImplCopyWith<$Res> {
  __$$EnrollmentDtoImplCopyWithImpl(
    _$EnrollmentDtoImpl _value,
    $Res Function(_$EnrollmentDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EnrollmentDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? teacherId = null,
    Object? studentId = null,
    Object? status = null,
    Object? counterpartUserId = null,
    Object? counterpartDisplayName = null,
    Object? counterpartEmail = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$EnrollmentDtoImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        teacherId:
            null == teacherId
                ? _value.teacherId
                : teacherId // ignore: cast_nullable_to_non_nullable
                    as String,
        studentId:
            null == studentId
                ? _value.studentId
                : studentId // ignore: cast_nullable_to_non_nullable
                    as String,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as EnrollmentStatus,
        counterpartUserId:
            null == counterpartUserId
                ? _value.counterpartUserId
                : counterpartUserId // ignore: cast_nullable_to_non_nullable
                    as String,
        counterpartDisplayName:
            null == counterpartDisplayName
                ? _value.counterpartDisplayName
                : counterpartDisplayName // ignore: cast_nullable_to_non_nullable
                    as String,
        counterpartEmail:
            null == counterpartEmail
                ? _value.counterpartEmail
                : counterpartEmail // ignore: cast_nullable_to_non_nullable
                    as String,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        updatedAt:
            null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EnrollmentDtoImpl implements _EnrollmentDto {
  const _$EnrollmentDtoImpl({
    required this.id,
    required this.teacherId,
    required this.studentId,
    @EnrollmentStatusConverter() required this.status,
    required this.counterpartUserId,
    required this.counterpartDisplayName,
    required this.counterpartEmail,
    required this.createdAt,
    required this.updatedAt,
  });

  factory _$EnrollmentDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EnrollmentDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String teacherId;
  @override
  final String studentId;
  @override
  @EnrollmentStatusConverter()
  final EnrollmentStatus status;
  @override
  final String counterpartUserId;
  @override
  final String counterpartDisplayName;
  @override
  final String counterpartEmail;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'EnrollmentDto(id: $id, teacherId: $teacherId, studentId: $studentId, status: $status, counterpartUserId: $counterpartUserId, counterpartDisplayName: $counterpartDisplayName, counterpartEmail: $counterpartEmail, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EnrollmentDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.teacherId, teacherId) ||
                other.teacherId == teacherId) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.counterpartUserId, counterpartUserId) ||
                other.counterpartUserId == counterpartUserId) &&
            (identical(other.counterpartDisplayName, counterpartDisplayName) ||
                other.counterpartDisplayName == counterpartDisplayName) &&
            (identical(other.counterpartEmail, counterpartEmail) ||
                other.counterpartEmail == counterpartEmail) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    teacherId,
    studentId,
    status,
    counterpartUserId,
    counterpartDisplayName,
    counterpartEmail,
    createdAt,
    updatedAt,
  );

  /// Create a copy of EnrollmentDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EnrollmentDtoImplCopyWith<_$EnrollmentDtoImpl> get copyWith =>
      __$$EnrollmentDtoImplCopyWithImpl<_$EnrollmentDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EnrollmentDtoImplToJson(this);
  }
}

abstract class _EnrollmentDto implements EnrollmentDto {
  const factory _EnrollmentDto({
    required final String id,
    required final String teacherId,
    required final String studentId,
    @EnrollmentStatusConverter() required final EnrollmentStatus status,
    required final String counterpartUserId,
    required final String counterpartDisplayName,
    required final String counterpartEmail,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$EnrollmentDtoImpl;

  factory _EnrollmentDto.fromJson(Map<String, dynamic> json) =
      _$EnrollmentDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get teacherId;
  @override
  String get studentId;
  @override
  @EnrollmentStatusConverter()
  EnrollmentStatus get status;
  @override
  String get counterpartUserId;
  @override
  String get counterpartDisplayName;
  @override
  String get counterpartEmail;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of EnrollmentDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EnrollmentDtoImplCopyWith<_$EnrollmentDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
