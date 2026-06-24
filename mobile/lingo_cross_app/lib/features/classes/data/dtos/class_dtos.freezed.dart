// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'class_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ClassDto _$ClassDtoFromJson(Map<String, dynamic> json) {
  return _ClassDto.fromJson(json);
}

/// @nodoc
mixin _$ClassDto {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get inviteCode => throw _privateConstructorUsedError;
  int get studentCount => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ClassDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClassDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClassDtoCopyWith<ClassDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClassDtoCopyWith<$Res> {
  factory $ClassDtoCopyWith(ClassDto value, $Res Function(ClassDto) then) =
      _$ClassDtoCopyWithImpl<$Res, ClassDto>;
  @useResult
  $Res call({
    String id,
    String name,
    String? inviteCode,
    int studentCount,
    DateTime createdAt,
  });
}

/// @nodoc
class _$ClassDtoCopyWithImpl<$Res, $Val extends ClassDto>
    implements $ClassDtoCopyWith<$Res> {
  _$ClassDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClassDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? inviteCode = freezed,
    Object? studentCount = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            inviteCode:
                freezed == inviteCode
                    ? _value.inviteCode
                    : inviteCode // ignore: cast_nullable_to_non_nullable
                        as String?,
            studentCount:
                null == studentCount
                    ? _value.studentCount
                    : studentCount // ignore: cast_nullable_to_non_nullable
                        as int,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ClassDtoImplCopyWith<$Res>
    implements $ClassDtoCopyWith<$Res> {
  factory _$$ClassDtoImplCopyWith(
    _$ClassDtoImpl value,
    $Res Function(_$ClassDtoImpl) then,
  ) = __$$ClassDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? inviteCode,
    int studentCount,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$ClassDtoImplCopyWithImpl<$Res>
    extends _$ClassDtoCopyWithImpl<$Res, _$ClassDtoImpl>
    implements _$$ClassDtoImplCopyWith<$Res> {
  __$$ClassDtoImplCopyWithImpl(
    _$ClassDtoImpl _value,
    $Res Function(_$ClassDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ClassDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? inviteCode = freezed,
    Object? studentCount = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$ClassDtoImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        inviteCode:
            freezed == inviteCode
                ? _value.inviteCode
                : inviteCode // ignore: cast_nullable_to_non_nullable
                    as String?,
        studentCount:
            null == studentCount
                ? _value.studentCount
                : studentCount // ignore: cast_nullable_to_non_nullable
                    as int,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ClassDtoImpl implements _ClassDto {
  const _$ClassDtoImpl({
    required this.id,
    required this.name,
    this.inviteCode,
    required this.studentCount,
    required this.createdAt,
  });

  factory _$ClassDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClassDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? inviteCode;
  @override
  final int studentCount;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ClassDto(id: $id, name: $name, inviteCode: $inviteCode, studentCount: $studentCount, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClassDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.inviteCode, inviteCode) ||
                other.inviteCode == inviteCode) &&
            (identical(other.studentCount, studentCount) ||
                other.studentCount == studentCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, inviteCode, studentCount, createdAt);

  /// Create a copy of ClassDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClassDtoImplCopyWith<_$ClassDtoImpl> get copyWith =>
      __$$ClassDtoImplCopyWithImpl<_$ClassDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClassDtoImplToJson(this);
  }
}

abstract class _ClassDto implements ClassDto {
  const factory _ClassDto({
    required final String id,
    required final String name,
    final String? inviteCode,
    required final int studentCount,
    required final DateTime createdAt,
  }) = _$ClassDtoImpl;

  factory _ClassDto.fromJson(Map<String, dynamic> json) =
      _$ClassDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get inviteCode;
  @override
  int get studentCount;
  @override
  DateTime get createdAt;

  /// Create a copy of ClassDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClassDtoImplCopyWith<_$ClassDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ClassMemberDto _$ClassMemberDtoFromJson(Map<String, dynamic> json) {
  return _ClassMemberDto.fromJson(json);
}

/// @nodoc
mixin _$ClassMemberDto {
  String get studentId => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;

  /// Serializes this ClassMemberDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClassMemberDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClassMemberDtoCopyWith<ClassMemberDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClassMemberDtoCopyWith<$Res> {
  factory $ClassMemberDtoCopyWith(
    ClassMemberDto value,
    $Res Function(ClassMemberDto) then,
  ) = _$ClassMemberDtoCopyWithImpl<$Res, ClassMemberDto>;
  @useResult
  $Res call({String studentId, String displayName, String email});
}

/// @nodoc
class _$ClassMemberDtoCopyWithImpl<$Res, $Val extends ClassMemberDto>
    implements $ClassMemberDtoCopyWith<$Res> {
  _$ClassMemberDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClassMemberDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? studentId = null,
    Object? displayName = null,
    Object? email = null,
  }) {
    return _then(
      _value.copyWith(
            studentId:
                null == studentId
                    ? _value.studentId
                    : studentId // ignore: cast_nullable_to_non_nullable
                        as String,
            displayName:
                null == displayName
                    ? _value.displayName
                    : displayName // ignore: cast_nullable_to_non_nullable
                        as String,
            email:
                null == email
                    ? _value.email
                    : email // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ClassMemberDtoImplCopyWith<$Res>
    implements $ClassMemberDtoCopyWith<$Res> {
  factory _$$ClassMemberDtoImplCopyWith(
    _$ClassMemberDtoImpl value,
    $Res Function(_$ClassMemberDtoImpl) then,
  ) = __$$ClassMemberDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String studentId, String displayName, String email});
}

/// @nodoc
class __$$ClassMemberDtoImplCopyWithImpl<$Res>
    extends _$ClassMemberDtoCopyWithImpl<$Res, _$ClassMemberDtoImpl>
    implements _$$ClassMemberDtoImplCopyWith<$Res> {
  __$$ClassMemberDtoImplCopyWithImpl(
    _$ClassMemberDtoImpl _value,
    $Res Function(_$ClassMemberDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ClassMemberDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? studentId = null,
    Object? displayName = null,
    Object? email = null,
  }) {
    return _then(
      _$ClassMemberDtoImpl(
        studentId:
            null == studentId
                ? _value.studentId
                : studentId // ignore: cast_nullable_to_non_nullable
                    as String,
        displayName:
            null == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                    as String,
        email:
            null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ClassMemberDtoImpl implements _ClassMemberDto {
  const _$ClassMemberDtoImpl({
    required this.studentId,
    required this.displayName,
    required this.email,
  });

  factory _$ClassMemberDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClassMemberDtoImplFromJson(json);

  @override
  final String studentId;
  @override
  final String displayName;
  @override
  final String email;

  @override
  String toString() {
    return 'ClassMemberDto(studentId: $studentId, displayName: $displayName, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClassMemberDtoImpl &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, studentId, displayName, email);

  /// Create a copy of ClassMemberDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClassMemberDtoImplCopyWith<_$ClassMemberDtoImpl> get copyWith =>
      __$$ClassMemberDtoImplCopyWithImpl<_$ClassMemberDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ClassMemberDtoImplToJson(this);
  }
}

abstract class _ClassMemberDto implements ClassMemberDto {
  const factory _ClassMemberDto({
    required final String studentId,
    required final String displayName,
    required final String email,
  }) = _$ClassMemberDtoImpl;

  factory _ClassMemberDto.fromJson(Map<String, dynamic> json) =
      _$ClassMemberDtoImpl.fromJson;

  @override
  String get studentId;
  @override
  String get displayName;
  @override
  String get email;

  /// Create a copy of ClassMemberDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClassMemberDtoImplCopyWith<_$ClassMemberDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ClassDetailDto _$ClassDetailDtoFromJson(Map<String, dynamic> json) {
  return _ClassDetailDto.fromJson(json);
}

/// @nodoc
mixin _$ClassDetailDto {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get inviteCode => throw _privateConstructorUsedError;
  int get studentCount => throw _privateConstructorUsedError;
  List<ClassMemberDto> get students => throw _privateConstructorUsedError;

  /// Serializes this ClassDetailDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClassDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClassDetailDtoCopyWith<ClassDetailDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClassDetailDtoCopyWith<$Res> {
  factory $ClassDetailDtoCopyWith(
    ClassDetailDto value,
    $Res Function(ClassDetailDto) then,
  ) = _$ClassDetailDtoCopyWithImpl<$Res, ClassDetailDto>;
  @useResult
  $Res call({
    String id,
    String name,
    String? inviteCode,
    int studentCount,
    List<ClassMemberDto> students,
  });
}

/// @nodoc
class _$ClassDetailDtoCopyWithImpl<$Res, $Val extends ClassDetailDto>
    implements $ClassDetailDtoCopyWith<$Res> {
  _$ClassDetailDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClassDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? inviteCode = freezed,
    Object? studentCount = null,
    Object? students = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            inviteCode:
                freezed == inviteCode
                    ? _value.inviteCode
                    : inviteCode // ignore: cast_nullable_to_non_nullable
                        as String?,
            studentCount:
                null == studentCount
                    ? _value.studentCount
                    : studentCount // ignore: cast_nullable_to_non_nullable
                        as int,
            students:
                null == students
                    ? _value.students
                    : students // ignore: cast_nullable_to_non_nullable
                        as List<ClassMemberDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ClassDetailDtoImplCopyWith<$Res>
    implements $ClassDetailDtoCopyWith<$Res> {
  factory _$$ClassDetailDtoImplCopyWith(
    _$ClassDetailDtoImpl value,
    $Res Function(_$ClassDetailDtoImpl) then,
  ) = __$$ClassDetailDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? inviteCode,
    int studentCount,
    List<ClassMemberDto> students,
  });
}

/// @nodoc
class __$$ClassDetailDtoImplCopyWithImpl<$Res>
    extends _$ClassDetailDtoCopyWithImpl<$Res, _$ClassDetailDtoImpl>
    implements _$$ClassDetailDtoImplCopyWith<$Res> {
  __$$ClassDetailDtoImplCopyWithImpl(
    _$ClassDetailDtoImpl _value,
    $Res Function(_$ClassDetailDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ClassDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? inviteCode = freezed,
    Object? studentCount = null,
    Object? students = null,
  }) {
    return _then(
      _$ClassDetailDtoImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        inviteCode:
            freezed == inviteCode
                ? _value.inviteCode
                : inviteCode // ignore: cast_nullable_to_non_nullable
                    as String?,
        studentCount:
            null == studentCount
                ? _value.studentCount
                : studentCount // ignore: cast_nullable_to_non_nullable
                    as int,
        students:
            null == students
                ? _value._students
                : students // ignore: cast_nullable_to_non_nullable
                    as List<ClassMemberDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ClassDetailDtoImpl implements _ClassDetailDto {
  const _$ClassDetailDtoImpl({
    required this.id,
    required this.name,
    this.inviteCode,
    required this.studentCount,
    required final List<ClassMemberDto> students,
  }) : _students = students;

  factory _$ClassDetailDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClassDetailDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? inviteCode;
  @override
  final int studentCount;
  final List<ClassMemberDto> _students;
  @override
  List<ClassMemberDto> get students {
    if (_students is EqualUnmodifiableListView) return _students;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_students);
  }

  @override
  String toString() {
    return 'ClassDetailDto(id: $id, name: $name, inviteCode: $inviteCode, studentCount: $studentCount, students: $students)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClassDetailDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.inviteCode, inviteCode) ||
                other.inviteCode == inviteCode) &&
            (identical(other.studentCount, studentCount) ||
                other.studentCount == studentCount) &&
            const DeepCollectionEquality().equals(other._students, _students));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    inviteCode,
    studentCount,
    const DeepCollectionEquality().hash(_students),
  );

  /// Create a copy of ClassDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClassDetailDtoImplCopyWith<_$ClassDetailDtoImpl> get copyWith =>
      __$$ClassDetailDtoImplCopyWithImpl<_$ClassDetailDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ClassDetailDtoImplToJson(this);
  }
}

abstract class _ClassDetailDto implements ClassDetailDto {
  const factory _ClassDetailDto({
    required final String id,
    required final String name,
    final String? inviteCode,
    required final int studentCount,
    required final List<ClassMemberDto> students,
  }) = _$ClassDetailDtoImpl;

  factory _ClassDetailDto.fromJson(Map<String, dynamic> json) =
      _$ClassDetailDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get inviteCode;
  @override
  int get studentCount;
  @override
  List<ClassMemberDto> get students;

  /// Create a copy of ClassDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClassDetailDtoImplCopyWith<_$ClassDetailDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ClassMembershipDto _$ClassMembershipDtoFromJson(Map<String, dynamic> json) {
  return _ClassMembershipDto.fromJson(json);
}

/// @nodoc
mixin _$ClassMembershipDto {
  String get classId => throw _privateConstructorUsedError;
  String get className => throw _privateConstructorUsedError;
  String get teacherName => throw _privateConstructorUsedError;

  /// Serializes this ClassMembershipDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClassMembershipDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClassMembershipDtoCopyWith<ClassMembershipDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClassMembershipDtoCopyWith<$Res> {
  factory $ClassMembershipDtoCopyWith(
    ClassMembershipDto value,
    $Res Function(ClassMembershipDto) then,
  ) = _$ClassMembershipDtoCopyWithImpl<$Res, ClassMembershipDto>;
  @useResult
  $Res call({String classId, String className, String teacherName});
}

/// @nodoc
class _$ClassMembershipDtoCopyWithImpl<$Res, $Val extends ClassMembershipDto>
    implements $ClassMembershipDtoCopyWith<$Res> {
  _$ClassMembershipDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClassMembershipDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? classId = null,
    Object? className = null,
    Object? teacherName = null,
  }) {
    return _then(
      _value.copyWith(
            classId:
                null == classId
                    ? _value.classId
                    : classId // ignore: cast_nullable_to_non_nullable
                        as String,
            className:
                null == className
                    ? _value.className
                    : className // ignore: cast_nullable_to_non_nullable
                        as String,
            teacherName:
                null == teacherName
                    ? _value.teacherName
                    : teacherName // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ClassMembershipDtoImplCopyWith<$Res>
    implements $ClassMembershipDtoCopyWith<$Res> {
  factory _$$ClassMembershipDtoImplCopyWith(
    _$ClassMembershipDtoImpl value,
    $Res Function(_$ClassMembershipDtoImpl) then,
  ) = __$$ClassMembershipDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String classId, String className, String teacherName});
}

/// @nodoc
class __$$ClassMembershipDtoImplCopyWithImpl<$Res>
    extends _$ClassMembershipDtoCopyWithImpl<$Res, _$ClassMembershipDtoImpl>
    implements _$$ClassMembershipDtoImplCopyWith<$Res> {
  __$$ClassMembershipDtoImplCopyWithImpl(
    _$ClassMembershipDtoImpl _value,
    $Res Function(_$ClassMembershipDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ClassMembershipDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? classId = null,
    Object? className = null,
    Object? teacherName = null,
  }) {
    return _then(
      _$ClassMembershipDtoImpl(
        classId:
            null == classId
                ? _value.classId
                : classId // ignore: cast_nullable_to_non_nullable
                    as String,
        className:
            null == className
                ? _value.className
                : className // ignore: cast_nullable_to_non_nullable
                    as String,
        teacherName:
            null == teacherName
                ? _value.teacherName
                : teacherName // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ClassMembershipDtoImpl implements _ClassMembershipDto {
  const _$ClassMembershipDtoImpl({
    required this.classId,
    required this.className,
    required this.teacherName,
  });

  factory _$ClassMembershipDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClassMembershipDtoImplFromJson(json);

  @override
  final String classId;
  @override
  final String className;
  @override
  final String teacherName;

  @override
  String toString() {
    return 'ClassMembershipDto(classId: $classId, className: $className, teacherName: $teacherName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClassMembershipDtoImpl &&
            (identical(other.classId, classId) || other.classId == classId) &&
            (identical(other.className, className) ||
                other.className == className) &&
            (identical(other.teacherName, teacherName) ||
                other.teacherName == teacherName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, classId, className, teacherName);

  /// Create a copy of ClassMembershipDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClassMembershipDtoImplCopyWith<_$ClassMembershipDtoImpl> get copyWith =>
      __$$ClassMembershipDtoImplCopyWithImpl<_$ClassMembershipDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ClassMembershipDtoImplToJson(this);
  }
}

abstract class _ClassMembershipDto implements ClassMembershipDto {
  const factory _ClassMembershipDto({
    required final String classId,
    required final String className,
    required final String teacherName,
  }) = _$ClassMembershipDtoImpl;

  factory _ClassMembershipDto.fromJson(Map<String, dynamic> json) =
      _$ClassMembershipDtoImpl.fromJson;

  @override
  String get classId;
  @override
  String get className;
  @override
  String get teacherName;

  /// Create a copy of ClassMembershipDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClassMembershipDtoImplCopyWith<_$ClassMembershipDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateClassRequest _$CreateClassRequestFromJson(Map<String, dynamic> json) {
  return _CreateClassRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateClassRequest {
  String get name => throw _privateConstructorUsedError;

  /// Serializes this CreateClassRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateClassRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateClassRequestCopyWith<CreateClassRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateClassRequestCopyWith<$Res> {
  factory $CreateClassRequestCopyWith(
    CreateClassRequest value,
    $Res Function(CreateClassRequest) then,
  ) = _$CreateClassRequestCopyWithImpl<$Res, CreateClassRequest>;
  @useResult
  $Res call({String name});
}

/// @nodoc
class _$CreateClassRequestCopyWithImpl<$Res, $Val extends CreateClassRequest>
    implements $CreateClassRequestCopyWith<$Res> {
  _$CreateClassRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateClassRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null}) {
    return _then(
      _value.copyWith(
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateClassRequestImplCopyWith<$Res>
    implements $CreateClassRequestCopyWith<$Res> {
  factory _$$CreateClassRequestImplCopyWith(
    _$CreateClassRequestImpl value,
    $Res Function(_$CreateClassRequestImpl) then,
  ) = __$$CreateClassRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name});
}

/// @nodoc
class __$$CreateClassRequestImplCopyWithImpl<$Res>
    extends _$CreateClassRequestCopyWithImpl<$Res, _$CreateClassRequestImpl>
    implements _$$CreateClassRequestImplCopyWith<$Res> {
  __$$CreateClassRequestImplCopyWithImpl(
    _$CreateClassRequestImpl _value,
    $Res Function(_$CreateClassRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateClassRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null}) {
    return _then(
      _$CreateClassRequestImpl(
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateClassRequestImpl implements _CreateClassRequest {
  const _$CreateClassRequestImpl({required this.name});

  factory _$CreateClassRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateClassRequestImplFromJson(json);

  @override
  final String name;

  @override
  String toString() {
    return 'CreateClassRequest(name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateClassRequestImpl &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name);

  /// Create a copy of CreateClassRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateClassRequestImplCopyWith<_$CreateClassRequestImpl> get copyWith =>
      __$$CreateClassRequestImplCopyWithImpl<_$CreateClassRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateClassRequestImplToJson(this);
  }
}

abstract class _CreateClassRequest implements CreateClassRequest {
  const factory _CreateClassRequest({required final String name}) =
      _$CreateClassRequestImpl;

  factory _CreateClassRequest.fromJson(Map<String, dynamic> json) =
      _$CreateClassRequestImpl.fromJson;

  @override
  String get name;

  /// Create a copy of CreateClassRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateClassRequestImplCopyWith<_$CreateClassRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ClassInviteCodeDto _$ClassInviteCodeDtoFromJson(Map<String, dynamic> json) {
  return _ClassInviteCodeDto.fromJson(json);
}

/// @nodoc
mixin _$ClassInviteCodeDto {
  String get code => throw _privateConstructorUsedError;

  /// Serializes this ClassInviteCodeDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClassInviteCodeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClassInviteCodeDtoCopyWith<ClassInviteCodeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClassInviteCodeDtoCopyWith<$Res> {
  factory $ClassInviteCodeDtoCopyWith(
    ClassInviteCodeDto value,
    $Res Function(ClassInviteCodeDto) then,
  ) = _$ClassInviteCodeDtoCopyWithImpl<$Res, ClassInviteCodeDto>;
  @useResult
  $Res call({String code});
}

/// @nodoc
class _$ClassInviteCodeDtoCopyWithImpl<$Res, $Val extends ClassInviteCodeDto>
    implements $ClassInviteCodeDtoCopyWith<$Res> {
  _$ClassInviteCodeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClassInviteCodeDto
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
abstract class _$$ClassInviteCodeDtoImplCopyWith<$Res>
    implements $ClassInviteCodeDtoCopyWith<$Res> {
  factory _$$ClassInviteCodeDtoImplCopyWith(
    _$ClassInviteCodeDtoImpl value,
    $Res Function(_$ClassInviteCodeDtoImpl) then,
  ) = __$$ClassInviteCodeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String code});
}

/// @nodoc
class __$$ClassInviteCodeDtoImplCopyWithImpl<$Res>
    extends _$ClassInviteCodeDtoCopyWithImpl<$Res, _$ClassInviteCodeDtoImpl>
    implements _$$ClassInviteCodeDtoImplCopyWith<$Res> {
  __$$ClassInviteCodeDtoImplCopyWithImpl(
    _$ClassInviteCodeDtoImpl _value,
    $Res Function(_$ClassInviteCodeDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ClassInviteCodeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? code = null}) {
    return _then(
      _$ClassInviteCodeDtoImpl(
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
class _$ClassInviteCodeDtoImpl implements _ClassInviteCodeDto {
  const _$ClassInviteCodeDtoImpl({required this.code});

  factory _$ClassInviteCodeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClassInviteCodeDtoImplFromJson(json);

  @override
  final String code;

  @override
  String toString() {
    return 'ClassInviteCodeDto(code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClassInviteCodeDtoImpl &&
            (identical(other.code, code) || other.code == code));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code);

  /// Create a copy of ClassInviteCodeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClassInviteCodeDtoImplCopyWith<_$ClassInviteCodeDtoImpl> get copyWith =>
      __$$ClassInviteCodeDtoImplCopyWithImpl<_$ClassInviteCodeDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ClassInviteCodeDtoImplToJson(this);
  }
}

abstract class _ClassInviteCodeDto implements ClassInviteCodeDto {
  const factory _ClassInviteCodeDto({required final String code}) =
      _$ClassInviteCodeDtoImpl;

  factory _ClassInviteCodeDto.fromJson(Map<String, dynamic> json) =
      _$ClassInviteCodeDtoImpl.fromJson;

  @override
  String get code;

  /// Create a copy of ClassInviteCodeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClassInviteCodeDtoImplCopyWith<_$ClassInviteCodeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

JoinClassRequest _$JoinClassRequestFromJson(Map<String, dynamic> json) {
  return _JoinClassRequest.fromJson(json);
}

/// @nodoc
mixin _$JoinClassRequest {
  String get code => throw _privateConstructorUsedError;

  /// Serializes this JoinClassRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JoinClassRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JoinClassRequestCopyWith<JoinClassRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JoinClassRequestCopyWith<$Res> {
  factory $JoinClassRequestCopyWith(
    JoinClassRequest value,
    $Res Function(JoinClassRequest) then,
  ) = _$JoinClassRequestCopyWithImpl<$Res, JoinClassRequest>;
  @useResult
  $Res call({String code});
}

/// @nodoc
class _$JoinClassRequestCopyWithImpl<$Res, $Val extends JoinClassRequest>
    implements $JoinClassRequestCopyWith<$Res> {
  _$JoinClassRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JoinClassRequest
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
abstract class _$$JoinClassRequestImplCopyWith<$Res>
    implements $JoinClassRequestCopyWith<$Res> {
  factory _$$JoinClassRequestImplCopyWith(
    _$JoinClassRequestImpl value,
    $Res Function(_$JoinClassRequestImpl) then,
  ) = __$$JoinClassRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String code});
}

/// @nodoc
class __$$JoinClassRequestImplCopyWithImpl<$Res>
    extends _$JoinClassRequestCopyWithImpl<$Res, _$JoinClassRequestImpl>
    implements _$$JoinClassRequestImplCopyWith<$Res> {
  __$$JoinClassRequestImplCopyWithImpl(
    _$JoinClassRequestImpl _value,
    $Res Function(_$JoinClassRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JoinClassRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? code = null}) {
    return _then(
      _$JoinClassRequestImpl(
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
class _$JoinClassRequestImpl implements _JoinClassRequest {
  const _$JoinClassRequestImpl({required this.code});

  factory _$JoinClassRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$JoinClassRequestImplFromJson(json);

  @override
  final String code;

  @override
  String toString() {
    return 'JoinClassRequest(code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JoinClassRequestImpl &&
            (identical(other.code, code) || other.code == code));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code);

  /// Create a copy of JoinClassRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JoinClassRequestImplCopyWith<_$JoinClassRequestImpl> get copyWith =>
      __$$JoinClassRequestImplCopyWithImpl<_$JoinClassRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$JoinClassRequestImplToJson(this);
  }
}

abstract class _JoinClassRequest implements JoinClassRequest {
  const factory _JoinClassRequest({required final String code}) =
      _$JoinClassRequestImpl;

  factory _JoinClassRequest.fromJson(Map<String, dynamic> json) =
      _$JoinClassRequestImpl.fromJson;

  @override
  String get code;

  /// Create a copy of JoinClassRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JoinClassRequestImplCopyWith<_$JoinClassRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
