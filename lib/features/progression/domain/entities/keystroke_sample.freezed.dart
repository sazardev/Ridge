// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'keystroke_sample.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$KeystrokeSample {

 String get character; Finger get finger; bool get isError; double get flightMs; DateTime get occurredAtUtc;
/// Create a copy of KeystrokeSample
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KeystrokeSampleCopyWith<KeystrokeSample> get copyWith => _$KeystrokeSampleCopyWithImpl<KeystrokeSample>(this as KeystrokeSample, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as KeystrokeSample;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KeystrokeSample&&(identical(other.character, _this.character) || other.character == _this.character)&&(identical(other.finger, _this.finger) || other.finger == _this.finger)&&(identical(other.isError, _this.isError) || other.isError == _this.isError)&&(identical(other.flightMs, _this.flightMs) || other.flightMs == _this.flightMs)&&(identical(other.occurredAtUtc, _this.occurredAtUtc) || other.occurredAtUtc == _this.occurredAtUtc));
}


@override
int get hashCode {
  final _this = this as KeystrokeSample;
  return Object.hash(runtimeType,_this.character,_this.finger,_this.isError,_this.flightMs,_this.occurredAtUtc);
}

@override
String toString() {
  final _this = this as KeystrokeSample;
  return 'KeystrokeSample(character: ${_this.character}, finger: ${_this.finger}, isError: ${_this.isError}, flightMs: ${_this.flightMs}, occurredAtUtc: ${_this.occurredAtUtc})';
}


}

/// @nodoc
abstract mixin class $KeystrokeSampleCopyWith<$Res>  {
  factory $KeystrokeSampleCopyWith(KeystrokeSample value, $Res Function(KeystrokeSample) _then) = _$KeystrokeSampleCopyWithImpl;
@useResult
$Res call({
 String character, Finger finger, bool isError, double flightMs, DateTime occurredAtUtc
});




}
/// @nodoc
class _$KeystrokeSampleCopyWithImpl<$Res>
    implements $KeystrokeSampleCopyWith<$Res> {
  _$KeystrokeSampleCopyWithImpl(this._self, this._then);

  final KeystrokeSample _self;
  final $Res Function(KeystrokeSample) _then;

/// Create a copy of KeystrokeSample
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? character = null,Object? finger = null,Object? isError = null,Object? flightMs = null,Object? occurredAtUtc = null,}) {
  return _then(KeystrokeSample(
character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,finger: null == finger ? _self.finger : finger // ignore: cast_nullable_to_non_nullable
as Finger,isError: null == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as bool,flightMs: null == flightMs ? _self.flightMs : flightMs // ignore: cast_nullable_to_non_nullable
as double,occurredAtUtc: null == occurredAtUtc ? _self.occurredAtUtc : occurredAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [KeystrokeSample].
extension KeystrokeSamplePatterns on KeystrokeSample {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KeystrokeSample value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KeystrokeSample() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KeystrokeSample value)  $default,){
final _that = this;
switch (_that) {
case _KeystrokeSample():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KeystrokeSample value)?  $default,){
final _that = this;
switch (_that) {
case _KeystrokeSample() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String character,  Finger finger,  bool isError,  double flightMs,  DateTime occurredAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KeystrokeSample() when $default != null:
return $default(_that.character,_that.finger,_that.isError,_that.flightMs,_that.occurredAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String character,  Finger finger,  bool isError,  double flightMs,  DateTime occurredAtUtc)  $default,) {final _that = this;
switch (_that) {
case _KeystrokeSample():
return $default(_that.character,_that.finger,_that.isError,_that.flightMs,_that.occurredAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String character,  Finger finger,  bool isError,  double flightMs,  DateTime occurredAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _KeystrokeSample() when $default != null:
return $default(_that.character,_that.finger,_that.isError,_that.flightMs,_that.occurredAtUtc);case _:
  return null;

}
}

}

/// @nodoc


class _KeystrokeSample implements KeystrokeSample {
  const _KeystrokeSample({required this.character, required this.finger, required this.isError, required this.flightMs, required this.occurredAtUtc});
  

@override final  String character;
@override final  Finger finger;
@override final  bool isError;
@override final  double flightMs;
@override final  DateTime occurredAtUtc;

/// Create a copy of KeystrokeSample
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KeystrokeSampleCopyWith<_KeystrokeSample> get copyWith => __$KeystrokeSampleCopyWithImpl<_KeystrokeSample>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _KeystrokeSample&&(identical(other.character, character) || other.character == character)&&(identical(other.finger, finger) || other.finger == finger)&&(identical(other.isError, isError) || other.isError == isError)&&(identical(other.flightMs, flightMs) || other.flightMs == flightMs)&&(identical(other.occurredAtUtc, occurredAtUtc) || other.occurredAtUtc == occurredAtUtc));
}


@override
int get hashCode {
    return Object.hash(runtimeType,character,finger,isError,flightMs,occurredAtUtc);
}

@override
String toString() {
    return 'KeystrokeSample(character: $character, finger: $finger, isError: $isError, flightMs: $flightMs, occurredAtUtc: $occurredAtUtc)';
}


}

/// @nodoc
abstract mixin class _$KeystrokeSampleCopyWith<$Res> implements $KeystrokeSampleCopyWith<$Res> {
  factory _$KeystrokeSampleCopyWith(_KeystrokeSample value, $Res Function(_KeystrokeSample) _then) = __$KeystrokeSampleCopyWithImpl;
@override @useResult
$Res call({
 String character, Finger finger, bool isError, double flightMs, DateTime occurredAtUtc
});




}
/// @nodoc
class __$KeystrokeSampleCopyWithImpl<$Res>
    implements _$KeystrokeSampleCopyWith<$Res> {
  __$KeystrokeSampleCopyWithImpl(this._self, this._then);

  final _KeystrokeSample _self;
  final $Res Function(_KeystrokeSample) _then;

/// Create a copy of KeystrokeSample
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? character = null,Object? finger = null,Object? isError = null,Object? flightMs = null,Object? occurredAtUtc = null,}) {
  return _then(_KeystrokeSample(
character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,finger: null == finger ? _self.finger : finger // ignore: cast_nullable_to_non_nullable
as Finger,isError: null == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as bool,flightMs: null == flightMs ? _self.flightMs : flightMs // ignore: cast_nullable_to_non_nullable
as double,occurredAtUtc: null == occurredAtUtc ? _self.occurredAtUtc : occurredAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
