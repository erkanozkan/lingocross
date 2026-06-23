// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CreateLessonRequest _$CreateLessonRequestFromJson(Map<String, dynamic> json) {
  return _CreateLessonRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateLessonRequest {
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get sourceLanguage => throw _privateConstructorUsedError;
  String? get targetLanguage => throw _privateConstructorUsedError;

  /// Serializes this CreateLessonRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateLessonRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateLessonRequestCopyWith<CreateLessonRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateLessonRequestCopyWith<$Res> {
  factory $CreateLessonRequestCopyWith(
    CreateLessonRequest value,
    $Res Function(CreateLessonRequest) then,
  ) = _$CreateLessonRequestCopyWithImpl<$Res, CreateLessonRequest>;
  @useResult
  $Res call({
    String title,
    String? description,
    String? sourceLanguage,
    String? targetLanguage,
  });
}

/// @nodoc
class _$CreateLessonRequestCopyWithImpl<$Res, $Val extends CreateLessonRequest>
    implements $CreateLessonRequestCopyWith<$Res> {
  _$CreateLessonRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateLessonRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = freezed,
    Object? sourceLanguage = freezed,
    Object? targetLanguage = freezed,
  }) {
    return _then(
      _value.copyWith(
            title:
                null == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String?,
            sourceLanguage:
                freezed == sourceLanguage
                    ? _value.sourceLanguage
                    : sourceLanguage // ignore: cast_nullable_to_non_nullable
                        as String?,
            targetLanguage:
                freezed == targetLanguage
                    ? _value.targetLanguage
                    : targetLanguage // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateLessonRequestImplCopyWith<$Res>
    implements $CreateLessonRequestCopyWith<$Res> {
  factory _$$CreateLessonRequestImplCopyWith(
    _$CreateLessonRequestImpl value,
    $Res Function(_$CreateLessonRequestImpl) then,
  ) = __$$CreateLessonRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String title,
    String? description,
    String? sourceLanguage,
    String? targetLanguage,
  });
}

/// @nodoc
class __$$CreateLessonRequestImplCopyWithImpl<$Res>
    extends _$CreateLessonRequestCopyWithImpl<$Res, _$CreateLessonRequestImpl>
    implements _$$CreateLessonRequestImplCopyWith<$Res> {
  __$$CreateLessonRequestImplCopyWithImpl(
    _$CreateLessonRequestImpl _value,
    $Res Function(_$CreateLessonRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateLessonRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = freezed,
    Object? sourceLanguage = freezed,
    Object? targetLanguage = freezed,
  }) {
    return _then(
      _$CreateLessonRequestImpl(
        title:
            null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String?,
        sourceLanguage:
            freezed == sourceLanguage
                ? _value.sourceLanguage
                : sourceLanguage // ignore: cast_nullable_to_non_nullable
                    as String?,
        targetLanguage:
            freezed == targetLanguage
                ? _value.targetLanguage
                : targetLanguage // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateLessonRequestImpl implements _CreateLessonRequest {
  const _$CreateLessonRequestImpl({
    required this.title,
    this.description,
    this.sourceLanguage,
    this.targetLanguage,
  });

  factory _$CreateLessonRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateLessonRequestImplFromJson(json);

  @override
  final String title;
  @override
  final String? description;
  @override
  final String? sourceLanguage;
  @override
  final String? targetLanguage;

  @override
  String toString() {
    return 'CreateLessonRequest(title: $title, description: $description, sourceLanguage: $sourceLanguage, targetLanguage: $targetLanguage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateLessonRequestImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.sourceLanguage, sourceLanguage) ||
                other.sourceLanguage == sourceLanguage) &&
            (identical(other.targetLanguage, targetLanguage) ||
                other.targetLanguage == targetLanguage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    title,
    description,
    sourceLanguage,
    targetLanguage,
  );

  /// Create a copy of CreateLessonRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateLessonRequestImplCopyWith<_$CreateLessonRequestImpl> get copyWith =>
      __$$CreateLessonRequestImplCopyWithImpl<_$CreateLessonRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateLessonRequestImplToJson(this);
  }
}

abstract class _CreateLessonRequest implements CreateLessonRequest {
  const factory _CreateLessonRequest({
    required final String title,
    final String? description,
    final String? sourceLanguage,
    final String? targetLanguage,
  }) = _$CreateLessonRequestImpl;

  factory _CreateLessonRequest.fromJson(Map<String, dynamic> json) =
      _$CreateLessonRequestImpl.fromJson;

  @override
  String get title;
  @override
  String? get description;
  @override
  String? get sourceLanguage;
  @override
  String? get targetLanguage;

  /// Create a copy of CreateLessonRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateLessonRequestImplCopyWith<_$CreateLessonRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UpdateLessonRequest _$UpdateLessonRequestFromJson(Map<String, dynamic> json) {
  return _UpdateLessonRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateLessonRequest {
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get sourceLanguage => throw _privateConstructorUsedError;
  String? get targetLanguage => throw _privateConstructorUsedError;

  /// Serializes this UpdateLessonRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateLessonRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateLessonRequestCopyWith<UpdateLessonRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateLessonRequestCopyWith<$Res> {
  factory $UpdateLessonRequestCopyWith(
    UpdateLessonRequest value,
    $Res Function(UpdateLessonRequest) then,
  ) = _$UpdateLessonRequestCopyWithImpl<$Res, UpdateLessonRequest>;
  @useResult
  $Res call({
    String title,
    String? description,
    String? sourceLanguage,
    String? targetLanguage,
  });
}

/// @nodoc
class _$UpdateLessonRequestCopyWithImpl<$Res, $Val extends UpdateLessonRequest>
    implements $UpdateLessonRequestCopyWith<$Res> {
  _$UpdateLessonRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateLessonRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = freezed,
    Object? sourceLanguage = freezed,
    Object? targetLanguage = freezed,
  }) {
    return _then(
      _value.copyWith(
            title:
                null == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String?,
            sourceLanguage:
                freezed == sourceLanguage
                    ? _value.sourceLanguage
                    : sourceLanguage // ignore: cast_nullable_to_non_nullable
                        as String?,
            targetLanguage:
                freezed == targetLanguage
                    ? _value.targetLanguage
                    : targetLanguage // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateLessonRequestImplCopyWith<$Res>
    implements $UpdateLessonRequestCopyWith<$Res> {
  factory _$$UpdateLessonRequestImplCopyWith(
    _$UpdateLessonRequestImpl value,
    $Res Function(_$UpdateLessonRequestImpl) then,
  ) = __$$UpdateLessonRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String title,
    String? description,
    String? sourceLanguage,
    String? targetLanguage,
  });
}

/// @nodoc
class __$$UpdateLessonRequestImplCopyWithImpl<$Res>
    extends _$UpdateLessonRequestCopyWithImpl<$Res, _$UpdateLessonRequestImpl>
    implements _$$UpdateLessonRequestImplCopyWith<$Res> {
  __$$UpdateLessonRequestImplCopyWithImpl(
    _$UpdateLessonRequestImpl _value,
    $Res Function(_$UpdateLessonRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateLessonRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = freezed,
    Object? sourceLanguage = freezed,
    Object? targetLanguage = freezed,
  }) {
    return _then(
      _$UpdateLessonRequestImpl(
        title:
            null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String?,
        sourceLanguage:
            freezed == sourceLanguage
                ? _value.sourceLanguage
                : sourceLanguage // ignore: cast_nullable_to_non_nullable
                    as String?,
        targetLanguage:
            freezed == targetLanguage
                ? _value.targetLanguage
                : targetLanguage // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateLessonRequestImpl implements _UpdateLessonRequest {
  const _$UpdateLessonRequestImpl({
    required this.title,
    this.description,
    this.sourceLanguage,
    this.targetLanguage,
  });

  factory _$UpdateLessonRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateLessonRequestImplFromJson(json);

  @override
  final String title;
  @override
  final String? description;
  @override
  final String? sourceLanguage;
  @override
  final String? targetLanguage;

  @override
  String toString() {
    return 'UpdateLessonRequest(title: $title, description: $description, sourceLanguage: $sourceLanguage, targetLanguage: $targetLanguage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateLessonRequestImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.sourceLanguage, sourceLanguage) ||
                other.sourceLanguage == sourceLanguage) &&
            (identical(other.targetLanguage, targetLanguage) ||
                other.targetLanguage == targetLanguage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    title,
    description,
    sourceLanguage,
    targetLanguage,
  );

  /// Create a copy of UpdateLessonRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateLessonRequestImplCopyWith<_$UpdateLessonRequestImpl> get copyWith =>
      __$$UpdateLessonRequestImplCopyWithImpl<_$UpdateLessonRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateLessonRequestImplToJson(this);
  }
}

abstract class _UpdateLessonRequest implements UpdateLessonRequest {
  const factory _UpdateLessonRequest({
    required final String title,
    final String? description,
    final String? sourceLanguage,
    final String? targetLanguage,
  }) = _$UpdateLessonRequestImpl;

  factory _UpdateLessonRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateLessonRequestImpl.fromJson;

  @override
  String get title;
  @override
  String? get description;
  @override
  String? get sourceLanguage;
  @override
  String? get targetLanguage;

  /// Create a copy of UpdateLessonRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateLessonRequestImplCopyWith<_$UpdateLessonRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LessonDto _$LessonDtoFromJson(Map<String, dynamic> json) {
  return _LessonDto.fromJson(json);
}

/// @nodoc
mixin _$LessonDto {
  String get id => throw _privateConstructorUsedError;
  String get teacherId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get sourceLanguage => throw _privateConstructorUsedError;
  String get targetLanguage => throw _privateConstructorUsedError;
  bool get isPublished => throw _privateConstructorUsedError;
  int get wordCount => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this LessonDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LessonDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LessonDtoCopyWith<LessonDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LessonDtoCopyWith<$Res> {
  factory $LessonDtoCopyWith(LessonDto value, $Res Function(LessonDto) then) =
      _$LessonDtoCopyWithImpl<$Res, LessonDto>;
  @useResult
  $Res call({
    String id,
    String teacherId,
    String title,
    String? description,
    String sourceLanguage,
    String targetLanguage,
    bool isPublished,
    int wordCount,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$LessonDtoCopyWithImpl<$Res, $Val extends LessonDto>
    implements $LessonDtoCopyWith<$Res> {
  _$LessonDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LessonDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? teacherId = null,
    Object? title = null,
    Object? description = freezed,
    Object? sourceLanguage = null,
    Object? targetLanguage = null,
    Object? isPublished = null,
    Object? wordCount = null,
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
            title:
                null == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String?,
            sourceLanguage:
                null == sourceLanguage
                    ? _value.sourceLanguage
                    : sourceLanguage // ignore: cast_nullable_to_non_nullable
                        as String,
            targetLanguage:
                null == targetLanguage
                    ? _value.targetLanguage
                    : targetLanguage // ignore: cast_nullable_to_non_nullable
                        as String,
            isPublished:
                null == isPublished
                    ? _value.isPublished
                    : isPublished // ignore: cast_nullable_to_non_nullable
                        as bool,
            wordCount:
                null == wordCount
                    ? _value.wordCount
                    : wordCount // ignore: cast_nullable_to_non_nullable
                        as int,
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
abstract class _$$LessonDtoImplCopyWith<$Res>
    implements $LessonDtoCopyWith<$Res> {
  factory _$$LessonDtoImplCopyWith(
    _$LessonDtoImpl value,
    $Res Function(_$LessonDtoImpl) then,
  ) = __$$LessonDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String teacherId,
    String title,
    String? description,
    String sourceLanguage,
    String targetLanguage,
    bool isPublished,
    int wordCount,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$LessonDtoImplCopyWithImpl<$Res>
    extends _$LessonDtoCopyWithImpl<$Res, _$LessonDtoImpl>
    implements _$$LessonDtoImplCopyWith<$Res> {
  __$$LessonDtoImplCopyWithImpl(
    _$LessonDtoImpl _value,
    $Res Function(_$LessonDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LessonDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? teacherId = null,
    Object? title = null,
    Object? description = freezed,
    Object? sourceLanguage = null,
    Object? targetLanguage = null,
    Object? isPublished = null,
    Object? wordCount = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$LessonDtoImpl(
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
        title:
            null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String?,
        sourceLanguage:
            null == sourceLanguage
                ? _value.sourceLanguage
                : sourceLanguage // ignore: cast_nullable_to_non_nullable
                    as String,
        targetLanguage:
            null == targetLanguage
                ? _value.targetLanguage
                : targetLanguage // ignore: cast_nullable_to_non_nullable
                    as String,
        isPublished:
            null == isPublished
                ? _value.isPublished
                : isPublished // ignore: cast_nullable_to_non_nullable
                    as bool,
        wordCount:
            null == wordCount
                ? _value.wordCount
                : wordCount // ignore: cast_nullable_to_non_nullable
                    as int,
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
class _$LessonDtoImpl implements _LessonDto {
  const _$LessonDtoImpl({
    required this.id,
    required this.teacherId,
    required this.title,
    this.description,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.isPublished,
    required this.wordCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory _$LessonDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$LessonDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String teacherId;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String sourceLanguage;
  @override
  final String targetLanguage;
  @override
  final bool isPublished;
  @override
  final int wordCount;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'LessonDto(id: $id, teacherId: $teacherId, title: $title, description: $description, sourceLanguage: $sourceLanguage, targetLanguage: $targetLanguage, isPublished: $isPublished, wordCount: $wordCount, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LessonDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.teacherId, teacherId) ||
                other.teacherId == teacherId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.sourceLanguage, sourceLanguage) ||
                other.sourceLanguage == sourceLanguage) &&
            (identical(other.targetLanguage, targetLanguage) ||
                other.targetLanguage == targetLanguage) &&
            (identical(other.isPublished, isPublished) ||
                other.isPublished == isPublished) &&
            (identical(other.wordCount, wordCount) ||
                other.wordCount == wordCount) &&
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
    title,
    description,
    sourceLanguage,
    targetLanguage,
    isPublished,
    wordCount,
    createdAt,
    updatedAt,
  );

  /// Create a copy of LessonDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LessonDtoImplCopyWith<_$LessonDtoImpl> get copyWith =>
      __$$LessonDtoImplCopyWithImpl<_$LessonDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LessonDtoImplToJson(this);
  }
}

abstract class _LessonDto implements LessonDto {
  const factory _LessonDto({
    required final String id,
    required final String teacherId,
    required final String title,
    final String? description,
    required final String sourceLanguage,
    required final String targetLanguage,
    required final bool isPublished,
    required final int wordCount,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$LessonDtoImpl;

  factory _LessonDto.fromJson(Map<String, dynamic> json) =
      _$LessonDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get teacherId;
  @override
  String get title;
  @override
  String? get description;
  @override
  String get sourceLanguage;
  @override
  String get targetLanguage;
  @override
  bool get isPublished;
  @override
  int get wordCount;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of LessonDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LessonDtoImplCopyWith<_$LessonDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
