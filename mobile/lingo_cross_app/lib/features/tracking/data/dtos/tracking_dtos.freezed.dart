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

ResultItemDto _$ResultItemDtoFromJson(Map<String, dynamic> json) {
  return _ResultItemDto.fromJson(json);
}

/// @nodoc
mixin _$ResultItemDto {
  int get ordinal => throw _privateConstructorUsedError;
  String get term => throw _privateConstructorUsedError;
  String get expectedAnswer => throw _privateConstructorUsedError;
  String? get studentAnswer => throw _privateConstructorUsedError;
  bool get isCorrect => throw _privateConstructorUsedError;

  /// Serializes this ResultItemDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ResultItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResultItemDtoCopyWith<ResultItemDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResultItemDtoCopyWith<$Res> {
  factory $ResultItemDtoCopyWith(
    ResultItemDto value,
    $Res Function(ResultItemDto) then,
  ) = _$ResultItemDtoCopyWithImpl<$Res, ResultItemDto>;
  @useResult
  $Res call({
    int ordinal,
    String term,
    String expectedAnswer,
    String? studentAnswer,
    bool isCorrect,
  });
}

/// @nodoc
class _$ResultItemDtoCopyWithImpl<$Res, $Val extends ResultItemDto>
    implements $ResultItemDtoCopyWith<$Res> {
  _$ResultItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResultItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ordinal = null,
    Object? term = null,
    Object? expectedAnswer = null,
    Object? studentAnswer = freezed,
    Object? isCorrect = null,
  }) {
    return _then(
      _value.copyWith(
            ordinal:
                null == ordinal
                    ? _value.ordinal
                    : ordinal // ignore: cast_nullable_to_non_nullable
                        as int,
            term:
                null == term
                    ? _value.term
                    : term // ignore: cast_nullable_to_non_nullable
                        as String,
            expectedAnswer:
                null == expectedAnswer
                    ? _value.expectedAnswer
                    : expectedAnswer // ignore: cast_nullable_to_non_nullable
                        as String,
            studentAnswer:
                freezed == studentAnswer
                    ? _value.studentAnswer
                    : studentAnswer // ignore: cast_nullable_to_non_nullable
                        as String?,
            isCorrect:
                null == isCorrect
                    ? _value.isCorrect
                    : isCorrect // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ResultItemDtoImplCopyWith<$Res>
    implements $ResultItemDtoCopyWith<$Res> {
  factory _$$ResultItemDtoImplCopyWith(
    _$ResultItemDtoImpl value,
    $Res Function(_$ResultItemDtoImpl) then,
  ) = __$$ResultItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int ordinal,
    String term,
    String expectedAnswer,
    String? studentAnswer,
    bool isCorrect,
  });
}

/// @nodoc
class __$$ResultItemDtoImplCopyWithImpl<$Res>
    extends _$ResultItemDtoCopyWithImpl<$Res, _$ResultItemDtoImpl>
    implements _$$ResultItemDtoImplCopyWith<$Res> {
  __$$ResultItemDtoImplCopyWithImpl(
    _$ResultItemDtoImpl _value,
    $Res Function(_$ResultItemDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ResultItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ordinal = null,
    Object? term = null,
    Object? expectedAnswer = null,
    Object? studentAnswer = freezed,
    Object? isCorrect = null,
  }) {
    return _then(
      _$ResultItemDtoImpl(
        ordinal:
            null == ordinal
                ? _value.ordinal
                : ordinal // ignore: cast_nullable_to_non_nullable
                    as int,
        term:
            null == term
                ? _value.term
                : term // ignore: cast_nullable_to_non_nullable
                    as String,
        expectedAnswer:
            null == expectedAnswer
                ? _value.expectedAnswer
                : expectedAnswer // ignore: cast_nullable_to_non_nullable
                    as String,
        studentAnswer:
            freezed == studentAnswer
                ? _value.studentAnswer
                : studentAnswer // ignore: cast_nullable_to_non_nullable
                    as String?,
        isCorrect:
            null == isCorrect
                ? _value.isCorrect
                : isCorrect // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ResultItemDtoImpl implements _ResultItemDto {
  const _$ResultItemDtoImpl({
    required this.ordinal,
    required this.term,
    required this.expectedAnswer,
    this.studentAnswer,
    required this.isCorrect,
  });

  factory _$ResultItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResultItemDtoImplFromJson(json);

  @override
  final int ordinal;
  @override
  final String term;
  @override
  final String expectedAnswer;
  @override
  final String? studentAnswer;
  @override
  final bool isCorrect;

  @override
  String toString() {
    return 'ResultItemDto(ordinal: $ordinal, term: $term, expectedAnswer: $expectedAnswer, studentAnswer: $studentAnswer, isCorrect: $isCorrect)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResultItemDtoImpl &&
            (identical(other.ordinal, ordinal) || other.ordinal == ordinal) &&
            (identical(other.term, term) || other.term == term) &&
            (identical(other.expectedAnswer, expectedAnswer) ||
                other.expectedAnswer == expectedAnswer) &&
            (identical(other.studentAnswer, studentAnswer) ||
                other.studentAnswer == studentAnswer) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    ordinal,
    term,
    expectedAnswer,
    studentAnswer,
    isCorrect,
  );

  /// Create a copy of ResultItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResultItemDtoImplCopyWith<_$ResultItemDtoImpl> get copyWith =>
      __$$ResultItemDtoImplCopyWithImpl<_$ResultItemDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResultItemDtoImplToJson(this);
  }
}

abstract class _ResultItemDto implements ResultItemDto {
  const factory _ResultItemDto({
    required final int ordinal,
    required final String term,
    required final String expectedAnswer,
    final String? studentAnswer,
    required final bool isCorrect,
  }) = _$ResultItemDtoImpl;

  factory _ResultItemDto.fromJson(Map<String, dynamic> json) =
      _$ResultItemDtoImpl.fromJson;

  @override
  int get ordinal;
  @override
  String get term;
  @override
  String get expectedAnswer;
  @override
  String? get studentAnswer;
  @override
  bool get isCorrect;

  /// Create a copy of ResultItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResultItemDtoImplCopyWith<_$ResultItemDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StudentResultDetailDto _$StudentResultDetailDtoFromJson(
  Map<String, dynamic> json,
) {
  return _StudentResultDetailDto.fromJson(json);
}

/// @nodoc
mixin _$StudentResultDetailDto {
  String get resultId => throw _privateConstructorUsedError;
  String get studentDisplayName => throw _privateConstructorUsedError;
  String get lessonTitle => throw _privateConstructorUsedError;
  @GameTypeConverter()
  GameType get gameType => throw _privateConstructorUsedError;
  int get score => throw _privateConstructorUsedError;
  int get durationMs => throw _privateConstructorUsedError;
  int get totalItems => throw _privateConstructorUsedError;
  int get correctItems => throw _privateConstructorUsedError;
  DateTime? get sharedAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  List<ResultItemDto> get items => throw _privateConstructorUsedError;

  /// Serializes this StudentResultDetailDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StudentResultDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudentResultDetailDtoCopyWith<StudentResultDetailDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudentResultDetailDtoCopyWith<$Res> {
  factory $StudentResultDetailDtoCopyWith(
    StudentResultDetailDto value,
    $Res Function(StudentResultDetailDto) then,
  ) = _$StudentResultDetailDtoCopyWithImpl<$Res, StudentResultDetailDto>;
  @useResult
  $Res call({
    String resultId,
    String studentDisplayName,
    String lessonTitle,
    @GameTypeConverter() GameType gameType,
    int score,
    int durationMs,
    int totalItems,
    int correctItems,
    DateTime? sharedAt,
    DateTime createdAt,
    List<ResultItemDto> items,
  });
}

/// @nodoc
class _$StudentResultDetailDtoCopyWithImpl<
  $Res,
  $Val extends StudentResultDetailDto
>
    implements $StudentResultDetailDtoCopyWith<$Res> {
  _$StudentResultDetailDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StudentResultDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? resultId = null,
    Object? studentDisplayName = null,
    Object? lessonTitle = null,
    Object? gameType = null,
    Object? score = null,
    Object? durationMs = null,
    Object? totalItems = null,
    Object? correctItems = null,
    Object? sharedAt = freezed,
    Object? createdAt = null,
    Object? items = null,
  }) {
    return _then(
      _value.copyWith(
            resultId:
                null == resultId
                    ? _value.resultId
                    : resultId // ignore: cast_nullable_to_non_nullable
                        as String,
            studentDisplayName:
                null == studentDisplayName
                    ? _value.studentDisplayName
                    : studentDisplayName // ignore: cast_nullable_to_non_nullable
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
            items:
                null == items
                    ? _value.items
                    : items // ignore: cast_nullable_to_non_nullable
                        as List<ResultItemDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StudentResultDetailDtoImplCopyWith<$Res>
    implements $StudentResultDetailDtoCopyWith<$Res> {
  factory _$$StudentResultDetailDtoImplCopyWith(
    _$StudentResultDetailDtoImpl value,
    $Res Function(_$StudentResultDetailDtoImpl) then,
  ) = __$$StudentResultDetailDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String resultId,
    String studentDisplayName,
    String lessonTitle,
    @GameTypeConverter() GameType gameType,
    int score,
    int durationMs,
    int totalItems,
    int correctItems,
    DateTime? sharedAt,
    DateTime createdAt,
    List<ResultItemDto> items,
  });
}

/// @nodoc
class __$$StudentResultDetailDtoImplCopyWithImpl<$Res>
    extends
        _$StudentResultDetailDtoCopyWithImpl<$Res, _$StudentResultDetailDtoImpl>
    implements _$$StudentResultDetailDtoImplCopyWith<$Res> {
  __$$StudentResultDetailDtoImplCopyWithImpl(
    _$StudentResultDetailDtoImpl _value,
    $Res Function(_$StudentResultDetailDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StudentResultDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? resultId = null,
    Object? studentDisplayName = null,
    Object? lessonTitle = null,
    Object? gameType = null,
    Object? score = null,
    Object? durationMs = null,
    Object? totalItems = null,
    Object? correctItems = null,
    Object? sharedAt = freezed,
    Object? createdAt = null,
    Object? items = null,
  }) {
    return _then(
      _$StudentResultDetailDtoImpl(
        resultId:
            null == resultId
                ? _value.resultId
                : resultId // ignore: cast_nullable_to_non_nullable
                    as String,
        studentDisplayName:
            null == studentDisplayName
                ? _value.studentDisplayName
                : studentDisplayName // ignore: cast_nullable_to_non_nullable
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
        items:
            null == items
                ? _value._items
                : items // ignore: cast_nullable_to_non_nullable
                    as List<ResultItemDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StudentResultDetailDtoImpl extends _StudentResultDetailDto {
  const _$StudentResultDetailDtoImpl({
    required this.resultId,
    required this.studentDisplayName,
    required this.lessonTitle,
    @GameTypeConverter() required this.gameType,
    required this.score,
    required this.durationMs,
    required this.totalItems,
    required this.correctItems,
    this.sharedAt,
    required this.createdAt,
    final List<ResultItemDto> items = const <ResultItemDto>[],
  }) : _items = items,
       super._();

  factory _$StudentResultDetailDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudentResultDetailDtoImplFromJson(json);

  @override
  final String resultId;
  @override
  final String studentDisplayName;
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
  final List<ResultItemDto> _items;
  @override
  @JsonKey()
  List<ResultItemDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'StudentResultDetailDto(resultId: $resultId, studentDisplayName: $studentDisplayName, lessonTitle: $lessonTitle, gameType: $gameType, score: $score, durationMs: $durationMs, totalItems: $totalItems, correctItems: $correctItems, sharedAt: $sharedAt, createdAt: $createdAt, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudentResultDetailDtoImpl &&
            (identical(other.resultId, resultId) ||
                other.resultId == resultId) &&
            (identical(other.studentDisplayName, studentDisplayName) ||
                other.studentDisplayName == studentDisplayName) &&
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
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    resultId,
    studentDisplayName,
    lessonTitle,
    gameType,
    score,
    durationMs,
    totalItems,
    correctItems,
    sharedAt,
    createdAt,
    const DeepCollectionEquality().hash(_items),
  );

  /// Create a copy of StudentResultDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudentResultDetailDtoImplCopyWith<_$StudentResultDetailDtoImpl>
  get copyWith =>
      __$$StudentResultDetailDtoImplCopyWithImpl<_$StudentResultDetailDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StudentResultDetailDtoImplToJson(this);
  }
}

abstract class _StudentResultDetailDto extends StudentResultDetailDto {
  const factory _StudentResultDetailDto({
    required final String resultId,
    required final String studentDisplayName,
    required final String lessonTitle,
    @GameTypeConverter() required final GameType gameType,
    required final int score,
    required final int durationMs,
    required final int totalItems,
    required final int correctItems,
    final DateTime? sharedAt,
    required final DateTime createdAt,
    final List<ResultItemDto> items,
  }) = _$StudentResultDetailDtoImpl;
  const _StudentResultDetailDto._() : super._();

  factory _StudentResultDetailDto.fromJson(Map<String, dynamic> json) =
      _$StudentResultDetailDtoImpl.fromJson;

  @override
  String get resultId;
  @override
  String get studentDisplayName;
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
  @override
  List<ResultItemDto> get items;

  /// Create a copy of StudentResultDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudentResultDetailDtoImplCopyWith<_$StudentResultDetailDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
