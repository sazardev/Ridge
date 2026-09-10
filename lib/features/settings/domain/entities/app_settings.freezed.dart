// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppSettings {

 AppThemeMode get themeMode; bool get expressiveColor; bool get appLockEnabled; bool get windowBorderEnabled; AppWindowBorderWidth get windowBorderWidth; AppCornerStyle get cornerStyle; AppPaletteId get palette; AppSoundPack get soundPack; bool get onboardingCompleted; Map<AppShortcutAction, ShortcutBinding> get shortcutBindings; String? get languageCode;
/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingsCopyWith<AppSettings> get copyWith => _$AppSettingsCopyWithImpl<AppSettings>(this as AppSettings, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AppSettings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSettings&&(identical(other.themeMode, _this.themeMode) || other.themeMode == _this.themeMode)&&(identical(other.expressiveColor, _this.expressiveColor) || other.expressiveColor == _this.expressiveColor)&&(identical(other.appLockEnabled, _this.appLockEnabled) || other.appLockEnabled == _this.appLockEnabled)&&(identical(other.windowBorderEnabled, _this.windowBorderEnabled) || other.windowBorderEnabled == _this.windowBorderEnabled)&&(identical(other.windowBorderWidth, _this.windowBorderWidth) || other.windowBorderWidth == _this.windowBorderWidth)&&(identical(other.cornerStyle, _this.cornerStyle) || other.cornerStyle == _this.cornerStyle)&&(identical(other.palette, _this.palette) || other.palette == _this.palette)&&(identical(other.soundPack, _this.soundPack) || other.soundPack == _this.soundPack)&&(identical(other.onboardingCompleted, _this.onboardingCompleted) || other.onboardingCompleted == _this.onboardingCompleted)&&const DeepCollectionEquality().equals(other.shortcutBindings, _this.shortcutBindings)&&(identical(other.languageCode, _this.languageCode) || other.languageCode == _this.languageCode));
}


@override
int get hashCode {
  final _this = this as AppSettings;
  return Object.hash(runtimeType,_this.themeMode,_this.expressiveColor,_this.appLockEnabled,_this.windowBorderEnabled,_this.windowBorderWidth,_this.cornerStyle,_this.palette,_this.soundPack,_this.onboardingCompleted,const DeepCollectionEquality().hash(_this.shortcutBindings),_this.languageCode);
}

@override
String toString() {
  final _this = this as AppSettings;
  return 'AppSettings(themeMode: ${_this.themeMode}, expressiveColor: ${_this.expressiveColor}, appLockEnabled: ${_this.appLockEnabled}, windowBorderEnabled: ${_this.windowBorderEnabled}, windowBorderWidth: ${_this.windowBorderWidth}, cornerStyle: ${_this.cornerStyle}, palette: ${_this.palette}, soundPack: ${_this.soundPack}, onboardingCompleted: ${_this.onboardingCompleted}, shortcutBindings: ${_this.shortcutBindings}, languageCode: ${_this.languageCode})';
}


}

