// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'guest_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GuestProfile {

 ProfileId get id; String get username; DateTime get createdAt; List<FavoriteLanguage> get favoriteLanguages; KeyboardLayout? get keyboardLayout; String? get keyboardBrand; String? get keyboardModel; String? get favoriteQuote; String? get favoriteProgrammer; String? get platform; String? get operatingSystemVersion; String? get deviceModel;
/// Create a copy of GuestProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GuestProfileCopyWith<GuestProfile> get copyWith => _$GuestProfileCopyWithImpl<GuestProfile>(this as GuestProfile, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as GuestProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GuestProfile&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.username, _this.username) || other.username == _this.username)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&const DeepCollectionEquality().equals(other.favoriteLanguages, _this.favoriteLanguages)&&(identical(other.keyboardLayout, _this.keyboardLayout) || other.keyboardLayout == _this.keyboardLayout)&&(identical(other.keyboardBrand, _this.keyboardBrand) || other.keyboardBrand == _this.keyboardBrand)&&(identical(other.keyboardModel, _this.keyboardModel) || other.keyboardModel == _this.keyboardModel)&&(identical(other.favoriteQuote, _this.favoriteQuote) || other.favoriteQuote == _this.favoriteQuote)&&(identical(other.favoriteProgrammer, _this.favoriteProgrammer) || other.favoriteProgrammer == _this.favoriteProgrammer)&&(identical(other.platform, _this.platform) || other.platform == _this.platform)&&(identical(other.operatingSystemVersion, _this.operatingSystemVersion) || other.operatingSystemVersion == _this.operatingSystemVersion)&&(identical(other.deviceModel, _this.deviceModel) || other.deviceModel == _this.deviceModel));
}


@override
int get hashCode {
  final _this = this as GuestProfile;
  return Object.hash(runtimeType,_this.id,_this.username,_this.createdAt,const DeepCollectionEquality().hash(_this.favoriteLanguages),_this.keyboardLayout,_this.keyboardBrand,_this.keyboardModel,_this.favoriteQuote,_this.favoriteProgrammer,_this.platform,_this.operatingSystemVersion,_this.deviceModel);
}

@override
String toString() {
  final _this = this as GuestProfile;
  return 'GuestProfile(id: ${_this.id}, username: ${_this.username}, createdAt: ${_this.createdAt}, favoriteLanguages: ${_this.favoriteLanguages}, keyboardLayout: ${_this.keyboardLayout}, keyboardBrand: ${_this.keyboardBrand}, keyboardModel: ${_this.keyboardModel}, favoriteQuote: ${_this.favoriteQuote}, favoriteProgrammer: ${_this.favoriteProgrammer}, platform: ${_this.platform}, operatingSystemVersion: ${_this.operatingSystemVersion}, deviceModel: ${_this.deviceModel})';
}


}

