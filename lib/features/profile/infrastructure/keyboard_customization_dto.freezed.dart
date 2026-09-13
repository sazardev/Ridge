// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'keyboard_customization_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KeyboardCustomizationDto {

 String? get shapeFamily; String? get keycapShape; String? get keycapTransparency; int? get keycapColor; int? get caseColor; bool get rgbEnabled; String? get rgbEffect; int? get rgbColor; String? get switchType; String? get keycapMaterial; String? get caseMaterial; String? get physicalLayout; String? get connection; bool? get hotSwappable; int? get purchaseYear; String? get notes; List<KeyboardKeyOverrideDto> get keyOverrides; List<KeyboardExtraKeyDto> get extraKeys; List<KeyboardKeyRemapDto> get remaps; List<KeyboardKeyLightDto> get keyLights;
/// Create a copy of KeyboardCustomizationDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KeyboardCustomizationDtoCopyWith<KeyboardCustomizationDto> get copyWith => _$KeyboardCustomizationDtoCopyWithImpl<KeyboardCustomizationDto>(this as KeyboardCustomizationDto, _$identity);

  /// Serializes this KeyboardCustomizationDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as KeyboardCustomizationDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KeyboardCustomizationDto&&(identical(other.shapeFamily, _this.shapeFamily) || other.shapeFamily == _this.shapeFamily)&&(identical(other.keycapShape, _this.keycapShape) || other.keycapShape == _this.keycapShape)&&(identical(other.keycapTransparency, _this.keycapTransparency) || other.keycapTransparency == _this.keycapTransparency)&&(identical(other.keycapColor, _this.keycapColor) || other.keycapColor == _this.keycapColor)&&(identical(other.caseColor, _this.caseColor) || other.caseColor == _this.caseColor)&&(identical(other.rgbEnabled, _this.rgbEnabled) || other.rgbEnabled == _this.rgbEnabled)&&(identical(other.rgbEffect, _this.rgbEffect) || other.rgbEffect == _this.rgbEffect)&&(identical(other.rgbColor, _this.rgbColor) || other.rgbColor == _this.rgbColor)&&(identical(other.switchType, _this.switchType) || other.switchType == _this.switchType)&&(identical(other.keycapMaterial, _this.keycapMaterial) || other.keycapMaterial == _this.keycapMaterial)&&(identical(other.caseMaterial, _this.caseMaterial) || other.caseMaterial == _this.caseMaterial)&&(identical(other.physicalLayout, _this.physicalLayout) || other.physicalLayout == _this.physicalLayout)&&(identical(other.connection, _this.connection) || other.connection == _this.connection)&&(identical(other.hotSwappable, _this.hotSwappable) || other.hotSwappable == _this.hotSwappable)&&(identical(other.purchaseYear, _this.purchaseYear) || other.purchaseYear == _this.purchaseYear)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&const DeepCollectionEquality().equals(other.keyOverrides, _this.keyOverrides)&&const DeepCollectionEquality().equals(other.extraKeys, _this.extraKeys)&&const DeepCollectionEquality().equals(other.remaps, _this.remaps)&&const DeepCollectionEquality().equals(other.keyLights, _this.keyLights));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as KeyboardCustomizationDto;
  return Object.hashAll([runtimeType,_this.shapeFamily,_this.keycapShape,_this.keycapTransparency,_this.keycapColor,_this.caseColor,_this.rgbEnabled,_this.rgbEffect,_this.rgbColor,_this.switchType,_this.keycapMaterial,_this.caseMaterial,_this.physicalLayout,_this.connection,_this.hotSwappable,_this.purchaseYear,_this.notes,const DeepCollectionEquality().hash(_this.keyOverrides),const DeepCollectionEquality().hash(_this.extraKeys),const DeepCollectionEquality().hash(_this.remaps),const DeepCollectionEquality().hash(_this.keyLights)]);
}

@override
String toString() {
  final _this = this as KeyboardCustomizationDto;
  return 'KeyboardCustomizationDto(shapeFamily: ${_this.shapeFamily}, keycapShape: ${_this.keycapShape}, keycapTransparency: ${_this.keycapTransparency}, keycapColor: ${_this.keycapColor}, caseColor: ${_this.caseColor}, rgbEnabled: ${_this.rgbEnabled}, rgbEffect: ${_this.rgbEffect}, rgbColor: ${_this.rgbColor}, switchType: ${_this.switchType}, keycapMaterial: ${_this.keycapMaterial}, caseMaterial: ${_this.caseMaterial}, physicalLayout: ${_this.physicalLayout}, connection: ${_this.connection}, hotSwappable: ${_this.hotSwappable}, purchaseYear: ${_this.purchaseYear}, notes: ${_this.notes}, keyOverrides: ${_this.keyOverrides}, extraKeys: ${_this.extraKeys}, remaps: ${_this.remaps}, keyLights: ${_this.keyLights})';
}


}

