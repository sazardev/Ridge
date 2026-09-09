// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'achievement_id.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AchievementId {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AchievementId);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AchievementId()';
}


}

/// @nodoc
class $AchievementIdCopyWith<$Res>  {
$AchievementIdCopyWith(AchievementId _, $Res Function(AchievementId) __);
}


/// Adds pattern-matching-related methods to [AchievementId].
extension AchievementIdPatterns on AchievementId {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _CeroErrores value)?  ceroErrores,TResult Function( _Maratonista value)?  maratonista,TResult Function( _Ambidiestro value)?  ambidiestro,TResult Function( _CategoryMastery value)?  categoryMastery,TResult Function( _Streak value)?  streak,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CeroErrores() when ceroErrores != null:
return ceroErrores(_that);case _Maratonista() when maratonista != null:
return maratonista(_that);case _Ambidiestro() when ambidiestro != null:
return ambidiestro(_that);case _CategoryMastery() when categoryMastery != null:
return categoryMastery(_that);case _Streak() when streak != null:
return streak(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _CeroErrores value)  ceroErrores,required TResult Function( _Maratonista value)  maratonista,required TResult Function( _Ambidiestro value)  ambidiestro,required TResult Function( _CategoryMastery value)  categoryMastery,required TResult Function( _Streak value)  streak,}){
final _that = this;
switch (_that) {
case _CeroErrores():
return ceroErrores(_that);case _Maratonista():
return maratonista(_that);case _Ambidiestro():
return ambidiestro(_that);case _CategoryMastery():
return categoryMastery(_that);case _Streak():
return streak(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _CeroErrores value)?  ceroErrores,TResult? Function( _Maratonista value)?  maratonista,TResult? Function( _Ambidiestro value)?  ambidiestro,TResult? Function( _CategoryMastery value)?  categoryMastery,TResult? Function( _Streak value)?  streak,}){
final _that = this;
switch (_that) {
case _CeroErrores() when ceroErrores != null:
return ceroErrores(_that);case _Maratonista() when maratonista != null:
return maratonista(_that);case _Ambidiestro() when ambidiestro != null:
return ambidiestro(_that);case _CategoryMastery() when categoryMastery != null:
return categoryMastery(_that);case _Streak() when streak != null:
return streak(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  ceroErrores,TResult Function( MaratonistaTier tier)?  maratonista,TResult Function()?  ambidiestro,TResult Function( ContentCategory category,  Difficulty difficulty)?  categoryMastery,TResult Function( StreakTier tier)?  streak,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CeroErrores() when ceroErrores != null:
return ceroErrores();case _Maratonista() when maratonista != null:
return maratonista(_that.tier);case _Ambidiestro() when ambidiestro != null:
return ambidiestro();case _CategoryMastery() when categoryMastery != null:
return categoryMastery(_that.category,_that.difficulty);case _Streak() when streak != null:
return streak(_that.tier);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  ceroErrores,required TResult Function( MaratonistaTier tier)  maratonista,required TResult Function()  ambidiestro,required TResult Function( ContentCategory category,  Difficulty difficulty)  categoryMastery,required TResult Function( StreakTier tier)  streak,}) {final _that = this;
switch (_that) {
case _CeroErrores():
return ceroErrores();case _Maratonista():
return maratonista(_that.tier);case _Ambidiestro():
return ambidiestro();case _CategoryMastery():
return categoryMastery(_that.category,_that.difficulty);case _Streak():
return streak(_that.tier);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  ceroErrores,TResult? Function( MaratonistaTier tier)?  maratonista,TResult? Function()?  ambidiestro,TResult? Function( ContentCategory category,  Difficulty difficulty)?  categoryMastery,TResult? Function( StreakTier tier)?  streak,}) {final _that = this;
switch (_that) {
case _CeroErrores() when ceroErrores != null:
return ceroErrores();case _Maratonista() when maratonista != null:
return maratonista(_that.tier);case _Ambidiestro() when ambidiestro != null:
return ambidiestro();case _CategoryMastery() when categoryMastery != null:
return categoryMastery(_that.category,_that.difficulty);case _Streak() when streak != null:
return streak(_that.tier);case _:
  return null;

}
}

}

/// @nodoc


class _CeroErrores extends AchievementId {
  const _CeroErrores(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CeroErrores);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AchievementId.ceroErrores()';
}


}




