// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_progress_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StudentProgressDto _$StudentProgressDtoFromJson(Map<String, dynamic> json) {
  return _StudentProgressDto.fromJson(json);
}

/// @nodoc
mixin _$StudentProgressDto {
  int get gamesPlayed => throw _privateConstructorUsedError;
  int get averageAccuracy => throw _privateConstructorUsedError;
  int? get accuracyTrendDelta => throw _privateConstructorUsedError;
  int get weeklyMinutes => throw _privateConstructorUsedError;
  int get weeklyGoalMinutes => throw _privateConstructorUsedError;
  int get streakDays => throw _privateConstructorUsedError;

  /// Serializes this StudentProgressDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StudentProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudentProgressDtoCopyWith<StudentProgressDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudentProgressDtoCopyWith<$Res> {
  factory $StudentProgressDtoCopyWith(
    StudentProgressDto value,
    $Res Function(StudentProgressDto) then,
  ) = _$StudentProgressDtoCopyWithImpl<$Res, StudentProgressDto>;
  @useResult
  $Res call({
    int gamesPlayed,
    int averageAccuracy,
    int? accuracyTrendDelta,
    int weeklyMinutes,
    int weeklyGoalMinutes,
    int streakDays,
  });
}

/// @nodoc
class _$StudentProgressDtoCopyWithImpl<$Res, $Val extends StudentProgressDto>
    implements $StudentProgressDtoCopyWith<$Res> {
  _$StudentProgressDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StudentProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gamesPlayed = null,
    Object? averageAccuracy = null,
    Object? accuracyTrendDelta = freezed,
    Object? weeklyMinutes = null,
    Object? weeklyGoalMinutes = null,
    Object? streakDays = null,
  }) {
    return _then(
      _value.copyWith(
            gamesPlayed:
                null == gamesPlayed
                    ? _value.gamesPlayed
                    : gamesPlayed // ignore: cast_nullable_to_non_nullable
                        as int,
            averageAccuracy:
                null == averageAccuracy
                    ? _value.averageAccuracy
                    : averageAccuracy // ignore: cast_nullable_to_non_nullable
                        as int,
            accuracyTrendDelta:
                freezed == accuracyTrendDelta
                    ? _value.accuracyTrendDelta
                    : accuracyTrendDelta // ignore: cast_nullable_to_non_nullable
                        as int?,
            weeklyMinutes:
                null == weeklyMinutes
                    ? _value.weeklyMinutes
                    : weeklyMinutes // ignore: cast_nullable_to_non_nullable
                        as int,
            weeklyGoalMinutes:
                null == weeklyGoalMinutes
                    ? _value.weeklyGoalMinutes
                    : weeklyGoalMinutes // ignore: cast_nullable_to_non_nullable
                        as int,
            streakDays:
                null == streakDays
                    ? _value.streakDays
                    : streakDays // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StudentProgressDtoImplCopyWith<$Res>
    implements $StudentProgressDtoCopyWith<$Res> {
  factory _$$StudentProgressDtoImplCopyWith(
    _$StudentProgressDtoImpl value,
    $Res Function(_$StudentProgressDtoImpl) then,
  ) = __$$StudentProgressDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int gamesPlayed,
    int averageAccuracy,
    int? accuracyTrendDelta,
    int weeklyMinutes,
    int weeklyGoalMinutes,
    int streakDays,
  });
}

/// @nodoc
class __$$StudentProgressDtoImplCopyWithImpl<$Res>
    extends _$StudentProgressDtoCopyWithImpl<$Res, _$StudentProgressDtoImpl>
    implements _$$StudentProgressDtoImplCopyWith<$Res> {
  __$$StudentProgressDtoImplCopyWithImpl(
    _$StudentProgressDtoImpl _value,
    $Res Function(_$StudentProgressDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StudentProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gamesPlayed = null,
    Object? averageAccuracy = null,
    Object? accuracyTrendDelta = freezed,
    Object? weeklyMinutes = null,
    Object? weeklyGoalMinutes = null,
    Object? streakDays = null,
  }) {
    return _then(
      _$StudentProgressDtoImpl(
        gamesPlayed:
            null == gamesPlayed
                ? _value.gamesPlayed
                : gamesPlayed // ignore: cast_nullable_to_non_nullable
                    as int,
        averageAccuracy:
            null == averageAccuracy
                ? _value.averageAccuracy
                : averageAccuracy // ignore: cast_nullable_to_non_nullable
                    as int,
        accuracyTrendDelta:
            freezed == accuracyTrendDelta
                ? _value.accuracyTrendDelta
                : accuracyTrendDelta // ignore: cast_nullable_to_non_nullable
                    as int?,
        weeklyMinutes:
            null == weeklyMinutes
                ? _value.weeklyMinutes
                : weeklyMinutes // ignore: cast_nullable_to_non_nullable
                    as int,
        weeklyGoalMinutes:
            null == weeklyGoalMinutes
                ? _value.weeklyGoalMinutes
                : weeklyGoalMinutes // ignore: cast_nullable_to_non_nullable
                    as int,
        streakDays:
            null == streakDays
                ? _value.streakDays
                : streakDays // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StudentProgressDtoImpl extends _StudentProgressDto {
  const _$StudentProgressDtoImpl({
    required this.gamesPlayed,
    required this.averageAccuracy,
    this.accuracyTrendDelta,
    required this.weeklyMinutes,
    required this.weeklyGoalMinutes,
    required this.streakDays,
  }) : super._();

  factory _$StudentProgressDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudentProgressDtoImplFromJson(json);

  @override
  final int gamesPlayed;
  @override
  final int averageAccuracy;
  @override
  final int? accuracyTrendDelta;
  @override
  final int weeklyMinutes;
  @override
  final int weeklyGoalMinutes;
  @override
  final int streakDays;

  @override
  String toString() {
    return 'StudentProgressDto(gamesPlayed: $gamesPlayed, averageAccuracy: $averageAccuracy, accuracyTrendDelta: $accuracyTrendDelta, weeklyMinutes: $weeklyMinutes, weeklyGoalMinutes: $weeklyGoalMinutes, streakDays: $streakDays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudentProgressDtoImpl &&
            (identical(other.gamesPlayed, gamesPlayed) ||
                other.gamesPlayed == gamesPlayed) &&
            (identical(other.averageAccuracy, averageAccuracy) ||
                other.averageAccuracy == averageAccuracy) &&
            (identical(other.accuracyTrendDelta, accuracyTrendDelta) ||
                other.accuracyTrendDelta == accuracyTrendDelta) &&
            (identical(other.weeklyMinutes, weeklyMinutes) ||
                other.weeklyMinutes == weeklyMinutes) &&
            (identical(other.weeklyGoalMinutes, weeklyGoalMinutes) ||
                other.weeklyGoalMinutes == weeklyGoalMinutes) &&
            (identical(other.streakDays, streakDays) ||
                other.streakDays == streakDays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    gamesPlayed,
    averageAccuracy,
    accuracyTrendDelta,
    weeklyMinutes,
    weeklyGoalMinutes,
    streakDays,
  );

  /// Create a copy of StudentProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudentProgressDtoImplCopyWith<_$StudentProgressDtoImpl> get copyWith =>
      __$$StudentProgressDtoImplCopyWithImpl<_$StudentProgressDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StudentProgressDtoImplToJson(this);
  }
}

abstract class _StudentProgressDto extends StudentProgressDto {
  const factory _StudentProgressDto({
    required final int gamesPlayed,
    required final int averageAccuracy,
    final int? accuracyTrendDelta,
    required final int weeklyMinutes,
    required final int weeklyGoalMinutes,
    required final int streakDays,
  }) = _$StudentProgressDtoImpl;
  const _StudentProgressDto._() : super._();

  factory _StudentProgressDto.fromJson(Map<String, dynamic> json) =
      _$StudentProgressDtoImpl.fromJson;

  @override
  int get gamesPlayed;
  @override
  int get averageAccuracy;
  @override
  int? get accuracyTrendDelta;
  @override
  int get weeklyMinutes;
  @override
  int get weeklyGoalMinutes;
  @override
  int get streakDays;

  /// Create a copy of StudentProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudentProgressDtoImplCopyWith<_$StudentProgressDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