/// @nodoc
abstract mixin class $KeyboardCustomizationDtoCopyWith<$Res>  {
  factory $KeyboardCustomizationDtoCopyWith(KeyboardCustomizationDto value, $Res Function(KeyboardCustomizationDto) _then) = _$KeyboardCustomizationDtoCopyWithImpl;
@useResult
$Res call({
 String? shapeFamily, String? keycapShape, String? keycapTransparency, int? keycapColor, int? caseColor, bool rgbEnabled, String? rgbEffect, int? rgbColor, String? switchType, String? keycapMaterial, String? caseMaterial, String? physicalLayout, String? connection, bool? hotSwappable, int? purchaseYear, String? notes, List<KeyboardKeyOverrideDto> keyOverrides, List<KeyboardExtraKeyDto> extraKeys, List<KeyboardKeyRemapDto> remaps, List<KeyboardKeyLightDto> keyLights
});




}
/// @nodoc
class _$KeyboardCustomizationDtoCopyWithImpl<$Res>
    implements $KeyboardCustomizationDtoCopyWith<$Res> {
  _$KeyboardCustomizationDtoCopyWithImpl(this._self, this._then);

  final KeyboardCustomizationDto _self;
  final $Res Function(KeyboardCustomizationDto) _then;

/// Create a copy of KeyboardCustomizationDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? shapeFamily = freezed,Object? keycapShape = freezed,Object? keycapTransparency = freezed,Object? keycapColor = freezed,Object? caseColor = freezed,Object? rgbEnabled = null,Object? rgbEffect = freezed,Object? rgbColor = freezed,Object? switchType = freezed,Object? keycapMaterial = freezed,Object? caseMaterial = freezed,Object? physicalLayout = freezed,Object? connection = freezed,Object? hotSwappable = freezed,Object? purchaseYear = freezed,Object? notes = freezed,Object? keyOverrides = null,Object? extraKeys = null,Object? remaps = null,Object? keyLights = null,}) {
  return _then(KeyboardCustomizationDto(
shapeFamily: freezed == shapeFamily ? _self.shapeFamily : shapeFamily // ignore: cast_nullable_to_non_nullable
as String?,keycapShape: freezed == keycapShape ? _self.keycapShape : keycapShape // ignore: cast_nullable_to_non_nullable
as String?,keycapTransparency: freezed == keycapTransparency ? _self.keycapTransparency : keycapTransparency // ignore: cast_nullable_to_non_nullable
as String?,keycapColor: freezed == keycapColor ? _self.keycapColor : keycapColor // ignore: cast_nullable_to_non_nullable
as int?,caseColor: freezed == caseColor ? _self.caseColor : caseColor // ignore: cast_nullable_to_non_nullable
as int?,rgbEnabled: null == rgbEnabled ? _self.rgbEnabled : rgbEnabled // ignore: cast_nullable_to_non_nullable
as bool,rgbEffect: freezed == rgbEffect ? _self.rgbEffect : rgbEffect // ignore: cast_nullable_to_non_nullable
as String?,rgbColor: freezed == rgbColor ? _self.rgbColor : rgbColor // ignore: cast_nullable_to_non_nullable
as int?,switchType: freezed == switchType ? _self.switchType : switchType // ignore: cast_nullable_to_non_nullable
as String?,keycapMaterial: freezed == keycapMaterial ? _self.keycapMaterial : keycapMaterial // ignore: cast_nullable_to_non_nullable
as String?,caseMaterial: freezed == caseMaterial ? _self.caseMaterial : caseMaterial // ignore: cast_nullable_to_non_nullable
as String?,physicalLayout: freezed == physicalLayout ? _self.physicalLayout : physicalLayout // ignore: cast_nullable_to_non_nullable
as String?,connection: freezed == connection ? _self.connection : connection // ignore: cast_nullable_to_non_nullable
as String?,hotSwappable: freezed == hotSwappable ? _self.hotSwappable : hotSwappable // ignore: cast_nullable_to_non_nullable
as bool?,purchaseYear: freezed == purchaseYear ? _self.purchaseYear : purchaseYear // ignore: cast_nullable_to_non_nullable
as int?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,keyOverrides: null == keyOverrides ? _self.keyOverrides : keyOverrides // ignore: cast_nullable_to_non_nullable
as List<KeyboardKeyOverrideDto>,extraKeys: null == extraKeys ? _self.extraKeys : extraKeys // ignore: cast_nullable_to_non_nullable
as List<KeyboardExtraKeyDto>,remaps: null == remaps ? _self.remaps : remaps // ignore: cast_nullable_to_non_nullable
as List<KeyboardKeyRemapDto>,keyLights: null == keyLights ? _self.keyLights : keyLights // ignore: cast_nullable_to_non_nullable
as List<KeyboardKeyLightDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [KeyboardCustomizationDto].
extension KeyboardCustomizationDtoPatterns on KeyboardCustomizationDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KeyboardCustomizationDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KeyboardCustomizationDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KeyboardCustomizationDto value)  $default,){
final _that = this;
switch (_that) {
case _KeyboardCustomizationDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KeyboardCustomizationDto value)?  $default,){
final _that = this;
switch (_that) {
case _KeyboardCustomizationDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? shapeFamily,  String? keycapShape,  String? keycapTransparency,  int? keycapColor,  int? caseColor,  bool rgbEnabled,  String? rgbEffect,  int? rgbColor,  String? switchType,  String? keycapMaterial,  String? caseMaterial,  String? physicalLayout,  String? connection,  bool? hotSwappable,  int? purchaseYear,  String? notes,  List<KeyboardKeyOverrideDto> keyOverrides,  List<KeyboardExtraKeyDto> extraKeys,  List<KeyboardKeyRemapDto> remaps,  List<KeyboardKeyLightDto> keyLights)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KeyboardCustomizationDto() when $default != null:
return $default(_that.shapeFamily,_that.keycapShape,_that.keycapTransparency,_that.keycapColor,_that.caseColor,_that.rgbEnabled,_that.rgbEffect,_that.rgbColor,_that.switchType,_that.keycapMaterial,_that.caseMaterial,_that.physicalLayout,_that.connection,_that.hotSwappable,_that.purchaseYear,_that.notes,_that.keyOverrides,_that.extraKeys,_that.remaps,_that.keyLights);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? shapeFamily,  String? keycapShape,  String? keycapTransparency,  int? keycapColor,  int? caseColor,  bool rgbEnabled,  String? rgbEffect,  int? rgbColor,  String? switchType,  String? keycapMaterial,  String? caseMaterial,  String? physicalLayout,  String? connection,  bool? hotSwappable,  int? purchaseYear,  String? notes,  List<KeyboardKeyOverrideDto> keyOverrides,  List<KeyboardExtraKeyDto> extraKeys,  List<KeyboardKeyRemapDto> remaps,  List<KeyboardKeyLightDto> keyLights)  $default,) {final _that = this;
switch (_that) {
case _KeyboardCustomizationDto():
return $default(_that.shapeFamily,_that.keycapShape,_that.keycapTransparency,_that.keycapColor,_that.caseColor,_that.rgbEnabled,_that.rgbEffect,_that.rgbColor,_that.switchType,_that.keycapMaterial,_that.caseMaterial,_that.physicalLayout,_that.connection,_that.hotSwappable,_that.purchaseYear,_that.notes,_that.keyOverrides,_that.extraKeys,_that.remaps,_that.keyLights);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? shapeFamily,  String? keycapShape,  String? keycapTransparency,  int? keycapColor,  int? caseColor,  bool rgbEnabled,  String? rgbEffect,  int? rgbColor,  String? switchType,  String? keycapMaterial,  String? caseMaterial,  String? physicalLayout,  String? connection,  bool? hotSwappable,  int? purchaseYear,  String? notes,  List<KeyboardKeyOverrideDto> keyOverrides,  List<KeyboardExtraKeyDto> extraKeys,  List<KeyboardKeyRemapDto> remaps,  List<KeyboardKeyLightDto> keyLights)?  $default,) {final _that = this;
switch (_that) {
case _KeyboardCustomizationDto() when $default != null:
return $default(_that.shapeFamily,_that.keycapShape,_that.keycapTransparency,_that.keycapColor,_that.caseColor,_that.rgbEnabled,_that.rgbEffect,_that.rgbColor,_that.switchType,_that.keycapMaterial,_that.caseMaterial,_that.physicalLayout,_that.connection,_that.hotSwappable,_that.purchaseYear,_that.notes,_that.keyOverrides,_that.extraKeys,_that.remaps,_that.keyLights);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KeyboardCustomizationDto implements KeyboardCustomizationDto {
  const _KeyboardCustomizationDto({this.shapeFamily, this.keycapShape, this.keycapTransparency, this.keycapColor, this.caseColor, this.rgbEnabled = false, this.rgbEffect, this.rgbColor, this.switchType, this.keycapMaterial, this.caseMaterial, this.physicalLayout, this.connection, this.hotSwappable, this.purchaseYear, this.notes,  List<KeyboardKeyOverrideDto> keyOverrides = const <KeyboardKeyOverrideDto>[],  List<KeyboardExtraKeyDto> extraKeys = const <KeyboardExtraKeyDto>[],  List<KeyboardKeyRemapDto> remaps = const <KeyboardKeyRemapDto>[],  List<KeyboardKeyLightDto> keyLights = const <KeyboardKeyLightDto>[]}): _keyOverrides = keyOverrides,_extraKeys = extraKeys,_remaps = remaps,_keyLights = keyLights;
  factory _KeyboardCustomizationDto.fromJson(Map<String, dynamic> json) => _$KeyboardCustomizationDtoFromJson(json);

@override final  String? shapeFamily;
@override final  String? keycapShape;
@override final  String? keycapTransparency;
@override final  int? keycapColor;
@override final  int? caseColor;
@override@JsonKey() final  bool rgbEnabled;
@override final  String? rgbEffect;
@override final  int? rgbColor;
@override final  String? switchType;
@override final  String? keycapMaterial;
@override final  String? caseMaterial;
@override final  String? physicalLayout;
@override final  String? connection;
@override final  bool? hotSwappable;
@override final  int? purchaseYear;
@override final  String? notes;
 final  List<KeyboardKeyOverrideDto> _keyOverrides;
@override@JsonKey() List<KeyboardKeyOverrideDto> get keyOverrides {
  if (_keyOverrides is EqualUnmodifiableListView) return _keyOverrides;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_keyOverrides);
}

 final  List<KeyboardExtraKeyDto> _extraKeys;
@override@JsonKey() List<KeyboardExtraKeyDto> get extraKeys {
  if (_extraKeys is EqualUnmodifiableListView) return _extraKeys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_extraKeys);
}

 final  List<KeyboardKeyRemapDto> _remaps;
@override@JsonKey() List<KeyboardKeyRemapDto> get remaps {
  if (_remaps is EqualUnmodifiableListView) return _remaps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_remaps);
}

 final  List<KeyboardKeyLightDto> _keyLights;
