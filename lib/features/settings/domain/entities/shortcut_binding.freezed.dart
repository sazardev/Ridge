// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shortcut_binding.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ShortcutBinding {

 int get keyId; bool get control; bool get alt; bool get shift;
/// Create a copy of ShortcutBinding
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShortcutBindingCopyWith<ShortcutBinding> get copyWith => _$ShortcutBindingCopyWithImpl<ShortcutBinding>(this as ShortcutBinding, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ShortcutBinding;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShortcutBinding&&(identical(other.keyId, _this.keyId) || other.keyId == _this.keyId)&&(identical(other.control, _this.control) || other.control == _this.control)&&(identical(other.alt, _this.alt) || other.alt == _this.alt)&&(identical(other.shift, _this.shift) || other.shift == _this.shift));
}


@override
int get hashCode {
  final _this = this as ShortcutBinding;
  return Object.hash(runtimeType,_this.keyId,_this.control,_this.alt,_this.shift);
}

@override
String toString() {
  final _this = this as ShortcutBinding;
  return 'ShortcutBinding(keyId: ${_this.keyId}, control: ${_this.control}, alt: ${_this.alt}, shift: ${_this.shift})';
}


}

/// @nodoc
abstract mixin class $ShortcutBindingCopyWith<$Res>  {
  factory $ShortcutBindingCopyWith(ShortcutBinding value, $Res Function(ShortcutBinding) _then) = _$ShortcutBindingCopyWithImpl;
@useResult
$Res call({
 int keyId, bool control, bool alt, bool shift
});




}
/// @nodoc
class _$ShortcutBindingCopyWithImpl<$Res>
    implements $ShortcutBindingCopyWith<$Res> {
  _$ShortcutBindingCopyWithImpl(this._self, this._then);

  final ShortcutBinding _self;
  final $Res Function(ShortcutBinding) _then;

/// Create a copy of ShortcutBinding
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? keyId = null,Object? control = null,Object? alt = null,Object? shift = null,}) {
  return _then(ShortcutBinding(
keyId: null == keyId ? _self.keyId : keyId // ignore: cast_nullable_to_non_nullable
as int,control: null == control ? _self.control : control // ignore: cast_nullable_to_non_nullable
as bool,alt: null == alt ? _self.alt : alt // ignore: cast_nullable_to_non_nullable
as bool,shift: null == shift ? _self.shift : shift // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ShortcutBinding].
extension ShortcutBindingPatterns on ShortcutBinding {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShortcutBinding value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShortcutBinding() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShortcutBinding value)  $default,){
final _that = this;
switch (_that) {
case _ShortcutBinding():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShortcutBinding value)?  $default,){
final _that = this;
switch (_that) {
case _ShortcutBinding() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int keyId,  bool control,  bool alt,  bool shift)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShortcutBinding() when $default != null:
return $default(_that.keyId,_that.control,_that.alt,_that.shift);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int keyId,  bool control,  bool alt,  bool shift)  $default,) {final _that = this;
switch (_that) {
case _ShortcutBinding():
return $default(_that.keyId,_that.control,_that.alt,_that.shift);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int keyId,  bool control,  bool alt,  bool shift)?  $default,) {final _that = this;
switch (_that) {
case _ShortcutBinding() when $default != null:
return $default(_that.keyId,_that.control,_that.alt,_that.shift);case _:
  return null;

}
}

}

/// @nodoc


class _ShortcutBinding implements ShortcutBinding {
  const _ShortcutBinding({required this.keyId, required this.control, required this.alt, required this.shift});
  

@override final  int keyId;
@override final  bool control;
@override final  bool alt;
@override final  bool shift;

/// Create a copy of ShortcutBinding
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShortcutBindingCopyWith<_ShortcutBinding> get copyWith => __$ShortcutBindingCopyWithImpl<_ShortcutBinding>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShortcutBinding&&(identical(other.keyId, keyId) || other.keyId == keyId)&&(identical(other.control, control) || other.control == control)&&(identical(other.alt, alt) || other.alt == alt)&&(identical(other.shift, shift) || other.shift == shift));
}


@override
int get hashCode {
    return Object.hash(runtimeType,keyId,control,alt,shift);
}

@override
String toString() {
    return 'ShortcutBinding(keyId: $keyId, control: $control, alt: $alt, shift: $shift)';
}


}

/// @nodoc
abstract mixin class _$ShortcutBindingCopyWith<$Res> implements $ShortcutBindingCopyWith<$Res> {
  factory _$ShortcutBindingCopyWith(_ShortcutBinding value, $Res Function(_ShortcutBinding) _then) = __$ShortcutBindingCopyWithImpl;
@override @useResult
$Res call({
 int keyId, bool control, bool alt, bool shift
});




}
/// @nodoc
class __$ShortcutBindingCopyWithImpl<$Res>
    implements _$ShortcutBindingCopyWith<$Res> {
  __$ShortcutBindingCopyWithImpl(this._self, this._then);

  final _ShortcutBinding _self;
  final $Res Function(_ShortcutBinding) _then;

/// Create a copy of ShortcutBinding
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? keyId = null,Object? control = null,Object? alt = null,Object? shift = null,}) {
  return _then(_ShortcutBinding(
keyId: null == keyId ? _self.keyId : keyId // ignore: cast_nullable_to_non_nullable
as int,control: null == control ? _self.control : control // ignore: cast_nullable_to_non_nullable
as bool,alt: null == alt ? _self.alt : alt // ignore: cast_nullable_to_non_nullable
as bool,shift: null == shift ? _self.shift : shift // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
