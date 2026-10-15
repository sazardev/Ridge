// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registered_account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RegisteredAccount {

 String get uid; String get username; DateTime? get createdAt;
/// Create a copy of RegisteredAccount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisteredAccountCopyWith<RegisteredAccount> get copyWith => _$RegisteredAccountCopyWithImpl<RegisteredAccount>(this as RegisteredAccount, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RegisteredAccount;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisteredAccount&&(identical(other.uid, _this.uid) || other.uid == _this.uid)&&(identical(other.username, _this.username) || other.username == _this.username)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}


@override
int get hashCode {
  final _this = this as RegisteredAccount;
  return Object.hash(runtimeType,_this.uid,_this.username,_this.createdAt);
}

@override
String toString() {
  final _this = this as RegisteredAccount;
  return 'RegisteredAccount(uid: ${_this.uid}, username: ${_this.username}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $RegisteredAccountCopyWith<$Res>  {
  factory $RegisteredAccountCopyWith(RegisteredAccount value, $Res Function(RegisteredAccount) _then) = _$RegisteredAccountCopyWithImpl;
@useResult
$Res call({
 String uid, String username, DateTime? createdAt
});




}
/// @nodoc
class _$RegisteredAccountCopyWithImpl<$Res>
    implements $RegisteredAccountCopyWith<$Res> {
  _$RegisteredAccountCopyWithImpl(this._self, this._then);

  final RegisteredAccount _self;
  final $Res Function(RegisteredAccount) _then;

/// Create a copy of RegisteredAccount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? username = null,Object? createdAt = freezed,}) {
  return _then(RegisteredAccount(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RegisteredAccount].
extension RegisteredAccountPatterns on RegisteredAccount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegisteredAccount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegisteredAccount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegisteredAccount value)  $default,){
final _that = this;
switch (_that) {
case _RegisteredAccount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegisteredAccount value)?  $default,){
final _that = this;
switch (_that) {
case _RegisteredAccount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String username,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegisteredAccount() when $default != null:
return $default(_that.uid,_that.username,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String username,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _RegisteredAccount():
return $default(_that.uid,_that.username,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String username,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _RegisteredAccount() when $default != null:
return $default(_that.uid,_that.username,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _RegisteredAccount implements RegisteredAccount {
  const _RegisteredAccount({required this.uid, required this.username, this.createdAt});
  

@override final  String uid;
@override final  String username;
@override final  DateTime? createdAt;

/// Create a copy of RegisteredAccount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegisteredAccountCopyWith<_RegisteredAccount> get copyWith => __$RegisteredAccountCopyWithImpl<_RegisteredAccount>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegisteredAccount&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.username, username) || other.username == username)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,uid,username,createdAt);
}

@override
String toString() {
    return 'RegisteredAccount(uid: $uid, username: $username, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$RegisteredAccountCopyWith<$Res> implements $RegisteredAccountCopyWith<$Res> {
  factory _$RegisteredAccountCopyWith(_RegisteredAccount value, $Res Function(_RegisteredAccount) _then) = __$RegisteredAccountCopyWithImpl;
@override @useResult
$Res call({
 String uid, String username, DateTime? createdAt
});




}
/// @nodoc
class __$RegisteredAccountCopyWithImpl<$Res>
    implements _$RegisteredAccountCopyWith<$Res> {
  __$RegisteredAccountCopyWithImpl(this._self, this._then);

  final _RegisteredAccount _self;
  final $Res Function(_RegisteredAccount) _then;

/// Create a copy of RegisteredAccount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? username = null,Object? createdAt = freezed,}) {
  return _then(_RegisteredAccount(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