@override@JsonKey() List<KeyboardKeyLightDto> get keyLights {
  if (_keyLights is EqualUnmodifiableListView) return _keyLights;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_keyLights);
}


/// Create a copy of KeyboardCustomizationDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KeyboardCustomizationDtoCopyWith<_KeyboardCustomizationDto> get copyWith => __$KeyboardCustomizationDtoCopyWithImpl<_KeyboardCustomizationDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KeyboardCustomizationDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _KeyboardCustomizationDto&&(identical(other.shapeFamily, shapeFamily) || other.shapeFamily == shapeFamily)&&(identical(other.keycapShape, keycapShape) || other.keycapShape == keycapShape)&&(identical(other.keycapTransparency, keycapTransparency) || other.keycapTransparency == keycapTransparency)&&(identical(other.keycapColor, keycapColor) || other.keycapColor == keycapColor)&&(identical(other.caseColor, caseColor) || other.caseColor == caseColor)&&(identical(other.rgbEnabled, rgbEnabled) || other.rgbEnabled == rgbEnabled)&&(identical(other.rgbEffect, rgbEffect) || other.rgbEffect == rgbEffect)&&(identical(other.rgbColor, rgbColor) || other.rgbColor == rgbColor)&&(identical(other.switchType, switchType) || other.switchType == switchType)&&(identical(other.keycapMaterial, keycapMaterial) || other.keycapMaterial == keycapMaterial)&&(identical(other.caseMaterial, caseMaterial) || other.caseMaterial == caseMaterial)&&(identical(other.physicalLayout, physicalLayout) || other.physicalLayout == physicalLayout)&&(identical(other.connection, connection) || other.connection == connection)&&(identical(other.hotSwappable, hotSwappable) || other.hotSwappable == hotSwappable)&&(identical(other.purchaseYear, purchaseYear) || other.purchaseYear == purchaseYear)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.keyOverrides, _keyOverrides)&&const DeepCollectionEquality().equals(other.extraKeys, _extraKeys)&&const DeepCollectionEquality().equals(other.remaps, _remaps)&&const DeepCollectionEquality().equals(other.keyLights, _keyLights));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,shapeFamily,keycapShape,keycapTransparency,keycapColor,caseColor,rgbEnabled,rgbEffect,rgbColor,switchType,keycapMaterial,caseMaterial,physicalLayout,connection,hotSwappable,purchaseYear,notes,const DeepCollectionEquality().hash(_keyOverrides),const DeepCollectionEquality().hash(_extraKeys),const DeepCollectionEquality().hash(_remaps),const DeepCollectionEquality().hash(_keyLights)]);
}

