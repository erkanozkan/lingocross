// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'word_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TranslationPayload _$TranslationPayloadFromJson(Map<String, dynamic> json) {
  return _TranslationPayload.fromJson(json);
}

/// @nodoc
mixin _$TranslationPayload {
  String get text => throw _privateConstructorUsedError;
  bool get isPrimary => throw _privateConstructorUsedError;

  /// Serializes this TranslationPayload to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TranslationPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TranslationPayloadCopyWith<TranslationPayload> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TranslationPayloadCopyWith<$Res> {
  factory $TranslationPayloadCopyWith(
    TranslationPayload value,
    $Res Function(TranslationPayload) then,
  ) = _$TranslationPayloadCopyWithImpl<$Res, TranslationPayload>;
  @useResult
  $Res call({String text, bool isPrimary});
}

/// @nodoc
class _$TranslationPayloadCopyWithImpl<$Res, $Val extends TranslationPayload>
    implements $TranslationPayloadCopyWith<$Res> {
  _$TranslationPayloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TranslationPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? text = null, Object? isPrimary = null}) {
    return _then(
      _value.copyWith(
            text:
                null == text
                    ? _value.text
                    : text // ignore: cast_nullable_to_non_nullable
                        as String,
            isPrimary:
                null == isPrimary
                    ? _value.isPrimary
                    : isPrimary // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TranslationPayloadImplCopyWith<$Res>
    implements $TranslationPayloadCopyWith<$Res> {
  factory _$$TranslationPayloadImplCopyWith(
    _$TranslationPayloadImpl value,
    $Res Function(_$TranslationPayloadImpl) then,
  ) = __$$TranslationPayloadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String text, bool isPrimary});
}

/// @nodoc
class __$$TranslationPayloadImplCopyWithImpl<$Res>
    extends _$TranslationPayloadCopyWithImpl<$Res, _$TranslationPayloadImpl>
    implements _$$TranslationPayloadImplCopyWith<$Res> {
  __$$TranslationPayloadImplCopyWithImpl(
    _$TranslationPayloadImpl _value,
    $Res Function(_$TranslationPayloadImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TranslationPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? text = null, Object? isPrimary = null}) {
    return _then(
      _$TranslationPayloadImpl(
        text:
            null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                    as String,
        isPrimary:
            null == isPrimary
                ? _value.isPrimary
                : isPrimary // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TranslationPayloadImpl implements _TranslationPayload {
  const _$TranslationPayloadImpl({required this.text, required this.isPrimary});

  factory _$TranslationPayloadImpl.fromJson(Map<String, dynamic> json) =>
      _$$TranslationPayloadImplFromJson(json);

  @override
  final String text;
  @override
  final bool isPrimary;

  @override
  String toString() {
    return 'TranslationPayload(text: $text, isPrimary: $isPrimary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TranslationPayloadImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.isPrimary, isPrimary) ||
                other.isPrimary == isPrimary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, text, isPrimary);

  /// Create a copy of TranslationPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TranslationPayloadImplCopyWith<_$TranslationPayloadImpl> get copyWith =>
      __$$TranslationPayloadImplCopyWithImpl<_$TranslationPayloadImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TranslationPayloadImplToJson(this);
  }
}

abstract class _TranslationPayload implements TranslationPayload {
  const factory _TranslationPayload({
    required final String text,
    required final bool isPrimary,
  }) = _$TranslationPayloadImpl;

  factory _TranslationPayload.fromJson(Map<String, dynamic> json) =
      _$TranslationPayloadImpl.fromJson;

  @override
  String get text;
  @override
  bool get isPrimary;

  /// Create a copy of TranslationPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TranslationPayloadImplCopyWith<_$TranslationPayloadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AddWordRequest _$AddWordRequestFromJson(Map<String, dynamic> json) {
  return _AddWordRequest.fromJson(json);
}

/// @nodoc
mixin _$AddWordRequest {
  String get term => throw _privateConstructorUsedError;
  int? get sortOrder => throw _privateConstructorUsedError;
  @WordSourceNullableConverter()
  WordSource? get source => throw _privateConstructorUsedError;
  List<TranslationPayload> get translations =>
      throw _privateConstructorUsedError;
  List<String>? get synonyms => throw _privateConstructorUsedError;

  /// Serializes this AddWordRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddWordRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddWordRequestCopyWith<AddWordRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddWordRequestCopyWith<$Res> {
  factory $AddWordRequestCopyWith(
    AddWordRequest value,
    $Res Function(AddWordRequest) then,
  ) = _$AddWordRequestCopyWithImpl<$Res, AddWordRequest>;
  @useResult
  $Res call({
    String term,
    int? sortOrder,
    @WordSourceNullableConverter() WordSource? source,
    List<TranslationPayload> translations,
    List<String>? synonyms,
  });
}

/// @nodoc
class _$AddWordRequestCopyWithImpl<$Res, $Val extends AddWordRequest>
    implements $AddWordRequestCopyWith<$Res> {
  _$AddWordRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddWordRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? term = null,
    Object? sortOrder = freezed,
    Object? source = freezed,
    Object? translations = null,
    Object? synonyms = freezed,
  }) {
    return _then(
      _value.copyWith(
            term:
                null == term
                    ? _value.term
                    : term // ignore: cast_nullable_to_non_nullable
                        as String,
            sortOrder:
                freezed == sortOrder
                    ? _value.sortOrder
                    : sortOrder // ignore: cast_nullable_to_non_nullable
                        as int?,
            source:
                freezed == source
                    ? _value.source
                    : source // ignore: cast_nullable_to_non_nullable
                        as WordSource?,
            translations:
                null == translations
                    ? _value.translations
                    : translations // ignore: cast_nullable_to_non_nullable
                        as List<TranslationPayload>,
            synonyms:
                freezed == synonyms
                    ? _value.synonyms
                    : synonyms // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AddWordRequestImplCopyWith<$Res>
    implements $AddWordRequestCopyWith<$Res> {
  factory _$$AddWordRequestImplCopyWith(
    _$AddWordRequestImpl value,
    $Res Function(_$AddWordRequestImpl) then,
  ) = __$$AddWordRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String term,
    int? sortOrder,
    @WordSourceNullableConverter() WordSource? source,
    List<TranslationPayload> translations,
    List<String>? synonyms,
  });
}

/// @nodoc
class __$$AddWordRequestImplCopyWithImpl<$Res>
    extends _$AddWordRequestCopyWithImpl<$Res, _$AddWordRequestImpl>
    implements _$$AddWordRequestImplCopyWith<$Res> {
  __$$AddWordRequestImplCopyWithImpl(
    _$AddWordRequestImpl _value,
    $Res Function(_$AddWordRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AddWordRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? term = null,
    Object? sortOrder = freezed,
    Object? source = freezed,
    Object? translations = null,
    Object? synonyms = freezed,
  }) {
    return _then(
      _$AddWordRequestImpl(
        term:
            null == term
                ? _value.term
                : term // ignore: cast_nullable_to_non_nullable
                    as String,
        sortOrder:
            freezed == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                    as int?,
        source:
            freezed == source
                ? _value.source
                : source // ignore: cast_nullable_to_non_nullable
                    as WordSource?,
        translations:
            null == translations
                ? _value._translations
                : translations // ignore: cast_nullable_to_non_nullable
                    as List<TranslationPayload>,
        synonyms:
            freezed == synonyms
                ? _value._synonyms
                : synonyms // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AddWordRequestImpl implements _AddWordRequest {
  const _$AddWordRequestImpl({
    required this.term,
    this.sortOrder,
    @WordSourceNullableConverter() this.source,
    required final List<TranslationPayload> translations,
    final List<String>? synonyms,
  }) : _translations = translations,
       _synonyms = synonyms;

  factory _$AddWordRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddWordRequestImplFromJson(json);

  @override
  final String term;
  @override
  final int? sortOrder;
  @override
  @WordSourceNullableConverter()
  final WordSource? source;
  final List<TranslationPayload> _translations;
  @override
  List<TranslationPayload> get translations {
    if (_translations is EqualUnmodifiableListView) return _translations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_translations);
  }

  final List<String>? _synonyms;
  @override
  List<String>? get synonyms {
    final value = _synonyms;
    if (value == null) return null;
    if (_synonyms is EqualUnmodifiableListView) return _synonyms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'AddWordRequest(term: $term, sortOrder: $sortOrder, source: $source, translations: $translations, synonyms: $synonyms)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddWordRequestImpl &&
            (identical(other.term, term) || other.term == term) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.source, source) || other.source == source) &&
            const DeepCollectionEquality().equals(
              other._translations,
              _translations,
            ) &&
            const DeepCollectionEquality().equals(other._synonyms, _synonyms));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    term,
    sortOrder,
    source,
    const DeepCollectionEquality().hash(_translations),
    const DeepCollectionEquality().hash(_synonyms),
  );

  /// Create a copy of AddWordRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddWordRequestImplCopyWith<_$AddWordRequestImpl> get copyWith =>
      __$$AddWordRequestImplCopyWithImpl<_$AddWordRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AddWordRequestImplToJson(this);
  }
}

abstract class _AddWordRequest implements AddWordRequest {
  const factory _AddWordRequest({
    required final String term,
    final int? sortOrder,
    @WordSourceNullableConverter() final WordSource? source,
    required final List<TranslationPayload> translations,
    final List<String>? synonyms,
  }) = _$AddWordRequestImpl;

  factory _AddWordRequest.fromJson(Map<String, dynamic> json) =
      _$AddWordRequestImpl.fromJson;

  @override
  String get term;
  @override
  int? get sortOrder;
  @override
  @WordSourceNullableConverter()
  WordSource? get source;
  @override
  List<TranslationPayload> get translations;
  @override
  List<String>? get synonyms;

  /// Create a copy of AddWordRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddWordRequestImplCopyWith<_$AddWordRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UpdateWordRequest _$UpdateWordRequestFromJson(Map<String, dynamic> json) {
  return _UpdateWordRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateWordRequest {
  String get term => throw _privateConstructorUsedError;
  int? get sortOrder => throw _privateConstructorUsedError;
  @WordSourceNullableConverter()
  WordSource? get source => throw _privateConstructorUsedError;
  List<TranslationPayload> get translations =>
      throw _privateConstructorUsedError;
  List<String>? get synonyms => throw _privateConstructorUsedError;

  /// Serializes this UpdateWordRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateWordRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateWordRequestCopyWith<UpdateWordRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateWordRequestCopyWith<$Res> {
  factory $UpdateWordRequestCopyWith(
    UpdateWordRequest value,
    $Res Function(UpdateWordRequest) then,
  ) = _$UpdateWordRequestCopyWithImpl<$Res, UpdateWordRequest>;
  @useResult
  $Res call({
    String term,
    int? sortOrder,
    @WordSourceNullableConverter() WordSource? source,
    List<TranslationPayload> translations,
    List<String>? synonyms,
  });
}

/// @nodoc
class _$UpdateWordRequestCopyWithImpl<$Res, $Val extends UpdateWordRequest>
    implements $UpdateWordRequestCopyWith<$Res> {
  _$UpdateWordRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateWordRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? term = null,
    Object? sortOrder = freezed,
    Object? source = freezed,
    Object? translations = null,
    Object? synonyms = freezed,
  }) {
    return _then(
      _value.copyWith(
            term:
                null == term
                    ? _value.term
                    : term // ignore: cast_nullable_to_non_nullable
                        as String,
            sortOrder:
                freezed == sortOrder
                    ? _value.sortOrder
                    : sortOrder // ignore: cast_nullable_to_non_nullable
                        as int?,
            source:
                freezed == source
                    ? _value.source
                    : source // ignore: cast_nullable_to_non_nullable
                        as WordSource?,
            translations:
                null == translations
                    ? _value.translations
                    : translations // ignore: cast_nullable_to_non_nullable
                        as List<TranslationPayload>,
            synonyms:
                freezed == synonyms
                    ? _value.synonyms
                    : synonyms // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateWordRequestImplCopyWith<$Res>
    implements $UpdateWordRequestCopyWith<$Res> {
  factory _$$UpdateWordRequestImplCopyWith(
    _$UpdateWordRequestImpl value,
    $Res Function(_$UpdateWordRequestImpl) then,
  ) = __$$UpdateWordRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String term,
    int? sortOrder,
    @WordSourceNullableConverter() WordSource? source,
    List<TranslationPayload> translations,
    List<String>? synonyms,
  });
}

/// @nodoc
class __$$UpdateWordRequestImplCopyWithImpl<$Res>
    extends _$UpdateWordRequestCopyWithImpl<$Res, _$UpdateWordRequestImpl>
    implements _$$UpdateWordRequestImplCopyWith<$Res> {
  __$$UpdateWordRequestImplCopyWithImpl(
    _$UpdateWordRequestImpl _value,
    $Res Function(_$UpdateWordRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateWordRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? term = null,
    Object? sortOrder = freezed,
    Object? source = freezed,
    Object? translations = null,
    Object? synonyms = freezed,
  }) {
    return _then(
      _$UpdateWordRequestImpl(
        term:
            null == term
                ? _value.term
                : term // ignore: cast_nullable_to_non_nullable
                    as String,
        sortOrder:
            freezed == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                    as int?,
        source:
            freezed == source
                ? _value.source
                : source // ignore: cast_nullable_to_non_nullable
                    as WordSource?,
        translations:
            null == translations
                ? _value._translations
                : translations // ignore: cast_nullable_to_non_nullable
                    as List<TranslationPayload>,
        synonyms:
            freezed == synonyms
                ? _value._synonyms
                : synonyms // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateWordRequestImpl implements _UpdateWordRequest {
  const _$UpdateWordRequestImpl({
    required this.term,
    this.sortOrder,
    @WordSourceNullableConverter() this.source,
    required final List<TranslationPayload> translations,
    final List<String>? synonyms,
  }) : _translations = translations,
       _synonyms = synonyms;

  factory _$UpdateWordRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateWordRequestImplFromJson(json);

  @override
  final String term;
  @override
  final int? sortOrder;
  @override
  @WordSourceNullableConverter()
  final WordSource? source;
  final List<TranslationPayload> _translations;
  @override
  List<TranslationPayload> get translations {
    if (_translations is EqualUnmodifiableListView) return _translations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_translations);
  }

  final List<String>? _synonyms;
  @override
  List<String>? get synonyms {
    final value = _synonyms;
    if (value == null) return null;
    if (_synonyms is EqualUnmodifiableListView) return _synonyms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'UpdateWordRequest(term: $term, sortOrder: $sortOrder, source: $source, translations: $translations, synonyms: $synonyms)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateWordRequestImpl &&
            (identical(other.term, term) || other.term == term) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.source, source) || other.source == source) &&
            const DeepCollectionEquality().equals(
              other._translations,
              _translations,
            ) &&
            const DeepCollectionEquality().equals(other._synonyms, _synonyms));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    term,
    sortOrder,
    source,
    const DeepCollectionEquality().hash(_translations),
    const DeepCollectionEquality().hash(_synonyms),
  );

  /// Create a copy of UpdateWordRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateWordRequestImplCopyWith<_$UpdateWordRequestImpl> get copyWith =>
      __$$UpdateWordRequestImplCopyWithImpl<_$UpdateWordRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateWordRequestImplToJson(this);
  }
}

