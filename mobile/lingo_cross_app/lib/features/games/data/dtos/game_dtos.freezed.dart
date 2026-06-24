// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GameDto _$GameDtoFromJson(Map<String, dynamic> json) {
  return _GameDto.fromJson(json);
}

/// @nodoc
mixin _$GameDto {
  String get id => throw _privateConstructorUsedError;
  String get lessonId => throw _privateConstructorUsedError;
  @GameTypeConverter()
  GameType get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  bool get isPublished => throw _privateConstructorUsedError;
  DateTime? get publishedAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this GameDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameDtoCopyWith<GameDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameDtoCopyWith<$Res> {
  factory $GameDtoCopyWith(GameDto value, $Res Function(GameDto) then) =
      _$GameDtoCopyWithImpl<$Res, GameDto>;
  @useResult
  $Res call({
    String id,
    String lessonId,
    @GameTypeConverter() GameType type,
    String title,
    bool isPublished,
    DateTime? publishedAt,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$GameDtoCopyWithImpl<$Res, $Val extends GameDto>
    implements $GameDtoCopyWith<$Res> {
  _$GameDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? lessonId = null,
    Object? type = null,
    Object? title = null,
    Object? isPublished = null,
    Object? publishedAt = freezed,
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
            lessonId:
                null == lessonId
                    ? _value.lessonId
                    : lessonId // ignore: cast_nullable_to_non_nullable
                        as String,
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as GameType,
            title:
                null == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String,
            isPublished:
                null == isPublished
                    ? _value.isPublished
                    : isPublished // ignore: cast_nullable_to_non_nullable
                        as bool,
            publishedAt:
                freezed == publishedAt
                    ? _value.publishedAt
                    : publishedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
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
abstract class _$$GameDtoImplCopyWith<$Res> implements $GameDtoCopyWith<$Res> {
  factory _$$GameDtoImplCopyWith(
    _$GameDtoImpl value,
    $Res Function(_$GameDtoImpl) then,
  ) = __$$GameDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String lessonId,
    @GameTypeConverter() GameType type,
    String title,
    bool isPublished,
    DateTime? publishedAt,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$GameDtoImplCopyWithImpl<$Res>
    extends _$GameDtoCopyWithImpl<$Res, _$GameDtoImpl>
    implements _$$GameDtoImplCopyWith<$Res> {
  __$$GameDtoImplCopyWithImpl(
    _$GameDtoImpl _value,
    $Res Function(_$GameDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? lessonId = null,
    Object? type = null,
    Object? title = null,
    Object? isPublished = null,
    Object? publishedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$GameDtoImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        lessonId:
            null == lessonId
                ? _value.lessonId
                : lessonId // ignore: cast_nullable_to_non_nullable
                    as String,
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as GameType,
        title:
            null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String,
        isPublished:
            null == isPublished
                ? _value.isPublished
                : isPublished // ignore: cast_nullable_to_non_nullable
                    as bool,
        publishedAt:
            freezed == publishedAt
                ? _value.publishedAt
                : publishedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
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
class _$GameDtoImpl implements _GameDto {
  const _$GameDtoImpl({
    required this.id,
    required this.lessonId,
    @GameTypeConverter() required this.type,
    required this.title,
    required this.isPublished,
    this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory _$GameDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String lessonId;
  @override
  @GameTypeConverter()
  final GameType type;
  @override
  final String title;
  @override
  final bool isPublished;
  @override
  final DateTime? publishedAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'GameDto(id: $id, lessonId: $lessonId, type: $type, title: $title, isPublished: $isPublished, publishedAt: $publishedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.lessonId, lessonId) ||
                other.lessonId == lessonId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.isPublished, isPublished) ||
                other.isPublished == isPublished) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt) &&
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
    lessonId,
    type,
    title,
    isPublished,
    publishedAt,
    createdAt,
    updatedAt,
  );

  /// Create a copy of GameDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameDtoImplCopyWith<_$GameDtoImpl> get copyWith =>
      __$$GameDtoImplCopyWithImpl<_$GameDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameDtoImplToJson(this);
  }
}

abstract class _GameDto implements GameDto {
  const factory _GameDto({
    required final String id,
    required final String lessonId,
    @GameTypeConverter() required final GameType type,
    required final String title,
    required final bool isPublished,
    final DateTime? publishedAt,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$GameDtoImpl;

  factory _GameDto.fromJson(Map<String, dynamic> json) = _$GameDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get lessonId;
  @override
  @GameTypeConverter()
  GameType get type;
  @override
  String get title;
  @override
  bool get isPublished;
  @override
  DateTime? get publishedAt;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of GameDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameDtoImplCopyWith<_$GameDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AssignedGameDto _$AssignedGameDtoFromJson(Map<String, dynamic> json) {
  return _AssignedGameDto.fromJson(json);
}

/// @nodoc
mixin _$AssignedGameDto {
  String get id => throw _privateConstructorUsedError;
  String get lessonId => throw _privateConstructorUsedError;
  String get lessonTitle => throw _privateConstructorUsedError;
  @GameTypeConverter()
  GameType get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  int get wordCount => throw _privateConstructorUsedError;
  String get teacherName => throw _privateConstructorUsedError;
  DateTime? get publishedAt => throw _privateConstructorUsedError;

  /// Serializes this AssignedGameDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AssignedGameDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AssignedGameDtoCopyWith<AssignedGameDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssignedGameDtoCopyWith<$Res> {
  factory $AssignedGameDtoCopyWith(
    AssignedGameDto value,
    $Res Function(AssignedGameDto) then,
  ) = _$AssignedGameDtoCopyWithImpl<$Res, AssignedGameDto>;
  @useResult
  $Res call({
    String id,
    String lessonId,
    String lessonTitle,
    @GameTypeConverter() GameType type,
    String title,
    int wordCount,
    String teacherName,
    DateTime? publishedAt,
  });
}

/// @nodoc
class _$AssignedGameDtoCopyWithImpl<$Res, $Val extends AssignedGameDto>
    implements $AssignedGameDtoCopyWith<$Res> {
  _$AssignedGameDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AssignedGameDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? lessonId = null,
    Object? lessonTitle = null,
    Object? type = null,
    Object? title = null,
    Object? wordCount = null,
    Object? teacherName = null,
    Object? publishedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            lessonId:
                null == lessonId
                    ? _value.lessonId
                    : lessonId // ignore: cast_nullable_to_non_nullable
                        as String,
            lessonTitle:
                null == lessonTitle
                    ? _value.lessonTitle
                    : lessonTitle // ignore: cast_nullable_to_non_nullable
                        as String,
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as GameType,
            title:
                null == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String,
            wordCount:
                null == wordCount
                    ? _value.wordCount
                    : wordCount // ignore: cast_nullable_to_non_nullable
                        as int,
            teacherName:
                null == teacherName
                    ? _value.teacherName
                    : teacherName // ignore: cast_nullable_to_non_nullable
                        as String,
            publishedAt:
                freezed == publishedAt
                    ? _value.publishedAt
                    : publishedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AssignedGameDtoImplCopyWith<$Res>
    implements $AssignedGameDtoCopyWith<$Res> {
  factory _$$AssignedGameDtoImplCopyWith(
    _$AssignedGameDtoImpl value,
    $Res Function(_$AssignedGameDtoImpl) then,
  ) = __$$AssignedGameDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String lessonId,
    String lessonTitle,
    @GameTypeConverter() GameType type,
    String title,
    int wordCount,
    String teacherName,
    DateTime? publishedAt,
  });
}

/// @nodoc
class __$$AssignedGameDtoImplCopyWithImpl<$Res>
    extends _$AssignedGameDtoCopyWithImpl<$Res, _$AssignedGameDtoImpl>
    implements _$$AssignedGameDtoImplCopyWith<$Res> {
  __$$AssignedGameDtoImplCopyWithImpl(
    _$AssignedGameDtoImpl _value,
    $Res Function(_$AssignedGameDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AssignedGameDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? lessonId = null,
    Object? lessonTitle = null,
    Object? type = null,
    Object? title = null,
    Object? wordCount = null,
    Object? teacherName = null,
    Object? publishedAt = freezed,
  }) {
    return _then(
      _$AssignedGameDtoImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        lessonId:
            null == lessonId
                ? _value.lessonId
                : lessonId // ignore: cast_nullable_to_non_nullable
                    as String,
        lessonTitle:
            null == lessonTitle
                ? _value.lessonTitle
                : lessonTitle // ignore: cast_nullable_to_non_nullable
                    as String,
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as GameType,
        title:
            null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String,
        wordCount:
            null == wordCount
                ? _value.wordCount
                : wordCount // ignore: cast_nullable_to_non_nullable
                    as int,
        teacherName:
            null == teacherName
                ? _value.teacherName
                : teacherName // ignore: cast_nullable_to_non_nullable
                    as String,
        publishedAt:
            freezed == publishedAt
                ? _value.publishedAt
                : publishedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AssignedGameDtoImpl implements _AssignedGameDto {
  const _$AssignedGameDtoImpl({
    required this.id,
    required this.lessonId,
    required this.lessonTitle,
    @GameTypeConverter() required this.type,
    required this.title,
    required this.wordCount,
    required this.teacherName,
    this.publishedAt,
  });

  factory _$AssignedGameDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssignedGameDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String lessonId;
  @override
  final String lessonTitle;
  @override
  @GameTypeConverter()
  final GameType type;
  @override
  final String title;
  @override
  final int wordCount;
  @override
  final String teacherName;
  @override
  final DateTime? publishedAt;

  @override
  String toString() {
    return 'AssignedGameDto(id: $id, lessonId: $lessonId, lessonTitle: $lessonTitle, type: $type, title: $title, wordCount: $wordCount, teacherName: $teacherName, publishedAt: $publishedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssignedGameDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.lessonId, lessonId) ||
                other.lessonId == lessonId) &&
            (identical(other.lessonTitle, lessonTitle) ||
                other.lessonTitle == lessonTitle) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.wordCount, wordCount) ||
                other.wordCount == wordCount) &&
            (identical(other.teacherName, teacherName) ||
                other.teacherName == teacherName) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    lessonId,
    lessonTitle,
    type,
    title,
    wordCount,
    teacherName,
    publishedAt,
  );

  /// Create a copy of AssignedGameDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AssignedGameDtoImplCopyWith<_$AssignedGameDtoImpl> get copyWith =>
      __$$AssignedGameDtoImplCopyWithImpl<_$AssignedGameDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AssignedGameDtoImplToJson(this);
  }
}

abstract class _AssignedGameDto implements AssignedGameDto {
  const factory _AssignedGameDto({
    required final String id,
    required final String lessonId,
    required final String lessonTitle,
    @GameTypeConverter() required final GameType type,
    required final String title,
    required final int wordCount,
    required final String teacherName,
    final DateTime? publishedAt,
  }) = _$AssignedGameDtoImpl;

  factory _AssignedGameDto.fromJson(Map<String, dynamic> json) =
      _$AssignedGameDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get lessonId;
  @override
  String get lessonTitle;
  @override
  @GameTypeConverter()
  GameType get type;
  @override
  String get title;
  @override
  int get wordCount;
  @override
  String get teacherName;
  @override
  DateTime? get publishedAt;

  /// Create a copy of AssignedGameDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AssignedGameDtoImplCopyWith<_$AssignedGameDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateGameRequest _$CreateGameRequestFromJson(Map<String, dynamic> json) {
  return _CreateGameRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateGameRequest {
  @GameTypeConverter()
  GameType get type => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;

  /// Serializes this CreateGameRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateGameRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateGameRequestCopyWith<CreateGameRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateGameRequestCopyWith<$Res> {
  factory $CreateGameRequestCopyWith(
    CreateGameRequest value,
    $Res Function(CreateGameRequest) then,
  ) = _$CreateGameRequestCopyWithImpl<$Res, CreateGameRequest>;
  @useResult
  $Res call({@GameTypeConverter() GameType type, String? title});
}

/// @nodoc
class _$CreateGameRequestCopyWithImpl<$Res, $Val extends CreateGameRequest>
    implements $CreateGameRequestCopyWith<$Res> {
  _$CreateGameRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateGameRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = null, Object? title = freezed}) {
    return _then(
      _value.copyWith(
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as GameType,
            title:
                freezed == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateGameRequestImplCopyWith<$Res>
    implements $CreateGameRequestCopyWith<$Res> {
  factory _$$CreateGameRequestImplCopyWith(
    _$CreateGameRequestImpl value,
    $Res Function(_$CreateGameRequestImpl) then,
  ) = __$$CreateGameRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@GameTypeConverter() GameType type, String? title});
}

/// @nodoc
class __$$CreateGameRequestImplCopyWithImpl<$Res>
    extends _$CreateGameRequestCopyWithImpl<$Res, _$CreateGameRequestImpl>
    implements _$$CreateGameRequestImplCopyWith<$Res> {
  __$$CreateGameRequestImplCopyWithImpl(
    _$CreateGameRequestImpl _value,
    $Res Function(_$CreateGameRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateGameRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = null, Object? title = freezed}) {
    return _then(
      _$CreateGameRequestImpl(
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as GameType,
        title:
            freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateGameRequestImpl implements _CreateGameRequest {
  const _$CreateGameRequestImpl({
    @GameTypeConverter() required this.type,
    this.title,
  });

  factory _$CreateGameRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateGameRequestImplFromJson(json);

  @override
  @GameTypeConverter()
  final GameType type;
  @override
  final String? title;

  @override
  String toString() {
    return 'CreateGameRequest(type: $type, title: $title)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateGameRequestImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, title);

  /// Create a copy of CreateGameRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateGameRequestImplCopyWith<_$CreateGameRequestImpl> get copyWith =>
      __$$CreateGameRequestImplCopyWithImpl<_$CreateGameRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateGameRequestImplToJson(this);
  }
}

abstract class _CreateGameRequest implements CreateGameRequest {
  const factory _CreateGameRequest({
    @GameTypeConverter() required final GameType type,
    final String? title,
  }) = _$CreateGameRequestImpl;

  factory _CreateGameRequest.fromJson(Map<String, dynamic> json) =
      _$CreateGameRequestImpl.fromJson;

  @override
  @GameTypeConverter()
  GameType get type;
  @override
  String? get title;

  /// Create a copy of CreateGameRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateGameRequestImplCopyWith<_$CreateGameRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GameSessionDto _$GameSessionDtoFromJson(Map<String, dynamic> json) {
  return _GameSessionDto.fromJson(json);
}

/// @nodoc
mixin _$GameSessionDto {
  String get id => throw _privateConstructorUsedError;
  String get gameId => throw _privateConstructorUsedError;
  String get studentId => throw _privateConstructorUsedError;
  @GameSessionStatusConverter()
  GameSessionStatus get status => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Serializes this GameSessionDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameSessionDtoCopyWith<GameSessionDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameSessionDtoCopyWith<$Res> {
  factory $GameSessionDtoCopyWith(
    GameSessionDto value,
    $Res Function(GameSessionDto) then,
  ) = _$GameSessionDtoCopyWithImpl<$Res, GameSessionDto>;
  @useResult
  $Res call({
    String id,
    String gameId,
    String studentId,
    @GameSessionStatusConverter() GameSessionStatus status,
    DateTime startedAt,
    DateTime? completedAt,
  });
}

/// @nodoc
class _$GameSessionDtoCopyWithImpl<$Res, $Val extends GameSessionDto>
    implements $GameSessionDtoCopyWith<$Res> {
  _$GameSessionDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? gameId = null,
    Object? studentId = null,
    Object? status = null,
    Object? startedAt = null,
    Object? completedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            gameId:
                null == gameId
                    ? _value.gameId
                    : gameId // ignore: cast_nullable_to_non_nullable
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
                        as GameSessionStatus,
            startedAt:
                null == startedAt
                    ? _value.startedAt
                    : startedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            completedAt:
                freezed == completedAt
                    ? _value.completedAt
                    : completedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GameSessionDtoImplCopyWith<$Res>
    implements $GameSessionDtoCopyWith<$Res> {
  factory _$$GameSessionDtoImplCopyWith(
    _$GameSessionDtoImpl value,
    $Res Function(_$GameSessionDtoImpl) then,
  ) = __$$GameSessionDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String gameId,
    String studentId,
    @GameSessionStatusConverter() GameSessionStatus status,
    DateTime startedAt,
    DateTime? completedAt,
  });
}

/// @nodoc
class __$$GameSessionDtoImplCopyWithImpl<$Res>
    extends _$GameSessionDtoCopyWithImpl<$Res, _$GameSessionDtoImpl>
    implements _$$GameSessionDtoImplCopyWith<$Res> {
  __$$GameSessionDtoImplCopyWithImpl(
    _$GameSessionDtoImpl _value,
    $Res Function(_$GameSessionDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? gameId = null,
    Object? studentId = null,
    Object? status = null,
    Object? startedAt = null,
    Object? completedAt = freezed,
  }) {
    return _then(
      _$GameSessionDtoImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        gameId:
            null == gameId
                ? _value.gameId
                : gameId // ignore: cast_nullable_to_non_nullable
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
                    as GameSessionStatus,
        startedAt:
            null == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        completedAt:
            freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GameSessionDtoImpl implements _GameSessionDto {
  const _$GameSessionDtoImpl({
    required this.id,
    required this.gameId,
    required this.studentId,
    @GameSessionStatusConverter() required this.status,
    required this.startedAt,
    this.completedAt,
  });

  factory _$GameSessionDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameSessionDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String gameId;
  @override
  final String studentId;
  @override
  @GameSessionStatusConverter()
  final GameSessionStatus status;
  @override
  final DateTime startedAt;
  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'GameSessionDto(id: $id, gameId: $gameId, studentId: $studentId, status: $status, startedAt: $startedAt, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameSessionDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.gameId, gameId) || other.gameId == gameId) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    gameId,
    studentId,
    status,
    startedAt,
    completedAt,
  );

  /// Create a copy of GameSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameSessionDtoImplCopyWith<_$GameSessionDtoImpl> get copyWith =>
      __$$GameSessionDtoImplCopyWithImpl<_$GameSessionDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GameSessionDtoImplToJson(this);
  }
}

abstract class _GameSessionDto implements GameSessionDto {
  const factory _GameSessionDto({
    required final String id,
    required final String gameId,
    required final String studentId,
    @GameSessionStatusConverter() required final GameSessionStatus status,
    required final DateTime startedAt,
    final DateTime? completedAt,
  }) = _$GameSessionDtoImpl;

  factory _GameSessionDto.fromJson(Map<String, dynamic> json) =
      _$GameSessionDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get gameId;
  @override
  String get studentId;
  @override
  @GameSessionStatusConverter()
  GameSessionStatus get status;
  @override
  DateTime get startedAt;
  @override
  DateTime? get completedAt;

  /// Create a copy of GameSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameSessionDtoImplCopyWith<_$GameSessionDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MatchingPair _$MatchingPairFromJson(Map<String, dynamic> json) {
  return _MatchingPair.fromJson(json);
}

/// @nodoc
mixin _$MatchingPair {
  String get wordId => throw _privateConstructorUsedError;
  String get term => throw _privateConstructorUsedError;
  String get correctTranslation => throw _privateConstructorUsedError;

  /// Serializes this MatchingPair to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MatchingPair
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchingPairCopyWith<MatchingPair> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchingPairCopyWith<$Res> {
  factory $MatchingPairCopyWith(
    MatchingPair value,
    $Res Function(MatchingPair) then,
  ) = _$MatchingPairCopyWithImpl<$Res, MatchingPair>;
  @useResult
  $Res call({String wordId, String term, String correctTranslation});
}

/// @nodoc
class _$MatchingPairCopyWithImpl<$Res, $Val extends MatchingPair>
    implements $MatchingPairCopyWith<$Res> {
  _$MatchingPairCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatchingPair
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wordId = null,
    Object? term = null,
    Object? correctTranslation = null,
  }) {
    return _then(
      _value.copyWith(
            wordId:
                null == wordId
                    ? _value.wordId
                    : wordId // ignore: cast_nullable_to_non_nullable
                        as String,
            term:
                null == term
                    ? _value.term
                    : term // ignore: cast_nullable_to_non_nullable
                        as String,
            correctTranslation:
                null == correctTranslation
                    ? _value.correctTranslation
                    : correctTranslation // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MatchingPairImplCopyWith<$Res>
    implements $MatchingPairCopyWith<$Res> {
  factory _$$MatchingPairImplCopyWith(
    _$MatchingPairImpl value,
    $Res Function(_$MatchingPairImpl) then,
  ) = __$$MatchingPairImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String wordId, String term, String correctTranslation});
}

/// @nodoc
class __$$MatchingPairImplCopyWithImpl<$Res>
    extends _$MatchingPairCopyWithImpl<$Res, _$MatchingPairImpl>
    implements _$$MatchingPairImplCopyWith<$Res> {
  __$$MatchingPairImplCopyWithImpl(
    _$MatchingPairImpl _value,
    $Res Function(_$MatchingPairImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MatchingPair
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wordId = null,
    Object? term = null,
    Object? correctTranslation = null,
  }) {
    return _then(
      _$MatchingPairImpl(
        wordId:
            null == wordId
                ? _value.wordId
                : wordId // ignore: cast_nullable_to_non_nullable
                    as String,
        term:
            null == term
                ? _value.term
                : term // ignore: cast_nullable_to_non_nullable
                    as String,
        correctTranslation:
            null == correctTranslation
                ? _value.correctTranslation
                : correctTranslation // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MatchingPairImpl implements _MatchingPair {
  const _$MatchingPairImpl({
    required this.wordId,
    required this.term,
    required this.correctTranslation,
  });

  factory _$MatchingPairImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchingPairImplFromJson(json);

  @override
  final String wordId;
  @override
  final String term;
  @override
  final String correctTranslation;

  @override
  String toString() {
    return 'MatchingPair(wordId: $wordId, term: $term, correctTranslation: $correctTranslation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchingPairImpl &&
            (identical(other.wordId, wordId) || other.wordId == wordId) &&
            (identical(other.term, term) || other.term == term) &&
            (identical(other.correctTranslation, correctTranslation) ||
                other.correctTranslation == correctTranslation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, wordId, term, correctTranslation);

  /// Create a copy of MatchingPair
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchingPairImplCopyWith<_$MatchingPairImpl> get copyWith =>
      __$$MatchingPairImplCopyWithImpl<_$MatchingPairImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchingPairImplToJson(this);
  }
}

abstract class _MatchingPair implements MatchingPair {
  const factory _MatchingPair({
    required final String wordId,
    required final String term,
    required final String correctTranslation,
  }) = _$MatchingPairImpl;

  factory _MatchingPair.fromJson(Map<String, dynamic> json) =
      _$MatchingPairImpl.fromJson;

  @override
  String get wordId;
  @override
  String get term;
  @override
  String get correctTranslation;

  /// Create a copy of MatchingPair
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchingPairImplCopyWith<_$MatchingPairImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WordMatchingContent _$WordMatchingContentFromJson(Map<String, dynamic> json) {
  return _WordMatchingContent.fromJson(json);
}

/// @nodoc
mixin _$WordMatchingContent {
  List<MatchingPair> get pairs => throw _privateConstructorUsedError;
  List<String> get distractors => throw _privateConstructorUsedError;

  /// Serializes this WordMatchingContent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WordMatchingContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WordMatchingContentCopyWith<WordMatchingContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WordMatchingContentCopyWith<$Res> {
  factory $WordMatchingContentCopyWith(
    WordMatchingContent value,
    $Res Function(WordMatchingContent) then,
  ) = _$WordMatchingContentCopyWithImpl<$Res, WordMatchingContent>;
  @useResult
  $Res call({List<MatchingPair> pairs, List<String> distractors});
}

/// @nodoc
class _$WordMatchingContentCopyWithImpl<$Res, $Val extends WordMatchingContent>
    implements $WordMatchingContentCopyWith<$Res> {
  _$WordMatchingContentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WordMatchingContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? pairs = null, Object? distractors = null}) {
    return _then(
      _value.copyWith(
            pairs:
                null == pairs
                    ? _value.pairs
                    : pairs // ignore: cast_nullable_to_non_nullable
                        as List<MatchingPair>,
            distractors:
                null == distractors
                    ? _value.distractors
                    : distractors // ignore: cast_nullable_to_non_nullable
                        as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WordMatchingContentImplCopyWith<$Res>
    implements $WordMatchingContentCopyWith<$Res> {
  factory _$$WordMatchingContentImplCopyWith(
    _$WordMatchingContentImpl value,
    $Res Function(_$WordMatchingContentImpl) then,
  ) = __$$WordMatchingContentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<MatchingPair> pairs, List<String> distractors});
}

/// @nodoc
class __$$WordMatchingContentImplCopyWithImpl<$Res>
    extends _$WordMatchingContentCopyWithImpl<$Res, _$WordMatchingContentImpl>
    implements _$$WordMatchingContentImplCopyWith<$Res> {
  __$$WordMatchingContentImplCopyWithImpl(
    _$WordMatchingContentImpl _value,
    $Res Function(_$WordMatchingContentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WordMatchingContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? pairs = null, Object? distractors = null}) {
    return _then(
      _$WordMatchingContentImpl(
        pairs:
            null == pairs
                ? _value._pairs
                : pairs // ignore: cast_nullable_to_non_nullable
                    as List<MatchingPair>,
        distractors:
            null == distractors
                ? _value._distractors
                : distractors // ignore: cast_nullable_to_non_nullable
                    as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WordMatchingContentImpl implements _WordMatchingContent {
  const _$WordMatchingContentImpl({
    required final List<MatchingPair> pairs,
    required final List<String> distractors,
  }) : _pairs = pairs,
       _distractors = distractors;

  factory _$WordMatchingContentImpl.fromJson(Map<String, dynamic> json) =>
      _$$WordMatchingContentImplFromJson(json);

  final List<MatchingPair> _pairs;
  @override
  List<MatchingPair> get pairs {
    if (_pairs is EqualUnmodifiableListView) return _pairs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pairs);
  }

  final List<String> _distractors;
  @override
  List<String> get distractors {
    if (_distractors is EqualUnmodifiableListView) return _distractors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_distractors);
  }

  @override
  String toString() {
    return 'WordMatchingContent(pairs: $pairs, distractors: $distractors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WordMatchingContentImpl &&
            const DeepCollectionEquality().equals(other._pairs, _pairs) &&
            const DeepCollectionEquality().equals(
              other._distractors,
              _distractors,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_pairs),
    const DeepCollectionEquality().hash(_distractors),
  );

  /// Create a copy of WordMatchingContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WordMatchingContentImplCopyWith<_$WordMatchingContentImpl> get copyWith =>
      __$$WordMatchingContentImplCopyWithImpl<_$WordMatchingContentImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WordMatchingContentImplToJson(this);
  }
}

abstract class _WordMatchingContent implements WordMatchingContent {
  const factory _WordMatchingContent({
    required final List<MatchingPair> pairs,
    required final List<String> distractors,
  }) = _$WordMatchingContentImpl;

  factory _WordMatchingContent.fromJson(Map<String, dynamic> json) =
      _$WordMatchingContentImpl.fromJson;

  @override
  List<MatchingPair> get pairs;
  @override
  List<String> get distractors;

  /// Create a copy of WordMatchingContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WordMatchingContentImplCopyWith<_$WordMatchingContentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StartGameSessionResponse _$StartGameSessionResponseFromJson(
  Map<String, dynamic> json,
) {
  return _StartGameSessionResponse.fromJson(json);
}

/// @nodoc
mixin _$StartGameSessionResponse {
  GameSessionDto get session => throw _privateConstructorUsedError;
  WordMatchingContent get content => throw _privateConstructorUsedError;

  /// Serializes this StartGameSessionResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StartGameSessionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StartGameSessionResponseCopyWith<StartGameSessionResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StartGameSessionResponseCopyWith<$Res> {
  factory $StartGameSessionResponseCopyWith(
    StartGameSessionResponse value,
    $Res Function(StartGameSessionResponse) then,
  ) = _$StartGameSessionResponseCopyWithImpl<$Res, StartGameSessionResponse>;
  @useResult
  $Res call({GameSessionDto session, WordMatchingContent content});

  $GameSessionDtoCopyWith<$Res> get session;
  $WordMatchingContentCopyWith<$Res> get content;
}

/// @nodoc
class _$StartGameSessionResponseCopyWithImpl<
  $Res,
  $Val extends StartGameSessionResponse
>
    implements $StartGameSessionResponseCopyWith<$Res> {
  _$StartGameSessionResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StartGameSessionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? session = null, Object? content = null}) {
    return _then(
      _value.copyWith(
            session:
                null == session
                    ? _value.session
                    : session // ignore: cast_nullable_to_non_nullable
                        as GameSessionDto,
            content:
                null == content
                    ? _value.content
                    : content // ignore: cast_nullable_to_non_nullable
                        as WordMatchingContent,
          )
          as $Val,
    );
  }

  /// Create a copy of StartGameSessionResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameSessionDtoCopyWith<$Res> get session {
    return $GameSessionDtoCopyWith<$Res>(_value.session, (value) {
      return _then(_value.copyWith(session: value) as $Val);
    });
  }

  /// Create a copy of StartGameSessionResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WordMatchingContentCopyWith<$Res> get content {
    return $WordMatchingContentCopyWith<$Res>(_value.content, (value) {
      return _then(_value.copyWith(content: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StartGameSessionResponseImplCopyWith<$Res>
    implements $StartGameSessionResponseCopyWith<$Res> {
  factory _$$StartGameSessionResponseImplCopyWith(
    _$StartGameSessionResponseImpl value,
    $Res Function(_$StartGameSessionResponseImpl) then,
  ) = __$$StartGameSessionResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({GameSessionDto session, WordMatchingContent content});

  @override
  $GameSessionDtoCopyWith<$Res> get session;
  @override
  $WordMatchingContentCopyWith<$Res> get content;
}

/// @nodoc
class __$$StartGameSessionResponseImplCopyWithImpl<$Res>
    extends
        _$StartGameSessionResponseCopyWithImpl<
          $Res,
          _$StartGameSessionResponseImpl
        >
    implements _$$StartGameSessionResponseImplCopyWith<$Res> {
  __$$StartGameSessionResponseImplCopyWithImpl(
    _$StartGameSessionResponseImpl _value,
    $Res Function(_$StartGameSessionResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StartGameSessionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? session = null, Object? content = null}) {
    return _then(
      _$StartGameSessionResponseImpl(
        session:
            null == session
                ? _value.session
                : session // ignore: cast_nullable_to_non_nullable
                    as GameSessionDto,
        content:
            null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                    as WordMatchingContent,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StartGameSessionResponseImpl implements _StartGameSessionResponse {
  const _$StartGameSessionResponseImpl({
    required this.session,
    required this.content,
  });

  factory _$StartGameSessionResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$StartGameSessionResponseImplFromJson(json);

  @override
  final GameSessionDto session;
  @override
  final WordMatchingContent content;

  @override
  String toString() {
    return 'StartGameSessionResponse(session: $session, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StartGameSessionResponseImpl &&
            (identical(other.session, session) || other.session == session) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, session, content);

  /// Create a copy of StartGameSessionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StartGameSessionResponseImplCopyWith<_$StartGameSessionResponseImpl>
  get copyWith => __$$StartGameSessionResponseImplCopyWithImpl<
    _$StartGameSessionResponseImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StartGameSessionResponseImplToJson(this);
  }
}

abstract class _StartGameSessionResponse implements StartGameSessionResponse {
  const factory _StartGameSessionResponse({
    required final GameSessionDto session,
    required final WordMatchingContent content,
  }) = _$StartGameSessionResponseImpl;

  factory _StartGameSessionResponse.fromJson(Map<String, dynamic> json) =
      _$StartGameSessionResponseImpl.fromJson;

  @override
  GameSessionDto get session;
  @override
  WordMatchingContent get content;

  /// Create a copy of StartGameSessionResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StartGameSessionResponseImplCopyWith<_$StartGameSessionResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}