@override
String toString() {
    return 'KeyboardCustomizationDto(shapeFamily: $shapeFamily, keycapShape: $keycapShape, keycapTransparency: $keycapTransparency, keycapColor: $keycapColor, caseColor: $caseColor, rgbEnabled: $rgbEnabled, rgbEffect: $rgbEffect, rgbColor: $rgbColor, switchType: $switchType, keycapMaterial: $keycapMaterial, caseMaterial: $caseMaterial, physicalLayout: $physicalLayout, connection: $connection, hotSwappable: $hotSwappable, purchaseYear: $purchaseYear, notes: $notes, keyOverrides: $keyOverrides, extraKeys: $extraKeys, remaps: $remaps, keyLights: $keyLights)';
}


}

/// @nodoc
abstract mixin class _$KeyboardCustomizationDtoCopyWith<$Res> implements $KeyboardCustomizationDtoCopyWith<$Res> {
  factory _$KeyboardCustomizationDtoCopyWith(_KeyboardCustomizationDto value, $Res Function(_KeyboardCustomizationDto) _then) = __$KeyboardCustomizationDtoCopyWithImpl;
@override @useResult
$Res call({
 String? shapeFamily, String? keycapShape, String? keycapTransparency, int? keycapColor, int? caseColor, bool rgbEnabled, String? rgbEffect, int? rgbColor, String? switchType, String? keycapMaterial, String? caseMaterial, String? physicalLayout, String? connection, bool? hotSwappable, int? purchaseYear, String? notes, List<KeyboardKeyOverrideDto> keyOverrides, List<KeyboardExtraKeyDto> extraKeys, List<KeyboardKeyRemapDto> remaps, List<KeyboardKeyLightDto> keyLights
});




}
/// @nodoc
class __$KeyboardCustomizationDtoCopyWithImpl<$Res>
    implements _$KeyboardCustomizationDtoCopyWith<$Res> {
  __$KeyboardCustomizationDtoCopyWithImpl(this._self, this._then);

  final _KeyboardCustomizationDto _self;
  final $Res Function(_KeyboardCustomizationDto) _then;

/// Create a copy of KeyboardCustomizationDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? shapeFamily = freezed,Object? keycapShape = freezed,Object? keycapTransparency = freezed,Object? keycapColor = freezed,Object? caseColor = freezed,Object? rgbEnabled = null,Object? rgbEffect = freezed,Object? rgbColor = freezed,Object? switchType = freezed,Object? keycapMaterial = freezed,Object? caseMaterial = freezed,Object? physicalLayout = freezed,Object? connection = freezed,Object? hotSwappable = freezed,Object? purchaseYear = freezed,Object? notes = freezed,Object? keyOverrides = null,Object? extraKeys = null,Object? remaps = null,Object? keyLights = null,}) {
  return _then(_KeyboardCustomizationDto(
shapeFamily: freezed == shapeFamily ? _self.shapeFamily : shapeFamily // ignore: cast_nullable_to_non_nullable
as String?,keycapShape: freezed == keycapShape ? _self.keycapShape : keycapShape // ignore: cast_nullable_to_non_nullable
as String?,keycapTransparency: freezed == keycapTransparency ? _self.keycapTransparency : keycapTransparency // ignore: cast_nullable_to_non_nullable
as String?,keycapColor: freezed == keycapColor ? _self.keycapColor : keycapColor // ignore: cast_nullable_to_non_nullable
as int?,caseColor: freezed == caseColor ? _self.caseColor : caseColor // ignore: cast_nullable_to_non_nullable
as int?,rgbEnabled: null == rgbEnabled ? _self.rgbEnabled : rgbEnabled // ignore: cast_nullable_to_non_nullable
as bool,rgbEffect: freezed == rgbEffect ? _self.rgbEffect : rgbEffect // ignore: cast_nullable_to_non_nullable
as String?,rgbColor: freezed == rgbColor ? _self.rgbColor : rgbColor // ignore: cast_nullable_to_non_nullable
as int?,switchType: freezed == switchType ? _self.switchType : switchType // ignore: cast_nullable_to_non_nullable
as String?,keycapMaterial: freezed == keycapMaterial ? _self.keycapMaterial : keycapMaterial // ignore: cast_nullable_to_non_nullable
as String?,caseMaterial: freezed == caseMaterial ? _self.caseMaterial : caseMaterial // ignore: cast_nullable_to_non_nullable
as String?,physicalLayout: freezed == physicalLayout ? _self.physicalLayout : physicalLayout // ignore: cast_nullable_to_non_nullable
as String?,connection: freezed == connection ? _self.connection : connection // ignore: cast_nullable_to_non_nullable
as String?,hotSwappable: freezed == hotSwappable ? _self.hotSwappable : hotSwappable // ignore: cast_nullable_to_non_nullable
as bool?,purchaseYear: freezed == purchaseYear ? _self.purchaseYear : purchaseYear // ignore: cast_nullable_to_non_nullable
as int?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,keyOverrides: null == keyOverrides ? _self._keyOverrides : keyOverrides // ignore: cast_nullable_to_non_nullable
as List<KeyboardKeyOverrideDto>,extraKeys: null == extraKeys ? _self._extraKeys : extraKeys // ignore: cast_nullable_to_non_nullable
as List<KeyboardExtraKeyDto>,remaps: null == remaps ? _self._remaps : remaps // ignore: cast_nullable_to_non_nullable
as List<KeyboardKeyRemapDto>,keyLights: null == keyLights ? _self._keyLights : keyLights // ignore: cast_nullable_to_non_nullable
as List<KeyboardKeyLightDto>,
  ));
}


}


