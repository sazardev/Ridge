// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_id.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaskId {

 String get value;
/// Create a copy of TaskId
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskIdCopyWith<TaskId> get copyWith => _$TaskIdCopyWithImpl<TaskId>(this as TaskId, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TaskId;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskId&&(identical(other.value, _this.value) || other.value == _this.value));
}


@override
int get hashCode {
  final _this = this as TaskId;
  return Object.hash(runtimeType,_this.value);
}

@override
String toString() {
  final _this = this as TaskId;
  return 'TaskId(value: ${_this.value})';
}


}

/// @nodoc
abstract mixin class $TaskIdCopyWith<$Res>  {
  factory $TaskIdCopyWith(TaskId value, $Res Function(TaskId) _then) = _$TaskIdCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class _$TaskIdCopyWithImpl<$Res>
    implements $TaskIdCopyWith<$Res> {
  _$TaskIdCopyWithImpl(this._self, this._then);

  final TaskId _self;
  final $Res Function(TaskId) _then;

/// Create a copy of TaskId
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,}) {
  return _then(TaskId(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskId].
extension TaskIdPatterns on TaskId {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskId value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskId() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskId value)  $default,){
final _that = this;
switch (_that) {
case _TaskId():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskId value)?  $default,){
final _that = this;
switch (_that) {
case _TaskId() when $default != null:
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
case _TaskId() when $default != null:
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
case _TaskId():
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
case _TaskId() when $default != null:
return $default(_that.value);case _:
  return null;

}
}

}

/// @nodoc


class _TaskId implements TaskId {
  const _TaskId(this.value);
  

@override final  String value;

/// Create a copy of TaskId
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskIdCopyWith<_TaskId> get copyWith => __$TaskIdCopyWithImpl<_TaskId>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskId&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode {
    return Object.hash(runtimeType,value);
}

@override
String toString() {
    return 'TaskId(value: $value)';
}


}

/// @nodoc
abstract mixin class _$TaskIdCopyWith<$Res> implements $TaskIdCopyWith<$Res> {
  factory _$TaskIdCopyWith(_TaskId value, $Res Function(_TaskId) _then) = __$TaskIdCopyWithImpl;
@override @useResult
$Res call({
 String value
});




}
/// @nodoc
class __$TaskIdCopyWithImpl<$Res>
    implements _$TaskIdCopyWith<$Res> {
  __$TaskIdCopyWithImpl(this._self, this._then);

  final _TaskId _self;
  final $Res Function(_TaskId) _then;

/// Create a copy of TaskId
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(_TaskId(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
