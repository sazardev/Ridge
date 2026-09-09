// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'finger_stat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FingerStat {

 Finger get finger; int get attempts; int get errors; double get avgFlightMs;
/// Create a copy of FingerStat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FingerStatCopyWith<FingerStat> get copyWith => _$FingerStatCopyWithImpl<FingerStat>(this as FingerStat, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FingerStat;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FingerStat&&(identical(other.finger, _this.finger) || other.finger == _this.finger)&&(identical(other.attempts, _this.attempts) || other.attempts == _this.attempts)&&(identical(other.errors, _this.errors) || other.errors == _this.errors)&&(identical(other.avgFlightMs, _this.avgFlightMs) || other.avgFlightMs == _this.avgFlightMs));
}


@override
int get hashCode {
  final _this = this as FingerStat;
  return Object.hash(runtimeType,_this.finger,_this.attempts,_this.errors,_this.avgFlightMs);
}

@override
String toString() {
  final _this = this as FingerStat;
  return 'FingerStat(finger: ${_this.finger}, attempts: ${_this.attempts}, errors: ${_this.errors}, avgFlightMs: ${_this.avgFlightMs})';
}


}

/// @nodoc
abstract mixin class $FingerStatCopyWith<$Res>  {
  factory $FingerStatCopyWith(FingerStat value, $Res Function(FingerStat) _then) = _$FingerStatCopyWithImpl;
@useResult
$Res call({
 Finger finger, int attempts, int errors, double avgFlightMs
});




}
/// @nodoc
class _$FingerStatCopyWithImpl<$Res>
    implements $FingerStatCopyWith<$Res> {
  _$FingerStatCopyWithImpl(this._self, this._then);

  final FingerStat _self;
  final $Res Function(FingerStat) _then;

/// Create a copy of FingerStat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? finger = null,Object? attempts = null,Object? errors = null,Object? avgFlightMs = null,}) {
  return _then(FingerStat(
finger: null == finger ? _self.finger : finger // ignore: cast_nullable_to_non_nullable
as Finger,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as int,avgFlightMs: null == avgFlightMs ? _self.avgFlightMs : avgFlightMs // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [FingerStat].
extension FingerStatPatterns on FingerStat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FingerStat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FingerStat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FingerStat value)  $default,){
final _that = this;
switch (_that) {
case _FingerStat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FingerStat value)?  $default,){
final _that = this;
switch (_that) {
case _FingerStat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Finger finger,  int attempts,  int errors,  double avgFlightMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FingerStat() when $default != null:
return $default(_that.finger,_that.attempts,_that.errors,_that.avgFlightMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Finger finger,  int attempts,  int errors,  double avgFlightMs)  $default,) {final _that = this;
switch (_that) {
case _FingerStat():
return $default(_that.finger,_that.attempts,_that.errors,_that.avgFlightMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Finger finger,  int attempts,  int errors,  double avgFlightMs)?  $default,) {final _that = this;
switch (_that) {
case _FingerStat() when $default != null:
return $default(_that.finger,_that.attempts,_that.errors,_that.avgFlightMs);case _:
  return null;

}
}

}

/// @nodoc


class _FingerStat implements FingerStat {
  const _FingerStat({required this.finger, required this.attempts, required this.errors, required this.avgFlightMs});
  

@override final  Finger finger;
@override final  int attempts;
@override final  int errors;
@override final  double avgFlightMs;

/// Create a copy of FingerStat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FingerStatCopyWith<_FingerStat> get copyWith => __$FingerStatCopyWithImpl<_FingerStat>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FingerStat&&(identical(other.finger, finger) || other.finger == finger)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.errors, errors) || other.errors == errors)&&(identical(other.avgFlightMs, avgFlightMs) || other.avgFlightMs == avgFlightMs));
}


@override
int get hashCode {
    return Object.hash(runtimeType,finger,attempts,errors,avgFlightMs);
}

@override
String toString() {
    return 'FingerStat(finger: $finger, attempts: $attempts, errors: $errors, avgFlightMs: $avgFlightMs)';
}


}

/// @nodoc
abstract mixin class _$FingerStatCopyWith<$Res> implements $FingerStatCopyWith<$Res> {
  factory _$FingerStatCopyWith(_FingerStat value, $Res Function(_FingerStat) _then) = __$FingerStatCopyWithImpl;
@override @useResult
$Res call({
 Finger finger, int attempts, int errors, double avgFlightMs
});




}
/// @nodoc
class __$FingerStatCopyWithImpl<$Res>
    implements _$FingerStatCopyWith<$Res> {
  __$FingerStatCopyWithImpl(this._self, this._then);

  final _FingerStat _self;
  final $Res Function(_FingerStat) _then;

/// Create a copy of FingerStat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? finger = null,Object? attempts = null,Object? errors = null,Object? avgFlightMs = null,}) {
  return _then(_FingerStat(
finger: null == finger ? _self.finger : finger // ignore: cast_nullable_to_non_nullable
as Finger,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as int,avgFlightMs: null == avgFlightMs ? _self.avgFlightMs : avgFlightMs // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
