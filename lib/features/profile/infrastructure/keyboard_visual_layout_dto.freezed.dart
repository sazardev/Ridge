// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'keyboard_visual_layout_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KeyboardKeySpecDto {

 double get x; double get y; double get w; double get h; double? get x2; double? get y2; double? get w2; double? get h2;@JsonKey(name: 'r') double get rotationAngle;@JsonKey(name: 'rx') double? get rotationX;@JsonKey(name: 'ry') double? get rotationY; String? get label; String? get label2;
/// Create a copy of KeyboardKeySpecDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KeyboardKeySpecDtoCopyWith<KeyboardKeySpecDto> get copyWith => _$KeyboardKeySpecDtoCopyWithImpl<KeyboardKeySpecDto>(this as KeyboardKeySpecDto, _$identity);

  /// Serializes this KeyboardKeySpecDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as KeyboardKeySpecDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KeyboardKeySpecDto&&(identical(other.x, _this.x) || other.x == _this.x)&&(identical(other.y, _this.y) || other.y == _this.y)&&(identical(other.w, _this.w) || other.w == _this.w)&&(identical(other.h, _this.h) || other.h == _this.h)&&(identical(other.x2, _this.x2) || other.x2 == _this.x2)&&(identical(other.y2, _this.y2) || other.y2 == _this.y2)&&(identical(other.w2, _this.w2) || other.w2 == _this.w2)&&(identical(other.h2, _this.h2) || other.h2 == _this.h2)&&(identical(other.rotationAngle, _this.rotationAngle) || other.rotationAngle == _this.rotationAngle)&&(identical(other.rotationX, _this.rotationX) || other.rotationX == _this.rotationX)&&(identical(other.rotationY, _this.rotationY) || other.rotationY == _this.rotationY)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.label2, _this.label2) || other.label2 == _this.label2));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as KeyboardKeySpecDto;
  return Object.hash(runtimeType,_this.x,_this.y,_this.w,_this.h,_this.x2,_this.y2,_this.w2,_this.h2,_this.rotationAngle,_this.rotationX,_this.rotationY,_this.label,_this.label2);
}

@override
String toString() {
  final _this = this as KeyboardKeySpecDto;
  return 'KeyboardKeySpecDto(x: ${_this.x}, y: ${_this.y}, w: ${_this.w}, h: ${_this.h}, x2: ${_this.x2}, y2: ${_this.y2}, w2: ${_this.w2}, h2: ${_this.h2}, rotationAngle: ${_this.rotationAngle}, rotationX: ${_this.rotationX}, rotationY: ${_this.rotationY}, label: ${_this.label}, label2: ${_this.label2})';
}


}