/// @nodoc
abstract mixin class $GuestProfileCopyWith<$Res>  {
  factory $GuestProfileCopyWith(GuestProfile value, $Res Function(GuestProfile) _then) = _$GuestProfileCopyWithImpl;
@useResult
$Res call({
 ProfileId id, String username, DateTime createdAt, List<FavoriteLanguage> favoriteLanguages, KeyboardLayout? keyboardLayout, String? keyboardBrand, String? keyboardModel, String? favoriteQuote, String? favoriteProgrammer, String? platform, String? operatingSystemVersion, String? deviceModel
});


$ProfileIdCopyWith<$Res> get id;

}
/// @nodoc
class _$GuestProfileCopyWithImpl<$Res>
    implements $GuestProfileCopyWith<$Res> {
  _$GuestProfileCopyWithImpl(this._self, this._then);

  final GuestProfile _self;
  final $Res Function(GuestProfile) _then;

/// Create a copy of GuestProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? createdAt = null,Object? favoriteLanguages = null,Object? keyboardLayout = freezed,Object? keyboardBrand = freezed,Object? keyboardModel = freezed,Object? favoriteQuote = freezed,Object? favoriteProgrammer = freezed,Object? platform = freezed,Object? operatingSystemVersion = freezed,Object? deviceModel = freezed,}) {
  return _then(GuestProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as ProfileId,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,favoriteLanguages: null == favoriteLanguages ? _self.favoriteLanguages : favoriteLanguages // ignore: cast_nullable_to_non_nullable
as List<FavoriteLanguage>,keyboardLayout: freezed == keyboardLayout ? _self.keyboardLayout : keyboardLayout // ignore: cast_nullable_to_non_nullable
as KeyboardLayout?,keyboardBrand: freezed == keyboardBrand ? _self.keyboardBrand : keyboardBrand // ignore: cast_nullable_to_non_nullable
as String?,keyboardModel: freezed == keyboardModel ? _self.keyboardModel : keyboardModel // ignore: cast_nullable_to_non_nullable
as String?,favoriteQuote: freezed == favoriteQuote ? _self.favoriteQuote : favoriteQuote // ignore: cast_nullable_to_non_nullable
as String?,favoriteProgrammer: freezed == favoriteProgrammer ? _self.favoriteProgrammer : favoriteProgrammer // ignore: cast_nullable_to_non_nullable
as String?,platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String?,operatingSystemVersion: freezed == operatingSystemVersion ? _self.operatingSystemVersion : operatingSystemVersion // ignore: cast_nullable_to_non_nullable
as String?,deviceModel: freezed == deviceModel ? _self.deviceModel : deviceModel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of GuestProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileIdCopyWith<$Res> get id {
  
  return $ProfileIdCopyWith<$Res>(_self.id, (value) {
    return _then(_self.copyWith(id: value));
  });
}
}


/// Adds pattern-matching-related methods to [GuestProfile].
extension GuestProfilePatterns on GuestProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GuestProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GuestProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GuestProfile value)  $default,){
final _that = this;
switch (_that) {
case _GuestProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GuestProfile value)?  $default,){
final _that = this;
switch (_that) {
case _GuestProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProfileId id,  String username,  DateTime createdAt,  List<FavoriteLanguage> favoriteLanguages,  KeyboardLayout? keyboardLayout,  String? keyboardBrand,  String? keyboardModel,  String? favoriteQuote,  String? favoriteProgrammer,  String? platform,  String? operatingSystemVersion,  String? deviceModel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GuestProfile() when $default != null:
return $default(_that.id,_that.username,_that.createdAt,_that.favoriteLanguages,_that.keyboardLayout,_that.keyboardBrand,_that.keyboardModel,_that.favoriteQuote,_that.favoriteProgrammer,_that.platform,_that.operatingSystemVersion,_that.deviceModel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProfileId id,  String username,  DateTime createdAt,  List<FavoriteLanguage> favoriteLanguages,  KeyboardLayout? keyboardLayout,  String? keyboardBrand,  String? keyboardModel,  String? favoriteQuote,  String? favoriteProgrammer,  String? platform,  String? operatingSystemVersion,  String? deviceModel)  $default,) {final _that = this;
switch (_that) {
case _GuestProfile():
return $default(_that.id,_that.username,_that.createdAt,_that.favoriteLanguages,_that.keyboardLayout,_that.keyboardBrand,_that.keyboardModel,_that.favoriteQuote,_that.favoriteProgrammer,_that.platform,_that.operatingSystemVersion,_that.deviceModel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProfileId id,  String username,  DateTime createdAt,  List<FavoriteLanguage> favoriteLanguages,  KeyboardLayout? keyboardLayout,  String? keyboardBrand,  String? keyboardModel,  String? favoriteQuote,  String? favoriteProgrammer,  String? platform,  String? operatingSystemVersion,  String? deviceModel)?  $default,) {final _that = this;
switch (_that) {
case _GuestProfile() when $default != null:
return $default(_that.id,_that.username,_that.createdAt,_that.favoriteLanguages,_that.keyboardLayout,_that.keyboardBrand,_that.keyboardModel,_that.favoriteQuote,_that.favoriteProgrammer,_that.platform,_that.operatingSystemVersion,_that.deviceModel);case _:
  return null;

}
}

}

/// @nodoc


class _GuestProfile implements GuestProfile {
  const _GuestProfile({required this.id, required this.username, required this.createdAt,  List<FavoriteLanguage> favoriteLanguages = const <FavoriteLanguage>[], this.keyboardLayout, this.keyboardBrand, this.keyboardModel, this.favoriteQuote, this.favoriteProgrammer, this.platform, this.operatingSystemVersion, this.deviceModel}): _favoriteLanguages = favoriteLanguages;
  

@override final  ProfileId id;
@override final  String username;
@override final  DateTime createdAt;
 final  List<FavoriteLanguage> _favoriteLanguages;
@override@JsonKey() List<FavoriteLanguage> get favoriteLanguages {
  if (_favoriteLanguages is EqualUnmodifiableListView) return _favoriteLanguages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_favoriteLanguages);
}

@override final  KeyboardLayout? keyboardLayout;
@override final  String? keyboardBrand;
@override final  String? keyboardModel;
@override final  String? favoriteQuote;
@override final  String? favoriteProgrammer;
@override final  String? platform;
@override final  String? operatingSystemVersion;
@override final  String? deviceModel;

/// Create a copy of GuestProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GuestProfileCopyWith<_GuestProfile> get copyWith => __$GuestProfileCopyWithImpl<_GuestProfile>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GuestProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.favoriteLanguages, _favoriteLanguages)&&(identical(other.keyboardLayout, keyboardLayout) || other.keyboardLayout == keyboardLayout)&&(identical(other.keyboardBrand, keyboardBrand) || other.keyboardBrand == keyboardBrand)&&(identical(other.keyboardModel, keyboardModel) || other.keyboardModel == keyboardModel)&&(identical(other.favoriteQuote, favoriteQuote) || other.favoriteQuote == favoriteQuote)&&(identical(other.favoriteProgrammer, favoriteProgrammer) || other.favoriteProgrammer == favoriteProgrammer)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.operatingSystemVersion, operatingSystemVersion) || other.operatingSystemVersion == operatingSystemVersion)&&(identical(other.deviceModel, deviceModel) || other.deviceModel == deviceModel));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,username,createdAt,const DeepCollectionEquality().hash(_favoriteLanguages),keyboardLayout,keyboardBrand,keyboardModel,favoriteQuote,favoriteProgrammer,platform,operatingSystemVersion,deviceModel);
}

