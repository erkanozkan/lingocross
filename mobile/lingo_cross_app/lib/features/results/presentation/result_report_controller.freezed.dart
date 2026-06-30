// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'result_report_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ResultReportState {
  AsyncValue<GameResultDto> get result => throw _privateConstructorUsedError;
  List<ResultItemModel> get items => throw _privateConstructorUsedError;

  /// Create a copy of ResultReportState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResultReportStateCopyWith<ResultReportState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResultReportStateCopyWith<$Res> {
  factory $ResultReportStateCopyWith(
    ResultReportState value,
    $Res Function(ResultReportState) then,
  ) = _$ResultReportStateCopyWithImpl<$Res, ResultReportState>;
  @useResult
  $Res call({AsyncValue<GameResultDto> result, List<ResultItemModel> items});
}

/// @nodoc
class _$ResultReportStateCopyWithImpl<$Res, $Val extends ResultReportState>
    implements $ResultReportStateCopyWith<$Res> {
  _$ResultReportStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResultReportState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? result = null, Object? items = null}) {
    return _then(
      _value.copyWith(
            result:
                null == result
                    ? _value.result
                    : result // ignore: cast_nullable_to_non_nullable
                        as AsyncValue<GameResultDto>,
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
abstract class _$$ResultReportStateImplCopyWith<$Res>
    implements $ResultReportStateCopyWith<$Res> {
  factory _$$ResultReportStateImplCopyWith(
    _$ResultReportStateImpl value,
    $Res Function(_$ResultReportStateImpl) then,
  ) = __$$ResultReportStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({AsyncValue<GameResultDto> result, List<ResultItemModel> items});
}

/// @nodoc
class __$$ResultReportStateImplCopyWithImpl<$Res>
    extends _$ResultReportStateCopyWithImpl<$Res, _$ResultReportStateImpl>
    implements _$$ResultReportStateImplCopyWith<$Res> {
  __$$ResultReportStateImplCopyWithImpl(
    _$ResultReportStateImpl _value,
    $Res Function(_$ResultReportStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ResultReportState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? result = null, Object? items = null}) {
    return _then(
      _$ResultReportStateImpl(
        result:
            null == result
                ? _value.result
                : result // ignore: cast_nullable_to_non_nullable
                    as AsyncValue<GameResultDto>,
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

class _$ResultReportStateImpl implements _ResultReportState {
  const _$ResultReportStateImpl({
    required this.result,
    final List<ResultItemModel> items = const <ResultItemModel>[],
  }) : _items = items;

  @override
  final AsyncValue<GameResultDto> result;
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
    return 'ResultReportState(result: $result, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResultReportStateImpl &&
            (identical(other.result, result) || other.result == result) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    result,
    const DeepCollectionEquality().hash(_items),
  );

  /// Create a copy of ResultReportState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResultReportStateImplCopyWith<_$ResultReportStateImpl> get copyWith =>
      __$$ResultReportStateImplCopyWithImpl<_$ResultReportStateImpl>(
        this,
        _$identity,
      );
}

abstract class _ResultReportState implements ResultReportState {
  const factory _ResultReportState({
    required final AsyncValue<GameResultDto> result,
    final List<ResultItemModel> items,
  }) = _$ResultReportStateImpl;

  @override
  AsyncValue<GameResultDto> get result;
  @override
  List<ResultItemModel> get items;

  /// Create a copy of ResultReportState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResultReportStateImplCopyWith<_$ResultReportStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
