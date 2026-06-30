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

  /// Kelime-bazlı döküm (F7.5). Opsiyonel; doluysa öğretmen "Sonuç Detayı"
  /// ekranında her terimin doğru/yanlış durumu + öğrenci cevabı gösterilir.
  /// Boş/null ise backend yalnız [totalItems]/[correctItems]'ten türetir.
  /// null iken JSON'a yazılmaz (gövde temiz kalır).
  @JsonKey(includeIfNull: false)
  List<SubmitResultItem>? get items => throw _privateConstructorUsedError;

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
  $Res call({
    int durationMs,
    int totalItems,
    int correctItems,
    @JsonKey(includeIfNull: false) List<SubmitResultItem>? items,
  });
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
    Object? items = freezed,
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
            items:
                freezed == items
                    ? _value.items
                    : items // ignore: cast_nullable_to_non_nullable
                        as List<SubmitResultItem>?,
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
  $Res call({
    int durationMs,
    int totalItems,
    int correctItems,
    @JsonKey(includeIfNull: false) List<SubmitResultItem>? items,
  });
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
    Object? items = freezed,
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
        items:
            freezed == items
                ? _value._items
                : items // ignore: cast_nullable_to_non_nullable
                    as List<SubmitResultItem>?,
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
    @JsonKey(includeIfNull: false) final List<SubmitResultItem>? items,
  }) : _items = items;

  factory _$SubmitResultRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubmitResultRequestImplFromJson(json);

  @override
  final int durationMs;
  @override
  final int totalItems;
  @override
  final int correctItems;

  /// Kelime-bazlı döküm (F7.5). Opsiyonel; doluysa öğretmen "Sonuç Detayı"
  /// ekranında her terimin doğru/yanlış durumu + öğrenci cevabı gösterilir.
  /// Boş/null ise backend yalnız [totalItems]/[correctItems]'ten türetir.
  /// null iken JSON'a yazılmaz (gövde temiz kalır).
  final List<SubmitResultItem>? _items;

  /// Kelime-bazlı döküm (F7.5). Opsiyonel; doluysa öğretmen "Sonuç Detayı"
  /// ekranında her terimin doğru/yanlış durumu + öğrenci cevabı gösterilir.
  /// Boş/null ise backend yalnız [totalItems]/[correctItems]'ten türetir.
  /// null iken JSON'a yazılmaz (gövde temiz kalır).
  @override
  @JsonKey(includeIfNull: false)
  List<SubmitResultItem>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'SubmitResultRequest(durationMs: $durationMs, totalItems: $totalItems, correctItems: $correctItems, items: $items)';
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
                other.correctItems == correctItems) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    durationMs,
    totalItems,
    correctItems,
    const DeepCollectionEquality().hash(_items),
  );

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
    @JsonKey(includeIfNull: false) final List<SubmitResultItem>? items,
  }) = _$SubmitResultRequestImpl;

  factory _SubmitResultRequest.fromJson(Map<String, dynamic> json) =
      _$SubmitResultRequestImpl.fromJson;

  @override
  int get durationMs;
  @override
  int get totalItems;
  @override
  int get correctItems;

  /// Kelime-bazlı döküm (F7.5). Opsiyonel; doluysa öğretmen "Sonuç Detayı"
  /// ekranında her terimin doğru/yanlış durumu + öğrenci cevabı gösterilir.
  /// Boş/null ise backend yalnız [totalItems]/[correctItems]'ten türetir.
  /// null iken JSON'a yazılmaz (gövde temiz kalır).
  @override
  @JsonKey(includeIfNull: false)
  List<SubmitResultItem>? get items;

  /// Create a copy of SubmitResultRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubmitResultRequestImplCopyWith<_$SubmitResultRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SubmitResultItem _$SubmitResultItemFromJson(Map<String, dynamic> json) {
  return _SubmitResultItem.fromJson(json);
}

