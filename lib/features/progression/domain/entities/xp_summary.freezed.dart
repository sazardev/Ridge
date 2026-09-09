// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'xp_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$XpSummary {

 int get totalXp; int get level; int get xpAtCurrentLevel; int get xpForNextLevel;
/// Create a copy of XpSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$XpSummaryCopyWith<XpSummary> get copyWith => _$XpSummaryCopyWithImpl<XpSummary>(this as XpSummary, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as XpSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is XpSummary&&(identical(other.totalXp, _this.totalXp) || other.totalXp == _this.totalXp)&&(identical(other.level, _this.level) || other.level == _this.level)&&(identical(other.xpAtCurrentLevel, _this.xpAtCurrentLevel) || other.xpAtCurrentLevel == _this.xpAtCurrentLevel)&&(identical(other.xpForNextLevel, _this.xpForNextLevel) || other.xpForNextLevel == _this.xpForNextLevel));
}


@override
int get hashCode {
  final _this = this as XpSummary;
  return Object.hash(runtimeType,_this.totalXp,_this.level,_this.xpAtCurrentLevel,_this.xpForNextLevel);
}

@override
String toString() {
  final _this = this as XpSummary;
  return 'XpSummary(totalXp: ${_this.totalXp}, level: ${_this.level}, xpAtCurrentLevel: ${_this.xpAtCurrentLevel}, xpForNextLevel: ${_this.xpForNextLevel})';
}


}

/// @nodoc
abstract mixin class $XpSummaryCopyWith<$Res>  {
  factory $XpSummaryCopyWith(XpSummary value, $Res Function(XpSummary) _then) = _$XpSummaryCopyWithImpl;
@useResult
$Res call({
 int totalXp, int level, int xpAtCurrentLevel, int xpForNextLevel
});




}
/// @nodoc
class _$XpSummaryCopyWithImpl<$Res>
    implements $XpSummaryCopyWith<$Res> {
  _$XpSummaryCopyWithImpl(this._self, this._then);

  final XpSummary _self;
  final $Res Function(XpSummary) _then;

/// Create a copy of XpSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalXp = null,Object? level = null,Object? xpAtCurrentLevel = null,Object? xpForNextLevel = null,}) {
  return _then(XpSummary(
totalXp: null == totalXp ? _self.totalXp : totalXp // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,xpAtCurrentLevel: null == xpAtCurrentLevel ? _self.xpAtCurrentLevel : xpAtCurrentLevel // ignore: cast_nullable_to_non_nullable
as int,xpForNextLevel: null == xpForNextLevel ? _self.xpForNextLevel : xpForNextLevel // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [XpSummary].
extension XpSummaryPatterns on XpSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _XpSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _XpSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _XpSummary value)  $default,){
final _that = this;
switch (_that) {
case _XpSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _XpSummary value)?  $default,){
final _that = this;
switch (_that) {
case _XpSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalXp,  int level,  int xpAtCurrentLevel,  int xpForNextLevel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _XpSummary() when $default != null:
return $default(_that.totalXp,_that.level,_that.xpAtCurrentLevel,_that.xpForNextLevel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalXp,  int level,  int xpAtCurrentLevel,  int xpForNextLevel)  $default,) {final _that = this;
switch (_that) {
case _XpSummary():
return $default(_that.totalXp,_that.level,_that.xpAtCurrentLevel,_that.xpForNextLevel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalXp,  int level,  int xpAtCurrentLevel,  int xpForNextLevel)?  $default,) {final _that = this;
switch (_that) {
case _XpSummary() when $default != null:
return $default(_that.totalXp,_that.level,_that.xpAtCurrentLevel,_that.xpForNextLevel);case _:
  return null;

}
}

}

/// @nodoc


class _XpSummary extends XpSummary {
  const _XpSummary({required this.totalXp, required this.level, required this.xpAtCurrentLevel, required this.xpForNextLevel}): super._();
  

@override final  int totalXp;
@override final  int level;
@override final  int xpAtCurrentLevel;
@override final  int xpForNextLevel;

/// Create a copy of XpSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$XpSummaryCopyWith<_XpSummary> get copyWith => __$XpSummaryCopyWithImpl<_XpSummary>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _XpSummary&&(identical(other.totalXp, totalXp) || other.totalXp == totalXp)&&(identical(other.level, level) || other.level == level)&&(identical(other.xpAtCurrentLevel, xpAtCurrentLevel) || other.xpAtCurrentLevel == xpAtCurrentLevel)&&(identical(other.xpForNextLevel, xpForNextLevel) || other.xpForNextLevel == xpForNextLevel));
}


@override
int get hashCode {
    return Object.hash(runtimeType,totalXp,level,xpAtCurrentLevel,xpForNextLevel);
}

@override
String toString() {
    return 'XpSummary(totalXp: $totalXp, level: $level, xpAtCurrentLevel: $xpAtCurrentLevel, xpForNextLevel: $xpForNextLevel)';
}


}

/// @nodoc
abstract mixin class _$XpSummaryCopyWith<$Res> implements $XpSummaryCopyWith<$Res> {
  factory _$XpSummaryCopyWith(_XpSummary value, $Res Function(_XpSummary) _then) = __$XpSummaryCopyWithImpl;
@override @useResult
$Res call({
 int totalXp, int level, int xpAtCurrentLevel, int xpForNextLevel
});




}
/// @nodoc
class __$XpSummaryCopyWithImpl<$Res>
    implements _$XpSummaryCopyWith<$Res> {
  __$XpSummaryCopyWithImpl(this._self, this._then);

  final _XpSummary _self;
  final $Res Function(_XpSummary) _then;

/// Create a copy of XpSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalXp = null,Object? level = null,Object? xpAtCurrentLevel = null,Object? xpForNextLevel = null,}) {
  return _then(_XpSummary(
totalXp: null == totalXp ? _self.totalXp : totalXp // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,xpAtCurrentLevel: null == xpAtCurrentLevel ? _self.xpAtCurrentLevel : xpAtCurrentLevel // ignore: cast_nullable_to_non_nullable
as int,xpForNextLevel: null == xpForNextLevel ? _self.xpForNextLevel : xpForNextLevel // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
