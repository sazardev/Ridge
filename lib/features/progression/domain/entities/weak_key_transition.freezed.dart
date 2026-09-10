// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weak_key_transition.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WeakKeyTransition {

 PhysicalKeyId get fromKey; PhysicalKeyId get toKey; double get score; Trend get trend;
/// Create a copy of WeakKeyTransition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeakKeyTransitionCopyWith<WeakKeyTransition> get copyWith => _$WeakKeyTransitionCopyWithImpl<WeakKeyTransition>(this as WeakKeyTransition, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WeakKeyTransition;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeakKeyTransition&&(identical(other.fromKey, _this.fromKey) || other.fromKey == _this.fromKey)&&(identical(other.toKey, _this.toKey) || other.toKey == _this.toKey)&&(identical(other.score, _this.score) || other.score == _this.score)&&(identical(other.trend, _this.trend) || other.trend == _this.trend));
}


@override
int get hashCode {
  final _this = this as WeakKeyTransition;
  return Object.hash(runtimeType,_this.fromKey,_this.toKey,_this.score,_this.trend);
}

@override
String toString() {
  final _this = this as WeakKeyTransition;
  return 'WeakKeyTransition(fromKey: ${_this.fromKey}, toKey: ${_this.toKey}, score: ${_this.score}, trend: ${_this.trend})';
}


}

/// @nodoc
abstract mixin class $WeakKeyTransitionCopyWith<$Res>  {
  factory $WeakKeyTransitionCopyWith(WeakKeyTransition value, $Res Function(WeakKeyTransition) _then) = _$WeakKeyTransitionCopyWithImpl;
@useResult
$Res call({
 PhysicalKeyId fromKey, PhysicalKeyId toKey, double score, Trend trend
});




}
/// @nodoc
class _$WeakKeyTransitionCopyWithImpl<$Res>
    implements $WeakKeyTransitionCopyWith<$Res> {
  _$WeakKeyTransitionCopyWithImpl(this._self, this._then);

  final WeakKeyTransition _self;
  final $Res Function(WeakKeyTransition) _then;

/// Create a copy of WeakKeyTransition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fromKey = null,Object? toKey = null,Object? score = null,Object? trend = null,}) {
  return _then(WeakKeyTransition(
fromKey: null == fromKey ? _self.fromKey : fromKey // ignore: cast_nullable_to_non_nullable
as PhysicalKeyId,toKey: null == toKey ? _self.toKey : toKey // ignore: cast_nullable_to_non_nullable
as PhysicalKeyId,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,trend: null == trend ? _self.trend : trend // ignore: cast_nullable_to_non_nullable
as Trend,
  ));
}

}


/// Adds pattern-matching-related methods to [WeakKeyTransition].
extension WeakKeyTransitionPatterns on WeakKeyTransition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeakKeyTransition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeakKeyTransition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeakKeyTransition value)  $default,){
final _that = this;
switch (_that) {
case _WeakKeyTransition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeakKeyTransition value)?  $default,){
final _that = this;
switch (_that) {
case _WeakKeyTransition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PhysicalKeyId fromKey,  PhysicalKeyId toKey,  double score,  Trend trend)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeakKeyTransition() when $default != null:
return $default(_that.fromKey,_that.toKey,_that.score,_that.trend);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PhysicalKeyId fromKey,  PhysicalKeyId toKey,  double score,  Trend trend)  $default,) {final _that = this;
switch (_that) {
case _WeakKeyTransition():
return $default(_that.fromKey,_that.toKey,_that.score,_that.trend);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PhysicalKeyId fromKey,  PhysicalKeyId toKey,  double score,  Trend trend)?  $default,) {final _that = this;
switch (_that) {
case _WeakKeyTransition() when $default != null:
return $default(_that.fromKey,_that.toKey,_that.score,_that.trend);case _:
  return null;

}
}

}

/// @nodoc


class _WeakKeyTransition implements WeakKeyTransition {
  const _WeakKeyTransition({required this.fromKey, required this.toKey, required this.score, required this.trend});
  

@override final  PhysicalKeyId fromKey;
@override final  PhysicalKeyId toKey;
@override final  double score;
@override final  Trend trend;

/// Create a copy of WeakKeyTransition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeakKeyTransitionCopyWith<_WeakKeyTransition> get copyWith => __$WeakKeyTransitionCopyWithImpl<_WeakKeyTransition>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeakKeyTransition&&(identical(other.fromKey, fromKey) || other.fromKey == fromKey)&&(identical(other.toKey, toKey) || other.toKey == toKey)&&(identical(other.score, score) || other.score == score)&&(identical(other.trend, trend) || other.trend == trend));
}


@override
int get hashCode {
    return Object.hash(runtimeType,fromKey,toKey,score,trend);
}

@override
String toString() {
    return 'WeakKeyTransition(fromKey: $fromKey, toKey: $toKey, score: $score, trend: $trend)';
}


}

/// @nodoc
abstract mixin class _$WeakKeyTransitionCopyWith<$Res> implements $WeakKeyTransitionCopyWith<$Res> {
  factory _$WeakKeyTransitionCopyWith(_WeakKeyTransition value, $Res Function(_WeakKeyTransition) _then) = __$WeakKeyTransitionCopyWithImpl;
@override @useResult
$Res call({
 PhysicalKeyId fromKey, PhysicalKeyId toKey, double score, Trend trend
});




}
/// @nodoc
class __$WeakKeyTransitionCopyWithImpl<$Res>
    implements _$WeakKeyTransitionCopyWith<$Res> {
  __$WeakKeyTransitionCopyWithImpl(this._self, this._then);

  final _WeakKeyTransition _self;
  final $Res Function(_WeakKeyTransition) _then;

/// Create a copy of WeakKeyTransition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fromKey = null,Object? toKey = null,Object? score = null,Object? trend = null,}) {
  return _then(_WeakKeyTransition(
fromKey: null == fromKey ? _self.fromKey : fromKey // ignore: cast_nullable_to_non_nullable
as PhysicalKeyId,toKey: null == toKey ? _self.toKey : toKey // ignore: cast_nullable_to_non_nullable
as PhysicalKeyId,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,trend: null == trend ? _self.trend : trend // ignore: cast_nullable_to_non_nullable
as Trend,
  ));
}


}

// dart format on
