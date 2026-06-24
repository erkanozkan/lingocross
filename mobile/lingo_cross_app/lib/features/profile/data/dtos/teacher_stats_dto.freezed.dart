// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher_stats_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TeacherStatsDto _$TeacherStatsDtoFromJson(Map<String, dynamic> json) {
  return _TeacherStatsDto.fromJson(json);
}

/// @nodoc
mixin _$TeacherStatsDto {
  int get classCount => throw _privateConstructorUsedError;
  int get studentCount => throw _privateConstructorUsedError;
  int get weeklyAssignedCount => throw _privateConstructorUsedError;
  int get weeklyCompletedCount => throw _privateConstructorUsedError;
  int get completionRate => throw _privateConstructorUsedError;

  /// Serializes this TeacherStatsDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeacherStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeacherStatsDtoCopyWith<TeacherStatsDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeacherStatsDtoCopyWith<$Res> {
  factory $TeacherStatsDtoCopyWith(
    TeacherStatsDto value,
    $Res Function(TeacherStatsDto) then,
  ) = _$TeacherStatsDtoCopyWithImpl<$Res, TeacherStatsDto>;
  @useResult
  $Res call({
    int classCount,
    int studentCount,
    int weeklyAssignedCount,
    int weeklyCompletedCount,
    int completionRate,
  });
}

/// @nodoc
class _$TeacherStatsDtoCopyWithImpl<$Res, $Val extends TeacherStatsDto>
    implements $TeacherStatsDtoCopyWith<$Res> {
  _$TeacherStatsDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeacherStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? classCount = null,
    Object? studentCount = null,
    Object? weeklyAssignedCount = null,
    Object? weeklyCompletedCount = null,
    Object? completionRate = null,
  }) {
    return _then(
      _value.copyWith(
            classCount:
                null == classCount
                    ? _value.classCount
                    : classCount // ignore: cast_nullable_to_non_nullable
                        as int,
            studentCount:
                null == studentCount
                    ? _value.studentCount
                    : studentCount // ignore: cast_nullable_to_non_nullable
                        as int,
            weeklyAssignedCount:
                null == weeklyAssignedCount
                    ? _value.weeklyAssignedCount
                    : weeklyAssignedCount // ignore: cast_nullable_to_non_nullable
                        as int,
            weeklyCompletedCount:
                null == weeklyCompletedCount
                    ? _value.weeklyCompletedCount
                    : weeklyCompletedCount // ignore: cast_nullable_to_non_nullable
                        as int,
            completionRate:
                null == completionRate
                    ? _value.completionRate
                    : completionRate // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TeacherStatsDtoImplCopyWith<$Res>
    implements $TeacherStatsDtoCopyWith<$Res> {
  factory _$$TeacherStatsDtoImplCopyWith(
    _$TeacherStatsDtoImpl value,
    $Res Function(_$TeacherStatsDtoImpl) then,
  ) = __$$TeacherStatsDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int classCount,
    int studentCount,
    int weeklyAssignedCount,
    int weeklyCompletedCount,
    int completionRate,
  });
}

/// @nodoc
class __$$TeacherStatsDtoImplCopyWithImpl<$Res>
    extends _$TeacherStatsDtoCopyWithImpl<$Res, _$TeacherStatsDtoImpl>
    implements _$$TeacherStatsDtoImplCopyWith<$Res> {
  __$$TeacherStatsDtoImplCopyWithImpl(
    _$TeacherStatsDtoImpl _value,
    $Res Function(_$TeacherStatsDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TeacherStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? classCount = null,
    Object? studentCount = null,
    Object? weeklyAssignedCount = null,
    Object? weeklyCompletedCount = null,
    Object? completionRate = null,
  }) {
    return _then(
      _$TeacherStatsDtoImpl(
        classCount:
            null == classCount
                ? _value.classCount
                : classCount // ignore: cast_nullable_to_non_nullable
                    as int,
        studentCount:
            null == studentCount
                ? _value.studentCount
                : studentCount // ignore: cast_nullable_to_non_nullable
                    as int,
        weeklyAssignedCount:
            null == weeklyAssignedCount
                ? _value.weeklyAssignedCount
                : weeklyAssignedCount // ignore: cast_nullable_to_non_nullable
                    as int,
        weeklyCompletedCount:
            null == weeklyCompletedCount
                ? _value.weeklyCompletedCount
                : weeklyCompletedCount // ignore: cast_nullable_to_non_nullable
                    as int,
        completionRate:
            null == completionRate
                ? _value.completionRate
                : completionRate // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TeacherStatsDtoImpl extends _TeacherStatsDto {
  const _$TeacherStatsDtoImpl({
    required this.classCount,
    required this.studentCount,
    required this.weeklyAssignedCount,
    required this.weeklyCompletedCount,
    required this.completionRate,
  }) : super._();

  factory _$TeacherStatsDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeacherStatsDtoImplFromJson(json);

  @override
  final int classCount;
  @override
  final int studentCount;
  @override
  final int weeklyAssignedCount;
  @override
  final int weeklyCompletedCount;
  @override
  final int completionRate;

  @override
  String toString() {
    return 'TeacherStatsDto(classCount: $classCount, studentCount: $studentCount, weeklyAssignedCount: $weeklyAssignedCount, weeklyCompletedCount: $weeklyCompletedCount, completionRate: $completionRate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeacherStatsDtoImpl &&
            (identical(other.classCount, classCount) ||
                other.classCount == classCount) &&
            (identical(other.studentCount, studentCount) ||
                other.studentCount == studentCount) &&
            (identical(other.weeklyAssignedCount, weeklyAssignedCount) ||
                other.weeklyAssignedCount == weeklyAssignedCount) &&
            (identical(other.weeklyCompletedCount, weeklyCompletedCount) ||
                other.weeklyCompletedCount == weeklyCompletedCount) &&
            (identical(other.completionRate, completionRate) ||
                other.completionRate == completionRate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    classCount,
    studentCount,
    weeklyAssignedCount,
    weeklyCompletedCount,
    completionRate,
  );

  /// Create a copy of TeacherStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeacherStatsDtoImplCopyWith<_$TeacherStatsDtoImpl> get copyWith =>
      __$$TeacherStatsDtoImplCopyWithImpl<_$TeacherStatsDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TeacherStatsDtoImplToJson(this);
  }
}

abstract class _TeacherStatsDto extends TeacherStatsDto {
  const factory _TeacherStatsDto({
    required final int classCount,
    required final int studentCount,
    required final int weeklyAssignedCount,
    required final int weeklyCompletedCount,
    required final int completionRate,
  }) = _$TeacherStatsDtoImpl;
  const _TeacherStatsDto._() : super._();

  factory _TeacherStatsDto.fromJson(Map<String, dynamic> json) =
      _$TeacherStatsDtoImpl.fromJson;

  @override
  int get classCount;
  @override
  int get studentCount;
  @override
  int get weeklyAssignedCount;
  @override
  int get weeklyCompletedCount;
  @override
  int get completionRate;

  /// Create a copy of TeacherStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeacherStatsDtoImplCopyWith<_$TeacherStatsDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
