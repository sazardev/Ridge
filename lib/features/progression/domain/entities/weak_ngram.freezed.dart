// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weak_ngram.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WeakNgram {

 String get text; double get score; Trend get trend;
/// Create a copy of WeakNgram
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeakNgramCopyWith<WeakNgram> get copyWith => _$WeakNgramCopyWithImpl<WeakNgram>(this as WeakNgram, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WeakNgram;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeakNgram&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.score, _this.score) || other.score == _this.score)&&(identical(other.trend, _this.trend) || other.trend == _this.trend));
}


@override
int get hashCode {
  final _this = this as WeakNgram;
  return Object.hash(runtimeType,_this.text,_this.score,_this.trend);
}

@override
String toString() {
  final _this = this as WeakNgram;
  return 'WeakNgram(text: ${_this.text}, score: ${_this.score}, trend: ${_this.trend})';
}


}

/// @nodoc
abstract mixin class $WeakNgramCopyWith<$Res>  {
  factory $WeakNgramCopyWith(WeakNgram value, $Res Function(WeakNgram) _then) = _$WeakNgramCopyWithImpl;
@useResult
$Res call({
 String text, double score, Trend trend
});




}
/// @nodoc
class _$WeakNgramCopyWithImpl<$Res>
    implements $WeakNgramCopyWith<$Res> {
  _$WeakNgramCopyWithImpl(this._self, this._then);

  final WeakNgram _self;
  final $Res Function(WeakNgram) _then;

/// Create a copy of WeakNgram
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? score = null,Object? trend = null,}) {
  return _then(WeakNgram(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,trend: null == trend ? _self.trend : trend // ignore: cast_nullable_to_non_nullable
as Trend,
  ));
}

}


/// Adds pattern-matching-related methods to [WeakNgram].
extension WeakNgramPatterns on WeakNgram {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeakNgram value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeakNgram() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeakNgram value)  $default,){
final _that = this;
switch (_that) {
case _WeakNgram():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeakNgram value)?  $default,){
final _that = this;
switch (_that) {
case _WeakNgram() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  double score,  Trend trend)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeakNgram() when $default != null:
return $default(_that.text,_that.score,_that.trend);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  double score,  Trend trend)  $default,) {final _that = this;
switch (_that) {
case _WeakNgram():
return $default(_that.text,_that.score,_that.trend);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  double score,  Trend trend)?  $default,) {final _that = this;
switch (_that) {
case _WeakNgram() when $default != null:
return $default(_that.text,_that.score,_that.trend);case _:
  return null;

}
}

}

/// @nodoc


class _WeakNgram implements WeakNgram {
  const _WeakNgram({required this.text, required this.score, required this.trend});
  

@override final  String text;
@override final  double score;
@override final  Trend trend;

/// Create a copy of WeakNgram
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeakNgramCopyWith<_WeakNgram> get copyWith => __$WeakNgramCopyWithImpl<_WeakNgram>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeakNgram&&(identical(other.text, text) || other.text == text)&&(identical(other.score, score) || other.score == score)&&(identical(other.trend, trend) || other.trend == trend));
}


@override
int get hashCode {
    return Object.hash(runtimeType,text,score,trend);
}

@override
String toString() {
    return 'WeakNgram(text: $text, score: $score, trend: $trend)';
}


}

/// @nodoc
abstract mixin class _$WeakNgramCopyWith<$Res> implements $WeakNgramCopyWith<$Res> {
  factory _$WeakNgramCopyWith(_WeakNgram value, $Res Function(_WeakNgram) _then) = __$WeakNgramCopyWithImpl;
@override @useResult
$Res call({
 String text, double score, Trend trend
});




}
/// @nodoc
class __$WeakNgramCopyWithImpl<$Res>
    implements _$WeakNgramCopyWith<$Res> {
  __$WeakNgramCopyWithImpl(this._self, this._then);

  final _WeakNgram _self;
  final $Res Function(_WeakNgram) _then;

/// Create a copy of WeakNgram
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? score = null,Object? trend = null,}) {
  return _then(_WeakNgram(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,trend: null == trend ? _self.trend : trend // ignore: cast_nullable_to_non_nullable
as Trend,
  ));
}


}

// dart format on
