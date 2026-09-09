// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'learning_path_id.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LearningPathId {

 String get value;
/// Create a copy of LearningPathId
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LearningPathIdCopyWith<LearningPathId> get copyWith => _$LearningPathIdCopyWithImpl<LearningPathId>(this as LearningPathId, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LearningPathId;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LearningPathId&&(identical(other.value, _this.value) || other.value == _this.value));
}


@override
int get hashCode {
  final _this = this as LearningPathId;
  return Object.hash(runtimeType,_this.value);
}

@override
String toString() {
  final _this = this as LearningPathId;
  return 'LearningPathId(value: ${_this.value})';
}


}

/// @nodoc
abstract mixin class $LearningPathIdCopyWith<$Res>  {
  factory $LearningPathIdCopyWith(LearningPathId value, $Res Function(LearningPathId) _then) = _$LearningPathIdCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class _$LearningPathIdCopyWithImpl<$Res>
    implements $LearningPathIdCopyWith<$Res> {
  _$LearningPathIdCopyWithImpl(this._self, this._then);

  final LearningPathId _self;
  final $Res Function(LearningPathId) _then;

/// Create a copy of LearningPathId
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,}) {
  return _then(LearningPathId(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LearningPathId].
extension LearningPathIdPatterns on LearningPathId {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LearningPathId value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LearningPathId() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LearningPathId value)  $default,){
final _that = this;
switch (_that) {
case _LearningPathId():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LearningPathId value)?  $default,){
final _that = this;
switch (_that) {
case _LearningPathId() when $default != null:
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
case _LearningPathId() when $default != null:
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
case _LearningPathId():
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
case _LearningPathId() when $default != null:
return $default(_that.value);case _:
  return null;

}
}

}

/// @nodoc


class _LearningPathId implements LearningPathId {
  const _LearningPathId(this.value);
  

@override final  String value;

/// Create a copy of LearningPathId
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LearningPathIdCopyWith<_LearningPathId> get copyWith => __$LearningPathIdCopyWithImpl<_LearningPathId>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LearningPathId&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode {
    return Object.hash(runtimeType,value);
}

@override
String toString() {
    return 'LearningPathId(value: $value)';
}


}

/// @nodoc
abstract mixin class _$LearningPathIdCopyWith<$Res> implements $LearningPathIdCopyWith<$Res> {
  factory _$LearningPathIdCopyWith(_LearningPathId value, $Res Function(_LearningPathId) _then) = __$LearningPathIdCopyWithImpl;
@override @useResult
$Res call({
 String value
});




}
/// @nodoc
class __$LearningPathIdCopyWithImpl<$Res>
    implements _$LearningPathIdCopyWith<$Res> {
  __$LearningPathIdCopyWithImpl(this._self, this._then);

  final _LearningPathId _self;
  final $Res Function(_LearningPathId) _then;

/// Create a copy of LearningPathId
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(_LearningPathId(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
