// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfileDto {

 String get id; String get username; String get createdAt; List<String>? get favoriteLanguages; String? get keyboardLayout; String? get keyboardBrand; String? get keyboardModel; String? get favoriteQuote; String? get favoriteProgrammer;
/// Create a copy of ProfileDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileDtoCopyWith<ProfileDto> get copyWith => _$ProfileDtoCopyWithImpl<ProfileDto>(this as ProfileDto, _$identity);

  /// Serializes this ProfileDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProfileDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.username, _this.username) || other.username == _this.username)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&const DeepCollectionEquality().equals(other.favoriteLanguages, _this.favoriteLanguages)&&(identical(other.keyboardLayout, _this.keyboardLayout) || other.keyboardLayout == _this.keyboardLayout)&&(identical(other.keyboardBrand, _this.keyboardBrand) || other.keyboardBrand == _this.keyboardBrand)&&(identical(other.keyboardModel, _this.keyboardModel) || other.keyboardModel == _this.keyboardModel)&&(identical(other.favoriteQuote, _this.favoriteQuote) || other.favoriteQuote == _this.favoriteQuote)&&(identical(other.favoriteProgrammer, _this.favoriteProgrammer) || other.favoriteProgrammer == _this.favoriteProgrammer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProfileDto;
  return Object.hash(runtimeType,_this.id,_this.username,_this.createdAt,const DeepCollectionEquality().hash(_this.favoriteLanguages),_this.keyboardLayout,_this.keyboardBrand,_this.keyboardModel,_this.favoriteQuote,_this.favoriteProgrammer);
}

@override
String toString() {
  final _this = this as ProfileDto;
  return 'ProfileDto(id: ${_this.id}, username: ${_this.username}, createdAt: ${_this.createdAt}, favoriteLanguages: ${_this.favoriteLanguages}, keyboardLayout: ${_this.keyboardLayout}, keyboardBrand: ${_this.keyboardBrand}, keyboardModel: ${_this.keyboardModel}, favoriteQuote: ${_this.favoriteQuote}, favoriteProgrammer: ${_this.favoriteProgrammer})';
}


}

