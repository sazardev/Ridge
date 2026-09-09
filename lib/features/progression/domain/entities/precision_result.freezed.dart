// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'precision_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PrecisionResult {

 double get accuracyPct; double get netSpeedCpm;
/// Create a copy of PrecisionResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrecisionResultCopyWith<PrecisionResult> get copyWith => _$PrecisionResultCopyWithImpl<PrecisionResult>(this as PrecisionResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PrecisionResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrecisionResult&&(identical(other.accuracyPct, _this.accuracyPct) || other.accuracyPct == _this.accuracyPct)&&(identical(other.netSpeedCpm, _this.netSpeedCpm) || other.netSpeedCpm == _this.netSpeedCpm));
}


@override
int get hashCode {
  final _this = this as PrecisionResult;
  return Object.hash(runtimeType,_this.accuracyPct,_this.netSpeedCpm);
}

@override
String toString() {
  final _this = this as PrecisionResult;
  return 'PrecisionResult(accuracyPct: ${_this.accuracyPct}, netSpeedCpm: ${_this.netSpeedCpm})';
}


}

/// @nodoc
abstract mixin class $PrecisionResultCopyWith<$Res>  {
  factory $PrecisionResultCopyWith(PrecisionResult value, $Res Function(PrecisionResult) _then) = _$PrecisionResultCopyWithImpl;
@useResult
$Res call({
 double accuracyPct, double netSpeedCpm
});




}
/// @nodoc
class _$PrecisionResultCopyWithImpl<$Res>
    implements $PrecisionResultCopyWith<$Res> {
  _$PrecisionResultCopyWithImpl(this._self, this._then);

  final PrecisionResult _self;
  final $Res Function(PrecisionResult) _then;

/// Create a copy of PrecisionResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accuracyPct = null,Object? netSpeedCpm = null,}) {
  return _then(PrecisionResult(
accuracyPct: null == accuracyPct ? _self.accuracyPct : accuracyPct // ignore: cast_nullable_to_non_nullable
as double,netSpeedCpm: null == netSpeedCpm ? _self.netSpeedCpm : netSpeedCpm // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [PrecisionResult].
extension PrecisionResultPatterns on PrecisionResult {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrecisionResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrecisionResult() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrecisionResult value)  $default,){
final _that = this;
switch (_that) {
case _PrecisionResult():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrecisionResult value)?  $default,){
final _that = this;
switch (_that) {
case _PrecisionResult() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double accuracyPct,  double netSpeedCpm)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrecisionResult() when $default != null:
return $default(_that.accuracyPct,_that.netSpeedCpm);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double accuracyPct,  double netSpeedCpm)  $default,) {final _that = this;
switch (_that) {
case _PrecisionResult():
return $default(_that.accuracyPct,_that.netSpeedCpm);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double accuracyPct,  double netSpeedCpm)?  $default,) {final _that = this;
switch (_that) {
case _PrecisionResult() when $default != null:
return $default(_that.accuracyPct,_that.netSpeedCpm);case _:
  return null;

}
}

}

/// @nodoc


class _PrecisionResult implements PrecisionResult {
  const _PrecisionResult({required this.accuracyPct, required this.netSpeedCpm});
  

@override final  double accuracyPct;
@override final  double netSpeedCpm;

/// Create a copy of PrecisionResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrecisionResultCopyWith<_PrecisionResult> get copyWith => __$PrecisionResultCopyWithImpl<_PrecisionResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrecisionResult&&(identical(other.accuracyPct, accuracyPct) || other.accuracyPct == accuracyPct)&&(identical(other.netSpeedCpm, netSpeedCpm) || other.netSpeedCpm == netSpeedCpm));
}


@override
int get hashCode {
    return Object.hash(runtimeType,accuracyPct,netSpeedCpm);
}

@override
String toString() {
    return 'PrecisionResult(accuracyPct: $accuracyPct, netSpeedCpm: $netSpeedCpm)';
}


}

/// @nodoc
abstract mixin class _$PrecisionResultCopyWith<$Res> implements $PrecisionResultCopyWith<$Res> {
  factory _$PrecisionResultCopyWith(_PrecisionResult value, $Res Function(_PrecisionResult) _then) = __$PrecisionResultCopyWithImpl;
@override @useResult
$Res call({
 double accuracyPct, double netSpeedCpm
});




}
/// @nodoc
class __$PrecisionResultCopyWithImpl<$Res>
    implements _$PrecisionResultCopyWith<$Res> {
  __$PrecisionResultCopyWithImpl(this._self, this._then);

  final _PrecisionResult _self;
  final $Res Function(_PrecisionResult) _then;

/// Create a copy of PrecisionResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accuracyPct = null,Object? netSpeedCpm = null,}) {
  return _then(_PrecisionResult(
accuracyPct: null == accuracyPct ? _self.accuracyPct : accuracyPct // ignore: cast_nullable_to_non_nullable
as double,netSpeedCpm: null == netSpeedCpm ? _self.netSpeedCpm : netSpeedCpm // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
