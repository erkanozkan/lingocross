// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tracking_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StudentSummaryDto _$StudentSummaryDtoFromJson(Map<String, dynamic> json) {
  return _StudentSummaryDto.fromJson(json);
}

/// @nodoc
mixin _$StudentSummaryDto {
  String get studentId => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  int get sharedResultsCount => throw _privateConstructorUsedError;
  int? get averageScore => throw _privateConstructorUsedError;
  DateTime? get lastActivityAt => throw _privateConstructorUsedError;

  /// Serializes this StudentSummaryDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StudentSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudentSummaryDtoCopyWith<StudentSummaryDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudentSummaryDtoCopyWith<$Res> {
  factory $StudentSummaryDtoCopyWith(
    StudentSummaryDto value,
    $Res Function(StudentSummaryDto) then,
  ) = _$StudentSummaryDtoCopyWithImpl<$Res, StudentSummaryDto>;
  @useResult
  $Res call({
    String studentId,
    String displayName,
    int sharedResultsCount,
    int? averageScore,
    DateTime? lastActivityAt,
  });
}

/// @nodoc
class _$StudentSummaryDtoCopyWithImpl<$Res, $Val extends StudentSummaryDto>
    implements $StudentSummaryDtoCopyWith<$Res> {
  _$StudentSummaryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StudentSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? studentId = null,
    Object? displayName = null,
    Object? sharedResultsCount = null,
    Object? averageScore = freezed,
    Object? lastActivityAt = freezed,
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
            sharedResultsCount:
                null == sharedResultsCount
                    ? _value.sharedResultsCount
                    : sharedResultsCount // ignore: cast_nullable_to_non_nullable
                        as int,
            averageScore:
                freezed == averageScore
                    ? _value.averageScore
                    : averageScore // ignore: cast_nullable_to_non_nullable
                        as int?,
            lastActivityAt:
                freezed == lastActivityAt
                    ? _value.lastActivityAt
                    : lastActivityAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StudentSummaryDtoImplCopyWith<$Res>
    implements $StudentSummaryDtoCopyWith<$Res> {
  factory _$$StudentSummaryDtoImplCopyWith(
    _$StudentSummaryDtoImpl value,
    $Res Function(_$StudentSummaryDtoImpl) then,
  ) = __$$StudentSummaryDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String studentId,
    String displayName,
    int sharedResultsCount,
    int? averageScore,
    DateTime? lastActivityAt,
  });
}

