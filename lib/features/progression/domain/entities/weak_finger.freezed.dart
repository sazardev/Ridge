// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weak_finger.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WeakFinger {

 Finger get finger; double get score; Trend get trend;
/// Create a copy of WeakFinger
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeakFingerCopyWith<WeakFinger> get copyWith => _$WeakFingerCopyWithImpl<WeakFinger>(this as WeakFinger, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WeakFinger;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeakFinger&&(identical(other.finger, _this.finger) || other.finger == _this.finger)&&(identical(other.score, _this.score) || other.score == _this.score)&&(identical(other.trend, _this.trend) || other.trend == _this.trend));
}


@override
int get hashCode {
  final _this = this as WeakFinger;
  return Object.hash(runtimeType,_this.finger,_this.score,_this.trend);
}

@override
String toString() {
  final _this = this as WeakFinger;
  return 'WeakFinger(finger: ${_this.finger}, score: ${_this.score}, trend: ${_this.trend})';
}


}

/// @nodoc
abstract mixin class $WeakFingerCopyWith<$Res>  {
  factory $WeakFingerCopyWith(WeakFinger value, $Res Function(WeakFinger) _then) = _$WeakFingerCopyWithImpl;
@useResult
$Res call({
 Finger finger, double score, Trend trend
});




}
/// @nodoc
class _$WeakFingerCopyWithImpl<$Res>
    implements $WeakFingerCopyWith<$Res> {
  _$WeakFingerCopyWithImpl(this._self, this._then);

  final WeakFinger _self;
  final $Res Function(WeakFinger) _then;

/// Create a copy of WeakFinger
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? finger = null,Object? score = null,Object? trend = null,}) {
  return _then(WeakFinger(
finger: null == finger ? _self.finger : finger // ignore: cast_nullable_to_non_nullable
as Finger,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,trend: null == trend ? _self.trend : trend // ignore: cast_nullable_to_non_nullable
as Trend,
  ));
}

}


/// Adds pattern-matching-related methods to [WeakFinger].
extension WeakFingerPatterns on WeakFinger {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeakFinger value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeakFinger() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeakFinger value)  $default,){
final _that = this;
switch (_that) {
case _WeakFinger():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeakFinger value)?  $default,){
final _that = this;
switch (_that) {
case _WeakFinger() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Finger finger,  double score,  Trend trend)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeakFinger() when $default != null:
return $default(_that.finger,_that.score,_that.trend);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Finger finger,  double score,  Trend trend)  $default,) {final _that = this;
switch (_that) {
case _WeakFinger():
return $default(_that.finger,_that.score,_that.trend);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Finger finger,  double score,  Trend trend)?  $default,) {final _that = this;
switch (_that) {
case _WeakFinger() when $default != null:
return $default(_that.finger,_that.score,_that.trend);case _:
  return null;

}
}

}

/// @nodoc


class _WeakFinger implements WeakFinger {
  const _WeakFinger({required this.finger, required this.score, required this.trend});
  

@override final  Finger finger;
@override final  double score;
@override final  Trend trend;

/// Create a copy of WeakFinger
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeakFingerCopyWith<_WeakFinger> get copyWith => __$WeakFingerCopyWithImpl<_WeakFinger>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeakFinger&&(identical(other.finger, finger) || other.finger == finger)&&(identical(other.score, score) || other.score == score)&&(identical(other.trend, trend) || other.trend == trend));
}


@override
int get hashCode {
    return Object.hash(runtimeType,finger,score,trend);
}

@override
String toString() {
    return 'WeakFinger(finger: $finger, score: $score, trend: $trend)';
}


}

/// @nodoc
abstract mixin class _$WeakFingerCopyWith<$Res> implements $WeakFingerCopyWith<$Res> {
  factory _$WeakFingerCopyWith(_WeakFinger value, $Res Function(_WeakFinger) _then) = __$WeakFingerCopyWithImpl;
@override @useResult
$Res call({
 Finger finger, double score, Trend trend
});




}
/// @nodoc
class __$WeakFingerCopyWithImpl<$Res>
    implements _$WeakFingerCopyWith<$Res> {
  __$WeakFingerCopyWithImpl(this._self, this._then);

  final _WeakFinger _self;
  final $Res Function(_WeakFinger) _then;

/// Create a copy of WeakFinger
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? finger = null,Object? score = null,Object? trend = null,}) {
  return _then(_WeakFinger(
finger: null == finger ? _self.finger : finger // ignore: cast_nullable_to_non_nullable
as Finger,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,trend: null == trend ? _self.trend : trend // ignore: cast_nullable_to_non_nullable
as Trend,
  ));
}


}

// dart format on
