// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_preferences_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NotificationPreferencesDto _$NotificationPreferencesDtoFromJson(
  Map<String, dynamic> json,
) {
  return _NotificationPreferencesDto.fromJson(json);
}

/// @nodoc
mixin _$NotificationPreferencesDto {
  bool get master => throw _privateConstructorUsedError;
  bool get assigned => throw _privateConstructorUsedError;
  bool get reminder => throw _privateConstructorUsedError;
  bool get results => throw _privateConstructorUsedError;
  bool get announcements => throw _privateConstructorUsedError;

  /// Serializes this NotificationPreferencesDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationPreferencesDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationPreferencesDtoCopyWith<NotificationPreferencesDto>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationPreferencesDtoCopyWith<$Res> {
  factory $NotificationPreferencesDtoCopyWith(
    NotificationPreferencesDto value,
    $Res Function(NotificationPreferencesDto) then,
  ) =
      _$NotificationPreferencesDtoCopyWithImpl<
        $Res,
        NotificationPreferencesDto
      >;
  @useResult
  $Res call({
    bool master,
    bool assigned,
    bool reminder,
    bool results,
    bool announcements,
  });
}

/// @nodoc
class _$NotificationPreferencesDtoCopyWithImpl<
  $Res,
  $Val extends NotificationPreferencesDto
>
    implements $NotificationPreferencesDtoCopyWith<$Res> {
  _$NotificationPreferencesDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationPreferencesDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? master = null,
    Object? assigned = null,
    Object? reminder = null,
    Object? results = null,
    Object? announcements = null,
  }) {
    return _then(
      _value.copyWith(
            master:
                null == master
                    ? _value.master
                    : master // ignore: cast_nullable_to_non_nullable
                        as bool,
            assigned:
                null == assigned
                    ? _value.assigned
                    : assigned // ignore: cast_nullable_to_non_nullable
                        as bool,
            reminder:
                null == reminder
                    ? _value.reminder
                    : reminder // ignore: cast_nullable_to_non_nullable
                        as bool,
            results:
                null == results
                    ? _value.results
                    : results // ignore: cast_nullable_to_non_nullable
                        as bool,
            announcements:
                null == announcements
                    ? _value.announcements
                    : announcements // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NotificationPreferencesDtoImplCopyWith<$Res>
    implements $NotificationPreferencesDtoCopyWith<$Res> {
  factory _$$NotificationPreferencesDtoImplCopyWith(
    _$NotificationPreferencesDtoImpl value,
    $Res Function(_$NotificationPreferencesDtoImpl) then,
  ) = __$$NotificationPreferencesDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool master,
    bool assigned,
    bool reminder,
    bool results,
    bool announcements,
  });
}

/// @nodoc
class __$$NotificationPreferencesDtoImplCopyWithImpl<$Res>
    extends
        _$NotificationPreferencesDtoCopyWithImpl<
          $Res,
          _$NotificationPreferencesDtoImpl
        >
    implements _$$NotificationPreferencesDtoImplCopyWith<$Res> {
  __$$NotificationPreferencesDtoImplCopyWithImpl(
    _$NotificationPreferencesDtoImpl _value,
    $Res Function(_$NotificationPreferencesDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationPreferencesDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? master = null,
    Object? assigned = null,
    Object? reminder = null,
    Object? results = null,
    Object? announcements = null,
  }) {
    return _then(
      _$NotificationPreferencesDtoImpl(
        master:
            null == master
                ? _value.master
                : master // ignore: cast_nullable_to_non_nullable
                    as bool,
        assigned:
            null == assigned
                ? _value.assigned
                : assigned // ignore: cast_nullable_to_non_nullable
                    as bool,
        reminder:
            null == reminder
                ? _value.reminder
                : reminder // ignore: cast_nullable_to_non_nullable
                    as bool,
        results:
            null == results
                ? _value.results
                : results // ignore: cast_nullable_to_non_nullable
                    as bool,
        announcements:
            null == announcements
                ? _value.announcements
                : announcements // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationPreferencesDtoImpl extends _NotificationPreferencesDto {
  const _$NotificationPreferencesDtoImpl({
    this.master = true,
    this.assigned = true,
    this.reminder = true,
    this.results = true,
    this.announcements = false,
  }) : super._();

  factory _$NotificationPreferencesDtoImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$NotificationPreferencesDtoImplFromJson(json);

  @override
  @JsonKey()
  final bool master;
  @override
  @JsonKey()
  final bool assigned;
  @override
  @JsonKey()
  final bool reminder;
  @override
  @JsonKey()
  final bool results;
  @override
  @JsonKey()
  final bool announcements;

  @override
  String toString() {
    return 'NotificationPreferencesDto(master: $master, assigned: $assigned, reminder: $reminder, results: $results, announcements: $announcements)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationPreferencesDtoImpl &&
            (identical(other.master, master) || other.master == master) &&
            (identical(other.assigned, assigned) ||
                other.assigned == assigned) &&
            (identical(other.reminder, reminder) ||
                other.reminder == reminder) &&
            (identical(other.results, results) || other.results == results) &&
            (identical(other.announcements, announcements) ||
                other.announcements == announcements));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    master,
    assigned,
    reminder,
    results,
    announcements,
  );

  /// Create a copy of NotificationPreferencesDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationPreferencesDtoImplCopyWith<_$NotificationPreferencesDtoImpl>
  get copyWith => __$$NotificationPreferencesDtoImplCopyWithImpl<
    _$NotificationPreferencesDtoImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationPreferencesDtoImplToJson(this);
  }
}

abstract class _NotificationPreferencesDto extends NotificationPreferencesDto {
  const factory _NotificationPreferencesDto({
    final bool master,
    final bool assigned,
    final bool reminder,
    final bool results,
    final bool announcements,
  }) = _$NotificationPreferencesDtoImpl;
  const _NotificationPreferencesDto._() : super._();

  factory _NotificationPreferencesDto.fromJson(Map<String, dynamic> json) =
      _$NotificationPreferencesDtoImpl.fromJson;

  @override
  bool get master;
  @override
  bool get assigned;
  @override
  bool get reminder;
  @override
  bool get results;
  @override
  bool get announcements;

  /// Create a copy of NotificationPreferencesDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationPreferencesDtoImplCopyWith<_$NotificationPreferencesDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