/// @nodoc
class __$$StudentSummaryDtoImplCopyWithImpl<$Res>
    extends _$StudentSummaryDtoCopyWithImpl<$Res, _$StudentSummaryDtoImpl>
    implements _$$StudentSummaryDtoImplCopyWith<$Res> {
  __$$StudentSummaryDtoImplCopyWithImpl(
    _$StudentSummaryDtoImpl _value,
    $Res Function(_$StudentSummaryDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StudentSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? studentId = null,
    Object? displayName = null,
    Object? sharedResultsCount = null,
    Object? averageScore = freezed,
    Object? lastActivityAt = freezed,
  }) {
    return _then(
      _$StudentSummaryDtoImpl(
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
        sharedResultsCount:
            null == sharedResultsCount
                ? _value.sharedResultsCount
                : sharedResultsCount // ignore: cast_nullable_to_non_nullable
                    as int,
        averageScore:
            freezed == averageScore
                ? _value.averageScore
                : averageScore // ignore: cast_nullable_to_non_nullable
                    as int?,
        lastActivityAt:
            freezed == lastActivityAt
                ? _value.lastActivityAt
                : lastActivityAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StudentSummaryDtoImpl extends _StudentSummaryDto {
  const _$StudentSummaryDtoImpl({
    required this.studentId,
    required this.displayName,
    required this.sharedResultsCount,
    this.averageScore,
    this.lastActivityAt,
  }) : super._();

  factory _$StudentSummaryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudentSummaryDtoImplFromJson(json);

  @override
  final String studentId;
  @override
  final String displayName;
  @override
  final int sharedResultsCount;
  @override
  final int? averageScore;
  @override
  final DateTime? lastActivityAt;

  @override
  String toString() {
    return 'StudentSummaryDto(studentId: $studentId, displayName: $displayName, sharedResultsCount: $sharedResultsCount, averageScore: $averageScore, lastActivityAt: $lastActivityAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudentSummaryDtoImpl &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.sharedResultsCount, sharedResultsCount) ||
                other.sharedResultsCount == sharedResultsCount) &&
            (identical(other.averageScore, averageScore) ||
                other.averageScore == averageScore) &&
            (identical(other.lastActivityAt, lastActivityAt) ||
                other.lastActivityAt == lastActivityAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    studentId,
    displayName,
    sharedResultsCount,
    averageScore,
    lastActivityAt,
  );

  /// Create a copy of StudentSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudentSummaryDtoImplCopyWith<_$StudentSummaryDtoImpl> get copyWith =>
      __$$StudentSummaryDtoImplCopyWithImpl<_$StudentSummaryDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StudentSummaryDtoImplToJson(this);
  }
}

abstract class _StudentSummaryDto extends StudentSummaryDto {
  const factory _StudentSummaryDto({
    required final String studentId,
    required final String displayName,
    required final int sharedResultsCount,
    final int? averageScore,
    final DateTime? lastActivityAt,
  }) = _$StudentSummaryDtoImpl;
  const _StudentSummaryDto._() : super._();

  factory _StudentSummaryDto.fromJson(Map<String, dynamic> json) =
      _$StudentSummaryDtoImpl.fromJson;

  @override
  String get studentId;
  @override
  String get displayName;
  @override
  int get sharedResultsCount;
  @override
  int? get averageScore;
  @override
  DateTime? get lastActivityAt;

  /// Create a copy of StudentSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudentSummaryDtoImplCopyWith<_$StudentSummaryDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SharedResultDto _$SharedResultDtoFromJson(Map<String, dynamic> json) {
  return _SharedResultDto.fromJson(json);
}

/// @nodoc
mixin _$SharedResultDto {
  String get resultId => throw _privateConstructorUsedError;
  String get lessonTitle => throw _privateConstructorUsedError;
  @GameTypeConverter()
  GameType get gameType => throw _privateConstructorUsedError;
  int get score => throw _privateConstructorUsedError;
  int get durationMs => throw _privateConstructorUsedError;
  int get totalItems => throw _privateConstructorUsedError;
  int get correctItems => throw _privateConstructorUsedError;
  DateTime? get sharedAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SharedResultDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SharedResultDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SharedResultDtoCopyWith<SharedResultDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SharedResultDtoCopyWith<$Res> {
  factory $SharedResultDtoCopyWith(
    SharedResultDto value,
    $Res Function(SharedResultDto) then,
  ) = _$SharedResultDtoCopyWithImpl<$Res, SharedResultDto>;
  @useResult
  $Res call({
    String resultId,
    String lessonTitle,
    @GameTypeConverter() GameType gameType,
    int score,
    int durationMs,
    int totalItems,
    int correctItems,
    DateTime? sharedAt,
    DateTime createdAt,
  });
}

/// @nodoc
class _$SharedResultDtoCopyWithImpl<$Res, $Val extends SharedResultDto>
    implements $SharedResultDtoCopyWith<$Res> {
  _$SharedResultDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SharedResultDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? resultId = null,
    Object? lessonTitle = null,
    Object? gameType = null,
    Object? score = null,
    Object? durationMs = null,
    Object? totalItems = null,
    Object? correctItems = null,
    Object? sharedAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            resultId:
                null == resultId
                    ? _value.resultId
                    : resultId // ignore: cast_nullable_to_non_nullable
                        as String,
            lessonTitle:
                null == lessonTitle
                    ? _value.lessonTitle
                    : lessonTitle // ignore: cast_nullable_to_non_nullable
                        as String,
            gameType:
                null == gameType
                    ? _value.gameType
                    : gameType // ignore: cast_nullable_to_non_nullable
                        as GameType,
            score:
                null == score
                    ? _value.score
                    : score // ignore: cast_nullable_to_non_nullable
                        as int,
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
abstract class _$$SharedResultDtoImplCopyWith<$Res>
    implements $SharedResultDtoCopyWith<$Res> {
  factory _$$SharedResultDtoImplCopyWith(
    _$SharedResultDtoImpl value,
    $Res Function(_$SharedResultDtoImpl) then,
  ) = __$$SharedResultDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String resultId,
    String lessonTitle,
    @GameTypeConverter() GameType gameType,
    int score,
    int durationMs,
    int totalItems,
    int correctItems,
    DateTime? sharedAt,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$SharedResultDtoImplCopyWithImpl<$Res>
    extends _$SharedResultDtoCopyWithImpl<$Res, _$SharedResultDtoImpl>
    implements _$$SharedResultDtoImplCopyWith<$Res> {
  __$$SharedResultDtoImplCopyWithImpl(
    _$SharedResultDtoImpl _value,
    $Res Function(_$SharedResultDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SharedResultDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? resultId = null,
    Object? lessonTitle = null,
    Object? gameType = null,
    Object? score = null,
    Object? durationMs = null,
    Object? totalItems = null,
    Object? correctItems = null,
    Object? sharedAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$SharedResultDtoImpl(
        resultId:
            null == resultId
                ? _value.resultId
                : resultId // ignore: cast_nullable_to_non_nullable
                    as String,
        lessonTitle:
            null == lessonTitle
                ? _value.lessonTitle
                : lessonTitle // ignore: cast_nullable_to_non_nullable
                    as String,
        gameType:
            null == gameType
                ? _value.gameType
                : gameType // ignore: cast_nullable_to_non_nullable
                    as GameType,
        score:
            null == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                    as int,
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
class _$SharedResultDtoImpl extends _SharedResultDto {
  const _$SharedResultDtoImpl({
    required this.resultId,
    required this.lessonTitle,
    @GameTypeConverter() required this.gameType,
    required this.score,
    required this.durationMs,
    required this.totalItems,
    required this.correctItems,
    this.sharedAt,
    required this.createdAt,
  }) : super._();

  factory _$SharedResultDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SharedResultDtoImplFromJson(json);

  @override
  final String resultId;
  @override
  final String lessonTitle;
  @override
  @GameTypeConverter()
  final GameType gameType;
  @override
  final int score;
  @override
  final int durationMs;
  @override
  final int totalItems;
  @override
  final int correctItems;
  @override
  final DateTime? sharedAt;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'SharedResultDto(resultId: $resultId, lessonTitle: $lessonTitle, gameType: $gameType, score: $score, durationMs: $durationMs, totalItems: $totalItems, correctItems: $correctItems, sharedAt: $sharedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SharedResultDtoImpl &&
            (identical(other.resultId, resultId) ||
                other.resultId == resultId) &&
            (identical(other.lessonTitle, lessonTitle) ||
                other.lessonTitle == lessonTitle) &&
            (identical(other.gameType, gameType) ||
                other.gameType == gameType) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.durationMs, durationMs) ||
                other.durationMs == durationMs) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            (identical(other.correctItems, correctItems) ||
                other.correctItems == correctItems) &&
            (identical(other.sharedAt, sharedAt) ||
                other.sharedAt == sharedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    resultId,
    lessonTitle,
    gameType,
    score,
    durationMs,
    totalItems,
    correctItems,
    sharedAt,
    createdAt,
  );

  /// Create a copy of SharedResultDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SharedResultDtoImplCopyWith<_$SharedResultDtoImpl> get copyWith =>
      __$$SharedResultDtoImplCopyWithImpl<_$SharedResultDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SharedResultDtoImplToJson(this);
  }
}

abstract class _SharedResultDto extends SharedResultDto {
  const factory _SharedResultDto({
    required final String resultId,
    required final String lessonTitle,
    @GameTypeConverter() required final GameType gameType,
    required final int score,
    required final int durationMs,
    required final int totalItems,
    required final int correctItems,
    final DateTime? sharedAt,
    required final DateTime createdAt,
  }) = _$SharedResultDtoImpl;
  const _SharedResultDto._() : super._();

  factory _SharedResultDto.fromJson(Map<String, dynamic> json) =
      _$SharedResultDtoImpl.fromJson;

  @override
  String get resultId;
  @override
  String get lessonTitle;
  @override
  @GameTypeConverter()
  GameType get gameType;
  @override
  int get score;
  @override
  int get durationMs;
  @override
  int get totalItems;
  @override
  int get correctItems;
  @override
  DateTime? get sharedAt;
  @override
  DateTime get createdAt;

  /// Create a copy of SharedResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SharedResultDtoImplCopyWith<_$SharedResultDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