/// @nodoc


class _Maratonista extends AchievementId {
  const _Maratonista(this.tier): super._();
  

 final  MaratonistaTier tier;

/// Create a copy of AchievementId
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MaratonistaCopyWith<_Maratonista> get copyWith => __$MaratonistaCopyWithImpl<_Maratonista>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Maratonista&&(identical(other.tier, tier) || other.tier == tier));
}


@override
int get hashCode {
    return Object.hash(runtimeType,tier);
}

@override
String toString() {
    return 'AchievementId.maratonista(tier: $tier)';
}


}

/// @nodoc
abstract mixin class _$MaratonistaCopyWith<$Res> implements $AchievementIdCopyWith<$Res> {
  factory _$MaratonistaCopyWith(_Maratonista value, $Res Function(_Maratonista) _then) = __$MaratonistaCopyWithImpl;
@useResult
$Res call({
 MaratonistaTier tier
});




}
/// @nodoc
class __$MaratonistaCopyWithImpl<$Res>
    implements _$MaratonistaCopyWith<$Res> {
  __$MaratonistaCopyWithImpl(this._self, this._then);

  final _Maratonista _self;
  final $Res Function(_Maratonista) _then;

/// Create a copy of AchievementId
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tier = null,}) {
  return _then(_Maratonista(
null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as MaratonistaTier,
  ));
}


}

/// @nodoc


class _Ambidiestro extends AchievementId {
  const _Ambidiestro(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Ambidiestro);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AchievementId.ambidiestro()';
}


}




/// @nodoc


class _CategoryMastery extends AchievementId {
  const _CategoryMastery({required this.category, required this.difficulty}): super._();
  

 final  ContentCategory category;
 final  Difficulty difficulty;

/// Create a copy of AchievementId
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryMasteryCopyWith<_CategoryMastery> get copyWith => __$CategoryMasteryCopyWithImpl<_CategoryMastery>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryMastery&&(identical(other.category, category) || other.category == category)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty));
}


@override
int get hashCode {
    return Object.hash(runtimeType,category,difficulty);
}

@override
String toString() {
    return 'AchievementId.categoryMastery(category: $category, difficulty: $difficulty)';
}


}

/// @nodoc
abstract mixin class _$CategoryMasteryCopyWith<$Res> implements $AchievementIdCopyWith<$Res> {
  factory _$CategoryMasteryCopyWith(_CategoryMastery value, $Res Function(_CategoryMastery) _then) = __$CategoryMasteryCopyWithImpl;
@useResult
$Res call({
 ContentCategory category, Difficulty difficulty
});




}
/// @nodoc
class __$CategoryMasteryCopyWithImpl<$Res>
    implements _$CategoryMasteryCopyWith<$Res> {
  __$CategoryMasteryCopyWithImpl(this._self, this._then);

  final _CategoryMastery _self;
  final $Res Function(_CategoryMastery) _then;

/// Create a copy of AchievementId
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? category = null,Object? difficulty = null,}) {
  return _then(_CategoryMastery(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ContentCategory,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as Difficulty,
  ));
}


}

/// @nodoc


class _Streak extends AchievementId {
  const _Streak(this.tier): super._();
  

 final  StreakTier tier;

/// Create a copy of AchievementId
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StreakCopyWith<_Streak> get copyWith => __$StreakCopyWithImpl<_Streak>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Streak&&(identical(other.tier, tier) || other.tier == tier));
}


@override
int get hashCode {
    return Object.hash(runtimeType,tier);
}

@override
String toString() {
    return 'AchievementId.streak(tier: $tier)';
}


}

/// @nodoc
abstract mixin class _$StreakCopyWith<$Res> implements $AchievementIdCopyWith<$Res> {
  factory _$StreakCopyWith(_Streak value, $Res Function(_Streak) _then) = __$StreakCopyWithImpl;
@useResult
$Res call({
 StreakTier tier
});




}
/// @nodoc
class __$StreakCopyWithImpl<$Res>
    implements _$StreakCopyWith<$Res> {
  __$StreakCopyWithImpl(this._self, this._then);

  final _Streak _self;
  final $Res Function(_Streak) _then;

/// Create a copy of AchievementId
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tier = null,}) {
  return _then(_Streak(
null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as StreakTier,
  ));
}


}

// dart format on