/// @nodoc
abstract mixin class $KeyboardKeySpecDtoCopyWith<$Res>  {
  factory $KeyboardKeySpecDtoCopyWith(KeyboardKeySpecDto value, $Res Function(KeyboardKeySpecDto) _then) = _$KeyboardKeySpecDtoCopyWithImpl;
@useResult
$Res call({
 double x, double y, double w, double h, double? x2, double? y2, double? w2, double? h2,@JsonKey(name: 'r') double rotationAngle,@JsonKey(name: 'rx') double? rotationX,@JsonKey(name: 'ry') double? rotationY, String? label, String? label2
});




}
/// @nodoc
class _$KeyboardKeySpecDtoCopyWithImpl<$Res>
    implements $KeyboardKeySpecDtoCopyWith<$Res> {
  _$KeyboardKeySpecDtoCopyWithImpl(this._self, this._then);

  final KeyboardKeySpecDto _self;
  final $Res Function(KeyboardKeySpecDto) _then;

/// Create a copy of KeyboardKeySpecDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? x = null,Object? y = null,Object? w = null,Object? h = null,Object? x2 = freezed,Object? y2 = freezed,Object? w2 = freezed,Object? h2 = freezed,Object? rotationAngle = null,Object? rotationX = freezed,Object? rotationY = freezed,Object? label = freezed,Object? label2 = freezed,}) {
  return _then(KeyboardKeySpecDto(
x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,w: null == w ? _self.w : w // ignore: cast_nullable_to_non_nullable
as double,h: null == h ? _self.h : h // ignore: cast_nullable_to_non_nullable
as double,x2: freezed == x2 ? _self.x2 : x2 // ignore: cast_nullable_to_non_nullable
as double?,y2: freezed == y2 ? _self.y2 : y2 // ignore: cast_nullable_to_non_nullable
as double?,w2: freezed == w2 ? _self.w2 : w2 // ignore: cast_nullable_to_non_nullable
as double?,h2: freezed == h2 ? _self.h2 : h2 // ignore: cast_nullable_to_non_nullable
as double?,rotationAngle: null == rotationAngle ? _self.rotationAngle : rotationAngle // ignore: cast_nullable_to_non_nullable
as double,rotationX: freezed == rotationX ? _self.rotationX : rotationX // ignore: cast_nullable_to_non_nullable
as double?,rotationY: freezed == rotationY ? _self.rotationY : rotationY // ignore: cast_nullable_to_non_nullable
as double?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,label2: freezed == label2 ? _self.label2 : label2 // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [KeyboardKeySpecDto].
extension KeyboardKeySpecDtoPatterns on KeyboardKeySpecDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KeyboardKeySpecDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KeyboardKeySpecDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KeyboardKeySpecDto value)  $default,){
final _that = this;
switch (_that) {
case _KeyboardKeySpecDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KeyboardKeySpecDto value)?  $default,){
final _that = this;
switch (_that) {
case _KeyboardKeySpecDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double x,  double y,  double w,  double h,  double? x2,  double? y2,  double? w2,  double? h2, @JsonKey(name: 'r')  double rotationAngle, @JsonKey(name: 'rx')  double? rotationX, @JsonKey(name: 'ry')  double? rotationY,  String? label,  String? label2)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KeyboardKeySpecDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double x,  double y,  double w,  double h,  double? x2,  double? y2,  double? w2,  double? h2, @JsonKey(name: 'r')  double rotationAngle, @JsonKey(name: 'rx')  double? rotationX, @JsonKey(name: 'ry')  double? rotationY,  String? label,  String? label2)  $default,) {final _that = this;
switch (_that) {
case _KeyboardKeySpecDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double x,  double y,  double w,  double h,  double? x2,  double? y2,  double? w2,  double? h2, @JsonKey(name: 'r')  double rotationAngle, @JsonKey(name: 'rx')  double? rotationX, @JsonKey(name: 'ry')  double? rotationY,  String? label,  String? label2)?  $default,) {final _that = this;
switch (_that) {
case _KeyboardKeySpecDto() when $default != null:
return $default(_that.x,_that.y,_that.w,_that.h,_that.x2,_that.y2,_that.w2,_that.h2,_that.rotationAngle,_that.rotationX,_that.rotationY,_that.label,_that.label2);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KeyboardKeySpecDto implements KeyboardKeySpecDto {
  const _KeyboardKeySpecDto({required this.x, required this.y, this.w = 1, this.h = 1, this.x2, this.y2, this.w2, this.h2, @JsonKey(name: 'r') this.rotationAngle = 0, @JsonKey(name: 'rx') this.rotationX, @JsonKey(name: 'ry') this.rotationY, this.label, this.label2});
  factory _KeyboardKeySpecDto.fromJson(Map<String, dynamic> json) => _$KeyboardKeySpecDtoFromJson(json);

@override final  double x;
@override final  double y;
@override@JsonKey() final  double w;
@override@JsonKey() final  double h;
@override final  double? x2;
@override final  double? y2;
@override final  double? w2;
@override final  double? h2;
@override@JsonKey(name: 'r') final  double rotationAngle;
@override@JsonKey(name: 'rx') final  double? rotationX;
@override@JsonKey(name: 'ry') final  double? rotationY;
@override final  String? label;
@override final  String? label2;

/// Create a copy of KeyboardKeySpecDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KeyboardKeySpecDtoCopyWith<_KeyboardKeySpecDto> get copyWith => __$KeyboardKeySpecDtoCopyWithImpl<_KeyboardKeySpecDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KeyboardKeySpecDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _KeyboardKeySpecDto&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.w, w) || other.w == w)&&(identical(other.h, h) || other.h == h)&&(identical(other.x2, x2) || other.x2 == x2)&&(identical(other.y2, y2) || other.y2 == y2)&&(identical(other.w2, w2) || other.w2 == w2)&&(identical(other.h2, h2) || other.h2 == h2)&&(identical(other.rotationAngle, rotationAngle) || other.rotationAngle == rotationAngle)&&(identical(other.rotationX, rotationX) || other.rotationX == rotationX)&&(identical(other.rotationY, rotationY) || other.rotationY == rotationY)&&(identical(other.label, label) || other.label == label)&&(identical(other.label2, label2) || other.label2 == label2));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,x,y,w,h,x2,y2,w2,h2,rotationAngle,rotationX,rotationY,label,label2);
}

@override
String toString() {
    return 'KeyboardKeySpecDto(x: $x, y: $y, w: $w, h: $h, x2: $x2, y2: $y2, w2: $w2, h2: $h2, rotationAngle: $rotationAngle, rotationX: $rotationX, rotationY: $rotationY, label: $label, label2: $label2)';
}


}

/// @nodoc
abstract mixin class _$KeyboardKeySpecDtoCopyWith<$Res> implements $KeyboardKeySpecDtoCopyWith<$Res> {
  factory _$KeyboardKeySpecDtoCopyWith(_KeyboardKeySpecDto value, $Res Function(_KeyboardKeySpecDto) _then) = __$KeyboardKeySpecDtoCopyWithImpl;
@override @useResult
$Res call({
 double x, double y, double w, double h, double? x2, double? y2, double? w2, double? h2,@JsonKey(name: 'r') double rotationAngle,@JsonKey(name: 'rx') double? rotationX,@JsonKey(name: 'ry') double? rotationY, String? label, String? label2
});




}
/// @nodoc
class __$KeyboardKeySpecDtoCopyWithImpl<$Res>
    implements _$KeyboardKeySpecDtoCopyWith<$Res> {
  __$KeyboardKeySpecDtoCopyWithImpl(this._self, this._then);

  final _KeyboardKeySpecDto _self;
  final $Res Function(_KeyboardKeySpecDto) _then;

/// Create a copy of KeyboardKeySpecDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? x = null,Object? y = null,Object? w = null,Object? h = null,Object? x2 = freezed,Object? y2 = freezed,Object? w2 = freezed,Object? h2 = freezed,Object? rotationAngle = null,Object? rotationX = freezed,Object? rotationY = freezed,Object? label = freezed,Object? label2 = freezed,}) {
  return _then(_KeyboardKeySpecDto(
x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,w: null == w ? _self.w : w // ignore: cast_nullable_to_non_nullable
as double,h: null == h ? _self.h : h // ignore: cast_nullable_to_non_nullable
as double,x2: freezed == x2 ? _self.x2 : x2 // ignore: cast_nullable_to_non_nullable
as double?,y2: freezed == y2 ? _self.y2 : y2 // ignore: cast_nullable_to_non_nullable
as double?,w2: freezed == w2 ? _self.w2 : w2 // ignore: cast_nullable_to_non_nullable
as double?,h2: freezed == h2 ? _self.h2 : h2 // ignore: cast_nullable_to_non_nullable
as double?,rotationAngle: null == rotationAngle ? _self.rotationAngle : rotationAngle // ignore: cast_nullable_to_non_nullable
as double,rotationX: freezed == rotationX ? _self.rotationX : rotationX // ignore: cast_nullable_to_non_nullable
as double?,rotationY: freezed == rotationY ? _self.rotationY : rotationY // ignore: cast_nullable_to_non_nullable
as double?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,label2: freezed == label2 ? _self.label2 : label2 // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$KeyboardVisualLayoutDto {

 String get model; List<KeyboardKeySpecDto> get keys;
/// Create a copy of KeyboardVisualLayoutDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KeyboardVisualLayoutDtoCopyWith<KeyboardVisualLayoutDto> get copyWith => _$KeyboardVisualLayoutDtoCopyWithImpl<KeyboardVisualLayoutDto>(this as KeyboardVisualLayoutDto, _$identity);

  /// Serializes this KeyboardVisualLayoutDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as KeyboardVisualLayoutDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KeyboardVisualLayoutDto&&(identical(other.model, _this.model) || other.model == _this.model)&&const DeepCollectionEquality().equals(other.keys, _this.keys));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as KeyboardVisualLayoutDto;
  return Object.hash(runtimeType,_this.model,const DeepCollectionEquality().hash(_this.keys));
}

@override
String toString() {
  final _this = this as KeyboardVisualLayoutDto;
  return 'KeyboardVisualLayoutDto(model: ${_this.model}, keys: ${_this.keys})';
}


}

/// @nodoc
abstract mixin class $KeyboardVisualLayoutDtoCopyWith<$Res>  {
  factory $KeyboardVisualLayoutDtoCopyWith(KeyboardVisualLayoutDto value, $Res Function(KeyboardVisualLayoutDto) _then) = _$KeyboardVisualLayoutDtoCopyWithImpl;
@useResult
$Res call({
 String model, List<KeyboardKeySpecDto> keys
});




}
/// @nodoc
class _$KeyboardVisualLayoutDtoCopyWithImpl<$Res>
    implements $KeyboardVisualLayoutDtoCopyWith<$Res> {
  _$KeyboardVisualLayoutDtoCopyWithImpl(this._self, this._then);

  final KeyboardVisualLayoutDto _self;
  final $Res Function(KeyboardVisualLayoutDto) _then;

/// Create a copy of KeyboardVisualLayoutDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? model = null,Object? keys = null,}) {
  return _then(KeyboardVisualLayoutDto(
model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,keys: null == keys ? _self.keys : keys // ignore: cast_nullable_to_non_nullable
as List<KeyboardKeySpecDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [KeyboardVisualLayoutDto].
extension KeyboardVisualLayoutDtoPatterns on KeyboardVisualLayoutDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KeyboardVisualLayoutDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KeyboardVisualLayoutDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KeyboardVisualLayoutDto value)  $default,){
final _that = this;
switch (_that) {
case _KeyboardVisualLayoutDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KeyboardVisualLayoutDto value)?  $default,){
final _that = this;
switch (_that) {
case _KeyboardVisualLayoutDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String model,  List<KeyboardKeySpecDto> keys)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KeyboardVisualLayoutDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String model,  List<KeyboardKeySpecDto> keys)  $default,) {final _that = this;
switch (_that) {
case _KeyboardVisualLayoutDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String model,  List<KeyboardKeySpecDto> keys)?  $default,) {final _that = this;
switch (_that) {
case _KeyboardVisualLayoutDto() when $default != null:
return $default(_that.model,_that.keys);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KeyboardVisualLayoutDto implements KeyboardVisualLayoutDto {
  const _KeyboardVisualLayoutDto({required this.model, required  List<KeyboardKeySpecDto> keys}): _keys = keys;
  factory _KeyboardVisualLayoutDto.fromJson(Map<String, dynamic> json) => _$KeyboardVisualLayoutDtoFromJson(json);

@override final  String model;
 final  List<KeyboardKeySpecDto> _keys;
@override List<KeyboardKeySpecDto> get keys {
  if (_keys is EqualUnmodifiableListView) return _keys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_keys);
}


/// Create a copy of KeyboardVisualLayoutDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KeyboardVisualLayoutDtoCopyWith<_KeyboardVisualLayoutDto> get copyWith => __$KeyboardVisualLayoutDtoCopyWithImpl<_KeyboardVisualLayoutDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KeyboardVisualLayoutDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _KeyboardVisualLayoutDto&&(identical(other.model, model) || other.model == model)&&const DeepCollectionEquality().equals(other.keys, _keys));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,model,const DeepCollectionEquality().hash(_keys));
}

@override
String toString() {
    return 'KeyboardVisualLayoutDto(model: $model, keys: $keys)';
}


}

/// @nodoc
abstract mixin class _$KeyboardVisualLayoutDtoCopyWith<$Res> implements $KeyboardVisualLayoutDtoCopyWith<$Res> {
  factory _$KeyboardVisualLayoutDtoCopyWith(_KeyboardVisualLayoutDto value, $Res Function(_KeyboardVisualLayoutDto) _then) = __$KeyboardVisualLayoutDtoCopyWithImpl;
@override @useResult
$Res call({
 String model, List<KeyboardKeySpecDto> keys
});




}
/// @nodoc
class __$KeyboardVisualLayoutDtoCopyWithImpl<$Res>
    implements _$KeyboardVisualLayoutDtoCopyWith<$Res> {
  __$KeyboardVisualLayoutDtoCopyWithImpl(this._self, this._then);

  final _KeyboardVisualLayoutDto _self;
  final $Res Function(_KeyboardVisualLayoutDto) _then;

/// Create a copy of KeyboardVisualLayoutDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? model = null,Object? keys = null,}) {
  return _then(_KeyboardVisualLayoutDto(
model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,keys: null == keys ? _self._keys : keys // ignore: cast_nullable_to_non_nullable
as List<KeyboardKeySpecDto>,
  ));
}


}

// dart format on
