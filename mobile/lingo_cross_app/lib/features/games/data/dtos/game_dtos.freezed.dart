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
  bool get isCompleted => throw _privateConstructorUsedError;
  String? get resultId => throw _privateConstructorUsedError;
  int? get score => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;

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
    bool isCompleted,
    String? resultId,
    int? score,
    DateTime? completedAt,
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
    Object? isCompleted = null,
    Object? resultId = freezed,
    Object? score = freezed,
    Object? completedAt = freezed,
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
            isCompleted:
                null == isCompleted
                    ? _value.isCompleted
                    : isCompleted // ignore: cast_nullable_to_non_nullable
                        as bool,
            resultId:
                freezed == resultId
                    ? _value.resultId
                    : resultId // ignore: cast_nullable_to_non_nullable
                        as String?,
            score:
                freezed == score
                    ? _value.score
                    : score // ignore: cast_nullable_to_non_nullable
                        as int?,
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
    bool isCompleted,
    String? resultId,
    int? score,
    DateTime? completedAt,
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
    Object? isCompleted = null,
    Object? resultId = freezed,
    Object? score = freezed,
    Object? completedAt = freezed,
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
        isCompleted:
            null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                    as bool,
        resultId:
            freezed == resultId
                ? _value.resultId
                : resultId // ignore: cast_nullable_to_non_nullable
                    as String?,
        score:
            freezed == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                    as int?,
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
    this.isCompleted = false,
    this.resultId,
    this.score,
    this.completedAt,
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
  @JsonKey()
  final bool isCompleted;
  @override
  final String? resultId;
  @override
  final int? score;
  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'AssignedGameDto(id: $id, lessonId: $lessonId, lessonTitle: $lessonTitle, type: $type, title: $title, wordCount: $wordCount, teacherName: $teacherName, publishedAt: $publishedAt, isCompleted: $isCompleted, resultId: $resultId, score: $score, completedAt: $completedAt)';
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
                other.publishedAt == publishedAt) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.resultId, resultId) ||
                other.resultId == resultId) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
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
    isCompleted,
    resultId,
    score,
    completedAt,
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
    final bool isCompleted,
    final String? resultId,
    final int? score,
    final DateTime? completedAt,
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
  @override
  bool get isCompleted;
  @override
  String? get resultId;
  @override
  int? get score;
  @override
  DateTime? get completedAt;

  /// Create a copy of AssignedGameDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AssignedGameDtoImplCopyWith<_$AssignedGameDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TeacherPuzzleDto _$TeacherPuzzleDtoFromJson(Map<String, dynamic> json) {
  return _TeacherPuzzleDto.fromJson(json);
}

/// @nodoc
mixin _$TeacherPuzzleDto {
  String get id => throw _privateConstructorUsedError;
  String get lessonId => throw _privateConstructorUsedError;
  String get lessonTitle => throw _privateConstructorUsedError;
  @GameTypeConverter()
  GameType get type => throw _privateConstructorUsedError;
  bool get isPublished => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  int get assignedStudentCount => throw _privateConstructorUsedError;
  int get solveCount => throw _privateConstructorUsedError;

  /// Serializes this TeacherPuzzleDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeacherPuzzleDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeacherPuzzleDtoCopyWith<TeacherPuzzleDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeacherPuzzleDtoCopyWith<$Res> {
  factory $TeacherPuzzleDtoCopyWith(
    TeacherPuzzleDto value,
    $Res Function(TeacherPuzzleDto) then,
  ) = _$TeacherPuzzleDtoCopyWithImpl<$Res, TeacherPuzzleDto>;
  @useResult
  $Res call({
    String id,
    String lessonId,
    String lessonTitle,
    @GameTypeConverter() GameType type,
    bool isPublished,
    DateTime createdAt,
    int assignedStudentCount,
    int solveCount,
  });
}

