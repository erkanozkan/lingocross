// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_exam_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AiExamGenerateRequest _$AiExamGenerateRequestFromJson(
  Map<String, dynamic> json,
) {
  return _AiExamGenerateRequest.fromJson(json);
}

/// @nodoc
mixin _$AiExamGenerateRequest {
  int get grade => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  List<String> get types => throw _privateConstructorUsedError;

  /// Serializes this AiExamGenerateRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AiExamGenerateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AiExamGenerateRequestCopyWith<AiExamGenerateRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiExamGenerateRequestCopyWith<$Res> {
  factory $AiExamGenerateRequestCopyWith(
    AiExamGenerateRequest value,
    $Res Function(AiExamGenerateRequest) then,
  ) = _$AiExamGenerateRequestCopyWithImpl<$Res, AiExamGenerateRequest>;
  @useResult
  $Res call({int grade, int count, List<String> types});
}

/// @nodoc
class _$AiExamGenerateRequestCopyWithImpl<
  $Res,
  $Val extends AiExamGenerateRequest
>
    implements $AiExamGenerateRequestCopyWith<$Res> {
  _$AiExamGenerateRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AiExamGenerateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? grade = null,
    Object? count = null,
    Object? types = null,
  }) {
    return _then(
      _value.copyWith(
            grade:
                null == grade
                    ? _value.grade
                    : grade // ignore: cast_nullable_to_non_nullable
                        as int,
            count:
                null == count
                    ? _value.count
                    : count // ignore: cast_nullable_to_non_nullable
                        as int,
            types:
                null == types
                    ? _value.types
                    : types // ignore: cast_nullable_to_non_nullable
                        as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AiExamGenerateRequestImplCopyWith<$Res>
    implements $AiExamGenerateRequestCopyWith<$Res> {
  factory _$$AiExamGenerateRequestImplCopyWith(
    _$AiExamGenerateRequestImpl value,
    $Res Function(_$AiExamGenerateRequestImpl) then,
  ) = __$$AiExamGenerateRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int grade, int count, List<String> types});
}

/// @nodoc
class __$$AiExamGenerateRequestImplCopyWithImpl<$Res>
    extends
        _$AiExamGenerateRequestCopyWithImpl<$Res, _$AiExamGenerateRequestImpl>
    implements _$$AiExamGenerateRequestImplCopyWith<$Res> {
  __$$AiExamGenerateRequestImplCopyWithImpl(
    _$AiExamGenerateRequestImpl _value,
    $Res Function(_$AiExamGenerateRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AiExamGenerateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? grade = null,
    Object? count = null,
    Object? types = null,
  }) {
    return _then(
      _$AiExamGenerateRequestImpl(
        grade:
            null == grade
                ? _value.grade
                : grade // ignore: cast_nullable_to_non_nullable
                    as int,
        count:
            null == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                    as int,
        types:
            null == types
                ? _value._types
                : types // ignore: cast_nullable_to_non_nullable
                    as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AiExamGenerateRequestImpl implements _AiExamGenerateRequest {
  const _$AiExamGenerateRequestImpl({
    required this.grade,
    required this.count,
    required final List<String> types,
  }) : _types = types;

  factory _$AiExamGenerateRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$AiExamGenerateRequestImplFromJson(json);

  @override
  final int grade;
  @override
  final int count;
  final List<String> _types;
  @override
  List<String> get types {
    if (_types is EqualUnmodifiableListView) return _types;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_types);
  }

  @override
  String toString() {
    return 'AiExamGenerateRequest(grade: $grade, count: $count, types: $types)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiExamGenerateRequestImpl &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.count, count) || other.count == count) &&
            const DeepCollectionEquality().equals(other._types, _types));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    grade,
    count,
    const DeepCollectionEquality().hash(_types),
  );

  /// Create a copy of AiExamGenerateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AiExamGenerateRequestImplCopyWith<_$AiExamGenerateRequestImpl>
  get copyWith =>
      __$$AiExamGenerateRequestImplCopyWithImpl<_$AiExamGenerateRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AiExamGenerateRequestImplToJson(this);
  }
}

abstract class _AiExamGenerateRequest implements AiExamGenerateRequest {
  const factory _AiExamGenerateRequest({
    required final int grade,
    required final int count,
    required final List<String> types,
  }) = _$AiExamGenerateRequestImpl;

  factory _AiExamGenerateRequest.fromJson(Map<String, dynamic> json) =
      _$AiExamGenerateRequestImpl.fromJson;

  @override
  int get grade;
  @override
  int get count;
  @override
  List<String> get types;

  /// Create a copy of AiExamGenerateRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AiExamGenerateRequestImplCopyWith<_$AiExamGenerateRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

AiGeneratedQuestionOption _$AiGeneratedQuestionOptionFromJson(
  Map<String, dynamic> json,
) {
  return _AiGeneratedQuestionOption.fromJson(json);
}

/// @nodoc
mixin _$AiGeneratedQuestionOption {
  String get id => throw _privateConstructorUsedError;
  int get position => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  bool get isCorrect => throw _privateConstructorUsedError;

  /// Serializes this AiGeneratedQuestionOption to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AiGeneratedQuestionOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AiGeneratedQuestionOptionCopyWith<AiGeneratedQuestionOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiGeneratedQuestionOptionCopyWith<$Res> {
  factory $AiGeneratedQuestionOptionCopyWith(
    AiGeneratedQuestionOption value,
    $Res Function(AiGeneratedQuestionOption) then,
  ) = _$AiGeneratedQuestionOptionCopyWithImpl<$Res, AiGeneratedQuestionOption>;
  @useResult
  $Res call({String id, int position, String text, bool isCorrect});
}

/// @nodoc
class _$AiGeneratedQuestionOptionCopyWithImpl<
  $Res,
  $Val extends AiGeneratedQuestionOption
>
    implements $AiGeneratedQuestionOptionCopyWith<$Res> {
  _$AiGeneratedQuestionOptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AiGeneratedQuestionOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? position = null,
    Object? text = null,
    Object? isCorrect = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            position:
                null == position
                    ? _value.position
                    : position // ignore: cast_nullable_to_non_nullable
                        as int,
            text:
                null == text
                    ? _value.text
                    : text // ignore: cast_nullable_to_non_nullable
                        as String,
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
abstract class _$$AiGeneratedQuestionOptionImplCopyWith<$Res>
    implements $AiGeneratedQuestionOptionCopyWith<$Res> {
  factory _$$AiGeneratedQuestionOptionImplCopyWith(
    _$AiGeneratedQuestionOptionImpl value,
    $Res Function(_$AiGeneratedQuestionOptionImpl) then,
  ) = __$$AiGeneratedQuestionOptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, int position, String text, bool isCorrect});
}

/// @nodoc
class __$$AiGeneratedQuestionOptionImplCopyWithImpl<$Res>
    extends
        _$AiGeneratedQuestionOptionCopyWithImpl<
          $Res,
          _$AiGeneratedQuestionOptionImpl
        >
    implements _$$AiGeneratedQuestionOptionImplCopyWith<$Res> {
  __$$AiGeneratedQuestionOptionImplCopyWithImpl(
    _$AiGeneratedQuestionOptionImpl _value,
    $Res Function(_$AiGeneratedQuestionOptionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AiGeneratedQuestionOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? position = null,
    Object? text = null,
    Object? isCorrect = null,
  }) {
    return _then(
      _$AiGeneratedQuestionOptionImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        position:
            null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                    as int,
        text:
            null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                    as String,
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
class _$AiGeneratedQuestionOptionImpl implements _AiGeneratedQuestionOption {
  const _$AiGeneratedQuestionOptionImpl({
    required this.id,
    required this.position,
    required this.text,
    required this.isCorrect,
  });

  factory _$AiGeneratedQuestionOptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$AiGeneratedQuestionOptionImplFromJson(json);

  @override
  final String id;
  @override
  final int position;
  @override
  final String text;
  @override
  final bool isCorrect;

  @override
  String toString() {
    return 'AiGeneratedQuestionOption(id: $id, position: $position, text: $text, isCorrect: $isCorrect)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiGeneratedQuestionOptionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, position, text, isCorrect);

  /// Create a copy of AiGeneratedQuestionOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AiGeneratedQuestionOptionImplCopyWith<_$AiGeneratedQuestionOptionImpl>
  get copyWith => __$$AiGeneratedQuestionOptionImplCopyWithImpl<
    _$AiGeneratedQuestionOptionImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AiGeneratedQuestionOptionImplToJson(this);
  }
}

abstract class _AiGeneratedQuestionOption implements AiGeneratedQuestionOption {
  const factory _AiGeneratedQuestionOption({
    required final String id,
    required final int position,
    required final String text,
    required final bool isCorrect,
  }) = _$AiGeneratedQuestionOptionImpl;

  factory _AiGeneratedQuestionOption.fromJson(Map<String, dynamic> json) =
      _$AiGeneratedQuestionOptionImpl.fromJson;

  @override
  String get id;
  @override
  int get position;
  @override
  String get text;
  @override
  bool get isCorrect;

  /// Create a copy of AiGeneratedQuestionOption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AiGeneratedQuestionOptionImplCopyWith<_$AiGeneratedQuestionOptionImpl>
  get copyWith => throw _privateConstructorUsedError;
}

AiGeneratedQuestion _$AiGeneratedQuestionFromJson(Map<String, dynamic> json) {
  return _AiGeneratedQuestion.fromJson(json);
}

/// @nodoc
mixin _$AiGeneratedQuestion {
  String get id => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get stem => throw _privateConstructorUsedError;
  String? get explanation => throw _privateConstructorUsedError;
  List<AiGeneratedQuestionOption> get options =>
      throw _privateConstructorUsedError;

  /// Serializes this AiGeneratedQuestion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AiGeneratedQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AiGeneratedQuestionCopyWith<AiGeneratedQuestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiGeneratedQuestionCopyWith<$Res> {
  factory $AiGeneratedQuestionCopyWith(
    AiGeneratedQuestion value,
    $Res Function(AiGeneratedQuestion) then,
  ) = _$AiGeneratedQuestionCopyWithImpl<$Res, AiGeneratedQuestion>;
  @useResult
  $Res call({
    String id,
    String type,
    String stem,
    String? explanation,
    List<AiGeneratedQuestionOption> options,
  });
}

/// @nodoc
class _$AiGeneratedQuestionCopyWithImpl<$Res, $Val extends AiGeneratedQuestion>
    implements $AiGeneratedQuestionCopyWith<$Res> {
  _$AiGeneratedQuestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AiGeneratedQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? stem = null,
    Object? explanation = freezed,
    Object? options = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as String,
            stem:
                null == stem
                    ? _value.stem
                    : stem // ignore: cast_nullable_to_non_nullable
                        as String,
            explanation:
                freezed == explanation
                    ? _value.explanation
                    : explanation // ignore: cast_nullable_to_non_nullable
                        as String?,
            options:
                null == options
                    ? _value.options
                    : options // ignore: cast_nullable_to_non_nullable
                        as List<AiGeneratedQuestionOption>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AiGeneratedQuestionImplCopyWith<$Res>
    implements $AiGeneratedQuestionCopyWith<$Res> {
  factory _$$AiGeneratedQuestionImplCopyWith(
    _$AiGeneratedQuestionImpl value,
    $Res Function(_$AiGeneratedQuestionImpl) then,
  ) = __$$AiGeneratedQuestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String type,
    String stem,
    String? explanation,
    List<AiGeneratedQuestionOption> options,
  });
}

/// @nodoc
class __$$AiGeneratedQuestionImplCopyWithImpl<$Res>
    extends _$AiGeneratedQuestionCopyWithImpl<$Res, _$AiGeneratedQuestionImpl>
    implements _$$AiGeneratedQuestionImplCopyWith<$Res> {
  __$$AiGeneratedQuestionImplCopyWithImpl(
    _$AiGeneratedQuestionImpl _value,
    $Res Function(_$AiGeneratedQuestionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AiGeneratedQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? stem = null,
    Object? explanation = freezed,
    Object? options = null,
  }) {
    return _then(
      _$AiGeneratedQuestionImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as String,
        stem:
            null == stem
                ? _value.stem
                : stem // ignore: cast_nullable_to_non_nullable
                    as String,
        explanation:
            freezed == explanation
                ? _value.explanation
                : explanation // ignore: cast_nullable_to_non_nullable
                    as String?,
        options:
            null == options
                ? _value._options
                : options // ignore: cast_nullable_to_non_nullable
                    as List<AiGeneratedQuestionOption>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AiGeneratedQuestionImpl implements _AiGeneratedQuestion {
  const _$AiGeneratedQuestionImpl({
    required this.id,
    required this.type,
    required this.stem,
    this.explanation,
    required final List<AiGeneratedQuestionOption> options,
  }) : _options = options;

  factory _$AiGeneratedQuestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$AiGeneratedQuestionImplFromJson(json);

  @override
  final String id;
  @override
  final String type;
  @override
  final String stem;
  @override
  final String? explanation;
  final List<AiGeneratedQuestionOption> _options;
  @override
  List<AiGeneratedQuestionOption> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  String toString() {
    return 'AiGeneratedQuestion(id: $id, type: $type, stem: $stem, explanation: $explanation, options: $options)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiGeneratedQuestionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.stem, stem) || other.stem == stem) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation) &&
            const DeepCollectionEquality().equals(other._options, _options));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    stem,
    explanation,
    const DeepCollectionEquality().hash(_options),
  );

  /// Create a copy of AiGeneratedQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AiGeneratedQuestionImplCopyWith<_$AiGeneratedQuestionImpl> get copyWith =>
      __$$AiGeneratedQuestionImplCopyWithImpl<_$AiGeneratedQuestionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AiGeneratedQuestionImplToJson(this);
  }
}

abstract class _AiGeneratedQuestion implements AiGeneratedQuestion {
  const factory _AiGeneratedQuestion({
    required final String id,
    required final String type,
    required final String stem,
    final String? explanation,
    required final List<AiGeneratedQuestionOption> options,
  }) = _$AiGeneratedQuestionImpl;

  factory _AiGeneratedQuestion.fromJson(Map<String, dynamic> json) =
      _$AiGeneratedQuestionImpl.fromJson;

  @override
  String get id;
  @override
  String get type;
  @override
  String get stem;
  @override
  String? get explanation;
  @override
  List<AiGeneratedQuestionOption> get options;

  /// Create a copy of AiGeneratedQuestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AiGeneratedQuestionImplCopyWith<_$AiGeneratedQuestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AiExamResultDto _$AiExamResultDtoFromJson(Map<String, dynamic> json) {
  return _AiExamResultDto.fromJson(json);
}

/// @nodoc
mixin _$AiExamResultDto {
  String get topicId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  int get grade => throw _privateConstructorUsedError;
  String get lessonId => throw _privateConstructorUsedError;
  List<AiGeneratedQuestion> get questions => throw _privateConstructorUsedError;

  /// Serializes this AiExamResultDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AiExamResultDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AiExamResultDtoCopyWith<AiExamResultDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiExamResultDtoCopyWith<$Res> {
  factory $AiExamResultDtoCopyWith(
    AiExamResultDto value,
    $Res Function(AiExamResultDto) then,
  ) = _$AiExamResultDtoCopyWithImpl<$Res, AiExamResultDto>;
  @useResult
  $Res call({
    String topicId,
    String title,
    int grade,
    String lessonId,
    List<AiGeneratedQuestion> questions,
  });
}

/// @nodoc
class _$AiExamResultDtoCopyWithImpl<$Res, $Val extends AiExamResultDto>
    implements $AiExamResultDtoCopyWith<$Res> {
  _$AiExamResultDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AiExamResultDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topicId = null,
    Object? title = null,
    Object? grade = null,
    Object? lessonId = null,
    Object? questions = null,
  }) {
    return _then(
      _value.copyWith(
            topicId:
                null == topicId
                    ? _value.topicId
                    : topicId // ignore: cast_nullable_to_non_nullable
                        as String,
            title:
                null == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String,
            grade:
                null == grade
                    ? _value.grade
                    : grade // ignore: cast_nullable_to_non_nullable
                        as int,
            lessonId:
                null == lessonId
                    ? _value.lessonId
                    : lessonId // ignore: cast_nullable_to_non_nullable
                        as String,
            questions:
                null == questions
                    ? _value.questions
                    : questions // ignore: cast_nullable_to_non_nullable
                        as List<AiGeneratedQuestion>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AiExamResultDtoImplCopyWith<$Res>
    implements $AiExamResultDtoCopyWith<$Res> {
  factory _$$AiExamResultDtoImplCopyWith(
    _$AiExamResultDtoImpl value,
    $Res Function(_$AiExamResultDtoImpl) then,
  ) = __$$AiExamResultDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String topicId,
    String title,
    int grade,
    String lessonId,
    List<AiGeneratedQuestion> questions,
  });
}

/// @nodoc
class __$$AiExamResultDtoImplCopyWithImpl<$Res>
    extends _$AiExamResultDtoCopyWithImpl<$Res, _$AiExamResultDtoImpl>
    implements _$$AiExamResultDtoImplCopyWith<$Res> {
  __$$AiExamResultDtoImplCopyWithImpl(
    _$AiExamResultDtoImpl _value,
    $Res Function(_$AiExamResultDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AiExamResultDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topicId = null,
    Object? title = null,
    Object? grade = null,
    Object? lessonId = null,
    Object? questions = null,
  }) {
    return _then(
      _$AiExamResultDtoImpl(
        topicId:
            null == topicId
                ? _value.topicId
                : topicId // ignore: cast_nullable_to_non_nullable
                    as String,
        title:
            null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String,
        grade:
            null == grade
                ? _value.grade
                : grade // ignore: cast_nullable_to_non_nullable
                    as int,
        lessonId:
            null == lessonId
                ? _value.lessonId
                : lessonId // ignore: cast_nullable_to_non_nullable
                    as String,
        questions:
            null == questions
                ? _value._questions
                : questions // ignore: cast_nullable_to_non_nullable
                    as List<AiGeneratedQuestion>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AiExamResultDtoImpl implements _AiExamResultDto {
  const _$AiExamResultDtoImpl({
    required this.topicId,
    required this.title,
    required this.grade,
    required this.lessonId,
    required final List<AiGeneratedQuestion> questions,
  }) : _questions = questions;

  factory _$AiExamResultDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AiExamResultDtoImplFromJson(json);

  @override
  final String topicId;
  @override
  final String title;
  @override
  final int grade;
  @override
  final String lessonId;
  final List<AiGeneratedQuestion> _questions;
  @override
  List<AiGeneratedQuestion> get questions {
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  @override
  String toString() {
    return 'AiExamResultDto(topicId: $topicId, title: $title, grade: $grade, lessonId: $lessonId, questions: $questions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiExamResultDtoImpl &&
            (identical(other.topicId, topicId) || other.topicId == topicId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.lessonId, lessonId) ||
                other.lessonId == lessonId) &&
            const DeepCollectionEquality().equals(
              other._questions,
              _questions,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    topicId,
    title,
    grade,
    lessonId,
    const DeepCollectionEquality().hash(_questions),
  );

  /// Create a copy of AiExamResultDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AiExamResultDtoImplCopyWith<_$AiExamResultDtoImpl> get copyWith =>
      __$$AiExamResultDtoImplCopyWithImpl<_$AiExamResultDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AiExamResultDtoImplToJson(this);
  }
}

abstract class _AiExamResultDto implements AiExamResultDto {
  const factory _AiExamResultDto({
    required final String topicId,
    required final String title,
    required final int grade,
    required final String lessonId,
    required final List<AiGeneratedQuestion> questions,
  }) = _$AiExamResultDtoImpl;

  factory _AiExamResultDto.fromJson(Map<String, dynamic> json) =
      _$AiExamResultDtoImpl.fromJson;

  @override
  String get topicId;
  @override
  String get title;
  @override
  int get grade;
  @override
  String get lessonId;
  @override
  List<AiGeneratedQuestion> get questions;

  /// Create a copy of AiExamResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AiExamResultDtoImplCopyWith<_$AiExamResultDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