abstract class _UpdateWordRequest implements UpdateWordRequest {
  const factory _UpdateWordRequest({
    required final String term,
    final int? sortOrder,
    @WordSourceNullableConverter() final WordSource? source,
    required final List<TranslationPayload> translations,
    final List<String>? synonyms,
  }) = _$UpdateWordRequestImpl;

  factory _UpdateWordRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateWordRequestImpl.fromJson;

  @override
  String get term;
  @override
  int? get sortOrder;
  @override
  @WordSourceNullableConverter()
  WordSource? get source;
  @override
  List<TranslationPayload> get translations;
  @override
  List<String>? get synonyms;

  /// Create a copy of UpdateWordRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateWordRequestImplCopyWith<_$UpdateWordRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WordDto _$WordDtoFromJson(Map<String, dynamic> json) {
  return _WordDto.fromJson(json);
}

/// @nodoc
mixin _$WordDto {
  String get id => throw _privateConstructorUsedError;
  String get lessonId => throw _privateConstructorUsedError;
  String get term => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;
  @WordSourceConverter()
  WordSource get source => throw _privateConstructorUsedError;
  List<TranslationDto> get translations => throw _privateConstructorUsedError;
  List<SynonymDto> get synonyms => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this WordDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WordDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WordDtoCopyWith<WordDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WordDtoCopyWith<$Res> {
  factory $WordDtoCopyWith(WordDto value, $Res Function(WordDto) then) =
      _$WordDtoCopyWithImpl<$Res, WordDto>;
  @useResult
  $Res call({
    String id,
    String lessonId,
    String term,
    int sortOrder,
    @WordSourceConverter() WordSource source,
    List<TranslationDto> translations,
    List<SynonymDto> synonyms,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$WordDtoCopyWithImpl<$Res, $Val extends WordDto>
    implements $WordDtoCopyWith<$Res> {
  _$WordDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WordDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? lessonId = null,
    Object? term = null,
    Object? sortOrder = null,
    Object? source = null,
    Object? translations = null,
    Object? synonyms = null,
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
            term:
                null == term
                    ? _value.term
                    : term // ignore: cast_nullable_to_non_nullable
                        as String,
            sortOrder:
                null == sortOrder
                    ? _value.sortOrder
                    : sortOrder // ignore: cast_nullable_to_non_nullable
                        as int,
            source:
                null == source
                    ? _value.source
                    : source // ignore: cast_nullable_to_non_nullable
                        as WordSource,
            translations:
                null == translations
                    ? _value.translations
                    : translations // ignore: cast_nullable_to_non_nullable
                        as List<TranslationDto>,
            synonyms:
                null == synonyms
                    ? _value.synonyms
                    : synonyms // ignore: cast_nullable_to_non_nullable
                        as List<SynonymDto>,
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
abstract class _$$WordDtoImplCopyWith<$Res> implements $WordDtoCopyWith<$Res> {
  factory _$$WordDtoImplCopyWith(
    _$WordDtoImpl value,
    $Res Function(_$WordDtoImpl) then,
  ) = __$$WordDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String lessonId,
    String term,
    int sortOrder,
    @WordSourceConverter() WordSource source,
    List<TranslationDto> translations,
    List<SynonymDto> synonyms,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$WordDtoImplCopyWithImpl<$Res>
    extends _$WordDtoCopyWithImpl<$Res, _$WordDtoImpl>
    implements _$$WordDtoImplCopyWith<$Res> {
  __$$WordDtoImplCopyWithImpl(
    _$WordDtoImpl _value,
    $Res Function(_$WordDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WordDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? lessonId = null,
    Object? term = null,
    Object? sortOrder = null,
    Object? source = null,
    Object? translations = null,
    Object? synonyms = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$WordDtoImpl(
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
        term:
            null == term
                ? _value.term
                : term // ignore: cast_nullable_to_non_nullable
                    as String,
        sortOrder:
            null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                    as int,
        source:
            null == source
                ? _value.source
                : source // ignore: cast_nullable_to_non_nullable
                    as WordSource,
        translations:
            null == translations
                ? _value._translations
                : translations // ignore: cast_nullable_to_non_nullable
                    as List<TranslationDto>,
        synonyms:
            null == synonyms
                ? _value._synonyms
                : synonyms // ignore: cast_nullable_to_non_nullable
                    as List<SynonymDto>,
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
class _$WordDtoImpl implements _WordDto {
  const _$WordDtoImpl({
    required this.id,
    required this.lessonId,
    required this.term,
    required this.sortOrder,
    @WordSourceConverter() required this.source,
    required final List<TranslationDto> translations,
    required final List<SynonymDto> synonyms,
    required this.createdAt,
    required this.updatedAt,
  }) : _translations = translations,
       _synonyms = synonyms;

  factory _$WordDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$WordDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String lessonId;
  @override
  final String term;
  @override
  final int sortOrder;
  @override
  @WordSourceConverter()
  final WordSource source;
  final List<TranslationDto> _translations;
  @override
  List<TranslationDto> get translations {
    if (_translations is EqualUnmodifiableListView) return _translations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_translations);
  }

  final List<SynonymDto> _synonyms;
  @override
  List<SynonymDto> get synonyms {
    if (_synonyms is EqualUnmodifiableListView) return _synonyms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_synonyms);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'WordDto(id: $id, lessonId: $lessonId, term: $term, sortOrder: $sortOrder, source: $source, translations: $translations, synonyms: $synonyms, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WordDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.lessonId, lessonId) ||
                other.lessonId == lessonId) &&
            (identical(other.term, term) || other.term == term) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.source, source) || other.source == source) &&
            const DeepCollectionEquality().equals(
              other._translations,
              _translations,
            ) &&
            const DeepCollectionEquality().equals(other._synonyms, _synonyms) &&
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
    term,
    sortOrder,
    source,
    const DeepCollectionEquality().hash(_translations),
    const DeepCollectionEquality().hash(_synonyms),
    createdAt,
    updatedAt,
  );

  /// Create a copy of WordDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WordDtoImplCopyWith<_$WordDtoImpl> get copyWith =>
      __$$WordDtoImplCopyWithImpl<_$WordDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WordDtoImplToJson(this);
  }
}

abstract class _WordDto implements WordDto {
  const factory _WordDto({
    required final String id,
    required final String lessonId,
    required final String term,
    required final int sortOrder,
    @WordSourceConverter() required final WordSource source,
    required final List<TranslationDto> translations,
    required final List<SynonymDto> synonyms,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$WordDtoImpl;

  factory _WordDto.fromJson(Map<String, dynamic> json) = _$WordDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get lessonId;
  @override
  String get term;
  @override
  int get sortOrder;
  @override
  @WordSourceConverter()
  WordSource get source;
  @override
  List<TranslationDto> get translations;
  @override
  List<SynonymDto> get synonyms;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of WordDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WordDtoImplCopyWith<_$WordDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TranslationDto _$TranslationDtoFromJson(Map<String, dynamic> json) {
  return _TranslationDto.fromJson(json);
}

/// @nodoc
mixin _$TranslationDto {
  String get id => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  bool get isPrimary => throw _privateConstructorUsedError;

  /// Serializes this TranslationDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TranslationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TranslationDtoCopyWith<TranslationDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TranslationDtoCopyWith<$Res> {
  factory $TranslationDtoCopyWith(
    TranslationDto value,
    $Res Function(TranslationDto) then,
  ) = _$TranslationDtoCopyWithImpl<$Res, TranslationDto>;
  @useResult
  $Res call({String id, String text, bool isPrimary});
}

/// @nodoc
class _$TranslationDtoCopyWithImpl<$Res, $Val extends TranslationDto>
    implements $TranslationDtoCopyWith<$Res> {
  _$TranslationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TranslationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? isPrimary = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            text:
                null == text
                    ? _value.text
                    : text // ignore: cast_nullable_to_non_nullable
                        as String,
            isPrimary:
                null == isPrimary
                    ? _value.isPrimary
                    : isPrimary // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TranslationDtoImplCopyWith<$Res>
    implements $TranslationDtoCopyWith<$Res> {
  factory _$$TranslationDtoImplCopyWith(
    _$TranslationDtoImpl value,
    $Res Function(_$TranslationDtoImpl) then,
  ) = __$$TranslationDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String text, bool isPrimary});
}

/// @nodoc
class __$$TranslationDtoImplCopyWithImpl<$Res>
    extends _$TranslationDtoCopyWithImpl<$Res, _$TranslationDtoImpl>
    implements _$$TranslationDtoImplCopyWith<$Res> {
  __$$TranslationDtoImplCopyWithImpl(
    _$TranslationDtoImpl _value,
    $Res Function(_$TranslationDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TranslationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? isPrimary = null,
  }) {
    return _then(
      _$TranslationDtoImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        text:
            null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                    as String,
        isPrimary:
            null == isPrimary
                ? _value.isPrimary
                : isPrimary // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TranslationDtoImpl implements _TranslationDto {
  const _$TranslationDtoImpl({
    required this.id,
    required this.text,
    required this.isPrimary,
  });

  factory _$TranslationDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TranslationDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String text;
  @override
  final bool isPrimary;

  @override
  String toString() {
    return 'TranslationDto(id: $id, text: $text, isPrimary: $isPrimary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TranslationDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.isPrimary, isPrimary) ||
                other.isPrimary == isPrimary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, text, isPrimary);

  /// Create a copy of TranslationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TranslationDtoImplCopyWith<_$TranslationDtoImpl> get copyWith =>
      __$$TranslationDtoImplCopyWithImpl<_$TranslationDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TranslationDtoImplToJson(this);
  }
}

abstract class _TranslationDto implements TranslationDto {
  const factory _TranslationDto({
    required final String id,
    required final String text,
    required final bool isPrimary,
  }) = _$TranslationDtoImpl;

  factory _TranslationDto.fromJson(Map<String, dynamic> json) =
      _$TranslationDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get text;
  @override
  bool get isPrimary;

  /// Create a copy of TranslationDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TranslationDtoImplCopyWith<_$TranslationDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SynonymDto _$SynonymDtoFromJson(Map<String, dynamic> json) {
  return _SynonymDto.fromJson(json);
}

/// @nodoc
mixin _$SynonymDto {
  String get id => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;

  /// Serializes this SynonymDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SynonymDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SynonymDtoCopyWith<SynonymDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SynonymDtoCopyWith<$Res> {
  factory $SynonymDtoCopyWith(
    SynonymDto value,
    $Res Function(SynonymDto) then,
  ) = _$SynonymDtoCopyWithImpl<$Res, SynonymDto>;
  @useResult
  $Res call({String id, String text});
}

/// @nodoc
class _$SynonymDtoCopyWithImpl<$Res, $Val extends SynonymDto>
    implements $SynonymDtoCopyWith<$Res> {
  _$SynonymDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SynonymDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? text = null}) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            text:
                null == text
                    ? _value.text
                    : text // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SynonymDtoImplCopyWith<$Res>
    implements $SynonymDtoCopyWith<$Res> {
  factory _$$SynonymDtoImplCopyWith(
    _$SynonymDtoImpl value,
    $Res Function(_$SynonymDtoImpl) then,
  ) = __$$SynonymDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String text});
}

/// @nodoc
class __$$SynonymDtoImplCopyWithImpl<$Res>
    extends _$SynonymDtoCopyWithImpl<$Res, _$SynonymDtoImpl>
    implements _$$SynonymDtoImplCopyWith<$Res> {
  __$$SynonymDtoImplCopyWithImpl(
    _$SynonymDtoImpl _value,
    $Res Function(_$SynonymDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SynonymDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? text = null}) {
    return _then(
      _$SynonymDtoImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        text:
            null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SynonymDtoImpl implements _SynonymDto {
  const _$SynonymDtoImpl({required this.id, required this.text});

  factory _$SynonymDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SynonymDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String text;

  @override
  String toString() {
    return 'SynonymDto(id: $id, text: $text)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SynonymDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, text);

  /// Create a copy of SynonymDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SynonymDtoImplCopyWith<_$SynonymDtoImpl> get copyWith =>
      __$$SynonymDtoImplCopyWithImpl<_$SynonymDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SynonymDtoImplToJson(this);
  }
}

abstract class _SynonymDto implements SynonymDto {
  const factory _SynonymDto({
    required final String id,
    required final String text,
  }) = _$SynonymDtoImpl;

  factory _SynonymDto.fromJson(Map<String, dynamic> json) =
      _$SynonymDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get text;

  /// Create a copy of SynonymDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SynonymDtoImplCopyWith<_$SynonymDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
