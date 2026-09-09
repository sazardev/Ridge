// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'typing_session_id.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TypingSessionId {

 String get value;
/// Create a copy of TypingSessionId
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TypingSessionIdCopyWith<TypingSessionId> get copyWith => _$TypingSessionIdCopyWithImpl<TypingSessionId>(this as TypingSessionId, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TypingSessionId;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TypingSessionId&&(identical(other.value, _this.value) || other.value == _this.value));
}


@override
int get hashCode {
  final _this = this as TypingSessionId;
  return Object.hash(runtimeType,_this.value);
}

@override
String toString() {
  final _this = this as TypingSessionId;
  return 'TypingSessionId(value: ${_this.value})';
}


}

/// @nodoc
abstract mixin class $TypingSessionIdCopyWith<$Res>  {
  factory $TypingSessionIdCopyWith(TypingSessionId value, $Res Function(TypingSessionId) _then) = _$TypingSessionIdCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class _$TypingSessionIdCopyWithImpl<$Res>
    implements $TypingSessionIdCopyWith<$Res> {
  _$TypingSessionIdCopyWithImpl(this._self, this._then);

  final TypingSessionId _self;
  final $Res Function(TypingSessionId) _then;

/// Create a copy of TypingSessionId
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,}) {
  return _then(TypingSessionId(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TypingSessionId].
extension TypingSessionIdPatterns on TypingSessionId {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TypingSessionId value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TypingSessionId() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TypingSessionId value)  $default,){
final _that = this;
switch (_that) {
case _TypingSessionId():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TypingSessionId value)?  $default,){
final _that = this;
switch (_that) {
case _TypingSessionId() when $default != null:
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
case _TypingSessionId() when $default != null:
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
case _TypingSessionId():
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
case _TypingSessionId() when $default != null:
return $default(_that.value);case _:
  return null;

}
}

}

/// @nodoc


class _TypingSessionId implements TypingSessionId {
  const _TypingSessionId(this.value);
  

@override final  String value;

/// Create a copy of TypingSessionId
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TypingSessionIdCopyWith<_TypingSessionId> get copyWith => __$TypingSessionIdCopyWithImpl<_TypingSessionId>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TypingSessionId&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode {
    return Object.hash(runtimeType,value);
}

@override
String toString() {
    return 'TypingSessionId(value: $value)';
}


}

/// @nodoc
abstract mixin class _$TypingSessionIdCopyWith<$Res> implements $TypingSessionIdCopyWith<$Res> {
  factory _$TypingSessionIdCopyWith(_TypingSessionId value, $Res Function(_TypingSessionId) _then) = __$TypingSessionIdCopyWithImpl;
@override @useResult
$Res call({
 String value
});




}
/// @nodoc
class __$TypingSessionIdCopyWithImpl<$Res>
    implements _$TypingSessionIdCopyWith<$Res> {
  __$TypingSessionIdCopyWithImpl(this._self, this._then);

  final _TypingSessionId _self;
  final $Res Function(_TypingSessionId) _then;

/// Create a copy of TypingSessionId
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(_TypingSessionId(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
