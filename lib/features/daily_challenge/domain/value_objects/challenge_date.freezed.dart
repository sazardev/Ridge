// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'challenge_date.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChallengeDate {

 DateTime get value;
/// Create a copy of ChallengeDate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChallengeDateCopyWith<ChallengeDate> get copyWith => _$ChallengeDateCopyWithImpl<ChallengeDate>(this as ChallengeDate, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ChallengeDate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChallengeDate&&(identical(other.value, _this.value) || other.value == _this.value));
}


@override
int get hashCode {
  final _this = this as ChallengeDate;
  return Object.hash(runtimeType,_this.value);
}

@override
String toString() {
  final _this = this as ChallengeDate;
  return 'ChallengeDate(value: ${_this.value})';
}


}

/// @nodoc
abstract mixin class $ChallengeDateCopyWith<$Res>  {
  factory $ChallengeDateCopyWith(ChallengeDate value, $Res Function(ChallengeDate) _then) = _$ChallengeDateCopyWithImpl;
@useResult
$Res call({
 DateTime value
});




}
/// @nodoc
class _$ChallengeDateCopyWithImpl<$Res>
    implements $ChallengeDateCopyWith<$Res> {
  _$ChallengeDateCopyWithImpl(this._self, this._then);

  final ChallengeDate _self;
  final $Res Function(ChallengeDate) _then;

/// Create a copy of ChallengeDate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,}) {
  return _then(ChallengeDate(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ChallengeDate].
extension ChallengeDatePatterns on ChallengeDate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChallengeDate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChallengeDate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChallengeDate value)  $default,){
final _that = this;
switch (_that) {
case _ChallengeDate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChallengeDate value)?  $default,){
final _that = this;
switch (_that) {
case _ChallengeDate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChallengeDate() when $default != null:
return $default(_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime value)  $default,) {final _that = this;
switch (_that) {
case _ChallengeDate():
return $default(_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime value)?  $default,) {final _that = this;
switch (_that) {
case _ChallengeDate() when $default != null:
return $default(_that.value);case _:
  return null;

}
}

}

/// @nodoc


class _ChallengeDate extends ChallengeDate {
  const _ChallengeDate(this.value): super._();
  

@override final  DateTime value;

/// Create a copy of ChallengeDate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChallengeDateCopyWith<_ChallengeDate> get copyWith => __$ChallengeDateCopyWithImpl<_ChallengeDate>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChallengeDate&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode {
    return Object.hash(runtimeType,value);
}

@override
String toString() {
    return 'ChallengeDate(value: $value)';
}


}

/// @nodoc
abstract mixin class _$ChallengeDateCopyWith<$Res> implements $ChallengeDateCopyWith<$Res> {
  factory _$ChallengeDateCopyWith(_ChallengeDate value, $Res Function(_ChallengeDate) _then) = __$ChallengeDateCopyWithImpl;
@override @useResult
$Res call({
 DateTime value
});




}
/// @nodoc
class __$ChallengeDateCopyWithImpl<$Res>
    implements _$ChallengeDateCopyWith<$Res> {
  __$ChallengeDateCopyWithImpl(this._self, this._then);

  final _ChallengeDate _self;
  final $Res Function(_ChallengeDate) _then;

/// Create a copy of ChallengeDate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(_ChallengeDate(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