/// @nodoc
class _$TeacherPuzzleDtoCopyWithImpl<$Res, $Val extends TeacherPuzzleDto>
    implements $TeacherPuzzleDtoCopyWith<$Res> {
  _$TeacherPuzzleDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeacherPuzzleDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? lessonId = null,
    Object? lessonTitle = null,
    Object? type = null,
    Object? isPublished = null,
    Object? createdAt = null,
    Object? assignedStudentCount = null,
    Object? solveCount = null,
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
            isPublished:
                null == isPublished
                    ? _value.isPublished
                    : isPublished // ignore: cast_nullable_to_non_nullable
                        as bool,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            assignedStudentCount:
                null == assignedStudentCount
                    ? _value.assignedStudentCount
                    : assignedStudentCount // ignore: cast_nullable_to_non_nullable
                        as int,
            solveCount:
                null == solveCount
                    ? _value.solveCount
                    : solveCount // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TeacherPuzzleDtoImplCopyWith<$Res>
    implements $TeacherPuzzleDtoCopyWith<$Res> {
  factory _$$TeacherPuzzleDtoImplCopyWith(
    _$TeacherPuzzleDtoImpl value,
    $Res Function(_$TeacherPuzzleDtoImpl) then,
  ) = __$$TeacherPuzzleDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String lessonId,
    String lessonTitle,
    @GameTypeConverter() GameType type,
    bool isPublished,
    DateTime createdAt,
    int assignedStudentCount,
    int solveCount,
  });
}

/// @nodoc
class __$$TeacherPuzzleDtoImplCopyWithImpl<$Res>
    extends _$TeacherPuzzleDtoCopyWithImpl<$Res, _$TeacherPuzzleDtoImpl>
    implements _$$TeacherPuzzleDtoImplCopyWith<$Res> {
  __$$TeacherPuzzleDtoImplCopyWithImpl(
    _$TeacherPuzzleDtoImpl _value,
    $Res Function(_$TeacherPuzzleDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TeacherPuzzleDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? lessonId = null,
    Object? lessonTitle = null,
    Object? type = null,
    Object? isPublished = null,
    Object? createdAt = null,
    Object? assignedStudentCount = null,
    Object? solveCount = null,
  }) {
    return _then(
      _$TeacherPuzzleDtoImpl(
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
        isPublished:
            null == isPublished
                ? _value.isPublished
                : isPublished // ignore: cast_nullable_to_non_nullable
                    as bool,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        assignedStudentCount:
            null == assignedStudentCount
                ? _value.assignedStudentCount
                : assignedStudentCount // ignore: cast_nullable_to_non_nullable
                    as int,
        solveCount:
            null == solveCount
                ? _value.solveCount
                : solveCount // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TeacherPuzzleDtoImpl implements _TeacherPuzzleDto {
  const _$TeacherPuzzleDtoImpl({
    required this.id,
    required this.lessonId,
    required this.lessonTitle,
    @GameTypeConverter() required this.type,
    required this.isPublished,
    required this.createdAt,
    required this.assignedStudentCount,
    required this.solveCount,
  });

  factory _$TeacherPuzzleDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeacherPuzzleDtoImplFromJson(json);

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
  final bool isPublished;
  @override
  final DateTime createdAt;
  @override
  final int assignedStudentCount;
  @override
  final int solveCount;

  @override
  String toString() {
    return 'TeacherPuzzleDto(id: $id, lessonId: $lessonId, lessonTitle: $lessonTitle, type: $type, isPublished: $isPublished, createdAt: $createdAt, assignedStudentCount: $assignedStudentCount, solveCount: $solveCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeacherPuzzleDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.lessonId, lessonId) ||
                other.lessonId == lessonId) &&
            (identical(other.lessonTitle, lessonTitle) ||
                other.lessonTitle == lessonTitle) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isPublished, isPublished) ||
                other.isPublished == isPublished) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.assignedStudentCount, assignedStudentCount) ||
                other.assignedStudentCount == assignedStudentCount) &&
            (identical(other.solveCount, solveCount) ||
                other.solveCount == solveCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    lessonId,
    lessonTitle,
    type,
    isPublished,
    createdAt,
    assignedStudentCount,
    solveCount,
  );

  /// Create a copy of TeacherPuzzleDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeacherPuzzleDtoImplCopyWith<_$TeacherPuzzleDtoImpl> get copyWith =>
      __$$TeacherPuzzleDtoImplCopyWithImpl<_$TeacherPuzzleDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TeacherPuzzleDtoImplToJson(this);
  }
}