@override
String toString() {
    return 'GuestProfile(id: $id, username: $username, createdAt: $createdAt, favoriteLanguages: $favoriteLanguages, keyboardLayout: $keyboardLayout, keyboardBrand: $keyboardBrand, keyboardModel: $keyboardModel, favoriteQuote: $favoriteQuote, favoriteProgrammer: $favoriteProgrammer, platform: $platform, operatingSystemVersion: $operatingSystemVersion, deviceModel: $deviceModel)';
}


}

/// @nodoc
abstract mixin class _$GuestProfileCopyWith<$Res> implements $GuestProfileCopyWith<$Res> {
  factory _$GuestProfileCopyWith(_GuestProfile value, $Res Function(_GuestProfile) _then) = __$GuestProfileCopyWithImpl;
@override @useResult
$Res call({
 ProfileId id, String username, DateTime createdAt, List<FavoriteLanguage> favoriteLanguages, KeyboardLayout? keyboardLayout, String? keyboardBrand, String? keyboardModel, String? favoriteQuote, String? favoriteProgrammer, String? platform, String? operatingSystemVersion, String? deviceModel
});


@override $ProfileIdCopyWith<$Res> get id;

}
/// @nodoc
class __$GuestProfileCopyWithImpl<$Res>
    implements _$GuestProfileCopyWith<$Res> {
  __$GuestProfileCopyWithImpl(this._self, this._then);

  final _GuestProfile _self;
  final $Res Function(_GuestProfile) _then;

/// Create a copy of GuestProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? createdAt = null,Object? favoriteLanguages = null,Object? keyboardLayout = freezed,Object? keyboardBrand = freezed,Object? keyboardModel = freezed,Object? favoriteQuote = freezed,Object? favoriteProgrammer = freezed,Object? platform = freezed,Object? operatingSystemVersion = freezed,Object? deviceModel = freezed,}) {
  return _then(_GuestProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as ProfileId,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,favoriteLanguages: null == favoriteLanguages ? _self._favoriteLanguages : favoriteLanguages // ignore: cast_nullable_to_non_nullable
as List<FavoriteLanguage>,keyboardLayout: freezed == keyboardLayout ? _self.keyboardLayout : keyboardLayout // ignore: cast_nullable_to_non_nullable
as KeyboardLayout?,keyboardBrand: freezed == keyboardBrand ? _self.keyboardBrand : keyboardBrand // ignore: cast_nullable_to_non_nullable
as String?,keyboardModel: freezed == keyboardModel ? _self.keyboardModel : keyboardModel // ignore: cast_nullable_to_non_nullable
as String?,favoriteQuote: freezed == favoriteQuote ? _self.favoriteQuote : favoriteQuote // ignore: cast_nullable_to_non_nullable
as String?,favoriteProgrammer: freezed == favoriteProgrammer ? _self.favoriteProgrammer : favoriteProgrammer // ignore: cast_nullable_to_non_nullable
as String?,platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String?,operatingSystemVersion: freezed == operatingSystemVersion ? _self.operatingSystemVersion : operatingSystemVersion // ignore: cast_nullable_to_non_nullable
as String?,deviceModel: freezed == deviceModel ? _self.deviceModel : deviceModel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of GuestProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileIdCopyWith<$Res> get id {
  
  return $ProfileIdCopyWith<$Res>(_self.id, (value) {
    return _then(_self.copyWith(id: value));
  });
}
}

// dart format on
