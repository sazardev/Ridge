// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'character_stat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CharacterStat {

 String get character; int get attempts; int get errors; double get avgFlightMs;
/// Create a copy of CharacterStat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CharacterStatCopyWith<CharacterStat> get copyWith => _$CharacterStatCopyWithImpl<CharacterStat>(this as CharacterStat, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CharacterStat;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CharacterStat&&(identical(other.character, _this.character) || other.character == _this.character)&&(identical(other.attempts, _this.attempts) || other.attempts == _this.attempts)&&(identical(other.errors, _this.errors) || other.errors == _this.errors)&&(identical(other.avgFlightMs, _this.avgFlightMs) || other.avgFlightMs == _this.avgFlightMs));
}


@override
int get hashCode {
  final _this = this as CharacterStat;
  return Object.hash(runtimeType,_this.character,_this.attempts,_this.errors,_this.avgFlightMs);
}

@override
String toString() {
  final _this = this as CharacterStat;
  return 'CharacterStat(character: ${_this.character}, attempts: ${_this.attempts}, errors: ${_this.errors}, avgFlightMs: ${_this.avgFlightMs})';
}


}

/// @nodoc
abstract mixin class $CharacterStatCopyWith<$Res>  {
  factory $CharacterStatCopyWith(CharacterStat value, $Res Function(CharacterStat) _then) = _$CharacterStatCopyWithImpl;
@useResult
$Res call({
 String character, int attempts, int errors, double avgFlightMs
});




}
/// @nodoc
class _$CharacterStatCopyWithImpl<$Res>
    implements $CharacterStatCopyWith<$Res> {
  _$CharacterStatCopyWithImpl(this._self, this._then);

  final CharacterStat _self;
  final $Res Function(CharacterStat) _then;

/// Create a copy of CharacterStat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? character = null,Object? attempts = null,Object? errors = null,Object? avgFlightMs = null,}) {
  return _then(CharacterStat(
character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as int,avgFlightMs: null == avgFlightMs ? _self.avgFlightMs : avgFlightMs // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [CharacterStat].
extension CharacterStatPatterns on CharacterStat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CharacterStat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CharacterStat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CharacterStat value)  $default,){
final _that = this;
switch (_that) {
case _CharacterStat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CharacterStat value)?  $default,){
final _that = this;
switch (_that) {
case _CharacterStat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String character,  int attempts,  int errors,  double avgFlightMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CharacterStat() when $default != null:
return $default(_that.character,_that.attempts,_that.errors,_that.avgFlightMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String character,  int attempts,  int errors,  double avgFlightMs)  $default,) {final _that = this;
switch (_that) {
case _CharacterStat():
return $default(_that.character,_that.attempts,_that.errors,_that.avgFlightMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String character,  int attempts,  int errors,  double avgFlightMs)?  $default,) {final _that = this;
switch (_that) {
case _CharacterStat() when $default != null:
return $default(_that.character,_that.attempts,_that.errors,_that.avgFlightMs);case _:
  return null;

}
}

}

/// @nodoc


class _CharacterStat implements CharacterStat {
  const _CharacterStat({required this.character, required this.attempts, required this.errors, required this.avgFlightMs});
  

@override final  String character;
@override final  int attempts;
@override final  int errors;
@override final  double avgFlightMs;

/// Create a copy of CharacterStat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CharacterStatCopyWith<_CharacterStat> get copyWith => __$CharacterStatCopyWithImpl<_CharacterStat>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CharacterStat&&(identical(other.character, character) || other.character == character)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.errors, errors) || other.errors == errors)&&(identical(other.avgFlightMs, avgFlightMs) || other.avgFlightMs == avgFlightMs));
}


@override
int get hashCode {
    return Object.hash(runtimeType,character,attempts,errors,avgFlightMs);
}

@override
String toString() {
    return 'CharacterStat(character: $character, attempts: $attempts, errors: $errors, avgFlightMs: $avgFlightMs)';
}


}

/// @nodoc
abstract mixin class _$CharacterStatCopyWith<$Res> implements $CharacterStatCopyWith<$Res> {
  factory _$CharacterStatCopyWith(_CharacterStat value, $Res Function(_CharacterStat) _then) = __$CharacterStatCopyWithImpl;
@override @useResult
$Res call({
 String character, int attempts, int errors, double avgFlightMs
});




}
/// @nodoc
class __$CharacterStatCopyWithImpl<$Res>
    implements _$CharacterStatCopyWith<$Res> {
  __$CharacterStatCopyWithImpl(this._self, this._then);

  final _CharacterStat _self;
  final $Res Function(_CharacterStat) _then;

/// Create a copy of CharacterStat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? character = null,Object? attempts = null,Object? errors = null,Object? avgFlightMs = null,}) {
  return _then(_CharacterStat(
character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as int,avgFlightMs: null == avgFlightMs ? _self.avgFlightMs : avgFlightMs // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
