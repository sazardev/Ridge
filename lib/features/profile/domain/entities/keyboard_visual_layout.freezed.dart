// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'keyboard_visual_layout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$KeyboardVisualLayout {

 String get model; List<KeyboardKeySpec> get keys;
/// Create a copy of KeyboardVisualLayout
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KeyboardVisualLayoutCopyWith<KeyboardVisualLayout> get copyWith => _$KeyboardVisualLayoutCopyWithImpl<KeyboardVisualLayout>(this as KeyboardVisualLayout, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as KeyboardVisualLayout;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KeyboardVisualLayout&&(identical(other.model, _this.model) || other.model == _this.model)&&const DeepCollectionEquality().equals(other.keys, _this.keys));
}


@override
int get hashCode {
  final _this = this as KeyboardVisualLayout;
  return Object.hash(runtimeType,_this.model,const DeepCollectionEquality().hash(_this.keys));
}

@override
String toString() {
  final _this = this as KeyboardVisualLayout;
  return 'KeyboardVisualLayout(model: ${_this.model}, keys: ${_this.keys})';
}


}

/// @nodoc
abstract mixin class $KeyboardVisualLayoutCopyWith<$Res>  {
  factory $KeyboardVisualLayoutCopyWith(KeyboardVisualLayout value, $Res Function(KeyboardVisualLayout) _then) = _$KeyboardVisualLayoutCopyWithImpl;
@useResult
$Res call({
 String model, List<KeyboardKeySpec> keys
});




}
/// @nodoc
class _$KeyboardVisualLayoutCopyWithImpl<$Res>
    implements $KeyboardVisualLayoutCopyWith<$Res> {
  _$KeyboardVisualLayoutCopyWithImpl(this._self, this._then);

  final KeyboardVisualLayout _self;
  final $Res Function(KeyboardVisualLayout) _then;

/// Create a copy of KeyboardVisualLayout
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? model = null,Object? keys = null,}) {
  return _then(KeyboardVisualLayout(
model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,keys: null == keys ? _self.keys : keys // ignore: cast_nullable_to_non_nullable
as List<KeyboardKeySpec>,
  ));
}

}


/// Adds pattern-matching-related methods to [KeyboardVisualLayout].
extension KeyboardVisualLayoutPatterns on KeyboardVisualLayout {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KeyboardVisualLayout value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KeyboardVisualLayout() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KeyboardVisualLayout value)  $default,){
final _that = this;
switch (_that) {
case _KeyboardVisualLayout():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KeyboardVisualLayout value)?  $default,){
final _that = this;
switch (_that) {
case _KeyboardVisualLayout() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String model,  List<KeyboardKeySpec> keys)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KeyboardVisualLayout() when $default != null:
return $default(_that.model,_that.keys);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String model,  List<KeyboardKeySpec> keys)  $default,) {final _that = this;
switch (_that) {
case _KeyboardVisualLayout():
return $default(_that.model,_that.keys);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String model,  List<KeyboardKeySpec> keys)?  $default,) {final _that = this;
switch (_that) {
case _KeyboardVisualLayout() when $default != null:
return $default(_that.model,_that.keys);case _:
  return null;

}
}

}

/// @nodoc


class _KeyboardVisualLayout implements KeyboardVisualLayout {
  const _KeyboardVisualLayout({required this.model, required  List<KeyboardKeySpec> keys}): _keys = keys;
  

@override final  String model;
 final  List<KeyboardKeySpec> _keys;
@override List<KeyboardKeySpec> get keys {
  if (_keys is EqualUnmodifiableListView) return _keys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_keys);
}


/// Create a copy of KeyboardVisualLayout
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KeyboardVisualLayoutCopyWith<_KeyboardVisualLayout> get copyWith => __$KeyboardVisualLayoutCopyWithImpl<_KeyboardVisualLayout>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _KeyboardVisualLayout&&(identical(other.model, model) || other.model == model)&&const DeepCollectionEquality().equals(other.keys, _keys));
}


@override
int get hashCode {
    return Object.hash(runtimeType,model,const DeepCollectionEquality().hash(_keys));
}

@override
String toString() {
    return 'KeyboardVisualLayout(model: $model, keys: $keys)';
}


}

/// @nodoc
abstract mixin class _$KeyboardVisualLayoutCopyWith<$Res> implements $KeyboardVisualLayoutCopyWith<$Res> {
  factory _$KeyboardVisualLayoutCopyWith(_KeyboardVisualLayout value, $Res Function(_KeyboardVisualLayout) _then) = __$KeyboardVisualLayoutCopyWithImpl;
@override @useResult
$Res call({
 String model, List<KeyboardKeySpec> keys
});




}
/// @nodoc
class __$KeyboardVisualLayoutCopyWithImpl<$Res>
    implements _$KeyboardVisualLayoutCopyWith<$Res> {
  __$KeyboardVisualLayoutCopyWithImpl(this._self, this._then);

  final _KeyboardVisualLayout _self;
  final $Res Function(_KeyboardVisualLayout) _then;

/// Create a copy of KeyboardVisualLayout
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? model = null,Object? keys = null,}) {
  return _then(_KeyboardVisualLayout(
model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,keys: null == keys ? _self._keys : keys // ignore: cast_nullable_to_non_nullable
as List<KeyboardKeySpec>,
  ));
}


}

// dart format on