/// @nodoc
mixin _$KeyboardKeyOverrideDto {

 String get keyId; String? get label; String? get label2;
/// Create a copy of KeyboardKeyOverrideDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KeyboardKeyOverrideDtoCopyWith<KeyboardKeyOverrideDto> get copyWith => _$KeyboardKeyOverrideDtoCopyWithImpl<KeyboardKeyOverrideDto>(this as KeyboardKeyOverrideDto, _$identity);

  /// Serializes this KeyboardKeyOverrideDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as KeyboardKeyOverrideDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KeyboardKeyOverrideDto&&(identical(other.keyId, _this.keyId) || other.keyId == _this.keyId)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.label2, _this.label2) || other.label2 == _this.label2));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as KeyboardKeyOverrideDto;
  return Object.hash(runtimeType,_this.keyId,_this.label,_this.label2);
}

@override
String toString() {
  final _this = this as KeyboardKeyOverrideDto;
  return 'KeyboardKeyOverrideDto(keyId: ${_this.keyId}, label: ${_this.label}, label2: ${_this.label2})';
}


}

/// @nodoc
abstract mixin class $KeyboardKeyOverrideDtoCopyWith<$Res>  {
  factory $KeyboardKeyOverrideDtoCopyWith(KeyboardKeyOverrideDto value, $Res Function(KeyboardKeyOverrideDto) _then) = _$KeyboardKeyOverrideDtoCopyWithImpl;
@useResult
$Res call({
 String keyId, String? label, String? label2
});




}
/// @nodoc
class _$KeyboardKeyOverrideDtoCopyWithImpl<$Res>
    implements $KeyboardKeyOverrideDtoCopyWith<$Res> {
  _$KeyboardKeyOverrideDtoCopyWithImpl(this._self, this._then);

  final KeyboardKeyOverrideDto _self;
  final $Res Function(KeyboardKeyOverrideDto) _then;

/// Create a copy of KeyboardKeyOverrideDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? keyId = null,Object? label = freezed,Object? label2 = freezed,}) {
  return _then(KeyboardKeyOverrideDto(
keyId: null == keyId ? _self.keyId : keyId // ignore: cast_nullable_to_non_nullable
as String,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,label2: freezed == label2 ? _self.label2 : label2 // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [KeyboardKeyOverrideDto].
extension KeyboardKeyOverrideDtoPatterns on KeyboardKeyOverrideDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KeyboardKeyOverrideDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KeyboardKeyOverrideDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KeyboardKeyOverrideDto value)  $default,){
final _that = this;
switch (_that) {
case _KeyboardKeyOverrideDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KeyboardKeyOverrideDto value)?  $default,){
final _that = this;
switch (_that) {
case _KeyboardKeyOverrideDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String keyId,  String? label,  String? label2)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KeyboardKeyOverrideDto() when $default != null:
return $default(_that.keyId,_that.label,_that.label2);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String keyId,  String? label,  String? label2)  $default,) {final _that = this;
switch (_that) {
case _KeyboardKeyOverrideDto():
return $default(_that.keyId,_that.label,_that.label2);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String keyId,  String? label,  String? label2)?  $default,) {final _that = this;
switch (_that) {
case _KeyboardKeyOverrideDto() when $default != null:
return $default(_that.keyId,_that.label,_that.label2);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KeyboardKeyOverrideDto implements KeyboardKeyOverrideDto {
  const _KeyboardKeyOverrideDto({required this.keyId, this.label, this.label2});
  factory _KeyboardKeyOverrideDto.fromJson(Map<String, dynamic> json) => _$KeyboardKeyOverrideDtoFromJson(json);

@override final  String keyId;
@override final  String? label;
@override final  String? label2;

/// Create a copy of KeyboardKeyOverrideDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KeyboardKeyOverrideDtoCopyWith<_KeyboardKeyOverrideDto> get copyWith => __$KeyboardKeyOverrideDtoCopyWithImpl<_KeyboardKeyOverrideDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KeyboardKeyOverrideDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _KeyboardKeyOverrideDto&&(identical(other.keyId, keyId) || other.keyId == keyId)&&(identical(other.label, label) || other.label == label)&&(identical(other.label2, label2) || other.label2 == label2));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,keyId,label,label2);
}

@override
String toString() {
    return 'KeyboardKeyOverrideDto(keyId: $keyId, label: $label, label2: $label2)';
}


}

/// @nodoc
abstract mixin class _$KeyboardKeyOverrideDtoCopyWith<$Res> implements $KeyboardKeyOverrideDtoCopyWith<$Res> {
  factory _$KeyboardKeyOverrideDtoCopyWith(_KeyboardKeyOverrideDto value, $Res Function(_KeyboardKeyOverrideDto) _then) = __$KeyboardKeyOverrideDtoCopyWithImpl;
@override @useResult
$Res call({
 String keyId, String? label, String? label2
});




}
/// @nodoc
class __$KeyboardKeyOverrideDtoCopyWithImpl<$Res>
    implements _$KeyboardKeyOverrideDtoCopyWith<$Res> {
  __$KeyboardKeyOverrideDtoCopyWithImpl(this._self, this._then);

  final _KeyboardKeyOverrideDto _self;
  final $Res Function(_KeyboardKeyOverrideDto) _then;

/// Create a copy of KeyboardKeyOverrideDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? keyId = null,Object? label = freezed,Object? label2 = freezed,}) {
  return _then(_KeyboardKeyOverrideDto(
keyId: null == keyId ? _self.keyId : keyId // ignore: cast_nullable_to_non_nullable
as String,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,label2: freezed == label2 ? _self.label2 : label2 // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$KeyboardExtraKeyDto {

 String get id; String? get label; String? get label2; double get width; double get height;
/// Create a copy of KeyboardExtraKeyDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KeyboardExtraKeyDtoCopyWith<KeyboardExtraKeyDto> get copyWith => _$KeyboardExtraKeyDtoCopyWithImpl<KeyboardExtraKeyDto>(this as KeyboardExtraKeyDto, _$identity);

  /// Serializes this KeyboardExtraKeyDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as KeyboardExtraKeyDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KeyboardExtraKeyDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.label2, _this.label2) || other.label2 == _this.label2)&&(identical(other.width, _this.width) || other.width == _this.width)&&(identical(other.height, _this.height) || other.height == _this.height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as KeyboardExtraKeyDto;
  return Object.hash(runtimeType,_this.id,_this.label,_this.label2,_this.width,_this.height);
}

@override
String toString() {
  final _this = this as KeyboardExtraKeyDto;
  return 'KeyboardExtraKeyDto(id: ${_this.id}, label: ${_this.label}, label2: ${_this.label2}, width: ${_this.width}, height: ${_this.height})';
}


}

/// @nodoc
abstract mixin class $KeyboardExtraKeyDtoCopyWith<$Res>  {
  factory $KeyboardExtraKeyDtoCopyWith(KeyboardExtraKeyDto value, $Res Function(KeyboardExtraKeyDto) _then) = _$KeyboardExtraKeyDtoCopyWithImpl;
@useResult
$Res call({
 String id, String? label, String? label2, double width, double height
});




}
/// @nodoc
class _$KeyboardExtraKeyDtoCopyWithImpl<$Res>
    implements $KeyboardExtraKeyDtoCopyWith<$Res> {
  _$KeyboardExtraKeyDtoCopyWithImpl(this._self, this._then);

  final KeyboardExtraKeyDto _self;
  final $Res Function(KeyboardExtraKeyDto) _then;

/// Create a copy of KeyboardExtraKeyDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = freezed,Object? label2 = freezed,Object? width = null,Object? height = null,}) {
  return _then(KeyboardExtraKeyDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,label2: freezed == label2 ? _self.label2 : label2 // ignore: cast_nullable_to_non_nullable
as String?,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [KeyboardExtraKeyDto].
extension KeyboardExtraKeyDtoPatterns on KeyboardExtraKeyDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KeyboardExtraKeyDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KeyboardExtraKeyDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KeyboardExtraKeyDto value)  $default,){
final _that = this;
switch (_that) {
case _KeyboardExtraKeyDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KeyboardExtraKeyDto value)?  $default,){
final _that = this;
switch (_that) {
case _KeyboardExtraKeyDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? label,  String? label2,  double width,  double height)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KeyboardExtraKeyDto() when $default != null:
return $default(_that.id,_that.label,_that.label2,_that.width,_that.height);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? label,  String? label2,  double width,  double height)  $default,) {final _that = this;
switch (_that) {
case _KeyboardExtraKeyDto():
return $default(_that.id,_that.label,_that.label2,_that.width,_that.height);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? label,  String? label2,  double width,  double height)?  $default,) {final _that = this;
switch (_that) {
case _KeyboardExtraKeyDto() when $default != null:
return $default(_that.id,_that.label,_that.label2,_that.width,_that.height);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KeyboardExtraKeyDto implements KeyboardExtraKeyDto {
  const _KeyboardExtraKeyDto({required this.id, this.label, this.label2, this.width = 1, this.height = 1});
  factory _KeyboardExtraKeyDto.fromJson(Map<String, dynamic> json) => _$KeyboardExtraKeyDtoFromJson(json);

@override final  String id;
@override final  String? label;
@override final  String? label2;
@override@JsonKey() final  double width;
@override@JsonKey() final  double height;

/// Create a copy of KeyboardExtraKeyDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KeyboardExtraKeyDtoCopyWith<_KeyboardExtraKeyDto> get copyWith => __$KeyboardExtraKeyDtoCopyWithImpl<_KeyboardExtraKeyDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KeyboardExtraKeyDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _KeyboardExtraKeyDto&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.label2, label2) || other.label2 == label2)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,label,label2,width,height);
}

@override
String toString() {
    return 'KeyboardExtraKeyDto(id: $id, label: $label, label2: $label2, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class _$KeyboardExtraKeyDtoCopyWith<$Res> implements $KeyboardExtraKeyDtoCopyWith<$Res> {
  factory _$KeyboardExtraKeyDtoCopyWith(_KeyboardExtraKeyDto value, $Res Function(_KeyboardExtraKeyDto) _then) = __$KeyboardExtraKeyDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String? label, String? label2, double width, double height
});




}
/// @nodoc
class __$KeyboardExtraKeyDtoCopyWithImpl<$Res>
    implements _$KeyboardExtraKeyDtoCopyWith<$Res> {
  __$KeyboardExtraKeyDtoCopyWithImpl(this._self, this._then);

  final _KeyboardExtraKeyDto _self;
  final $Res Function(_KeyboardExtraKeyDto) _then;

/// Create a copy of KeyboardExtraKeyDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = freezed,Object? label2 = freezed,Object? width = null,Object? height = null,}) {
  return _then(_KeyboardExtraKeyDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,label2: freezed == label2 ? _self.label2 : label2 // ignore: cast_nullable_to_non_nullable
as String?,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$KeyboardKeyRemapDto {

 String get physicalKey; String get character; String? get shiftedCharacter;
/// Create a copy of KeyboardKeyRemapDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KeyboardKeyRemapDtoCopyWith<KeyboardKeyRemapDto> get copyWith => _$KeyboardKeyRemapDtoCopyWithImpl<KeyboardKeyRemapDto>(this as KeyboardKeyRemapDto, _$identity);

  /// Serializes this KeyboardKeyRemapDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as KeyboardKeyRemapDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KeyboardKeyRemapDto&&(identical(other.physicalKey, _this.physicalKey) || other.physicalKey == _this.physicalKey)&&(identical(other.character, _this.character) || other.character == _this.character)&&(identical(other.shiftedCharacter, _this.shiftedCharacter) || other.shiftedCharacter == _this.shiftedCharacter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as KeyboardKeyRemapDto;
  return Object.hash(runtimeType,_this.physicalKey,_this.character,_this.shiftedCharacter);
}

@override
String toString() {
  final _this = this as KeyboardKeyRemapDto;
  return 'KeyboardKeyRemapDto(physicalKey: ${_this.physicalKey}, character: ${_this.character}, shiftedCharacter: ${_this.shiftedCharacter})';
}


}

/// @nodoc
abstract mixin class $KeyboardKeyRemapDtoCopyWith<$Res>  {
  factory $KeyboardKeyRemapDtoCopyWith(KeyboardKeyRemapDto value, $Res Function(KeyboardKeyRemapDto) _then) = _$KeyboardKeyRemapDtoCopyWithImpl;
@useResult
$Res call({
 String physicalKey, String character, String? shiftedCharacter
});




}
/// @nodoc
class _$KeyboardKeyRemapDtoCopyWithImpl<$Res>
    implements $KeyboardKeyRemapDtoCopyWith<$Res> {
  _$KeyboardKeyRemapDtoCopyWithImpl(this._self, this._then);

  final KeyboardKeyRemapDto _self;
  final $Res Function(KeyboardKeyRemapDto) _then;

/// Create a copy of KeyboardKeyRemapDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? physicalKey = null,Object? character = null,Object? shiftedCharacter = freezed,}) {
  return _then(KeyboardKeyRemapDto(
physicalKey: null == physicalKey ? _self.physicalKey : physicalKey // ignore: cast_nullable_to_non_nullable
as String,character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,shiftedCharacter: freezed == shiftedCharacter ? _self.shiftedCharacter : shiftedCharacter // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [KeyboardKeyRemapDto].
extension KeyboardKeyRemapDtoPatterns on KeyboardKeyRemapDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KeyboardKeyRemapDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KeyboardKeyRemapDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KeyboardKeyRemapDto value)  $default,){
final _that = this;
switch (_that) {
case _KeyboardKeyRemapDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KeyboardKeyRemapDto value)?  $default,){
final _that = this;
switch (_that) {
case _KeyboardKeyRemapDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String physicalKey,  String character,  String? shiftedCharacter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KeyboardKeyRemapDto() when $default != null:
return $default(_that.physicalKey,_that.character,_that.shiftedCharacter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String physicalKey,  String character,  String? shiftedCharacter)  $default,) {final _that = this;
switch (_that) {
case _KeyboardKeyRemapDto():
return $default(_that.physicalKey,_that.character,_that.shiftedCharacter);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String physicalKey,  String character,  String? shiftedCharacter)?  $default,) {final _that = this;
switch (_that) {
case _KeyboardKeyRemapDto() when $default != null:
return $default(_that.physicalKey,_that.character,_that.shiftedCharacter);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KeyboardKeyRemapDto implements KeyboardKeyRemapDto {
  const _KeyboardKeyRemapDto({required this.physicalKey, required this.character, this.shiftedCharacter});
  factory _KeyboardKeyRemapDto.fromJson(Map<String, dynamic> json) => _$KeyboardKeyRemapDtoFromJson(json);

@override final  String physicalKey;
@override final  String character;
@override final  String? shiftedCharacter;

/// Create a copy of KeyboardKeyRemapDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KeyboardKeyRemapDtoCopyWith<_KeyboardKeyRemapDto> get copyWith => __$KeyboardKeyRemapDtoCopyWithImpl<_KeyboardKeyRemapDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KeyboardKeyRemapDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _KeyboardKeyRemapDto&&(identical(other.physicalKey, physicalKey) || other.physicalKey == physicalKey)&&(identical(other.character, character) || other.character == character)&&(identical(other.shiftedCharacter, shiftedCharacter) || other.shiftedCharacter == shiftedCharacter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,physicalKey,character,shiftedCharacter);
}

@override
String toString() {
    return 'KeyboardKeyRemapDto(physicalKey: $physicalKey, character: $character, shiftedCharacter: $shiftedCharacter)';
}


}

/// @nodoc
abstract mixin class _$KeyboardKeyRemapDtoCopyWith<$Res> implements $KeyboardKeyRemapDtoCopyWith<$Res> {
  factory _$KeyboardKeyRemapDtoCopyWith(_KeyboardKeyRemapDto value, $Res Function(_KeyboardKeyRemapDto) _then) = __$KeyboardKeyRemapDtoCopyWithImpl;
@override @useResult
$Res call({
 String physicalKey, String character, String? shiftedCharacter
});




}
/// @nodoc
class __$KeyboardKeyRemapDtoCopyWithImpl<$Res>
    implements _$KeyboardKeyRemapDtoCopyWith<$Res> {
  __$KeyboardKeyRemapDtoCopyWithImpl(this._self, this._then);

  final _KeyboardKeyRemapDto _self;
  final $Res Function(_KeyboardKeyRemapDto) _then;

/// Create a copy of KeyboardKeyRemapDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? physicalKey = null,Object? character = null,Object? shiftedCharacter = freezed,}) {
  return _then(_KeyboardKeyRemapDto(
physicalKey: null == physicalKey ? _self.physicalKey : physicalKey // ignore: cast_nullable_to_non_nullable
as String,character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,shiftedCharacter: freezed == shiftedCharacter ? _self.shiftedCharacter : shiftedCharacter // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$KeyboardKeyLightDto {

 String get keyId; int get color;
/// Create a copy of KeyboardKeyLightDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KeyboardKeyLightDtoCopyWith<KeyboardKeyLightDto> get copyWith => _$KeyboardKeyLightDtoCopyWithImpl<KeyboardKeyLightDto>(this as KeyboardKeyLightDto, _$identity);

  /// Serializes this KeyboardKeyLightDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as KeyboardKeyLightDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KeyboardKeyLightDto&&(identical(other.keyId, _this.keyId) || other.keyId == _this.keyId)&&(identical(other.color, _this.color) || other.color == _this.color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as KeyboardKeyLightDto;
  return Object.hash(runtimeType,_this.keyId,_this.color);
}

@override
String toString() {
  final _this = this as KeyboardKeyLightDto;
  return 'KeyboardKeyLightDto(keyId: ${_this.keyId}, color: ${_this.color})';
}


}

/// @nodoc
abstract mixin class $KeyboardKeyLightDtoCopyWith<$Res>  {
  factory $KeyboardKeyLightDtoCopyWith(KeyboardKeyLightDto value, $Res Function(KeyboardKeyLightDto) _then) = _$KeyboardKeyLightDtoCopyWithImpl;
@useResult
$Res call({
 String keyId, int color
});




}
/// @nodoc
class _$KeyboardKeyLightDtoCopyWithImpl<$Res>
    implements $KeyboardKeyLightDtoCopyWith<$Res> {
  _$KeyboardKeyLightDtoCopyWithImpl(this._self, this._then);

  final KeyboardKeyLightDto _self;
  final $Res Function(KeyboardKeyLightDto) _then;

/// Create a copy of KeyboardKeyLightDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? keyId = null,Object? color = null,}) {
  return _then(KeyboardKeyLightDto(
keyId: null == keyId ? _self.keyId : keyId // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [KeyboardKeyLightDto].
extension KeyboardKeyLightDtoPatterns on KeyboardKeyLightDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KeyboardKeyLightDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KeyboardKeyLightDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KeyboardKeyLightDto value)  $default,){
final _that = this;
switch (_that) {
case _KeyboardKeyLightDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KeyboardKeyLightDto value)?  $default,){
final _that = this;
switch (_that) {
case _KeyboardKeyLightDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String keyId,  int color)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KeyboardKeyLightDto() when $default != null:
return $default(_that.keyId,_that.color);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String keyId,  int color)  $default,) {final _that = this;
switch (_that) {
case _KeyboardKeyLightDto():
return $default(_that.keyId,_that.color);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String keyId,  int color)?  $default,) {final _that = this;
switch (_that) {
case _KeyboardKeyLightDto() when $default != null:
return $default(_that.keyId,_that.color);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KeyboardKeyLightDto implements KeyboardKeyLightDto {
  const _KeyboardKeyLightDto({required this.keyId, required this.color});
  factory _KeyboardKeyLightDto.fromJson(Map<String, dynamic> json) => _$KeyboardKeyLightDtoFromJson(json);

@override final  String keyId;
@override final  int color;

/// Create a copy of KeyboardKeyLightDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KeyboardKeyLightDtoCopyWith<_KeyboardKeyLightDto> get copyWith => __$KeyboardKeyLightDtoCopyWithImpl<_KeyboardKeyLightDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KeyboardKeyLightDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _KeyboardKeyLightDto&&(identical(other.keyId, keyId) || other.keyId == keyId)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,keyId,color);
}

@override
String toString() {
    return 'KeyboardKeyLightDto(keyId: $keyId, color: $color)';
}


}

/// @nodoc
abstract mixin class _$KeyboardKeyLightDtoCopyWith<$Res> implements $KeyboardKeyLightDtoCopyWith<$Res> {
  factory _$KeyboardKeyLightDtoCopyWith(_KeyboardKeyLightDto value, $Res Function(_KeyboardKeyLightDto) _then) = __$KeyboardKeyLightDtoCopyWithImpl;
@override @useResult
$Res call({
 String keyId, int color
});




}
/// @nodoc
class __$KeyboardKeyLightDtoCopyWithImpl<$Res>
    implements _$KeyboardKeyLightDtoCopyWith<$Res> {
  __$KeyboardKeyLightDtoCopyWithImpl(this._self, this._then);

  final _KeyboardKeyLightDto _self;
  final $Res Function(_KeyboardKeyLightDto) _then;

/// Create a copy of KeyboardKeyLightDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? keyId = null,Object? color = null,}) {
  return _then(_KeyboardKeyLightDto(
keyId: null == keyId ? _self.keyId : keyId // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