abstract class _TeacherPuzzleDto implements TeacherPuzzleDto {
  const factory _TeacherPuzzleDto({
    required final String id,
    required final String lessonId,
    required final String lessonTitle,
    @GameTypeConverter() required final GameType type,
    required final bool isPublished,
    required final DateTime createdAt,
    required final int assignedStudentCount,
    required final int solveCount,
  }) = _$TeacherPuzzleDtoImpl;

  factory _TeacherPuzzleDto.fromJson(Map<String, dynamic> json) =
      _$TeacherPuzzleDtoImpl.fromJson;

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
  bool get isPublished;
  @override
  DateTime get createdAt;
  @override
  int get assignedStudentCount;
  @override
  int get solveCount;

  /// Create a copy of TeacherPuzzleDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeacherPuzzleDtoImplCopyWith<_$TeacherPuzzleDtoImpl> get copyWith =>
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
  List<String>? get classIds => throw _privateConstructorUsedError;

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
  $Res call({
    @GameTypeConverter() GameType type,
    String? title,
    List<String>? classIds,
  });
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
  $Res call({
    Object? type = null,
    Object? title = freezed,
    Object? classIds = freezed,
  }) {
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
            classIds:
                freezed == classIds
                    ? _value.classIds
                    : classIds // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
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
  $Res call({
    @GameTypeConverter() GameType type,
    String? title,
    List<String>? classIds,
  });
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
  $Res call({
    Object? type = null,
    Object? title = freezed,
    Object? classIds = freezed,
  }) {
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
        classIds:
            freezed == classIds
                ? _value._classIds
                : classIds // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
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
    final List<String>? classIds,
  }) : _classIds = classIds;

  factory _$CreateGameRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateGameRequestImplFromJson(json);

  @override
  @GameTypeConverter()
  final GameType type;
  @override
  final String? title;
  final List<String>? _classIds;
  @override
  List<String>? get classIds {
    final value = _classIds;
    if (value == null) return null;
    if (_classIds is EqualUnmodifiableListView) return _classIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'CreateGameRequest(type: $type, title: $title, classIds: $classIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateGameRequestImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._classIds, _classIds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    title,
    const DeepCollectionEquality().hash(_classIds),
  );

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
    final List<String>? classIds,
  }) = _$CreateGameRequestImpl;

  factory _CreateGameRequest.fromJson(Map<String, dynamic> json) =
      _$CreateGameRequestImpl.fromJson;

  @override
  @GameTypeConverter()
  GameType get type;
  @override
  String? get title;
  @override
  List<String>? get classIds;

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

CrosswordEntry _$CrosswordEntryFromJson(Map<String, dynamic> json) {
  return _CrosswordEntry.fromJson(json);
}

/// @nodoc
mixin _$CrosswordEntry {
  int get number => throw _privateConstructorUsedError;
  String get answer => throw _privateConstructorUsedError;
  String get clue => throw _privateConstructorUsedError;
  int get row => throw _privateConstructorUsedError;
  int get col => throw _privateConstructorUsedError;
  @CrosswordDirectionConverter()
  CrosswordDirection get direction => throw _privateConstructorUsedError;
  int get length => throw _privateConstructorUsedError;

  /// Serializes this CrosswordEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CrosswordEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CrosswordEntryCopyWith<CrosswordEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CrosswordEntryCopyWith<$Res> {
  factory $CrosswordEntryCopyWith(
    CrosswordEntry value,
    $Res Function(CrosswordEntry) then,
  ) = _$CrosswordEntryCopyWithImpl<$Res, CrosswordEntry>;
  @useResult
  $Res call({
    int number,
    String answer,
    String clue,
    int row,
    int col,
    @CrosswordDirectionConverter() CrosswordDirection direction,
    int length,
  });
}

