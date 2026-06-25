// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ocr_enrich_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OcrEnrichRequest _$OcrEnrichRequestFromJson(Map<String, dynamic> json) {
  return _OcrEnrichRequest.fromJson(json);
}

/// @nodoc
mixin _$OcrEnrichRequest {
  String get imageBase64 => throw _privateConstructorUsedError;
  String get mediaType => throw _privateConstructorUsedError;
  String get sourceLanguage => throw _privateConstructorUsedError;
  String get targetLanguage => throw _privateConstructorUsedError;

  /// Serializes this OcrEnrichRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OcrEnrichRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OcrEnrichRequestCopyWith<OcrEnrichRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OcrEnrichRequestCopyWith<$Res> {
  factory $OcrEnrichRequestCopyWith(
    OcrEnrichRequest value,
    $Res Function(OcrEnrichRequest) then,
  ) = _$OcrEnrichRequestCopyWithImpl<$Res, OcrEnrichRequest>;
  @useResult
  $Res call({
    String imageBase64,
    String mediaType,
    String sourceLanguage,
    String targetLanguage,
  });
}

/// @nodoc
class _$OcrEnrichRequestCopyWithImpl<$Res, $Val extends OcrEnrichRequest>
    implements $OcrEnrichRequestCopyWith<$Res> {
  _$OcrEnrichRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OcrEnrichRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imageBase64 = null,
    Object? mediaType = null,
    Object? sourceLanguage = null,
    Object? targetLanguage = null,
  }) {
    return _then(
      _value.copyWith(
            imageBase64:
                null == imageBase64
                    ? _value.imageBase64
                    : imageBase64 // ignore: cast_nullable_to_non_nullable
                        as String,
            mediaType:
                null == mediaType
                    ? _value.mediaType
                    : mediaType // ignore: cast_nullable_to_non_nullable
                        as String,
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OcrEnrichRequestImplCopyWith<$Res>
    implements $OcrEnrichRequestCopyWith<$Res> {
  factory _$$OcrEnrichRequestImplCopyWith(
    _$OcrEnrichRequestImpl value,
    $Res Function(_$OcrEnrichRequestImpl) then,
  ) = __$$OcrEnrichRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String imageBase64,
    String mediaType,
    String sourceLanguage,
    String targetLanguage,
  });
}

/// @nodoc
class __$$OcrEnrichRequestImplCopyWithImpl<$Res>
    extends _$OcrEnrichRequestCopyWithImpl<$Res, _$OcrEnrichRequestImpl>
    implements _$$OcrEnrichRequestImplCopyWith<$Res> {
  __$$OcrEnrichRequestImplCopyWithImpl(
    _$OcrEnrichRequestImpl _value,
    $Res Function(_$OcrEnrichRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OcrEnrichRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imageBase64 = null,
    Object? mediaType = null,
    Object? sourceLanguage = null,
    Object? targetLanguage = null,
  }) {
    return _then(
      _$OcrEnrichRequestImpl(
        imageBase64:
            null == imageBase64
                ? _value.imageBase64
                : imageBase64 // ignore: cast_nullable_to_non_nullable
                    as String,
        mediaType:
            null == mediaType
                ? _value.mediaType
                : mediaType // ignore: cast_nullable_to_non_nullable
                    as String,
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OcrEnrichRequestImpl implements _OcrEnrichRequest {
  const _$OcrEnrichRequestImpl({
    required this.imageBase64,
    required this.mediaType,
    required this.sourceLanguage,
    required this.targetLanguage,
  });

  factory _$OcrEnrichRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$OcrEnrichRequestImplFromJson(json);

  @override
  final String imageBase64;
  @override
  final String mediaType;
  @override
  final String sourceLanguage;
  @override
  final String targetLanguage;

  @override
  String toString() {
    return 'OcrEnrichRequest(imageBase64: $imageBase64, mediaType: $mediaType, sourceLanguage: $sourceLanguage, targetLanguage: $targetLanguage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OcrEnrichRequestImpl &&
            (identical(other.imageBase64, imageBase64) ||
                other.imageBase64 == imageBase64) &&
            (identical(other.mediaType, mediaType) ||
                other.mediaType == mediaType) &&
            (identical(other.sourceLanguage, sourceLanguage) ||
                other.sourceLanguage == sourceLanguage) &&
            (identical(other.targetLanguage, targetLanguage) ||
                other.targetLanguage == targetLanguage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    imageBase64,
    mediaType,
    sourceLanguage,
    targetLanguage,
  );

  /// Create a copy of OcrEnrichRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OcrEnrichRequestImplCopyWith<_$OcrEnrichRequestImpl> get copyWith =>
      __$$OcrEnrichRequestImplCopyWithImpl<_$OcrEnrichRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OcrEnrichRequestImplToJson(this);
  }
}

abstract class _OcrEnrichRequest implements OcrEnrichRequest {
  const factory _OcrEnrichRequest({
    required final String imageBase64,
    required final String mediaType,
    required final String sourceLanguage,
    required final String targetLanguage,
  }) = _$OcrEnrichRequestImpl;

  factory _OcrEnrichRequest.fromJson(Map<String, dynamic> json) =
      _$OcrEnrichRequestImpl.fromJson;

  @override
  String get imageBase64;
  @override
  String get mediaType;
  @override
  String get sourceLanguage;
  @override
  String get targetLanguage;

  /// Create a copy of OcrEnrichRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OcrEnrichRequestImplCopyWith<_$OcrEnrichRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OcrEnrichResponse _$OcrEnrichResponseFromJson(Map<String, dynamic> json) {
  return _OcrEnrichResponse.fromJson(json);
}

/// @nodoc
mixin _$OcrEnrichResponse {
  List<OcrEnrichedWord> get words => throw _privateConstructorUsedError;

  /// Serializes this OcrEnrichResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OcrEnrichResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OcrEnrichResponseCopyWith<OcrEnrichResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OcrEnrichResponseCopyWith<$Res> {
  factory $OcrEnrichResponseCopyWith(
    OcrEnrichResponse value,
    $Res Function(OcrEnrichResponse) then,
  ) = _$OcrEnrichResponseCopyWithImpl<$Res, OcrEnrichResponse>;
  @useResult
  $Res call({List<OcrEnrichedWord> words});
}

/// @nodoc
class _$OcrEnrichResponseCopyWithImpl<$Res, $Val extends OcrEnrichResponse>
    implements $OcrEnrichResponseCopyWith<$Res> {
  _$OcrEnrichResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OcrEnrichResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? words = null}) {
    return _then(
      _value.copyWith(
            words:
                null == words
                    ? _value.words
                    : words // ignore: cast_nullable_to_non_nullable
                        as List<OcrEnrichedWord>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OcrEnrichResponseImplCopyWith<$Res>
    implements $OcrEnrichResponseCopyWith<$Res> {
  factory _$$OcrEnrichResponseImplCopyWith(
    _$OcrEnrichResponseImpl value,
    $Res Function(_$OcrEnrichResponseImpl) then,
  ) = __$$OcrEnrichResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<OcrEnrichedWord> words});
}

/// @nodoc
class __$$OcrEnrichResponseImplCopyWithImpl<$Res>
    extends _$OcrEnrichResponseCopyWithImpl<$Res, _$OcrEnrichResponseImpl>
    implements _$$OcrEnrichResponseImplCopyWith<$Res> {
  __$$OcrEnrichResponseImplCopyWithImpl(
    _$OcrEnrichResponseImpl _value,
    $Res Function(_$OcrEnrichResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OcrEnrichResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? words = null}) {
    return _then(
      _$OcrEnrichResponseImpl(
        words:
            null == words
                ? _value._words
                : words // ignore: cast_nullable_to_non_nullable
                    as List<OcrEnrichedWord>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OcrEnrichResponseImpl implements _OcrEnrichResponse {
  const _$OcrEnrichResponseImpl({
    final List<OcrEnrichedWord> words = const <OcrEnrichedWord>[],
  }) : _words = words;

  factory _$OcrEnrichResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$OcrEnrichResponseImplFromJson(json);

  final List<OcrEnrichedWord> _words;
  @override
  @JsonKey()
  List<OcrEnrichedWord> get words {
    if (_words is EqualUnmodifiableListView) return _words;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_words);
  }

  @override
  String toString() {
    return 'OcrEnrichResponse(words: $words)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OcrEnrichResponseImpl &&
            const DeepCollectionEquality().equals(other._words, _words));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_words));

  /// Create a copy of OcrEnrichResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OcrEnrichResponseImplCopyWith<_$OcrEnrichResponseImpl> get copyWith =>
      __$$OcrEnrichResponseImplCopyWithImpl<_$OcrEnrichResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OcrEnrichResponseImplToJson(this);
  }
}

abstract class _OcrEnrichResponse implements OcrEnrichResponse {
  const factory _OcrEnrichResponse({final List<OcrEnrichedWord> words}) =
      _$OcrEnrichResponseImpl;

  factory _OcrEnrichResponse.fromJson(Map<String, dynamic> json) =
      _$OcrEnrichResponseImpl.fromJson;

  @override
  List<OcrEnrichedWord> get words;

  /// Create a copy of OcrEnrichResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OcrEnrichResponseImplCopyWith<_$OcrEnrichResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OcrEnrichedWord _$OcrEnrichedWordFromJson(Map<String, dynamic> json) {
  return _OcrEnrichedWord.fromJson(json);
}

/// @nodoc
mixin _$OcrEnrichedWord {
  String get term => throw _privateConstructorUsedError;
  String get meaning => throw _privateConstructorUsedError;
  List<String> get synonyms => throw _privateConstructorUsedError;

  /// Serializes this OcrEnrichedWord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OcrEnrichedWord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OcrEnrichedWordCopyWith<OcrEnrichedWord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OcrEnrichedWordCopyWith<$Res> {
  factory $OcrEnrichedWordCopyWith(
    OcrEnrichedWord value,
    $Res Function(OcrEnrichedWord) then,
  ) = _$OcrEnrichedWordCopyWithImpl<$Res, OcrEnrichedWord>;
  @useResult
  $Res call({String term, String meaning, List<String> synonyms});
}

/// @nodoc
class _$OcrEnrichedWordCopyWithImpl<$Res, $Val extends OcrEnrichedWord>
    implements $OcrEnrichedWordCopyWith<$Res> {
  _$OcrEnrichedWordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OcrEnrichedWord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? term = null,
    Object? meaning = null,
    Object? synonyms = null,
  }) {
    return _then(
      _value.copyWith(
            term:
                null == term
                    ? _value.term
                    : term // ignore: cast_nullable_to_non_nullable
                        as String,
            meaning:
                null == meaning
                    ? _value.meaning
                    : meaning // ignore: cast_nullable_to_non_nullable
                        as String,
            synonyms:
                null == synonyms
                    ? _value.synonyms
                    : synonyms // ignore: cast_nullable_to_non_nullable
                        as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OcrEnrichedWordImplCopyWith<$Res>
    implements $OcrEnrichedWordCopyWith<$Res> {
  factory _$$OcrEnrichedWordImplCopyWith(
    _$OcrEnrichedWordImpl value,
    $Res Function(_$OcrEnrichedWordImpl) then,
  ) = __$$OcrEnrichedWordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String term, String meaning, List<String> synonyms});
}

/// @nodoc
class __$$OcrEnrichedWordImplCopyWithImpl<$Res>
    extends _$OcrEnrichedWordCopyWithImpl<$Res, _$OcrEnrichedWordImpl>
    implements _$$OcrEnrichedWordImplCopyWith<$Res> {
  __$$OcrEnrichedWordImplCopyWithImpl(
    _$OcrEnrichedWordImpl _value,
    $Res Function(_$OcrEnrichedWordImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OcrEnrichedWord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? term = null,
    Object? meaning = null,
    Object? synonyms = null,
  }) {
    return _then(
      _$OcrEnrichedWordImpl(
        term:
            null == term
                ? _value.term
                : term // ignore: cast_nullable_to_non_nullable
                    as String,
        meaning:
            null == meaning
                ? _value.meaning
                : meaning // ignore: cast_nullable_to_non_nullable
                    as String,
        synonyms:
            null == synonyms
                ? _value._synonyms
                : synonyms // ignore: cast_nullable_to_non_nullable
                    as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OcrEnrichedWordImpl implements _OcrEnrichedWord {
  const _$OcrEnrichedWordImpl({
    required this.term,
    this.meaning = '',
    final List<String> synonyms = const <String>[],
  }) : _synonyms = synonyms;

  factory _$OcrEnrichedWordImpl.fromJson(Map<String, dynamic> json) =>
      _$$OcrEnrichedWordImplFromJson(json);

  @override
  final String term;
  @override
  @JsonKey()
  final String meaning;
  final List<String> _synonyms;
  @override
  @JsonKey()
  List<String> get synonyms {
    if (_synonyms is EqualUnmodifiableListView) return _synonyms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_synonyms);
  }

  @override
  String toString() {
    return 'OcrEnrichedWord(term: $term, meaning: $meaning, synonyms: $synonyms)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OcrEnrichedWordImpl &&
            (identical(other.term, term) || other.term == term) &&
            (identical(other.meaning, meaning) || other.meaning == meaning) &&
            const DeepCollectionEquality().equals(other._synonyms, _synonyms));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    term,
    meaning,
    const DeepCollectionEquality().hash(_synonyms),
  );

  /// Create a copy of OcrEnrichedWord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OcrEnrichedWordImplCopyWith<_$OcrEnrichedWordImpl> get copyWith =>
      __$$OcrEnrichedWordImplCopyWithImpl<_$OcrEnrichedWordImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OcrEnrichedWordImplToJson(this);
  }
}

abstract class _OcrEnrichedWord implements OcrEnrichedWord {
  const factory _OcrEnrichedWord({
    required final String term,
    final String meaning,
    final List<String> synonyms,
  }) = _$OcrEnrichedWordImpl;

  factory _OcrEnrichedWord.fromJson(Map<String, dynamic> json) =
      _$OcrEnrichedWordImpl.fromJson;

  @override
  String get term;
  @override
  String get meaning;
  @override
  List<String> get synonyms;

  /// Create a copy of OcrEnrichedWord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OcrEnrichedWordImplCopyWith<_$OcrEnrichedWordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
