// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'result_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SubmitResultRequest _$SubmitResultRequestFromJson(Map<String, dynamic> json) {
  return _SubmitResultRequest.fromJson(json);
}

/// @nodoc
mixin _$SubmitResultRequest {
  int get durationMs => throw _privateConstructorUsedError;
  int get totalItems => throw _privateConstructorUsedError;
  int get correctItems => throw _privateConstructorUsedError;

  /// Serializes this SubmitResultRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubmitResultRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubmitResultRequestCopyWith<SubmitResultRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubmitResultRequestCopyWith<$Res> {
  factory $SubmitResultRequestCopyWith(
    SubmitResultRequest value,
    $Res Function(SubmitResultRequest) then,
  ) = _$SubmitResultRequestCopyWithImpl<$Res, SubmitResultRequest>;
  @useResult
  $Res call({int durationMs, int totalItems, int correctItems});
}

/// @nodoc
class _$SubmitResultRequestCopyWithImpl<$Res, $Val extends SubmitResultRequest>
    implements $SubmitResultRequestCopyWith<$Res> {
  _$SubmitResultRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubmitResultRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? durationMs = null,
    Object? totalItems = null,
    Object? correctItems = null,
  }) {
    return _then(
      _value.copyWith(
            durationMs:
                null == durationMs
                    ? _value.durationMs
                    : durationMs // ignore: cast_nullable_to_non_nullable
                        as int,
            totalItems:
                null == totalItems
                    ? _value.totalItems
                    : totalItems // ignore: cast_nullable_to_non_nullable
                        as int,
            correctItems:
                null == correctItems
                    ? _value.correctItems
                    : correctItems // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SubmitResultRequestImplCopyWith<$Res>
    implements $SubmitResultRequestCopyWith<$Res> {
  factory _$$SubmitResultRequestImplCopyWith(
    _$SubmitResultRequestImpl value,
    $Res Function(_$SubmitResultRequestImpl) then,
  ) = __$$SubmitResultRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int durationMs, int totalItems, int correctItems});
}

/// @nodoc
class __$$SubmitResultRequestImplCopyWithImpl<$Res>
    extends _$SubmitResultRequestCopyWithImpl<$Res, _$SubmitResultRequestImpl>
    implements _$$SubmitResultRequestImplCopyWith<$Res> {
  __$$SubmitResultRequestImplCopyWithImpl(
    _$SubmitResultRequestImpl _value,
    $Res Function(_$SubmitResultRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubmitResultRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? durationMs = null,
    Object? totalItems = null,
    Object? correctItems = null,
  }) {
    return _then(
      _$SubmitResultRequestImpl(
        durationMs:
            null == durationMs
                ? _value.durationMs
                : durationMs // ignore: cast_nullable_to_non_nullable
                    as int,
        totalItems:
            null == totalItems
                ? _value.totalItems
                : totalItems // ignore: cast_nullable_to_non_nullable
                    as int,
        correctItems:
            null == correctItems
                ? _value.correctItems
                : correctItems // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SubmitResultRequestImpl implements _SubmitResultRequest {
  const _$SubmitResultRequestImpl({
    required this.durationMs,
    required this.totalItems,
    required this.correctItems,
  });

  factory _$SubmitResultRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubmitResultRequestImplFromJson(json);

  @override
  final int durationMs;
  @override
  final int totalItems;
  @override
  final int correctItems;

  @override
  String toString() {
    return 'SubmitResultRequest(durationMs: $durationMs, totalItems: $totalItems, correctItems: $correctItems)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubmitResultRequestImpl &&
            (identical(other.durationMs, durationMs) ||
                other.durationMs == durationMs) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            (identical(other.correctItems, correctItems) ||
                other.correctItems == correctItems));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, durationMs, totalItems, correctItems);

  /// Create a copy of SubmitResultRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubmitResultRequestImplCopyWith<_$SubmitResultRequestImpl> get copyWith =>
      __$$SubmitResultRequestImplCopyWithImpl<_$SubmitResultRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SubmitResultRequestImplToJson(this);
  }
}

abstract class _SubmitResultRequest implements SubmitResultRequest {
  const factory _SubmitResultRequest({
    required final int durationMs,
    required final int totalItems,
    required final int correctItems,
  }) = _$SubmitResultRequestImpl;

  factory _SubmitResultRequest.fromJson(Map<String, dynamic> json) =
      _$SubmitResultRequestImpl.fromJson;

  @override
  int get durationMs;
  @override
  int get totalItems;
  @override
  int get correctItems;

  /// Create a copy of SubmitResultRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubmitResultRequestImplCopyWith<_$SubmitResultRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GameResultDto _$GameResultDtoFromJson(Map<String, dynamic> json) {
  return _GameResultDto.fromJson(json);
}

/// @nodoc
mixin _$GameResultDto {
  String get id => throw _privateConstructorUsedError;
  String get sessionId => throw _privateConstructorUsedError;
  String get gameId => throw _privateConstructorUsedError;
  @GameTypeConverter()
  GameType get gameType => throw _privateConstructorUsedError;
  String get lessonId => throw _privateConstructorUsedError;
  String get lessonTitle => throw _privateConstructorUsedError;
  int get durationMs => throw _privateConstructorUsedError;
  int get totalItems => throw _privateConstructorUsedError;
  int get correctItems => throw _privateConstructorUsedError;
  int get score => throw _privateConstructorUsedError;
  bool get sharedWithTeacher => throw _privateConstructorUsedError;
  DateTime? get sharedAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this GameResultDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameResultDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameResultDtoCopyWith<GameResultDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameResultDtoCopyWith<$Res> {
  factory $GameResultDtoCopyWith(
    GameResultDto value,
    $Res Function(GameResultDto) then,
  ) = _$GameResultDtoCopyWithImpl<$Res, GameResultDto>;
  @useResult
  $Res call({
    String id,
    String sessionId,
    String gameId,
    @GameTypeConverter() GameType gameType,
    String lessonId,
    String lessonTitle,
    int durationMs,
    int totalItems,
    int correctItems,
    int score,
    bool sharedWithTeacher,
    DateTime? sharedAt,
    DateTime createdAt,
  });
}

/// @nodoc
class _$GameResultDtoCopyWithImpl<$Res, $Val extends GameResultDto>
    implements $GameResultDtoCopyWith<$Res> {
  _$GameResultDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameResultDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? gameId = null,
    Object? gameType = null,
    Object? lessonId = null,
    Object? lessonTitle = null,
    Object? durationMs = null,
    Object? totalItems = null,
    Object? correctItems = null,
    Object? score = null,
    Object? sharedWithTeacher = null,
    Object? sharedAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            sessionId:
                null == sessionId
                    ? _value.sessionId
                    : sessionId // ignore: cast_nullable_to_non_nullable
                        as String,
            gameId:
                null == gameId
                    ? _value.gameId
                    : gameId // ignore: cast_nullable_to_non_nullable
                        as String,
            gameType:
                null == gameType
                    ? _value.gameType
                    : gameType // ignore: cast_nullable_to_non_nullable
                        as GameType,
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
            durationMs:
                null == durationMs
                    ? _value.durationMs
                    : durationMs // ignore: cast_nullable_to_non_nullable
                        as int,
            totalItems:
                null == totalItems
                    ? _value.totalItems
                    : totalItems // ignore: cast_nullable_to_non_nullable
                        as int,
            correctItems:
                null == correctItems
                    ? _value.correctItems
                    : correctItems // ignore: cast_nullable_to_non_nullable
                        as int,
            score:
                null == score
                    ? _value.score
                    : score // ignore: cast_nullable_to_non_nullable
                        as int,
            sharedWithTeacher:
                null == sharedWithTeacher
                    ? _value.sharedWithTeacher
                    : sharedWithTeacher // ignore: cast_nullable_to_non_nullable
                        as bool,
            sharedAt:
                freezed == sharedAt
                    ? _value.sharedAt
                    : sharedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
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
abstract class _$$GameResultDtoImplCopyWith<$Res>
    implements $GameResultDtoCopyWith<$Res> {
  factory _$$GameResultDtoImplCopyWith(
    _$GameResultDtoImpl value,
    $Res Function(_$GameResultDtoImpl) then,
  ) = __$$GameResultDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String sessionId,
    String gameId,
    @GameTypeConverter() GameType gameType,
    String lessonId,
    String lessonTitle,
    int durationMs,
    int totalItems,
    int correctItems,
    int score,
    bool sharedWithTeacher,
    DateTime? sharedAt,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$GameResultDtoImplCopyWithImpl<$Res>
    extends _$GameResultDtoCopyWithImpl<$Res, _$GameResultDtoImpl>
    implements _$$GameResultDtoImplCopyWith<$Res> {
  __$$GameResultDtoImplCopyWithImpl(
    _$GameResultDtoImpl _value,
    $Res Function(_$GameResultDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameResultDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? gameId = null,
    Object? gameType = null,
    Object? lessonId = null,
    Object? lessonTitle = null,
    Object? durationMs = null,
    Object? totalItems = null,
    Object? correctItems = null,
    Object? score = null,
    Object? sharedWithTeacher = null,
    Object? sharedAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$GameResultDtoImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        sessionId:
            null == sessionId
                ? _value.sessionId
                : sessionId // ignore: cast_nullable_to_non_nullable
                    as String,
        gameId:
            null == gameId
                ? _value.gameId
                : gameId // ignore: cast_nullable_to_non_nullable
                    as String,
        gameType:
            null == gameType
                ? _value.gameType
                : gameType // ignore: cast_nullable_to_non_nullable
                    as GameType,
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
        durationMs:
            null == durationMs
                ? _value.durationMs
                : durationMs // ignore: cast_nullable_to_non_nullable
                    as int,
        totalItems:
            null == totalItems
                ? _value.totalItems
                : totalItems // ignore: cast_nullable_to_non_nullable
                    as int,
        correctItems:
            null == correctItems
                ? _value.correctItems
                : correctItems // ignore: cast_nullable_to_non_nullable
                    as int,
        score:
            null == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                    as int,
        sharedWithTeacher:
            null == sharedWithTeacher
                ? _value.sharedWithTeacher
                : sharedWithTeacher // ignore: cast_nullable_to_non_nullable
                    as bool,
        sharedAt:
            freezed == sharedAt
                ? _value.sharedAt
                : sharedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
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
class _$GameResultDtoImpl extends _GameResultDto {
  const _$GameResultDtoImpl({
    required this.id,
    required this.sessionId,
    required this.gameId,
    @GameTypeConverter() required this.gameType,
    required this.lessonId,
    required this.lessonTitle,
    required this.durationMs,
    required this.totalItems,
    required this.correctItems,
    required this.score,
    required this.sharedWithTeacher,
    this.sharedAt,
    required this.createdAt,
  }) : super._();

  factory _$GameResultDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameResultDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String sessionId;
  @override
  final String gameId;
  @override
  @GameTypeConverter()
  final GameType gameType;
  @override
  final String lessonId;
  @override
  final String lessonTitle;
  @override
  final int durationMs;
  @override
  final int totalItems;
  @override
  final int correctItems;
  @override
  final int score;
  @override
  final bool sharedWithTeacher;
  @override
  final DateTime? sharedAt;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'GameResultDto(id: $id, sessionId: $sessionId, gameId: $gameId, gameType: $gameType, lessonId: $lessonId, lessonTitle: $lessonTitle, durationMs: $durationMs, totalItems: $totalItems, correctItems: $correctItems, score: $score, sharedWithTeacher: $sharedWithTeacher, sharedAt: $sharedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameResultDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.gameId, gameId) || other.gameId == gameId) &&
            (identical(other.gameType, gameType) ||
                other.gameType == gameType) &&
            (identical(other.lessonId, lessonId) ||
                other.lessonId == lessonId) &&
            (identical(other.lessonTitle, lessonTitle) ||
                other.lessonTitle == lessonTitle) &&
            (identical(other.durationMs, durationMs) ||
                other.durationMs == durationMs) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            (identical(other.correctItems, correctItems) ||
                other.correctItems == correctItems) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.sharedWithTeacher, sharedWithTeacher) ||
                other.sharedWithTeacher == sharedWithTeacher) &&
            (identical(other.sharedAt, sharedAt) ||
                other.sharedAt == sharedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    sessionId,
    gameId,
    gameType,
    lessonId,
    lessonTitle,
    durationMs,
    totalItems,
    correctItems,
    score,
    sharedWithTeacher,
    sharedAt,
    createdAt,
  );

  /// Create a copy of GameResultDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameResultDtoImplCopyWith<_$GameResultDtoImpl> get copyWith =>
      __$$GameResultDtoImplCopyWithImpl<_$GameResultDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameResultDtoImplToJson(this);
  }
}

abstract class _GameResultDto extends GameResultDto {
  const factory _GameResultDto({
    required final String id,
    required final String sessionId,
    required final String gameId,
    @GameTypeConverter() required final GameType gameType,
    required final String lessonId,
    required final String lessonTitle,
    required final int durationMs,
    required final int totalItems,
    required final int correctItems,
    required final int score,
    required final bool sharedWithTeacher,
    final DateTime? sharedAt,
    required final DateTime createdAt,
  }) = _$GameResultDtoImpl;
  const _GameResultDto._() : super._();

  factory _GameResultDto.fromJson(Map<String, dynamic> json) =
      _$GameResultDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get sessionId;
  @override
  String get gameId;
  @override
  @GameTypeConverter()
  GameType get gameType;
  @override
  String get lessonId;
  @override
  String get lessonTitle;
  @override
  int get durationMs;
  @override
  int get totalItems;
  @override
  int get correctItems;
  @override
  int get score;
  @override
  bool get sharedWithTeacher;
  @override
  DateTime? get sharedAt;
  @override
  DateTime get createdAt;

  /// Create a copy of GameResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameResultDtoImplCopyWith<_$GameResultDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
