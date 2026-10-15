// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_username.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountUsername {

 String get value;
/// Create a copy of AccountUsername
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountUsernameCopyWith<AccountUsername> get copyWith => _$AccountUsernameCopyWithImpl<AccountUsername>(this as AccountUsername, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AccountUsername;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountUsername&&(identical(other.value, _this.value) || other.value == _this.value));
}


@override
int get hashCode {
  final _this = this as AccountUsername;
  return Object.hash(runtimeType,_this.value);
}

@override
String toString() {
  final _this = this as AccountUsername;
  return 'AccountUsername(value: ${_this.value})';
}


}

/// @nodoc
abstract mixin class $AccountUsernameCopyWith<$Res>  {
  factory $AccountUsernameCopyWith(AccountUsername value, $Res Function(AccountUsername) _then) = _$AccountUsernameCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class _$AccountUsernameCopyWithImpl<$Res>
    implements $AccountUsernameCopyWith<$Res> {
  _$AccountUsernameCopyWithImpl(this._self, this._then);

  final AccountUsername _self;
  final $Res Function(AccountUsername) _then;

/// Create a copy of AccountUsername
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,}) {
  return _then(AccountUsername(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountUsername].
extension AccountUsernamePatterns on AccountUsername {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountUsername value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountUsername() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountUsername value)  $default,){
final _that = this;
switch (_that) {
case _AccountUsername():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountUsername value)?  $default,){
final _that = this;
switch (_that) {
case _AccountUsername() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountUsername() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String value)  $default,) {final _that = this;
switch (_that) {
case _AccountUsername():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String value)?  $default,) {final _that = this;
switch (_that) {
case _AccountUsername() when $default != null:
return $default(_that.value);case _:
  return null;

}
}

}

/// @nodoc


class _AccountUsername implements AccountUsername {
  const _AccountUsername(this.value);
  

@override final  String value;

/// Create a copy of AccountUsername
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountUsernameCopyWith<_AccountUsername> get copyWith => __$AccountUsernameCopyWithImpl<_AccountUsername>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountUsername&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode {
    return Object.hash(runtimeType,value);
}

@override
String toString() {
    return 'AccountUsername(value: $value)';
}


}

/// @nodoc
abstract mixin class _$AccountUsernameCopyWith<$Res> implements $AccountUsernameCopyWith<$Res> {
  factory _$AccountUsernameCopyWith(_AccountUsername value, $Res Function(_AccountUsername) _then) = __$AccountUsernameCopyWithImpl;
@override @useResult
$Res call({
 String value
});




}
/// @nodoc
class __$AccountUsernameCopyWithImpl<$Res>
    implements _$AccountUsernameCopyWith<$Res> {
  __$AccountUsernameCopyWithImpl(this._self, this._then);

  final _AccountUsername _self;
  final $Res Function(_AccountUsername) _then;

/// Create a copy of AccountUsername
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(_AccountUsername(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
