// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SubscriptionDto _$SubscriptionDtoFromJson(Map<String, dynamic> json) {
  return _SubscriptionDto.fromJson(json);
}

/// @nodoc
mixin _$SubscriptionDto {
  @SubscriptionPlanConverter()
  SubscriptionPlan get plan => throw _privateConstructorUsedError;
  @SubscriptionStatusConverter()
  SubscriptionStatus get status => throw _privateConstructorUsedError;
  @SubscriptionPeriodConverter()
  SubscriptionPeriod get period => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  bool get isPremium => throw _privateConstructorUsedError;
  int get maxClasses => throw _privateConstructorUsedError;
  int get maxLessons => throw _privateConstructorUsedError;
  int get maxTeachers => throw _privateConstructorUsedError;
  bool get ocrEnabled => throw _privateConstructorUsedError;

  /// Serializes this SubscriptionDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubscriptionDtoCopyWith<SubscriptionDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionDtoCopyWith<$Res> {
  factory $SubscriptionDtoCopyWith(
    SubscriptionDto value,
    $Res Function(SubscriptionDto) then,
  ) = _$SubscriptionDtoCopyWithImpl<$Res, SubscriptionDto>;
  @useResult
  $Res call({
    @SubscriptionPlanConverter() SubscriptionPlan plan,
    @SubscriptionStatusConverter() SubscriptionStatus status,
    @SubscriptionPeriodConverter() SubscriptionPeriod period,
    DateTime? expiresAt,
    bool isPremium,
    int maxClasses,
    int maxLessons,
    int maxTeachers,
    bool ocrEnabled,
  });
}