/// @nodoc
abstract mixin class $AppSettingsCopyWith<$Res>  {
  factory $AppSettingsCopyWith(AppSettings value, $Res Function(AppSettings) _then) = _$AppSettingsCopyWithImpl;
@useResult
$Res call({
 AppThemeMode themeMode, bool expressiveColor, bool appLockEnabled, bool windowBorderEnabled, AppWindowBorderWidth windowBorderWidth, AppCornerStyle cornerStyle, AppPaletteId palette, AppSoundPack soundPack, bool onboardingCompleted, Map<AppShortcutAction, ShortcutBinding> shortcutBindings, String? languageCode
});




}
/// @nodoc
class _$AppSettingsCopyWithImpl<$Res>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._self, this._then);

  final AppSettings _self;
  final $Res Function(AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? themeMode = null,Object? expressiveColor = null,Object? appLockEnabled = null,Object? windowBorderEnabled = null,Object? windowBorderWidth = null,Object? cornerStyle = null,Object? palette = null,Object? soundPack = null,Object? onboardingCompleted = null,Object? shortcutBindings = null,Object? languageCode = freezed,}) {
  return _then(AppSettings(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as AppThemeMode,expressiveColor: null == expressiveColor ? _self.expressiveColor : expressiveColor // ignore: cast_nullable_to_non_nullable
as bool,appLockEnabled: null == appLockEnabled ? _self.appLockEnabled : appLockEnabled // ignore: cast_nullable_to_non_nullable
as bool,windowBorderEnabled: null == windowBorderEnabled ? _self.windowBorderEnabled : windowBorderEnabled // ignore: cast_nullable_to_non_nullable
as bool,windowBorderWidth: null == windowBorderWidth ? _self.windowBorderWidth : windowBorderWidth // ignore: cast_nullable_to_non_nullable
as AppWindowBorderWidth,cornerStyle: null == cornerStyle ? _self.cornerStyle : cornerStyle // ignore: cast_nullable_to_non_nullable
as AppCornerStyle,palette: null == palette ? _self.palette : palette // ignore: cast_nullable_to_non_nullable
as AppPaletteId,soundPack: null == soundPack ? _self.soundPack : soundPack // ignore: cast_nullable_to_non_nullable
as AppSoundPack,onboardingCompleted: null == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,shortcutBindings: null == shortcutBindings ? _self.shortcutBindings : shortcutBindings // ignore: cast_nullable_to_non_nullable
as Map<AppShortcutAction, ShortcutBinding>,languageCode: freezed == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSettings].
extension AppSettingsPatterns on AppSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSettings value)  $default,){
final _that = this;
switch (_that) {
case _AppSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppThemeMode themeMode,  bool expressiveColor,  bool appLockEnabled,  bool windowBorderEnabled,  AppWindowBorderWidth windowBorderWidth,  AppCornerStyle cornerStyle,  AppPaletteId palette,  AppSoundPack soundPack,  bool onboardingCompleted,  Map<AppShortcutAction, ShortcutBinding> shortcutBindings,  String? languageCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.themeMode,_that.expressiveColor,_that.appLockEnabled,_that.windowBorderEnabled,_that.windowBorderWidth,_that.cornerStyle,_that.palette,_that.soundPack,_that.onboardingCompleted,_that.shortcutBindings,_that.languageCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppThemeMode themeMode,  bool expressiveColor,  bool appLockEnabled,  bool windowBorderEnabled,  AppWindowBorderWidth windowBorderWidth,  AppCornerStyle cornerStyle,  AppPaletteId palette,  AppSoundPack soundPack,  bool onboardingCompleted,  Map<AppShortcutAction, ShortcutBinding> shortcutBindings,  String? languageCode)  $default,) {final _that = this;
switch (_that) {
case _AppSettings():
return $default(_that.themeMode,_that.expressiveColor,_that.appLockEnabled,_that.windowBorderEnabled,_that.windowBorderWidth,_that.cornerStyle,_that.palette,_that.soundPack,_that.onboardingCompleted,_that.shortcutBindings,_that.languageCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppThemeMode themeMode,  bool expressiveColor,  bool appLockEnabled,  bool windowBorderEnabled,  AppWindowBorderWidth windowBorderWidth,  AppCornerStyle cornerStyle,  AppPaletteId palette,  AppSoundPack soundPack,  bool onboardingCompleted,  Map<AppShortcutAction, ShortcutBinding> shortcutBindings,  String? languageCode)?  $default,) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.themeMode,_that.expressiveColor,_that.appLockEnabled,_that.windowBorderEnabled,_that.windowBorderWidth,_that.cornerStyle,_that.palette,_that.soundPack,_that.onboardingCompleted,_that.shortcutBindings,_that.languageCode);case _:
  return null;

}
}

}

/// @nodoc


class _AppSettings implements AppSettings {
  const _AppSettings({required this.themeMode, required this.expressiveColor, required this.appLockEnabled, required this.windowBorderEnabled, required this.windowBorderWidth, required this.cornerStyle, required this.palette, required this.soundPack, required this.onboardingCompleted, required  Map<AppShortcutAction, ShortcutBinding> shortcutBindings, this.languageCode}): _shortcutBindings = shortcutBindings;
  

@override final  AppThemeMode themeMode;
@override final  bool expressiveColor;
@override final  bool appLockEnabled;
@override final  bool windowBorderEnabled;
@override final  AppWindowBorderWidth windowBorderWidth;
@override final  AppCornerStyle cornerStyle;
@override final  AppPaletteId palette;
@override final  AppSoundPack soundPack;
@override final  bool onboardingCompleted;
 final  Map<AppShortcutAction, ShortcutBinding> _shortcutBindings;
@override Map<AppShortcutAction, ShortcutBinding> get shortcutBindings {
  if (_shortcutBindings is EqualUnmodifiableMapView) return _shortcutBindings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_shortcutBindings);
}

