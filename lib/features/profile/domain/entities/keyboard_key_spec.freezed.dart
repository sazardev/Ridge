// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'keyboard_key_spec.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$KeyboardKeySpec {

 double get x; double get y; double get w; double get h; double get x2; double get y2; double get w2; double get h2; double get rotationAngle; double get rotationX; double get rotationY; String? get label; String? get label2;
/// Create a copy of KeyboardKeySpec
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KeyboardKeySpecCopyWith<KeyboardKeySpec> get copyWith => _$KeyboardKeySpecCopyWithImpl<KeyboardKeySpec>(this as KeyboardKeySpec, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as KeyboardKeySpec;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KeyboardKeySpec&&(identical(other.x, _this.x) || other.x == _this.x)&&(identical(other.y, _this.y) || other.y == _this.y)&&(identical(other.w, _this.w) || other.w == _this.w)&&(identical(other.h, _this.h) || other.h == _this.h)&&(identical(other.x2, _this.x2) || other.x2 == _this.x2)&&(identical(other.y2, _this.y2) || other.y2 == _this.y2)&&(identical(other.w2, _this.w2) || other.w2 == _this.w2)&&(identical(other.h2, _this.h2) || other.h2 == _this.h2)&&(identical(other.rotationAngle, _this.rotationAngle) || other.rotationAngle == _this.rotationAngle)&&(identical(other.rotationX, _this.rotationX) || other.rotationX == _this.rotationX)&&(identical(other.rotationY, _this.rotationY) || other.rotationY == _this.rotationY)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.label2, _this.label2) || other.label2 == _this.label2));
}


@override
int get hashCode {
  final _this = this as KeyboardKeySpec;
  return Object.hash(runtimeType,_this.x,_this.y,_this.w,_this.h,_this.x2,_this.y2,_this.w2,_this.h2,_this.rotationAngle,_this.rotationX,_this.rotationY,_this.label,_this.label2);
}

@override
String toString() {
  final _this = this as KeyboardKeySpec;
  return 'KeyboardKeySpec(x: ${_this.x}, y: ${_this.y}, w: ${_this.w}, h: ${_this.h}, x2: ${_this.x2}, y2: ${_this.y2}, w2: ${_this.w2}, h2: ${_this.h2}, rotationAngle: ${_this.rotationAngle}, rotationX: ${_this.rotationX}, rotationY: ${_this.rotationY}, label: ${_this.label}, label2: ${_this.label2})';
}


}

/// @nodoc
abstract mixin class $KeyboardKeySpecCopyWith<$Res>  {
  factory $KeyboardKeySpecCopyWith(KeyboardKeySpec value, $Res Function(KeyboardKeySpec) _then) = _$KeyboardKeySpecCopyWithImpl;
@useResult
$Res call({
 double x, double y, double w, double h, double x2, double y2, double w2, double h2, double rotationAngle, double rotationX, double rotationY, String? label, String? label2
});




}
/// @nodoc
class _$KeyboardKeySpecCopyWithImpl<$Res>
    implements $KeyboardKeySpecCopyWith<$Res> {
  _$KeyboardKeySpecCopyWithImpl(this._self, this._then);

  final KeyboardKeySpec _self;
  final $Res Function(KeyboardKeySpec) _then;

/// Create a copy of KeyboardKeySpec
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? x = null,Object? y = null,Object? w = null,Object? h = null,Object? x2 = null,Object? y2 = null,Object? w2 = null,Object? h2 = null,Object? rotationAngle = null,Object? rotationX = null,Object? rotationY = null,Object? label = freezed,Object? label2 = freezed,}) {
  return _then(KeyboardKeySpec(
x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,w: null == w ? _self.w : w // ignore: cast_nullable_to_non_nullable
as double,h: null == h ? _self.h : h // ignore: cast_nullable_to_non_nullable
as double,x2: null == x2 ? _self.x2 : x2 // ignore: cast_nullable_to_non_nullable
as double,y2: null == y2 ? _self.y2 : y2 // ignore: cast_nullable_to_non_nullable
as double,w2: null == w2 ? _self.w2 : w2 // ignore: cast_nullable_to_non_nullable
as double,h2: null == h2 ? _self.h2 : h2 // ignore: cast_nullable_to_non_nullable
as double,rotationAngle: null == rotationAngle ? _self.rotationAngle : rotationAngle // ignore: cast_nullable_to_non_nullable
as double,rotationX: null == rotationX ? _self.rotationX : rotationX // ignore: cast_nullable_to_non_nullable
as double,rotationY: null == rotationY ? _self.rotationY : rotationY // ignore: cast_nullable_to_non_nullable
as double,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,label2: freezed == label2 ? _self.label2 : label2 // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [KeyboardKeySpec].
extension KeyboardKeySpecPatterns on KeyboardKeySpec {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KeyboardKeySpec value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KeyboardKeySpec() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KeyboardKeySpec value)  $default,){
final _that = this;
switch (_that) {
case _KeyboardKeySpec():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KeyboardKeySpec value)?  $default,){
final _that = this;
switch (_that) {
case _KeyboardKeySpec() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double x,  double y,  double w,  double h,  double x2,  double y2,  double w2,  double h2,  double rotationAngle,  double rotationX,  double rotationY,  String? label,  String? label2)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KeyboardKeySpec() when $default != null:
return $default(_that.x,_that.y,_that.w,_that.h,_that.x2,_that.y2,_that.w2,_that.h2,_that.rotationAngle,_that.rotationX,_that.rotationY,_that.label,_that.label2);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double x,  double y,  double w,  double h,  double x2,  double y2,  double w2,  double h2,  double rotationAngle,  double rotationX,  double rotationY,  String? label,  String? label2)  $default,) {final _that = this;
switch (_that) {
case _KeyboardKeySpec():
return $default(_that.x,_that.y,_that.w,_that.h,_that.x2,_that.y2,_that.w2,_that.h2,_that.rotationAngle,_that.rotationX,_that.rotationY,_that.label,_that.label2);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double x,  double y,  double w,  double h,  double x2,  double y2,  double w2,  double h2,  double rotationAngle,  double rotationX,  double rotationY,  String? label,  String? label2)?  $default,) {final _that = this;
switch (_that) {
case _KeyboardKeySpec() when $default != null:
return $default(_that.x,_that.y,_that.w,_that.h,_that.x2,_that.y2,_that.w2,_that.h2,_that.rotationAngle,_that.rotationX,_that.rotationY,_that.label,_that.label2);case _:
  return null;

}
}

}

