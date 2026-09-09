// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ngram_sample.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NgramSample {

 String get text; bool get isError; double get flightMs; DateTime get occurredAtUtc;
/// Create a copy of NgramSample
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NgramSampleCopyWith<NgramSample> get copyWith => _$NgramSampleCopyWithImpl<NgramSample>(this as NgramSample, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as NgramSample;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NgramSample&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.isError, _this.isError) || other.isError == _this.isError)&&(identical(other.flightMs, _this.flightMs) || other.flightMs == _this.flightMs)&&(identical(other.occurredAtUtc, _this.occurredAtUtc) || other.occurredAtUtc == _this.occurredAtUtc));
}


@override
int get hashCode {
  final _this = this as NgramSample;
  return Object.hash(runtimeType,_this.text,_this.isError,_this.flightMs,_this.occurredAtUtc);
}

@override
String toString() {
  final _this = this as NgramSample;
  return 'NgramSample(text: ${_this.text}, isError: ${_this.isError}, flightMs: ${_this.flightMs}, occurredAtUtc: ${_this.occurredAtUtc})';
}


}

/// @nodoc
abstract mixin class $NgramSampleCopyWith<$Res>  {
  factory $NgramSampleCopyWith(NgramSample value, $Res Function(NgramSample) _then) = _$NgramSampleCopyWithImpl;
@useResult
$Res call({
 String text, bool isError, double flightMs, DateTime occurredAtUtc
});




}
/// @nodoc
class _$NgramSampleCopyWithImpl<$Res>
    implements $NgramSampleCopyWith<$Res> {
  _$NgramSampleCopyWithImpl(this._self, this._then);

  final NgramSample _self;
  final $Res Function(NgramSample) _then;

/// Create a copy of NgramSample
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? isError = null,Object? flightMs = null,Object? occurredAtUtc = null,}) {
  return _then(NgramSample(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,isError: null == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as bool,flightMs: null == flightMs ? _self.flightMs : flightMs // ignore: cast_nullable_to_non_nullable
as double,occurredAtUtc: null == occurredAtUtc ? _self.occurredAtUtc : occurredAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [NgramSample].
extension NgramSamplePatterns on NgramSample {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NgramSample value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NgramSample() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NgramSample value)  $default,){
final _that = this;
switch (_that) {
case _NgramSample():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NgramSample value)?  $default,){
final _that = this;
switch (_that) {
case _NgramSample() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  bool isError,  double flightMs,  DateTime occurredAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NgramSample() when $default != null:
return $default(_that.text,_that.isError,_that.flightMs,_that.occurredAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  bool isError,  double flightMs,  DateTime occurredAtUtc)  $default,) {final _that = this;
switch (_that) {
case _NgramSample():
return $default(_that.text,_that.isError,_that.flightMs,_that.occurredAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  bool isError,  double flightMs,  DateTime occurredAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _NgramSample() when $default != null:
return $default(_that.text,_that.isError,_that.flightMs,_that.occurredAtUtc);case _:
  return null;

}
}

}

/// @nodoc


class _NgramSample implements NgramSample {
  const _NgramSample({required this.text, required this.isError, required this.flightMs, required this.occurredAtUtc});
  

@override final  String text;
@override final  bool isError;
@override final  double flightMs;
@override final  DateTime occurredAtUtc;

/// Create a copy of NgramSample
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NgramSampleCopyWith<_NgramSample> get copyWith => __$NgramSampleCopyWithImpl<_NgramSample>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NgramSample&&(identical(other.text, text) || other.text == text)&&(identical(other.isError, isError) || other.isError == isError)&&(identical(other.flightMs, flightMs) || other.flightMs == flightMs)&&(identical(other.occurredAtUtc, occurredAtUtc) || other.occurredAtUtc == occurredAtUtc));
}


@override
int get hashCode {
    return Object.hash(runtimeType,text,isError,flightMs,occurredAtUtc);
}

@override
String toString() {
    return 'NgramSample(text: $text, isError: $isError, flightMs: $flightMs, occurredAtUtc: $occurredAtUtc)';
}


}

/// @nodoc
abstract mixin class _$NgramSampleCopyWith<$Res> implements $NgramSampleCopyWith<$Res> {
  factory _$NgramSampleCopyWith(_NgramSample value, $Res Function(_NgramSample) _then) = __$NgramSampleCopyWithImpl;
@override @useResult
$Res call({
 String text, bool isError, double flightMs, DateTime occurredAtUtc
});




}
/// @nodoc
class __$NgramSampleCopyWithImpl<$Res>
    implements _$NgramSampleCopyWith<$Res> {
  __$NgramSampleCopyWithImpl(this._self, this._then);

  final _NgramSample _self;
  final $Res Function(_NgramSample) _then;

/// Create a copy of NgramSample
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? isError = null,Object? flightMs = null,Object? occurredAtUtc = null,}) {
  return _then(_NgramSample(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,isError: null == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as bool,flightMs: null == flightMs ? _self.flightMs : flightMs // ignore: cast_nullable_to_non_nullable
as double,occurredAtUtc: null == occurredAtUtc ? _self.occurredAtUtc : occurredAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