/// @nodoc
class _$CrosswordEntryCopyWithImpl<$Res, $Val extends CrosswordEntry>
    implements $CrosswordEntryCopyWith<$Res> {
  _$CrosswordEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CrosswordEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? number = null,
    Object? answer = null,
    Object? clue = null,
    Object? row = null,
    Object? col = null,
    Object? direction = null,
    Object? length = null,
  }) {
    return _then(
      _value.copyWith(
            number:
                null == number
                    ? _value.number
                    : number // ignore: cast_nullable_to_non_nullable
                        as int,
            answer:
                null == answer
                    ? _value.answer
                    : answer // ignore: cast_nullable_to_non_nullable
                        as String,
            clue:
                null == clue
                    ? _value.clue
                    : clue // ignore: cast_nullable_to_non_nullable
                        as String,
            row:
                null == row
                    ? _value.row
                    : row // ignore: cast_nullable_to_non_nullable
                        as int,
            col:
                null == col
                    ? _value.col
                    : col // ignore: cast_nullable_to_non_nullable
                        as int,
            direction:
                null == direction
                    ? _value.direction
                    : direction // ignore: cast_nullable_to_non_nullable
                        as CrosswordDirection,
            length:
                null == length
                    ? _value.length
                    : length // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CrosswordEntryImplCopyWith<$Res>
    implements $CrosswordEntryCopyWith<$Res> {
  factory _$$CrosswordEntryImplCopyWith(
    _$CrosswordEntryImpl value,
    $Res Function(_$CrosswordEntryImpl) then,
  ) = __$$CrosswordEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int number,
    String answer,
    String clue,
    int row,
    int col,
    @CrosswordDirectionConverter() CrosswordDirection direction,
    int length,
  });
}

/// @nodoc
class __$$CrosswordEntryImplCopyWithImpl<$Res>
    extends _$CrosswordEntryCopyWithImpl<$Res, _$CrosswordEntryImpl>
    implements _$$CrosswordEntryImplCopyWith<$Res> {
  __$$CrosswordEntryImplCopyWithImpl(
    _$CrosswordEntryImpl _value,
    $Res Function(_$CrosswordEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CrosswordEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? number = null,
    Object? answer = null,
    Object? clue = null,
    Object? row = null,
    Object? col = null,
    Object? direction = null,
    Object? length = null,
  }) {
    return _then(
      _$CrosswordEntryImpl(
        number:
            null == number
                ? _value.number
                : number // ignore: cast_nullable_to_non_nullable
                    as int,
        answer:
            null == answer
                ? _value.answer
                : answer // ignore: cast_nullable_to_non_nullable
                    as String,
        clue:
            null == clue
                ? _value.clue
                : clue // ignore: cast_nullable_to_non_nullable
                    as String,
        row:
            null == row
                ? _value.row
                : row // ignore: cast_nullable_to_non_nullable
                    as int,
        col:
            null == col
                ? _value.col
                : col // ignore: cast_nullable_to_non_nullable
                    as int,
        direction:
            null == direction
                ? _value.direction
                : direction // ignore: cast_nullable_to_non_nullable
                    as CrosswordDirection,
        length:
            null == length
                ? _value.length
                : length // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CrosswordEntryImpl implements _CrosswordEntry {
  const _$CrosswordEntryImpl({
    required this.number,
    required this.answer,
    required this.clue,
    required this.row,
    required this.col,
    @CrosswordDirectionConverter() required this.direction,
    required this.length,
  });

  factory _$CrosswordEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CrosswordEntryImplFromJson(json);

  @override
  final int number;
  @override
  final String answer;
  @override
  final String clue;
  @override
  final int row;
  @override
  final int col;
  @override
  @CrosswordDirectionConverter()
  final CrosswordDirection direction;
  @override
  final int length;

  @override
  String toString() {
    return 'CrosswordEntry(number: $number, answer: $answer, clue: $clue, row: $row, col: $col, direction: $direction, length: $length)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CrosswordEntryImpl &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.answer, answer) || other.answer == answer) &&
            (identical(other.clue, clue) || other.clue == clue) &&
            (identical(other.row, row) || other.row == row) &&
            (identical(other.col, col) || other.col == col) &&
            (identical(other.direction, direction) ||
                other.direction == direction) &&
            (identical(other.length, length) || other.length == length));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    number,
    answer,
    clue,
    row,
    col,
    direction,
    length,
  );

  /// Create a copy of CrosswordEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CrosswordEntryImplCopyWith<_$CrosswordEntryImpl> get copyWith =>
      __$$CrosswordEntryImplCopyWithImpl<_$CrosswordEntryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CrosswordEntryImplToJson(this);
  }
}

abstract class _CrosswordEntry implements CrosswordEntry {
  const factory _CrosswordEntry({
    required final int number,
    required final String answer,
    required final String clue,
    required final int row,
    required final int col,
    @CrosswordDirectionConverter() required final CrosswordDirection direction,
    required final int length,
  }) = _$CrosswordEntryImpl;

  factory _CrosswordEntry.fromJson(Map<String, dynamic> json) =
      _$CrosswordEntryImpl.fromJson;

  @override
  int get number;
  @override
  String get answer;
  @override
  String get clue;
  @override
  int get row;
  @override
  int get col;
  @override
  @CrosswordDirectionConverter()
  CrosswordDirection get direction;
  @override
  int get length;

  /// Create a copy of CrosswordEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CrosswordEntryImplCopyWith<_$CrosswordEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CrosswordContent _$CrosswordContentFromJson(Map<String, dynamic> json) {
  return _CrosswordContent.fromJson(json);
}

/// @nodoc
mixin _$CrosswordContent {
  int get rows => throw _privateConstructorUsedError;
  int get cols => throw _privateConstructorUsedError;
  List<CrosswordEntry> get entries => throw _privateConstructorUsedError;

  /// Serializes this CrosswordContent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CrosswordContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CrosswordContentCopyWith<CrosswordContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CrosswordContentCopyWith<$Res> {
  factory $CrosswordContentCopyWith(
    CrosswordContent value,
    $Res Function(CrosswordContent) then,
  ) = _$CrosswordContentCopyWithImpl<$Res, CrosswordContent>;
  @useResult
  $Res call({int rows, int cols, List<CrosswordEntry> entries});
}

/// @nodoc
class _$CrosswordContentCopyWithImpl<$Res, $Val extends CrosswordContent>
    implements $CrosswordContentCopyWith<$Res> {
  _$CrosswordContentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CrosswordContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rows = null,
    Object? cols = null,
    Object? entries = null,
  }) {
    return _then(
      _value.copyWith(
            rows:
                null == rows
                    ? _value.rows
                    : rows // ignore: cast_nullable_to_non_nullable
                        as int,
            cols:
                null == cols
                    ? _value.cols
                    : cols // ignore: cast_nullable_to_non_nullable
                        as int,
            entries:
                null == entries
                    ? _value.entries
                    : entries // ignore: cast_nullable_to_non_nullable
                        as List<CrosswordEntry>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CrosswordContentImplCopyWith<$Res>
    implements $CrosswordContentCopyWith<$Res> {
  factory _$$CrosswordContentImplCopyWith(
    _$CrosswordContentImpl value,
    $Res Function(_$CrosswordContentImpl) then,
  ) = __$$CrosswordContentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int rows, int cols, List<CrosswordEntry> entries});
}

/// @nodoc
class __$$CrosswordContentImplCopyWithImpl<$Res>
    extends _$CrosswordContentCopyWithImpl<$Res, _$CrosswordContentImpl>
    implements _$$CrosswordContentImplCopyWith<$Res> {
  __$$CrosswordContentImplCopyWithImpl(
    _$CrosswordContentImpl _value,
    $Res Function(_$CrosswordContentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CrosswordContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rows = null,
    Object? cols = null,
    Object? entries = null,
  }) {
    return _then(
      _$CrosswordContentImpl(
        rows:
            null == rows
                ? _value.rows
                : rows // ignore: cast_nullable_to_non_nullable
                    as int,
        cols:
            null == cols
                ? _value.cols
                : cols // ignore: cast_nullable_to_non_nullable
                    as int,
        entries:
            null == entries
                ? _value._entries
                : entries // ignore: cast_nullable_to_non_nullable
                    as List<CrosswordEntry>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CrosswordContentImpl implements _CrosswordContent {
  const _$CrosswordContentImpl({
    required this.rows,
    required this.cols,
    required final List<CrosswordEntry> entries,
  }) : _entries = entries;

  factory _$CrosswordContentImpl.fromJson(Map<String, dynamic> json) =>
      _$$CrosswordContentImplFromJson(json);

  @override
  final int rows;
  @override
  final int cols;
  final List<CrosswordEntry> _entries;
  @override
  List<CrosswordEntry> get entries {
    if (_entries is EqualUnmodifiableListView) return _entries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entries);
  }

  @override
  String toString() {
    return 'CrosswordContent(rows: $rows, cols: $cols, entries: $entries)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CrosswordContentImpl &&
            (identical(other.rows, rows) || other.rows == rows) &&
            (identical(other.cols, cols) || other.cols == cols) &&
            const DeepCollectionEquality().equals(other._entries, _entries));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    rows,
    cols,
    const DeepCollectionEquality().hash(_entries),
  );

  /// Create a copy of CrosswordContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CrosswordContentImplCopyWith<_$CrosswordContentImpl> get copyWith =>
      __$$CrosswordContentImplCopyWithImpl<_$CrosswordContentImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CrosswordContentImplToJson(this);
  }
}

abstract class _CrosswordContent implements CrosswordContent {
  const factory _CrosswordContent({
    required final int rows,
    required final int cols,
    required final List<CrosswordEntry> entries,
  }) = _$CrosswordContentImpl;

  factory _CrosswordContent.fromJson(Map<String, dynamic> json) =
      _$CrosswordContentImpl.fromJson;

  @override
  int get rows;
  @override
  int get cols;
  @override
  List<CrosswordEntry> get entries;

  /// Create a copy of CrosswordContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CrosswordContentImplCopyWith<_$CrosswordContentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GamePreviewResponse _$GamePreviewResponseFromJson(Map<String, dynamic> json) {
  return _GamePreviewResponse.fromJson(json);
}

/// @nodoc
mixin _$GamePreviewResponse {
  @GameTypeConverter()
  GameType get type => throw _privateConstructorUsedError;
  WordMatchingContent? get wordMatching => throw _privateConstructorUsedError;
  CrosswordContent? get crossword => throw _privateConstructorUsedError;

  /// Serializes this GamePreviewResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GamePreviewResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GamePreviewResponseCopyWith<GamePreviewResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GamePreviewResponseCopyWith<$Res> {
  factory $GamePreviewResponseCopyWith(
    GamePreviewResponse value,
    $Res Function(GamePreviewResponse) then,
  ) = _$GamePreviewResponseCopyWithImpl<$Res, GamePreviewResponse>;
  @useResult
  $Res call({
    @GameTypeConverter() GameType type,
    WordMatchingContent? wordMatching,
    CrosswordContent? crossword,
  });

  $WordMatchingContentCopyWith<$Res>? get wordMatching;
  $CrosswordContentCopyWith<$Res>? get crossword;
}

/// @nodoc
class _$GamePreviewResponseCopyWithImpl<$Res, $Val extends GamePreviewResponse>
    implements $GamePreviewResponseCopyWith<$Res> {
  _$GamePreviewResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GamePreviewResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? wordMatching = freezed,
    Object? crossword = freezed,
  }) {
    return _then(
      _value.copyWith(
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as GameType,
            wordMatching:
                freezed == wordMatching
                    ? _value.wordMatching
                    : wordMatching // ignore: cast_nullable_to_non_nullable
                        as WordMatchingContent?,
            crossword:
                freezed == crossword
                    ? _value.crossword
                    : crossword // ignore: cast_nullable_to_non_nullable
                        as CrosswordContent?,
          )
          as $Val,
    );
  }

  /// Create a copy of GamePreviewResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WordMatchingContentCopyWith<$Res>? get wordMatching {
    if (_value.wordMatching == null) {
      return null;
    }

    return $WordMatchingContentCopyWith<$Res>(_value.wordMatching!, (value) {
      return _then(_value.copyWith(wordMatching: value) as $Val);
    });
  }

  /// Create a copy of GamePreviewResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CrosswordContentCopyWith<$Res>? get crossword {
    if (_value.crossword == null) {
      return null;
    }

    return $CrosswordContentCopyWith<$Res>(_value.crossword!, (value) {
      return _then(_value.copyWith(crossword: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GamePreviewResponseImplCopyWith<$Res>
    implements $GamePreviewResponseCopyWith<$Res> {
  factory _$$GamePreviewResponseImplCopyWith(
    _$GamePreviewResponseImpl value,
    $Res Function(_$GamePreviewResponseImpl) then,
  ) = __$$GamePreviewResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @GameTypeConverter() GameType type,
    WordMatchingContent? wordMatching,
    CrosswordContent? crossword,
  });

  @override
  $WordMatchingContentCopyWith<$Res>? get wordMatching;
  @override
  $CrosswordContentCopyWith<$Res>? get crossword;
}

/// @nodoc
class __$$GamePreviewResponseImplCopyWithImpl<$Res>
    extends _$GamePreviewResponseCopyWithImpl<$Res, _$GamePreviewResponseImpl>
    implements _$$GamePreviewResponseImplCopyWith<$Res> {
  __$$GamePreviewResponseImplCopyWithImpl(
    _$GamePreviewResponseImpl _value,
    $Res Function(_$GamePreviewResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GamePreviewResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? wordMatching = freezed,
    Object? crossword = freezed,
  }) {
    return _then(
      _$GamePreviewResponseImpl(
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as GameType,
        wordMatching:
            freezed == wordMatching
                ? _value.wordMatching
                : wordMatching // ignore: cast_nullable_to_non_nullable
                    as WordMatchingContent?,
        crossword:
            freezed == crossword
                ? _value.crossword
                : crossword // ignore: cast_nullable_to_non_nullable
                    as CrosswordContent?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GamePreviewResponseImpl implements _GamePreviewResponse {
  const _$GamePreviewResponseImpl({
    @GameTypeConverter() required this.type,
    this.wordMatching,
    this.crossword,
  });

  factory _$GamePreviewResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GamePreviewResponseImplFromJson(json);

  @override
  @GameTypeConverter()
  final GameType type;
  @override
  final WordMatchingContent? wordMatching;
  @override
  final CrosswordContent? crossword;

  @override
  String toString() {
    return 'GamePreviewResponse(type: $type, wordMatching: $wordMatching, crossword: $crossword)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GamePreviewResponseImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.wordMatching, wordMatching) ||
                other.wordMatching == wordMatching) &&
            (identical(other.crossword, crossword) ||
                other.crossword == crossword));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, wordMatching, crossword);

  /// Create a copy of GamePreviewResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GamePreviewResponseImplCopyWith<_$GamePreviewResponseImpl> get copyWith =>
      __$$GamePreviewResponseImplCopyWithImpl<_$GamePreviewResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GamePreviewResponseImplToJson(this);
  }
}

abstract class _GamePreviewResponse implements GamePreviewResponse {
  const factory _GamePreviewResponse({
    @GameTypeConverter() required final GameType type,
    final WordMatchingContent? wordMatching,
    final CrosswordContent? crossword,
  }) = _$GamePreviewResponseImpl;

  factory _GamePreviewResponse.fromJson(Map<String, dynamic> json) =
      _$GamePreviewResponseImpl.fromJson;

  @override
  @GameTypeConverter()
  GameType get type;
  @override
  WordMatchingContent? get wordMatching;
  @override
  CrosswordContent? get crossword;

  /// Create a copy of GamePreviewResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GamePreviewResponseImplCopyWith<_$GamePreviewResponseImpl> get copyWith =>
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
  @GameTypeConverter()
  GameType get type => throw _privateConstructorUsedError;
  WordMatchingContent? get wordMatching => throw _privateConstructorUsedError;
  CrosswordContent? get crossword => throw _privateConstructorUsedError;

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
  $Res call({
    GameSessionDto session,
    @GameTypeConverter() GameType type,
    WordMatchingContent? wordMatching,
    CrosswordContent? crossword,
  });

  $GameSessionDtoCopyWith<$Res> get session;
  $WordMatchingContentCopyWith<$Res>? get wordMatching;
  $CrosswordContentCopyWith<$Res>? get crossword;
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
  $Res call({
    Object? session = null,
    Object? type = null,
    Object? wordMatching = freezed,
    Object? crossword = freezed,
  }) {
    return _then(
      _value.copyWith(
            session:
                null == session
                    ? _value.session
                    : session // ignore: cast_nullable_to_non_nullable
                        as GameSessionDto,
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as GameType,
            wordMatching:
                freezed == wordMatching
                    ? _value.wordMatching
                    : wordMatching // ignore: cast_nullable_to_non_nullable
                        as WordMatchingContent?,
            crossword:
                freezed == crossword
                    ? _value.crossword
                    : crossword // ignore: cast_nullable_to_non_nullable
                        as CrosswordContent?,
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
  $WordMatchingContentCopyWith<$Res>? get wordMatching {
    if (_value.wordMatching == null) {
      return null;
    }

    return $WordMatchingContentCopyWith<$Res>(_value.wordMatching!, (value) {
      return _then(_value.copyWith(wordMatching: value) as $Val);
    });
  }

  /// Create a copy of StartGameSessionResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CrosswordContentCopyWith<$Res>? get crossword {
    if (_value.crossword == null) {
      return null;
    }

    return $CrosswordContentCopyWith<$Res>(_value.crossword!, (value) {
      return _then(_value.copyWith(crossword: value) as $Val);
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
  $Res call({
    GameSessionDto session,
    @GameTypeConverter() GameType type,
    WordMatchingContent? wordMatching,
    CrosswordContent? crossword,
  });

  @override
  $GameSessionDtoCopyWith<$Res> get session;
  @override
  $WordMatchingContentCopyWith<$Res>? get wordMatching;
  @override
  $CrosswordContentCopyWith<$Res>? get crossword;
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
  $Res call({
    Object? session = null,
    Object? type = null,
    Object? wordMatching = freezed,
    Object? crossword = freezed,
  }) {
    return _then(
      _$StartGameSessionResponseImpl(
        session:
            null == session
                ? _value.session
                : session // ignore: cast_nullable_to_non_nullable
                    as GameSessionDto,
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as GameType,
        wordMatching:
            freezed == wordMatching
                ? _value.wordMatching
                : wordMatching // ignore: cast_nullable_to_non_nullable
                    as WordMatchingContent?,
        crossword:
            freezed == crossword
                ? _value.crossword
                : crossword // ignore: cast_nullable_to_non_nullable
                    as CrosswordContent?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StartGameSessionResponseImpl implements _StartGameSessionResponse {
  const _$StartGameSessionResponseImpl({
    required this.session,
    @GameTypeConverter() required this.type,
    this.wordMatching,
    this.crossword,
  });

  factory _$StartGameSessionResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$StartGameSessionResponseImplFromJson(json);

  @override
  final GameSessionDto session;
  @override
  @GameTypeConverter()
  final GameType type;
  @override
  final WordMatchingContent? wordMatching;
  @override
  final CrosswordContent? crossword;

  @override
  String toString() {
    return 'StartGameSessionResponse(session: $session, type: $type, wordMatching: $wordMatching, crossword: $crossword)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StartGameSessionResponseImpl &&
            (identical(other.session, session) || other.session == session) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.wordMatching, wordMatching) ||
                other.wordMatching == wordMatching) &&
            (identical(other.crossword, crossword) ||
                other.crossword == crossword));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, session, type, wordMatching, crossword);

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
    @GameTypeConverter() required final GameType type,
    final WordMatchingContent? wordMatching,
    final CrosswordContent? crossword,
  }) = _$StartGameSessionResponseImpl;

  factory _StartGameSessionResponse.fromJson(Map<String, dynamic> json) =
      _$StartGameSessionResponseImpl.fromJson;

  @override
  GameSessionDto get session;
  @override
  @GameTypeConverter()
  GameType get type;
  @override
  WordMatchingContent? get wordMatching;
  @override
  CrosswordContent? get crossword;

  /// Create a copy of StartGameSessionResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StartGameSessionResponseImplCopyWith<_$StartGameSessionResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}