/// @nodoc


class _KeyboardKeySpec implements KeyboardKeySpec {
  const _KeyboardKeySpec({required this.x, required this.y, required this.w, required this.h, required this.x2, required this.y2, required this.w2, required this.h2, required this.rotationAngle, required this.rotationX, required this.rotationY, this.label, this.label2});
  

@override final  double x;
@override final  double y;
@override final  double w;
@override final  double h;
@override final  double x2;
@override final  double y2;
@override final  double w2;
@override final  double h2;
@override final  double rotationAngle;
@override final  double rotationX;
@override final  double rotationY;
@override final  String? label;
@override final  String? label2;

/// Create a copy of KeyboardKeySpec
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KeyboardKeySpecCopyWith<_KeyboardKeySpec> get copyWith => __$KeyboardKeySpecCopyWithImpl<_KeyboardKeySpec>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _KeyboardKeySpec&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.w, w) || other.w == w)&&(identical(other.h, h) || other.h == h)&&(identical(other.x2, x2) || other.x2 == x2)&&(identical(other.y2, y2) || other.y2 == y2)&&(identical(other.w2, w2) || other.w2 == w2)&&(identical(other.h2, h2) || other.h2 == h2)&&(identical(other.rotationAngle, rotationAngle) || other.rotationAngle == rotationAngle)&&(identical(other.rotationX, rotationX) || other.rotationX == rotationX)&&(identical(other.rotationY, rotationY) || other.rotationY == rotationY)&&(identical(other.label, label) || other.label == label)&&(identical(other.label2, label2) || other.label2 == label2));
}


@override
int get hashCode {
    return Object.hash(runtimeType,x,y,w,h,x2,y2,w2,h2,rotationAngle,rotationX,rotationY,label,label2);
}

@override
String toString() {
    return 'KeyboardKeySpec(x: $x, y: $y, w: $w, h: $h, x2: $x2, y2: $y2, w2: $w2, h2: $h2, rotationAngle: $rotationAngle, rotationX: $rotationX, rotationY: $rotationY, label: $label, label2: $label2)';
}


}

/// @nodoc
abstract mixin class _$KeyboardKeySpecCopyWith<$Res> implements $KeyboardKeySpecCopyWith<$Res> {
  factory _$KeyboardKeySpecCopyWith(_KeyboardKeySpec value, $Res Function(_KeyboardKeySpec) _then) = __$KeyboardKeySpecCopyWithImpl;
@override @useResult
$Res call({
 double x, double y, double w, double h, double x2, double y2, double w2, double h2, double rotationAngle, double rotationX, double rotationY, String? label, String? label2
});




}
/// @nodoc
class __$KeyboardKeySpecCopyWithImpl<$Res>
    implements _$KeyboardKeySpecCopyWith<$Res> {
  __$KeyboardKeySpecCopyWithImpl(this._self, this._then);

  final _KeyboardKeySpec _self;
  final $Res Function(_KeyboardKeySpec) _then;

/// Create a copy of KeyboardKeySpec
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? x = null,Object? y = null,Object? w = null,Object? h = null,Object? x2 = null,Object? y2 = null,Object? w2 = null,Object? h2 = null,Object? rotationAngle = null,Object? rotationX = null,Object? rotationY = null,Object? label = freezed,Object? label2 = freezed,}) {
  return _then(_KeyboardKeySpec(
x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,w: null == w ? _self.w : w // ignore: cast_nullable_to_non_nullable
as double,h: null == h ? _self.h : h // ignore: cast_nullable_to_non_nullable
as double,x2: null == x2 ? _self.x2 : x2 // ignore: cast_nullable_to_non_nullable
as double,y2: null == y2 ? _self.y2 : y2 // ignore: cast_nullable_to_non_nullable
as double,w2: null == w2 ? _self.w2 : w2 // ignore: cast_nullable_to_non_nullable
as double,h2: null == h2 ? _self.h2 : h2 // ignore: cast_nullable_to_non_nullable
as double,rotationAngle: null == rotationAngle ? _self.rotationAngle : rotationAngle // ignore: cast_nullable_to_non_nullable
as double,rotationX: null == rotationX ? _self.rotationX : rotationX // ignore: cast_nullable_to_non_nullable
as double,rotationY: null == rotationY ? _self.rotationY : rotationY // ignore: cast_nullable_to_non_nullable
as double,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,label2: freezed == label2 ? _self.label2 : label2 // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