@override final  String? languageCode;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingsCopyWith<_AppSettings> get copyWith => __$AppSettingsCopyWithImpl<_AppSettings>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSettings&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.expressiveColor, expressiveColor) || other.expressiveColor == expressiveColor)&&(identical(other.appLockEnabled, appLockEnabled) || other.appLockEnabled == appLockEnabled)&&(identical(other.windowBorderEnabled, windowBorderEnabled) || other.windowBorderEnabled == windowBorderEnabled)&&(identical(other.windowBorderWidth, windowBorderWidth) || other.windowBorderWidth == windowBorderWidth)&&(identical(other.cornerStyle, cornerStyle) || other.cornerStyle == cornerStyle)&&(identical(other.palette, palette) || other.palette == palette)&&(identical(other.soundPack, soundPack) || other.soundPack == soundPack)&&(identical(other.onboardingCompleted, onboardingCompleted) || other.onboardingCompleted == onboardingCompleted)&&const DeepCollectionEquality().equals(other.shortcutBindings, _shortcutBindings)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode));
}


@override
int get hashCode {
    return Object.hash(runtimeType,themeMode,expressiveColor,appLockEnabled,windowBorderEnabled,windowBorderWidth,cornerStyle,palette,soundPack,onboardingCompleted,const DeepCollectionEquality().hash(_shortcutBindings),languageCode);
}

@override
String toString() {
    return 'AppSettings(themeMode: $themeMode, expressiveColor: $expressiveColor, appLockEnabled: $appLockEnabled, windowBorderEnabled: $windowBorderEnabled, windowBorderWidth: $windowBorderWidth, cornerStyle: $cornerStyle, palette: $palette, soundPack: $soundPack, onboardingCompleted: $onboardingCompleted, shortcutBindings: $shortcutBindings, languageCode: $languageCode)';
}


}

/// @nodoc
abstract mixin class _$AppSettingsCopyWith<$Res> implements $AppSettingsCopyWith<$Res> {
  factory _$AppSettingsCopyWith(_AppSettings value, $Res Function(_AppSettings) _then) = __$AppSettingsCopyWithImpl;
@override @useResult
$Res call({
 AppThemeMode themeMode, bool expressiveColor, bool appLockEnabled, bool windowBorderEnabled, AppWindowBorderWidth windowBorderWidth, AppCornerStyle cornerStyle, AppPaletteId palette, AppSoundPack soundPack, bool onboardingCompleted, Map<AppShortcutAction, ShortcutBinding> shortcutBindings, String? languageCode
});




}
/// @nodoc
class __$AppSettingsCopyWithImpl<$Res>
    implements _$AppSettingsCopyWith<$Res> {
  __$AppSettingsCopyWithImpl(this._self, this._then);

  final _AppSettings _self;
  final $Res Function(_AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? themeMode = null,Object? expressiveColor = null,Object? appLockEnabled = null,Object? windowBorderEnabled = null,Object? windowBorderWidth = null,Object? cornerStyle = null,Object? palette = null,Object? soundPack = null,Object? onboardingCompleted = null,Object? shortcutBindings = null,Object? languageCode = freezed,}) {
  return _then(_AppSettings(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as AppThemeMode,expressiveColor: null == expressiveColor ? _self.expressiveColor : expressiveColor // ignore: cast_nullable_to_non_nullable
as bool,appLockEnabled: null == appLockEnabled ? _self.appLockEnabled : appLockEnabled // ignore: cast_nullable_to_non_nullable
as bool,windowBorderEnabled: null == windowBorderEnabled ? _self.windowBorderEnabled : windowBorderEnabled // ignore: cast_nullable_to_non_nullable
as bool,windowBorderWidth: null == windowBorderWidth ? _self.windowBorderWidth : windowBorderWidth // ignore: cast_nullable_to_non_nullable
as AppWindowBorderWidth,cornerStyle: null == cornerStyle ? _self.cornerStyle : cornerStyle // ignore: cast_nullable_to_non_nullable
as AppCornerStyle,palette: null == palette ? _self.palette : palette // ignore: cast_nullable_to_non_nullable
as AppPaletteId,soundPack: null == soundPack ? _self.soundPack : soundPack // ignore: cast_nullable_to_non_nullable
as AppSoundPack,onboardingCompleted: null == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,shortcutBindings: null == shortcutBindings ? _self._shortcutBindings : shortcutBindings // ignore: cast_nullable_to_non_nullable
as Map<AppShortcutAction, ShortcutBinding>,languageCode: freezed == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