/// @nodoc
class _$SubscriptionDtoCopyWithImpl<$Res, $Val extends SubscriptionDto>
    implements $SubscriptionDtoCopyWith<$Res> {
  _$SubscriptionDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? plan = null,
    Object? status = null,
    Object? period = null,
    Object? expiresAt = freezed,
    Object? isPremium = null,
    Object? maxClasses = null,
    Object? maxLessons = null,
    Object? maxTeachers = null,
    Object? ocrEnabled = null,
  }) {
    return _then(
      _value.copyWith(
            plan:
                null == plan
                    ? _value.plan
                    : plan // ignore: cast_nullable_to_non_nullable
                        as SubscriptionPlan,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as SubscriptionStatus,
            period:
                null == period
                    ? _value.period
                    : period // ignore: cast_nullable_to_non_nullable
                        as SubscriptionPeriod,
            expiresAt:
                freezed == expiresAt
                    ? _value.expiresAt
                    : expiresAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            isPremium:
                null == isPremium
                    ? _value.isPremium
                    : isPremium // ignore: cast_nullable_to_non_nullable
                        as bool,
            maxClasses:
                null == maxClasses
                    ? _value.maxClasses
                    : maxClasses // ignore: cast_nullable_to_non_nullable
                        as int,
            maxLessons:
                null == maxLessons
                    ? _value.maxLessons
                    : maxLessons // ignore: cast_nullable_to_non_nullable
                        as int,
            maxTeachers:
                null == maxTeachers
                    ? _value.maxTeachers
                    : maxTeachers // ignore: cast_nullable_to_non_nullable
                        as int,
            ocrEnabled:
                null == ocrEnabled
                    ? _value.ocrEnabled
                    : ocrEnabled // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SubscriptionDtoImplCopyWith<$Res>
    implements $SubscriptionDtoCopyWith<$Res> {
  factory _$$SubscriptionDtoImplCopyWith(
    _$SubscriptionDtoImpl value,
    $Res Function(_$SubscriptionDtoImpl) then,
  ) = __$$SubscriptionDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @SubscriptionPlanConverter() SubscriptionPlan plan,
    @SubscriptionStatusConverter() SubscriptionStatus status,
    @SubscriptionPeriodConverter() SubscriptionPeriod period,
    DateTime? expiresAt,
    bool isPremium,
    int maxClasses,
    int maxLessons,
    int maxTeachers,
    bool ocrEnabled,
  });
}

/// @nodoc
class __$$SubscriptionDtoImplCopyWithImpl<$Res>
    extends _$SubscriptionDtoCopyWithImpl<$Res, _$SubscriptionDtoImpl>
    implements _$$SubscriptionDtoImplCopyWith<$Res> {
  __$$SubscriptionDtoImplCopyWithImpl(
    _$SubscriptionDtoImpl _value,
    $Res Function(_$SubscriptionDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? plan = null,
    Object? status = null,
    Object? period = null,
    Object? expiresAt = freezed,
    Object? isPremium = null,
    Object? maxClasses = null,
    Object? maxLessons = null,
    Object? maxTeachers = null,
    Object? ocrEnabled = null,
  }) {
    return _then(
      _$SubscriptionDtoImpl(
        plan:
            null == plan
                ? _value.plan
                : plan // ignore: cast_nullable_to_non_nullable
                    as SubscriptionPlan,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as SubscriptionStatus,
        period:
            null == period
                ? _value.period
                : period // ignore: cast_nullable_to_non_nullable
                    as SubscriptionPeriod,
        expiresAt:
            freezed == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        isPremium:
            null == isPremium
                ? _value.isPremium
                : isPremium // ignore: cast_nullable_to_non_nullable
                    as bool,
        maxClasses:
            null == maxClasses
                ? _value.maxClasses
                : maxClasses // ignore: cast_nullable_to_non_nullable
                    as int,
        maxLessons:
            null == maxLessons
                ? _value.maxLessons
                : maxLessons // ignore: cast_nullable_to_non_nullable
                    as int,
        maxTeachers:
            null == maxTeachers
                ? _value.maxTeachers
                : maxTeachers // ignore: cast_nullable_to_non_nullable
                    as int,
        ocrEnabled:
            null == ocrEnabled
                ? _value.ocrEnabled
                : ocrEnabled // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SubscriptionDtoImpl extends _SubscriptionDto {
  const _$SubscriptionDtoImpl({
    @SubscriptionPlanConverter() required this.plan,
    @SubscriptionStatusConverter() required this.status,
    @SubscriptionPeriodConverter() required this.period,
    this.expiresAt,
    required this.isPremium,
    required this.maxClasses,
    required this.maxLessons,
    required this.maxTeachers,
    required this.ocrEnabled,
  }) : super._();

  factory _$SubscriptionDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubscriptionDtoImplFromJson(json);

  @override
  @SubscriptionPlanConverter()
  final SubscriptionPlan plan;
  @override
  @SubscriptionStatusConverter()
  final SubscriptionStatus status;
  @override
  @SubscriptionPeriodConverter()
  final SubscriptionPeriod period;
  @override
  final DateTime? expiresAt;
  @override
  final bool isPremium;
  @override
  final int maxClasses;
  @override
  final int maxLessons;
  @override
  final int maxTeachers;
  @override
  final bool ocrEnabled;

  @override
  String toString() {
    return 'SubscriptionDto(plan: $plan, status: $status, period: $period, expiresAt: $expiresAt, isPremium: $isPremium, maxClasses: $maxClasses, maxLessons: $maxLessons, maxTeachers: $maxTeachers, ocrEnabled: $ocrEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionDtoImpl &&
            (identical(other.plan, plan) || other.plan == plan) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.isPremium, isPremium) ||
                other.isPremium == isPremium) &&
            (identical(other.maxClasses, maxClasses) ||
                other.maxClasses == maxClasses) &&
            (identical(other.maxLessons, maxLessons) ||
                other.maxLessons == maxLessons) &&
            (identical(other.maxTeachers, maxTeachers) ||
                other.maxTeachers == maxTeachers) &&
            (identical(other.ocrEnabled, ocrEnabled) ||
                other.ocrEnabled == ocrEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    plan,
    status,
    period,
    expiresAt,
    isPremium,
    maxClasses,
    maxLessons,
    maxTeachers,
    ocrEnabled,
  );

  /// Create a copy of SubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionDtoImplCopyWith<_$SubscriptionDtoImpl> get copyWith =>
      __$$SubscriptionDtoImplCopyWithImpl<_$SubscriptionDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SubscriptionDtoImplToJson(this);
  }
}

abstract class _SubscriptionDto extends SubscriptionDto {
  const factory _SubscriptionDto({
    @SubscriptionPlanConverter() required final SubscriptionPlan plan,
    @SubscriptionStatusConverter() required final SubscriptionStatus status,
    @SubscriptionPeriodConverter() required final SubscriptionPeriod period,
    final DateTime? expiresAt,
    required final bool isPremium,
    required final int maxClasses,
    required final int maxLessons,
    required final int maxTeachers,
    required final bool ocrEnabled,
  }) = _$SubscriptionDtoImpl;
  const _SubscriptionDto._() : super._();

  factory _SubscriptionDto.fromJson(Map<String, dynamic> json) =
      _$SubscriptionDtoImpl.fromJson;

  @override
  @SubscriptionPlanConverter()
  SubscriptionPlan get plan;
  @override
  @SubscriptionStatusConverter()
  SubscriptionStatus get status;
  @override
  @SubscriptionPeriodConverter()
  SubscriptionPeriod get period;
  @override
  DateTime? get expiresAt;
  @override
  bool get isPremium;
  @override
  int get maxClasses;
  @override
  int get maxLessons;
  @override
  int get maxTeachers;
  @override
  bool get ocrEnabled;

  /// Create a copy of SubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscriptionDtoImplCopyWith<_$SubscriptionDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActivateStubRequest _$ActivateStubRequestFromJson(Map<String, dynamic> json) {
  return _ActivateStubRequest.fromJson(json);
}

/// @nodoc
mixin _$ActivateStubRequest {
  int? get period => throw _privateConstructorUsedError;
  bool get trial => throw _privateConstructorUsedError;

  /// Serializes this ActivateStubRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivateStubRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivateStubRequestCopyWith<ActivateStubRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivateStubRequestCopyWith<$Res> {
  factory $ActivateStubRequestCopyWith(
    ActivateStubRequest value,
    $Res Function(ActivateStubRequest) then,
  ) = _$ActivateStubRequestCopyWithImpl<$Res, ActivateStubRequest>;
  @useResult
  $Res call({int? period, bool trial});
}

/// @nodoc
class _$ActivateStubRequestCopyWithImpl<$Res, $Val extends ActivateStubRequest>
    implements $ActivateStubRequestCopyWith<$Res> {
  _$ActivateStubRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivateStubRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? period = freezed, Object? trial = null}) {
    return _then(
      _value.copyWith(
            period:
                freezed == period
                    ? _value.period
                    : period // ignore: cast_nullable_to_non_nullable
                        as int?,
            trial:
                null == trial
                    ? _value.trial
                    : trial // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActivateStubRequestImplCopyWith<$Res>
    implements $ActivateStubRequestCopyWith<$Res> {
  factory _$$ActivateStubRequestImplCopyWith(
    _$ActivateStubRequestImpl value,
    $Res Function(_$ActivateStubRequestImpl) then,
  ) = __$$ActivateStubRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? period, bool trial});
}

/// @nodoc
class __$$ActivateStubRequestImplCopyWithImpl<$Res>
    extends _$ActivateStubRequestCopyWithImpl<$Res, _$ActivateStubRequestImpl>
    implements _$$ActivateStubRequestImplCopyWith<$Res> {
  __$$ActivateStubRequestImplCopyWithImpl(
    _$ActivateStubRequestImpl _value,
    $Res Function(_$ActivateStubRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivateStubRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? period = freezed, Object? trial = null}) {
    return _then(
      _$ActivateStubRequestImpl(
        period:
            freezed == period
                ? _value.period
                : period // ignore: cast_nullable_to_non_nullable
                    as int?,
        trial:
            null == trial
                ? _value.trial
                : trial // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivateStubRequestImpl implements _ActivateStubRequest {
  const _$ActivateStubRequestImpl({this.period, this.trial = false});

  factory _$ActivateStubRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivateStubRequestImplFromJson(json);

  @override
  final int? period;
  @override
  @JsonKey()
  final bool trial;

  @override
  String toString() {
    return 'ActivateStubRequest(period: $period, trial: $trial)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivateStubRequestImpl &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.trial, trial) || other.trial == trial));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, period, trial);

  /// Create a copy of ActivateStubRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivateStubRequestImplCopyWith<_$ActivateStubRequestImpl> get copyWith =>
      __$$ActivateStubRequestImplCopyWithImpl<_$ActivateStubRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivateStubRequestImplToJson(this);
  }
}

abstract class _ActivateStubRequest implements ActivateStubRequest {
  const factory _ActivateStubRequest({final int? period, final bool trial}) =
      _$ActivateStubRequestImpl;

  factory _ActivateStubRequest.fromJson(Map<String, dynamic> json) =
      _$ActivateStubRequestImpl.fromJson;

  @override
  int? get period;
  @override
  bool get trial;

  /// Create a copy of ActivateStubRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivateStubRequestImplCopyWith<_$ActivateStubRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AppleVerifyRequest _$AppleVerifyRequestFromJson(Map<String, dynamic> json) {
  return _AppleVerifyRequest.fromJson(json);
}

/// @nodoc
mixin _$AppleVerifyRequest {
  String get receiptData => throw _privateConstructorUsedError;

  /// Serializes this AppleVerifyRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppleVerifyRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppleVerifyRequestCopyWith<AppleVerifyRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppleVerifyRequestCopyWith<$Res> {
  factory $AppleVerifyRequestCopyWith(
    AppleVerifyRequest value,
    $Res Function(AppleVerifyRequest) then,
  ) = _$AppleVerifyRequestCopyWithImpl<$Res, AppleVerifyRequest>;
  @useResult
  $Res call({String receiptData});
}

/// @nodoc
class _$AppleVerifyRequestCopyWithImpl<$Res, $Val extends AppleVerifyRequest>
    implements $AppleVerifyRequestCopyWith<$Res> {
  _$AppleVerifyRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppleVerifyRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? receiptData = null}) {
    return _then(
      _value.copyWith(
            receiptData:
                null == receiptData
                    ? _value.receiptData
                    : receiptData // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppleVerifyRequestImplCopyWith<$Res>
    implements $AppleVerifyRequestCopyWith<$Res> {
  factory _$$AppleVerifyRequestImplCopyWith(
    _$AppleVerifyRequestImpl value,
    $Res Function(_$AppleVerifyRequestImpl) then,
  ) = __$$AppleVerifyRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String receiptData});
}

/// @nodoc
class __$$AppleVerifyRequestImplCopyWithImpl<$Res>
    extends _$AppleVerifyRequestCopyWithImpl<$Res, _$AppleVerifyRequestImpl>
    implements _$$AppleVerifyRequestImplCopyWith<$Res> {
  __$$AppleVerifyRequestImplCopyWithImpl(
    _$AppleVerifyRequestImpl _value,
    $Res Function(_$AppleVerifyRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppleVerifyRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? receiptData = null}) {
    return _then(
      _$AppleVerifyRequestImpl(
        receiptData:
            null == receiptData
                ? _value.receiptData
                : receiptData // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppleVerifyRequestImpl implements _AppleVerifyRequest {
  const _$AppleVerifyRequestImpl({required this.receiptData});

  factory _$AppleVerifyRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppleVerifyRequestImplFromJson(json);

  @override
  final String receiptData;

  @override
  String toString() {
    return 'AppleVerifyRequest(receiptData: $receiptData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppleVerifyRequestImpl &&
            (identical(other.receiptData, receiptData) ||
                other.receiptData == receiptData));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, receiptData);

  /// Create a copy of AppleVerifyRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppleVerifyRequestImplCopyWith<_$AppleVerifyRequestImpl> get copyWith =>
      __$$AppleVerifyRequestImplCopyWithImpl<_$AppleVerifyRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AppleVerifyRequestImplToJson(this);
  }
}

abstract class _AppleVerifyRequest implements AppleVerifyRequest {
  const factory _AppleVerifyRequest({required final String receiptData}) =
      _$AppleVerifyRequestImpl;

  factory _AppleVerifyRequest.fromJson(Map<String, dynamic> json) =
      _$AppleVerifyRequestImpl.fromJson;

  @override
  String get receiptData;

  /// Create a copy of AppleVerifyRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppleVerifyRequestImplCopyWith<_$AppleVerifyRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GoogleVerifyRequest _$GoogleVerifyRequestFromJson(Map<String, dynamic> json) {
  return _GoogleVerifyRequest.fromJson(json);
}

/// @nodoc
mixin _$GoogleVerifyRequest {
  String get purchaseToken => throw _privateConstructorUsedError;
  String get productId => throw _privateConstructorUsedError;

  /// Serializes this GoogleVerifyRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GoogleVerifyRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GoogleVerifyRequestCopyWith<GoogleVerifyRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoogleVerifyRequestCopyWith<$Res> {
  factory $GoogleVerifyRequestCopyWith(
    GoogleVerifyRequest value,
    $Res Function(GoogleVerifyRequest) then,
  ) = _$GoogleVerifyRequestCopyWithImpl<$Res, GoogleVerifyRequest>;
  @useResult
  $Res call({String purchaseToken, String productId});
}

/// @nodoc
class _$GoogleVerifyRequestCopyWithImpl<$Res, $Val extends GoogleVerifyRequest>
    implements $GoogleVerifyRequestCopyWith<$Res> {
  _$GoogleVerifyRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GoogleVerifyRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? purchaseToken = null, Object? productId = null}) {
    return _then(
      _value.copyWith(
            purchaseToken:
                null == purchaseToken
                    ? _value.purchaseToken
                    : purchaseToken // ignore: cast_nullable_to_non_nullable
                        as String,
            productId:
                null == productId
                    ? _value.productId
                    : productId // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GoogleVerifyRequestImplCopyWith<$Res>
    implements $GoogleVerifyRequestCopyWith<$Res> {
  factory _$$GoogleVerifyRequestImplCopyWith(
    _$GoogleVerifyRequestImpl value,
    $Res Function(_$GoogleVerifyRequestImpl) then,
  ) = __$$GoogleVerifyRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String purchaseToken, String productId});
}

/// @nodoc
class __$$GoogleVerifyRequestImplCopyWithImpl<$Res>
    extends _$GoogleVerifyRequestCopyWithImpl<$Res, _$GoogleVerifyRequestImpl>
    implements _$$GoogleVerifyRequestImplCopyWith<$Res> {
  __$$GoogleVerifyRequestImplCopyWithImpl(
    _$GoogleVerifyRequestImpl _value,
    $Res Function(_$GoogleVerifyRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GoogleVerifyRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? purchaseToken = null, Object? productId = null}) {
    return _then(
      _$GoogleVerifyRequestImpl(
        purchaseToken:
            null == purchaseToken
                ? _value.purchaseToken
                : purchaseToken // ignore: cast_nullable_to_non_nullable
                    as String,
        productId:
            null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GoogleVerifyRequestImpl implements _GoogleVerifyRequest {
  const _$GoogleVerifyRequestImpl({
    required this.purchaseToken,
    required this.productId,
  });

  factory _$GoogleVerifyRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$GoogleVerifyRequestImplFromJson(json);

  @override
  final String purchaseToken;
  @override
  final String productId;

  @override
  String toString() {
    return 'GoogleVerifyRequest(purchaseToken: $purchaseToken, productId: $productId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoogleVerifyRequestImpl &&
            (identical(other.purchaseToken, purchaseToken) ||
                other.purchaseToken == purchaseToken) &&
            (identical(other.productId, productId) ||
                other.productId == productId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, purchaseToken, productId);

  /// Create a copy of GoogleVerifyRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GoogleVerifyRequestImplCopyWith<_$GoogleVerifyRequestImpl> get copyWith =>
      __$$GoogleVerifyRequestImplCopyWithImpl<_$GoogleVerifyRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GoogleVerifyRequestImplToJson(this);
  }
}

abstract class _GoogleVerifyRequest implements GoogleVerifyRequest {
  const factory _GoogleVerifyRequest({
    required final String purchaseToken,
    required final String productId,
  }) = _$GoogleVerifyRequestImpl;

  factory _GoogleVerifyRequest.fromJson(Map<String, dynamic> json) =
      _$GoogleVerifyRequestImpl.fromJson;

  @override
  String get purchaseToken;
  @override
  String get productId;

  /// Create a copy of GoogleVerifyRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GoogleVerifyRequestImplCopyWith<_$GoogleVerifyRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
