// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weak_character.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WeakCharacter {

 String get character; double get score; Trend get trend;
/// Create a copy of WeakCharacter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeakCharacterCopyWith<WeakCharacter> get copyWith => _$WeakCharacterCopyWithImpl<WeakCharacter>(this as WeakCharacter, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WeakCharacter;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeakCharacter&&(identical(other.character, _this.character) || other.character == _this.character)&&(identical(other.score, _this.score) || other.score == _this.score)&&(identical(other.trend, _this.trend) || other.trend == _this.trend));
}


@override
int get hashCode {
  final _this = this as WeakCharacter;
  return Object.hash(runtimeType,_this.character,_this.score,_this.trend);
}

@override
String toString() {
  final _this = this as WeakCharacter;
  return 'WeakCharacter(character: ${_this.character}, score: ${_this.score}, trend: ${_this.trend})';
}


}

/// @nodoc
abstract mixin class $WeakCharacterCopyWith<$Res>  {
  factory $WeakCharacterCopyWith(WeakCharacter value, $Res Function(WeakCharacter) _then) = _$WeakCharacterCopyWithImpl;
@useResult
$Res call({
 String character, double score, Trend trend
});




}
/// @nodoc
class _$WeakCharacterCopyWithImpl<$Res>
    implements $WeakCharacterCopyWith<$Res> {
  _$WeakCharacterCopyWithImpl(this._self, this._then);

  final WeakCharacter _self;
  final $Res Function(WeakCharacter) _then;

/// Create a copy of WeakCharacter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? character = null,Object? score = null,Object? trend = null,}) {
  return _then(WeakCharacter(
character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,trend: null == trend ? _self.trend : trend // ignore: cast_nullable_to_non_nullable
as Trend,
  ));
}

}


/// Adds pattern-matching-related methods to [WeakCharacter].
extension WeakCharacterPatterns on WeakCharacter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeakCharacter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeakCharacter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeakCharacter value)  $default,){
final _that = this;
switch (_that) {
case _WeakCharacter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeakCharacter value)?  $default,){
final _that = this;
switch (_that) {
case _WeakCharacter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String character,  double score,  Trend trend)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeakCharacter() when $default != null:
return $default(_that.character,_that.score,_that.trend);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String character,  double score,  Trend trend)  $default,) {final _that = this;
switch (_that) {
case _WeakCharacter():
return $default(_that.character,_that.score,_that.trend);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String character,  double score,  Trend trend)?  $default,) {final _that = this;
switch (_that) {
case _WeakCharacter() when $default != null:
return $default(_that.character,_that.score,_that.trend);case _:
  return null;

}
}

}

/// @nodoc


class _WeakCharacter implements WeakCharacter {
  const _WeakCharacter({required this.character, required this.score, required this.trend});
  

@override final  String character;
@override final  double score;
@override final  Trend trend;

/// Create a copy of WeakCharacter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeakCharacterCopyWith<_WeakCharacter> get copyWith => __$WeakCharacterCopyWithImpl<_WeakCharacter>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeakCharacter&&(identical(other.character, character) || other.character == character)&&(identical(other.score, score) || other.score == score)&&(identical(other.trend, trend) || other.trend == trend));
}


@override
int get hashCode {
    return Object.hash(runtimeType,character,score,trend);
}

@override
String toString() {
    return 'WeakCharacter(character: $character, score: $score, trend: $trend)';
}


}

/// @nodoc
abstract mixin class _$WeakCharacterCopyWith<$Res> implements $WeakCharacterCopyWith<$Res> {
  factory _$WeakCharacterCopyWith(_WeakCharacter value, $Res Function(_WeakCharacter) _then) = __$WeakCharacterCopyWithImpl;
@override @useResult
$Res call({
 String character, double score, Trend trend
});




}
/// @nodoc
class __$WeakCharacterCopyWithImpl<$Res>
    implements _$WeakCharacterCopyWith<$Res> {
  __$WeakCharacterCopyWithImpl(this._self, this._then);

  final _WeakCharacter _self;
  final $Res Function(_WeakCharacter) _then;

/// Create a copy of WeakCharacter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? character = null,Object? score = null,Object? trend = null,}) {
  return _then(_WeakCharacter(
character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,trend: null == trend ? _self.trend : trend // ignore: cast_nullable_to_non_nullable
as Trend,
  ));
}


}

// dart format on