/// @nodoc
mixin _$SubmitResultItem {
  int get ordinal => throw _privateConstructorUsedError;
  String get term => throw _privateConstructorUsedError;
  String get expectedAnswer => throw _privateConstructorUsedError;
  String? get studentAnswer => throw _privateConstructorUsedError;
  bool get isCorrect => throw _privateConstructorUsedError;

  /// Serializes this SubmitResultItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubmitResultItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubmitResultItemCopyWith<SubmitResultItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubmitResultItemCopyWith<$Res> {
  factory $SubmitResultItemCopyWith(
    SubmitResultItem value,
    $Res Function(SubmitResultItem) then,
  ) = _$SubmitResultItemCopyWithImpl<$Res, SubmitResultItem>;
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
class _$SubmitResultItemCopyWithImpl<$Res, $Val extends SubmitResultItem>
    implements $SubmitResultItemCopyWith<$Res> {
  _$SubmitResultItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubmitResultItem
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
abstract class _$$SubmitResultItemImplCopyWith<$Res>
    implements $SubmitResultItemCopyWith<$Res> {
  factory _$$SubmitResultItemImplCopyWith(
    _$SubmitResultItemImpl value,
    $Res Function(_$SubmitResultItemImpl) then,
  ) = __$$SubmitResultItemImplCopyWithImpl<$Res>;
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
class __$$SubmitResultItemImplCopyWithImpl<$Res>
    extends _$SubmitResultItemCopyWithImpl<$Res, _$SubmitResultItemImpl>
    implements _$$SubmitResultItemImplCopyWith<$Res> {
  __$$SubmitResultItemImplCopyWithImpl(
    _$SubmitResultItemImpl _value,
    $Res Function(_$SubmitResultItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubmitResultItem
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
      _$SubmitResultItemImpl(
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
class _$SubmitResultItemImpl implements _SubmitResultItem {
  const _$SubmitResultItemImpl({
    required this.ordinal,
    required this.term,
    required this.expectedAnswer,
    this.studentAnswer,
    required this.isCorrect,
  });

  factory _$SubmitResultItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubmitResultItemImplFromJson(json);

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
    return 'SubmitResultItem(ordinal: $ordinal, term: $term, expectedAnswer: $expectedAnswer, studentAnswer: $studentAnswer, isCorrect: $isCorrect)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubmitResultItemImpl &&
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

  /// Create a copy of SubmitResultItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubmitResultItemImplCopyWith<_$SubmitResultItemImpl> get copyWith =>
      __$$SubmitResultItemImplCopyWithImpl<_$SubmitResultItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SubmitResultItemImplToJson(this);
  }
}

abstract class _SubmitResultItem implements SubmitResultItem {
  const factory _SubmitResultItem({
    required final int ordinal,
    required final String term,
    required final String expectedAnswer,
    final String? studentAnswer,
    required final bool isCorrect,
  }) = _$SubmitResultItemImpl;

  factory _SubmitResultItem.fromJson(Map<String, dynamic> json) =
      _$SubmitResultItemImpl.fromJson;

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

  /// Create a copy of SubmitResultItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubmitResultItemImplCopyWith<_$SubmitResultItemImpl> get copyWith =>
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
  GameType get gameType => throw _privateConstructorUsedError; // QuestionSet (çıkmış sorular) sonucunda ders yoktur → lessonId null gelir;
  // lessonTitle yerine konu başlığı döner. (API ile birebir; aksi halde sonuç
  // yanıtı parse edilemez ve "Bitir" hata verir.)
  String? get lessonId => throw _privateConstructorUsedError;
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
    String? lessonId,
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
    Object? lessonId = freezed,
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
                freezed == lessonId
                    ? _value.lessonId
                    : lessonId // ignore: cast_nullable_to_non_nullable
                        as String?,
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
    String? lessonId,
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
    Object? lessonId = freezed,
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
            freezed == lessonId
                ? _value.lessonId
                : lessonId // ignore: cast_nullable_to_non_nullable
                    as String?,
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
    this.lessonId,
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
  // QuestionSet (çıkmış sorular) sonucunda ders yoktur → lessonId null gelir;
  // lessonTitle yerine konu başlığı döner. (API ile birebir; aksi halde sonuç
  // yanıtı parse edilemez ve "Bitir" hata verir.)
  @override
  final String? lessonId;
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
    final String? lessonId,
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
  GameType get gameType; // QuestionSet (çıkmış sorular) sonucunda ders yoktur → lessonId null gelir;
  // lessonTitle yerine konu başlığı döner. (API ile birebir; aksi halde sonuç
  // yanıtı parse edilemez ve "Bitir" hata verir.)
  @override
  String? get lessonId;
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

ResultItemModel _$ResultItemModelFromJson(Map<String, dynamic> json) {
  return _ResultItemModel.fromJson(json);
}

/// @nodoc
mixin _$ResultItemModel {
  int get ordinal => throw _privateConstructorUsedError;
  String get term => throw _privateConstructorUsedError;
  String get expectedAnswer => throw _privateConstructorUsedError;
  String? get studentAnswer => throw _privateConstructorUsedError;
  bool get isCorrect => throw _privateConstructorUsedError;

  /// Serializes this ResultItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ResultItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResultItemModelCopyWith<ResultItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResultItemModelCopyWith<$Res> {
  factory $ResultItemModelCopyWith(
    ResultItemModel value,
    $Res Function(ResultItemModel) then,
  ) = _$ResultItemModelCopyWithImpl<$Res, ResultItemModel>;
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
class _$ResultItemModelCopyWithImpl<$Res, $Val extends ResultItemModel>
    implements $ResultItemModelCopyWith<$Res> {
  _$ResultItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResultItemModel
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
abstract class _$$ResultItemModelImplCopyWith<$Res>
    implements $ResultItemModelCopyWith<$Res> {
  factory _$$ResultItemModelImplCopyWith(
    _$ResultItemModelImpl value,
    $Res Function(_$ResultItemModelImpl) then,
  ) = __$$ResultItemModelImplCopyWithImpl<$Res>;
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
class __$$ResultItemModelImplCopyWithImpl<$Res>
    extends _$ResultItemModelCopyWithImpl<$Res, _$ResultItemModelImpl>
    implements _$$ResultItemModelImplCopyWith<$Res> {
  __$$ResultItemModelImplCopyWithImpl(
    _$ResultItemModelImpl _value,
    $Res Function(_$ResultItemModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ResultItemModel
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
      _$ResultItemModelImpl(
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
class _$ResultItemModelImpl implements _ResultItemModel {
  const _$ResultItemModelImpl({
    required this.ordinal,
    required this.term,
    required this.expectedAnswer,
    this.studentAnswer,
    required this.isCorrect,
  });

  factory _$ResultItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResultItemModelImplFromJson(json);

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
    return 'ResultItemModel(ordinal: $ordinal, term: $term, expectedAnswer: $expectedAnswer, studentAnswer: $studentAnswer, isCorrect: $isCorrect)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResultItemModelImpl &&
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

  /// Create a copy of ResultItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResultItemModelImplCopyWith<_$ResultItemModelImpl> get copyWith =>
      __$$ResultItemModelImplCopyWithImpl<_$ResultItemModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ResultItemModelImplToJson(this);
  }
}

abstract class _ResultItemModel implements ResultItemModel {
  const factory _ResultItemModel({
    required final int ordinal,
    required final String term,
    required final String expectedAnswer,
    final String? studentAnswer,
    required final bool isCorrect,
  }) = _$ResultItemModelImpl;

  factory _ResultItemModel.fromJson(Map<String, dynamic> json) =
      _$ResultItemModelImpl.fromJson;

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

  /// Create a copy of ResultItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResultItemModelImplCopyWith<_$ResultItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GameResultDetailDto _$GameResultDetailDtoFromJson(Map<String, dynamic> json) {
  return _GameResultDetailDto.fromJson(json);
}

/// @nodoc
mixin _$GameResultDetailDto {
  String get id => throw _privateConstructorUsedError;
  String get gameId => throw _privateConstructorUsedError;
  @GameTypeConverter()
  GameType get gameType => throw _privateConstructorUsedError; // QuestionSet sonucunda ders yoktur → lessonId null gelir.
  String? get lessonId => throw _privateConstructorUsedError;
  String get lessonTitle => throw _privateConstructorUsedError;
  int get durationMs => throw _privateConstructorUsedError;
  int get totalItems => throw _privateConstructorUsedError;
  int get correctItems => throw _privateConstructorUsedError;
  int get score => throw _privateConstructorUsedError;
  bool get sharedWithTeacher => throw _privateConstructorUsedError;
  DateTime? get sharedAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  List<ResultItemModel> get items => throw _privateConstructorUsedError;

  /// Serializes this GameResultDetailDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameResultDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameResultDetailDtoCopyWith<GameResultDetailDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameResultDetailDtoCopyWith<$Res> {
  factory $GameResultDetailDtoCopyWith(
    GameResultDetailDto value,
    $Res Function(GameResultDetailDto) then,
  ) = _$GameResultDetailDtoCopyWithImpl<$Res, GameResultDetailDto>;
  @useResult
  $Res call({
    String id,
    String gameId,
    @GameTypeConverter() GameType gameType,
    String? lessonId,
    String lessonTitle,
    int durationMs,
    int totalItems,
    int correctItems,
    int score,
    bool sharedWithTeacher,
    DateTime? sharedAt,
    DateTime createdAt,
    List<ResultItemModel> items,
  });
}

/// @nodoc
class _$GameResultDetailDtoCopyWithImpl<$Res, $Val extends GameResultDetailDto>
    implements $GameResultDetailDtoCopyWith<$Res> {
  _$GameResultDetailDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameResultDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? gameId = null,
    Object? gameType = null,
    Object? lessonId = freezed,
    Object? lessonTitle = null,
    Object? durationMs = null,
    Object? totalItems = null,
    Object? correctItems = null,
    Object? score = null,
    Object? sharedWithTeacher = null,
    Object? sharedAt = freezed,
    Object? createdAt = null,
    Object? items = null,
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
            gameType:
                null == gameType
                    ? _value.gameType
                    : gameType // ignore: cast_nullable_to_non_nullable
                        as GameType,
            lessonId:
                freezed == lessonId
                    ? _value.lessonId
                    : lessonId // ignore: cast_nullable_to_non_nullable
                        as String?,
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
            items:
                null == items
                    ? _value.items
                    : items // ignore: cast_nullable_to_non_nullable
                        as List<ResultItemModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GameResultDetailDtoImplCopyWith<$Res>
    implements $GameResultDetailDtoCopyWith<$Res> {
  factory _$$GameResultDetailDtoImplCopyWith(
    _$GameResultDetailDtoImpl value,
    $Res Function(_$GameResultDetailDtoImpl) then,
  ) = __$$GameResultDetailDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String gameId,
    @GameTypeConverter() GameType gameType,
    String? lessonId,
    String lessonTitle,
    int durationMs,
    int totalItems,
    int correctItems,
    int score,
    bool sharedWithTeacher,
    DateTime? sharedAt,
    DateTime createdAt,
    List<ResultItemModel> items,
  });
}

/// @nodoc
class __$$GameResultDetailDtoImplCopyWithImpl<$Res>
    extends _$GameResultDetailDtoCopyWithImpl<$Res, _$GameResultDetailDtoImpl>
    implements _$$GameResultDetailDtoImplCopyWith<$Res> {
  __$$GameResultDetailDtoImplCopyWithImpl(
    _$GameResultDetailDtoImpl _value,
    $Res Function(_$GameResultDetailDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameResultDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? gameId = null,
    Object? gameType = null,
    Object? lessonId = freezed,
    Object? lessonTitle = null,
    Object? durationMs = null,
    Object? totalItems = null,
    Object? correctItems = null,
    Object? score = null,
    Object? sharedWithTeacher = null,
    Object? sharedAt = freezed,
    Object? createdAt = null,
    Object? items = null,
  }) {
    return _then(
      _$GameResultDetailDtoImpl(
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
        gameType:
            null == gameType
                ? _value.gameType
                : gameType // ignore: cast_nullable_to_non_nullable
                    as GameType,
        lessonId:
            freezed == lessonId
                ? _value.lessonId
                : lessonId // ignore: cast_nullable_to_non_nullable
                    as String?,
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
        items:
            null == items
                ? _value._items
                : items // ignore: cast_nullable_to_non_nullable
                    as List<ResultItemModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GameResultDetailDtoImpl extends _GameResultDetailDto {
  const _$GameResultDetailDtoImpl({
    required this.id,
    required this.gameId,
    @GameTypeConverter() required this.gameType,
    this.lessonId,
    required this.lessonTitle,
    required this.durationMs,
    required this.totalItems,
    required this.correctItems,
    required this.score,
    required this.sharedWithTeacher,
    this.sharedAt,
    required this.createdAt,
    final List<ResultItemModel> items = const <ResultItemModel>[],
  }) : _items = items,
       super._();

  factory _$GameResultDetailDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameResultDetailDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String gameId;
  @override
  @GameTypeConverter()
  final GameType gameType;
  // QuestionSet sonucunda ders yoktur → lessonId null gelir.
  @override
  final String? lessonId;
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
  final List<ResultItemModel> _items;
  @override
  @JsonKey()
  List<ResultItemModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'GameResultDetailDto(id: $id, gameId: $gameId, gameType: $gameType, lessonId: $lessonId, lessonTitle: $lessonTitle, durationMs: $durationMs, totalItems: $totalItems, correctItems: $correctItems, score: $score, sharedWithTeacher: $sharedWithTeacher, sharedAt: $sharedAt, createdAt: $createdAt, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameResultDetailDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
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
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
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
    const DeepCollectionEquality().hash(_items),
  );

  /// Create a copy of GameResultDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameResultDetailDtoImplCopyWith<_$GameResultDetailDtoImpl> get copyWith =>
      __$$GameResultDetailDtoImplCopyWithImpl<_$GameResultDetailDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GameResultDetailDtoImplToJson(this);
  }
}

abstract class _GameResultDetailDto extends GameResultDetailDto {
  const factory _GameResultDetailDto({
    required final String id,
    required final String gameId,
    @GameTypeConverter() required final GameType gameType,
    final String? lessonId,
    required final String lessonTitle,
    required final int durationMs,
    required final int totalItems,
    required final int correctItems,
    required final int score,
    required final bool sharedWithTeacher,
    final DateTime? sharedAt,
    required final DateTime createdAt,
    final List<ResultItemModel> items,
  }) = _$GameResultDetailDtoImpl;
  const _GameResultDetailDto._() : super._();

  factory _GameResultDetailDto.fromJson(Map<String, dynamic> json) =
      _$GameResultDetailDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get gameId;
  @override
  @GameTypeConverter()
  GameType get gameType; // QuestionSet sonucunda ders yoktur → lessonId null gelir.
  @override
  String? get lessonId;
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
  @override
  List<ResultItemModel> get items;

  /// Create a copy of GameResultDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameResultDetailDtoImplCopyWith<_$GameResultDetailDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
