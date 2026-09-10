// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'key_transition_sample.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$KeyTransitionSample {

 PhysicalKeyId get fromKey; PhysicalKeyId get toKey; bool get isError; double get flightMs; DateTime get occurredAtUtc;
/// Create a copy of KeyTransitionSample
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KeyTransitionSampleCopyWith<KeyTransitionSample> get copyWith => _$KeyTransitionSampleCopyWithImpl<KeyTransitionSample>(this as KeyTransitionSample, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as KeyTransitionSample;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KeyTransitionSample&&(identical(other.fromKey, _this.fromKey) || other.fromKey == _this.fromKey)&&(identical(other.toKey, _this.toKey) || other.toKey == _this.toKey)&&(identical(other.isError, _this.isError) || other.isError == _this.isError)&&(identical(other.flightMs, _this.flightMs) || other.flightMs == _this.flightMs)&&(identical(other.occurredAtUtc, _this.occurredAtUtc) || other.occurredAtUtc == _this.occurredAtUtc));
}


@override
int get hashCode {
  final _this = this as KeyTransitionSample;
  return Object.hash(runtimeType,_this.fromKey,_this.toKey,_this.isError,_this.flightMs,_this.occurredAtUtc);
}

@override
String toString() {
  final _this = this as KeyTransitionSample;
  return 'KeyTransitionSample(fromKey: ${_this.fromKey}, toKey: ${_this.toKey}, isError: ${_this.isError}, flightMs: ${_this.flightMs}, occurredAtUtc: ${_this.occurredAtUtc})';
}


}

/// @nodoc
abstract mixin class $KeyTransitionSampleCopyWith<$Res>  {
  factory $KeyTransitionSampleCopyWith(KeyTransitionSample value, $Res Function(KeyTransitionSample) _then) = _$KeyTransitionSampleCopyWithImpl;
@useResult
$Res call({
 PhysicalKeyId fromKey, PhysicalKeyId toKey, bool isError, double flightMs, DateTime occurredAtUtc
});




}
/// @nodoc
class _$KeyTransitionSampleCopyWithImpl<$Res>
    implements $KeyTransitionSampleCopyWith<$Res> {
  _$KeyTransitionSampleCopyWithImpl(this._self, this._then);

  final KeyTransitionSample _self;
  final $Res Function(KeyTransitionSample) _then;

/// Create a copy of KeyTransitionSample
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fromKey = null,Object? toKey = null,Object? isError = null,Object? flightMs = null,Object? occurredAtUtc = null,}) {
  return _then(KeyTransitionSample(
fromKey: null == fromKey ? _self.fromKey : fromKey // ignore: cast_nullable_to_non_nullable
as PhysicalKeyId,toKey: null == toKey ? _self.toKey : toKey // ignore: cast_nullable_to_non_nullable
as PhysicalKeyId,isError: null == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as bool,flightMs: null == flightMs ? _self.flightMs : flightMs // ignore: cast_nullable_to_non_nullable
as double,occurredAtUtc: null == occurredAtUtc ? _self.occurredAtUtc : occurredAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [KeyTransitionSample].
extension KeyTransitionSamplePatterns on KeyTransitionSample {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KeyTransitionSample value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KeyTransitionSample() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KeyTransitionSample value)  $default,){
final _that = this;
switch (_that) {
case _KeyTransitionSample():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KeyTransitionSample value)?  $default,){
final _that = this;
switch (_that) {
case _KeyTransitionSample() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PhysicalKeyId fromKey,  PhysicalKeyId toKey,  bool isError,  double flightMs,  DateTime occurredAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KeyTransitionSample() when $default != null:
return $default(_that.fromKey,_that.toKey,_that.isError,_that.flightMs,_that.occurredAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PhysicalKeyId fromKey,  PhysicalKeyId toKey,  bool isError,  double flightMs,  DateTime occurredAtUtc)  $default,) {final _that = this;
switch (_that) {
case _KeyTransitionSample():
return $default(_that.fromKey,_that.toKey,_that.isError,_that.flightMs,_that.occurredAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PhysicalKeyId fromKey,  PhysicalKeyId toKey,  bool isError,  double flightMs,  DateTime occurredAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _KeyTransitionSample() when $default != null:
return $default(_that.fromKey,_that.toKey,_that.isError,_that.flightMs,_that.occurredAtUtc);case _:
  return null;

}
}

}

/// @nodoc


class _KeyTransitionSample implements KeyTransitionSample {
  const _KeyTransitionSample({required this.fromKey, required this.toKey, required this.isError, required this.flightMs, required this.occurredAtUtc});
  

@override final  PhysicalKeyId fromKey;
@override final  PhysicalKeyId toKey;
@override final  bool isError;
@override final  double flightMs;
@override final  DateTime occurredAtUtc;

/// Create a copy of KeyTransitionSample
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KeyTransitionSampleCopyWith<_KeyTransitionSample> get copyWith => __$KeyTransitionSampleCopyWithImpl<_KeyTransitionSample>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _KeyTransitionSample&&(identical(other.fromKey, fromKey) || other.fromKey == fromKey)&&(identical(other.toKey, toKey) || other.toKey == toKey)&&(identical(other.isError, isError) || other.isError == isError)&&(identical(other.flightMs, flightMs) || other.flightMs == flightMs)&&(identical(other.occurredAtUtc, occurredAtUtc) || other.occurredAtUtc == occurredAtUtc));
}


@override
int get hashCode {
    return Object.hash(runtimeType,fromKey,toKey,isError,flightMs,occurredAtUtc);
}

@override
String toString() {
    return 'KeyTransitionSample(fromKey: $fromKey, toKey: $toKey, isError: $isError, flightMs: $flightMs, occurredAtUtc: $occurredAtUtc)';
}


}

/// @nodoc
abstract mixin class _$KeyTransitionSampleCopyWith<$Res> implements $KeyTransitionSampleCopyWith<$Res> {
  factory _$KeyTransitionSampleCopyWith(_KeyTransitionSample value, $Res Function(_KeyTransitionSample) _then) = __$KeyTransitionSampleCopyWithImpl;
@override @useResult
$Res call({
 PhysicalKeyId fromKey, PhysicalKeyId toKey, bool isError, double flightMs, DateTime occurredAtUtc
});




}
/// @nodoc
class __$KeyTransitionSampleCopyWithImpl<$Res>
    implements _$KeyTransitionSampleCopyWith<$Res> {
  __$KeyTransitionSampleCopyWithImpl(this._self, this._then);

  final _KeyTransitionSample _self;
  final $Res Function(_KeyTransitionSample) _then;

/// Create a copy of KeyTransitionSample
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fromKey = null,Object? toKey = null,Object? isError = null,Object? flightMs = null,Object? occurredAtUtc = null,}) {
  return _then(_KeyTransitionSample(
fromKey: null == fromKey ? _self.fromKey : fromKey // ignore: cast_nullable_to_non_nullable
as PhysicalKeyId,toKey: null == toKey ? _self.toKey : toKey // ignore: cast_nullable_to_non_nullable
as PhysicalKeyId,isError: null == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as bool,flightMs: null == flightMs ? _self.flightMs : flightMs // ignore: cast_nullable_to_non_nullable
as double,occurredAtUtc: null == occurredAtUtc ? _self.occurredAtUtc : occurredAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
