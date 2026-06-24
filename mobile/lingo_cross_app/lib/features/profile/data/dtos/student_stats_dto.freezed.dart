// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_stats_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StudentStatsDto _$StudentStatsDtoFromJson(Map<String, dynamic> json) {
  return _StudentStatsDto.fromJson(json);
}

/// @nodoc
mixin _$StudentStatsDto {
  int get gamesPlayed => throw _privateConstructorUsedError;
  int get averageAccuracy => throw _privateConstructorUsedError;

  /// Serializes this StudentStatsDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StudentStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudentStatsDtoCopyWith<StudentStatsDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudentStatsDtoCopyWith<$Res> {
  factory $StudentStatsDtoCopyWith(
    StudentStatsDto value,
    $Res Function(StudentStatsDto) then,
  ) = _$StudentStatsDtoCopyWithImpl<$Res, StudentStatsDto>;
  @useResult
  $Res call({int gamesPlayed, int averageAccuracy});
}

/// @nodoc
class _$StudentStatsDtoCopyWithImpl<$Res, $Val extends StudentStatsDto>
    implements $StudentStatsDtoCopyWith<$Res> {
  _$StudentStatsDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StudentStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? gamesPlayed = null, Object? averageAccuracy = null}) {
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StudentStatsDtoImplCopyWith<$Res>
    implements $StudentStatsDtoCopyWith<$Res> {
  factory _$$StudentStatsDtoImplCopyWith(
    _$StudentStatsDtoImpl value,
    $Res Function(_$StudentStatsDtoImpl) then,
  ) = __$$StudentStatsDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int gamesPlayed, int averageAccuracy});
}

/// @nodoc
class __$$StudentStatsDtoImplCopyWithImpl<$Res>
    extends _$StudentStatsDtoCopyWithImpl<$Res, _$StudentStatsDtoImpl>
    implements _$$StudentStatsDtoImplCopyWith<$Res> {
  __$$StudentStatsDtoImplCopyWithImpl(
    _$StudentStatsDtoImpl _value,
    $Res Function(_$StudentStatsDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StudentStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? gamesPlayed = null, Object? averageAccuracy = null}) {
    return _then(
      _$StudentStatsDtoImpl(
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StudentStatsDtoImpl extends _StudentStatsDto {
  const _$StudentStatsDtoImpl({
    required this.gamesPlayed,
    required this.averageAccuracy,
  }) : super._();

  factory _$StudentStatsDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudentStatsDtoImplFromJson(json);

  @override
  final int gamesPlayed;
  @override
  final int averageAccuracy;

  @override
  String toString() {
    return 'StudentStatsDto(gamesPlayed: $gamesPlayed, averageAccuracy: $averageAccuracy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudentStatsDtoImpl &&
            (identical(other.gamesPlayed, gamesPlayed) ||
                other.gamesPlayed == gamesPlayed) &&
            (identical(other.averageAccuracy, averageAccuracy) ||
                other.averageAccuracy == averageAccuracy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, gamesPlayed, averageAccuracy);

  /// Create a copy of StudentStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudentStatsDtoImplCopyWith<_$StudentStatsDtoImpl> get copyWith =>
      __$$StudentStatsDtoImplCopyWithImpl<_$StudentStatsDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StudentStatsDtoImplToJson(this);
  }
}

abstract class _StudentStatsDto extends StudentStatsDto {
  const factory _StudentStatsDto({
    required final int gamesPlayed,
    required final int averageAccuracy,
  }) = _$StudentStatsDtoImpl;
  const _StudentStatsDto._() : super._();

  factory _StudentStatsDto.fromJson(Map<String, dynamic> json) =
      _$StudentStatsDtoImpl.fromJson;

  @override
  int get gamesPlayed;
  @override
  int get averageAccuracy;

  /// Create a copy of StudentStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudentStatsDtoImplCopyWith<_$StudentStatsDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