/// @nodoc
abstract mixin class $ProfileDtoCopyWith<$Res>  {
  factory $ProfileDtoCopyWith(ProfileDto value, $Res Function(ProfileDto) _then) = _$ProfileDtoCopyWithImpl;
@useResult
$Res call({
 String id, String username, String createdAt, List<String>? favoriteLanguages, String? keyboardLayout, String? keyboardBrand, String? keyboardModel, String? favoriteQuote, String? favoriteProgrammer
});




}
/// @nodoc
class _$ProfileDtoCopyWithImpl<$Res>
    implements $ProfileDtoCopyWith<$Res> {
  _$ProfileDtoCopyWithImpl(this._self, this._then);

  final ProfileDto _self;
  final $Res Function(ProfileDto) _then;

/// Create a copy of ProfileDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? createdAt = null,Object? favoriteLanguages = freezed,Object? keyboardLayout = freezed,Object? keyboardBrand = freezed,Object? keyboardModel = freezed,Object? favoriteQuote = freezed,Object? favoriteProgrammer = freezed,}) {
  return _then(ProfileDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,favoriteLanguages: freezed == favoriteLanguages ? _self.favoriteLanguages : favoriteLanguages // ignore: cast_nullable_to_non_nullable
as List<String>?,keyboardLayout: freezed == keyboardLayout ? _self.keyboardLayout : keyboardLayout // ignore: cast_nullable_to_non_nullable
as String?,keyboardBrand: freezed == keyboardBrand ? _self.keyboardBrand : keyboardBrand // ignore: cast_nullable_to_non_nullable
as String?,keyboardModel: freezed == keyboardModel ? _self.keyboardModel : keyboardModel // ignore: cast_nullable_to_non_nullable
as String?,favoriteQuote: freezed == favoriteQuote ? _self.favoriteQuote : favoriteQuote // ignore: cast_nullable_to_non_nullable
as String?,favoriteProgrammer: freezed == favoriteProgrammer ? _self.favoriteProgrammer : favoriteProgrammer // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileDto].
extension ProfileDtoPatterns on ProfileDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileDto value)  $default,){
final _that = this;
switch (_that) {
case _ProfileDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String username,  String createdAt,  List<String>? favoriteLanguages,  String? keyboardLayout,  String? keyboardBrand,  String? keyboardModel,  String? favoriteQuote,  String? favoriteProgrammer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileDto() when $default != null:
return $default(_that.id,_that.username,_that.createdAt,_that.favoriteLanguages,_that.keyboardLayout,_that.keyboardBrand,_that.keyboardModel,_that.favoriteQuote,_that.favoriteProgrammer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String username,  String createdAt,  List<String>? favoriteLanguages,  String? keyboardLayout,  String? keyboardBrand,  String? keyboardModel,  String? favoriteQuote,  String? favoriteProgrammer)  $default,) {final _that = this;
switch (_that) {
case _ProfileDto():
return $default(_that.id,_that.username,_that.createdAt,_that.favoriteLanguages,_that.keyboardLayout,_that.keyboardBrand,_that.keyboardModel,_that.favoriteQuote,_that.favoriteProgrammer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String username,  String createdAt,  List<String>? favoriteLanguages,  String? keyboardLayout,  String? keyboardBrand,  String? keyboardModel,  String? favoriteQuote,  String? favoriteProgrammer)?  $default,) {final _that = this;
switch (_that) {
case _ProfileDto() when $default != null:
return $default(_that.id,_that.username,_that.createdAt,_that.favoriteLanguages,_that.keyboardLayout,_that.keyboardBrand,_that.keyboardModel,_that.favoriteQuote,_that.favoriteProgrammer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileDto implements ProfileDto {
  const _ProfileDto({required this.id, required this.username, required this.createdAt,  List<String>? favoriteLanguages, this.keyboardLayout, this.keyboardBrand, this.keyboardModel, this.favoriteQuote, this.favoriteProgrammer}): _favoriteLanguages = favoriteLanguages;
  factory _ProfileDto.fromJson(Map<String, dynamic> json) => _$ProfileDtoFromJson(json);

@override final  String id;
@override final  String username;
@override final  String createdAt;
 final  List<String>? _favoriteLanguages;
@override List<String>? get favoriteLanguages {
  final value = _favoriteLanguages;
  if (value == null) return null;
  if (_favoriteLanguages is EqualUnmodifiableListView) return _favoriteLanguages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? keyboardLayout;
@override final  String? keyboardBrand;
@override final  String? keyboardModel;
@override final  String? favoriteQuote;
@override final  String? favoriteProgrammer;

/// Create a copy of ProfileDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileDtoCopyWith<_ProfileDto> get copyWith => __$ProfileDtoCopyWithImpl<_ProfileDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileDto&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.favoriteLanguages, _favoriteLanguages)&&(identical(other.keyboardLayout, keyboardLayout) || other.keyboardLayout == keyboardLayout)&&(identical(other.keyboardBrand, keyboardBrand) || other.keyboardBrand == keyboardBrand)&&(identical(other.keyboardModel, keyboardModel) || other.keyboardModel == keyboardModel)&&(identical(other.favoriteQuote, favoriteQuote) || other.favoriteQuote == favoriteQuote)&&(identical(other.favoriteProgrammer, favoriteProgrammer) || other.favoriteProgrammer == favoriteProgrammer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,username,createdAt,const DeepCollectionEquality().hash(_favoriteLanguages),keyboardLayout,keyboardBrand,keyboardModel,favoriteQuote,favoriteProgrammer);
}

@override
String toString() {
    return 'ProfileDto(id: $id, username: $username, createdAt: $createdAt, favoriteLanguages: $favoriteLanguages, keyboardLayout: $keyboardLayout, keyboardBrand: $keyboardBrand, keyboardModel: $keyboardModel, favoriteQuote: $favoriteQuote, favoriteProgrammer: $favoriteProgrammer)';
}


}

/// @nodoc
abstract mixin class _$ProfileDtoCopyWith<$Res> implements $ProfileDtoCopyWith<$Res> {
  factory _$ProfileDtoCopyWith(_ProfileDto value, $Res Function(_ProfileDto) _then) = __$ProfileDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String username, String createdAt, List<String>? favoriteLanguages, String? keyboardLayout, String? keyboardBrand, String? keyboardModel, String? favoriteQuote, String? favoriteProgrammer
});




}
/// @nodoc
class __$ProfileDtoCopyWithImpl<$Res>
    implements _$ProfileDtoCopyWith<$Res> {
  __$ProfileDtoCopyWithImpl(this._self, this._then);

  final _ProfileDto _self;
  final $Res Function(_ProfileDto) _then;

/// Create a copy of ProfileDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? createdAt = null,Object? favoriteLanguages = freezed,Object? keyboardLayout = freezed,Object? keyboardBrand = freezed,Object? keyboardModel = freezed,Object? favoriteQuote = freezed,Object? favoriteProgrammer = freezed,}) {
  return _then(_ProfileDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,favoriteLanguages: freezed == favoriteLanguages ? _self._favoriteLanguages : favoriteLanguages // ignore: cast_nullable_to_non_nullable
as List<String>?,keyboardLayout: freezed == keyboardLayout ? _self.keyboardLayout : keyboardLayout // ignore: cast_nullable_to_non_nullable
as String?,keyboardBrand: freezed == keyboardBrand ? _self.keyboardBrand : keyboardBrand // ignore: cast_nullable_to_non_nullable
as String?,keyboardModel: freezed == keyboardModel ? _self.keyboardModel : keyboardModel // ignore: cast_nullable_to_non_nullable
as String?,favoriteQuote: freezed == favoriteQuote ? _self.favoriteQuote : favoriteQuote // ignore: cast_nullable_to_non_nullable
as String?,favoriteProgrammer: freezed == favoriteProgrammer ? _self.favoriteProgrammer : favoriteProgrammer // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
