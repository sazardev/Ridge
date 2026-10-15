// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_password.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountPassword {

 String get value;
/// Create a copy of AccountPassword
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountPasswordCopyWith<AccountPassword> get copyWith => _$AccountPasswordCopyWithImpl<AccountPassword>(this as AccountPassword, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AccountPassword;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountPassword&&(identical(other.value, _this.value) || other.value == _this.value));
}


@override
int get hashCode {
  final _this = this as AccountPassword;
  return Object.hash(runtimeType,_this.value);
}

@override
String toString() {
  final _this = this as AccountPassword;
  return 'AccountPassword(value: ${_this.value})';
}


}

/// @nodoc
abstract mixin class $AccountPasswordCopyWith<$Res>  {
  factory $AccountPasswordCopyWith(AccountPassword value, $Res Function(AccountPassword) _then) = _$AccountPasswordCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class _$AccountPasswordCopyWithImpl<$Res>
    implements $AccountPasswordCopyWith<$Res> {
  _$AccountPasswordCopyWithImpl(this._self, this._then);

  final AccountPassword _self;
  final $Res Function(AccountPassword) _then;

/// Create a copy of AccountPassword
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,}) {
  return _then(AccountPassword(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountPassword].
extension AccountPasswordPatterns on AccountPassword {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountPassword value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountPassword() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountPassword value)  $default,){
final _that = this;
switch (_that) {
case _AccountPassword():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountPassword value)?  $default,){
final _that = this;
switch (_that) {
case _AccountPassword() when $default != null:
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
case _AccountPassword() when $default != null:
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
case _AccountPassword():
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
case _AccountPassword() when $default != null:
return $default(_that.value);case _:
  return null;

}
}

}

/// @nodoc


class _AccountPassword implements AccountPassword {
  const _AccountPassword(this.value);
  

@override final  String value;

/// Create a copy of AccountPassword
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountPasswordCopyWith<_AccountPassword> get copyWith => __$AccountPasswordCopyWithImpl<_AccountPassword>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountPassword&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode {
    return Object.hash(runtimeType,value);
}

@override
String toString() {
    return 'AccountPassword(value: $value)';
}


}

/// @nodoc
abstract mixin class _$AccountPasswordCopyWith<$Res> implements $AccountPasswordCopyWith<$Res> {
  factory _$AccountPasswordCopyWith(_AccountPassword value, $Res Function(_AccountPassword) _then) = __$AccountPasswordCopyWithImpl;
@override @useResult
$Res call({
 String value
});




}
/// @nodoc
class __$AccountPasswordCopyWithImpl<$Res>
    implements _$AccountPasswordCopyWith<$Res> {
  __$AccountPasswordCopyWithImpl(this._self, this._then);

  final _AccountPassword _self;
  final $Res Function(_AccountPassword) _then;

/// Create a copy of AccountPassword
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(_AccountPassword(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
