// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mastery_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MasteryStatus {

 ContentCategory get category; Difficulty get difficulty; bool get isMastered; DateTime get evaluatedAt; int? get passCountInLastFive;
/// Create a copy of MasteryStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MasteryStatusCopyWith<MasteryStatus> get copyWith => _$MasteryStatusCopyWithImpl<MasteryStatus>(this as MasteryStatus, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MasteryStatus;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MasteryStatus&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.difficulty, _this.difficulty) || other.difficulty == _this.difficulty)&&(identical(other.isMastered, _this.isMastered) || other.isMastered == _this.isMastered)&&(identical(other.evaluatedAt, _this.evaluatedAt) || other.evaluatedAt == _this.evaluatedAt)&&(identical(other.passCountInLastFive, _this.passCountInLastFive) || other.passCountInLastFive == _this.passCountInLastFive));
}


@override
int get hashCode {
  final _this = this as MasteryStatus;
  return Object.hash(runtimeType,_this.category,_this.difficulty,_this.isMastered,_this.evaluatedAt,_this.passCountInLastFive);
}

@override
String toString() {
  final _this = this as MasteryStatus;
  return 'MasteryStatus(category: ${_this.category}, difficulty: ${_this.difficulty}, isMastered: ${_this.isMastered}, evaluatedAt: ${_this.evaluatedAt}, passCountInLastFive: ${_this.passCountInLastFive})';
}


}

/// @nodoc
abstract mixin class $MasteryStatusCopyWith<$Res>  {
  factory $MasteryStatusCopyWith(MasteryStatus value, $Res Function(MasteryStatus) _then) = _$MasteryStatusCopyWithImpl;
@useResult
$Res call({
 ContentCategory category, Difficulty difficulty, bool isMastered, DateTime evaluatedAt, int? passCountInLastFive
});




}
/// @nodoc
class _$MasteryStatusCopyWithImpl<$Res>
    implements $MasteryStatusCopyWith<$Res> {
  _$MasteryStatusCopyWithImpl(this._self, this._then);

  final MasteryStatus _self;
  final $Res Function(MasteryStatus) _then;

/// Create a copy of MasteryStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? difficulty = null,Object? isMastered = null,Object? evaluatedAt = null,Object? passCountInLastFive = freezed,}) {
  return _then(MasteryStatus(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ContentCategory,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as Difficulty,isMastered: null == isMastered ? _self.isMastered : isMastered // ignore: cast_nullable_to_non_nullable
as bool,evaluatedAt: null == evaluatedAt ? _self.evaluatedAt : evaluatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,passCountInLastFive: freezed == passCountInLastFive ? _self.passCountInLastFive : passCountInLastFive // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MasteryStatus].
extension MasteryStatusPatterns on MasteryStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MasteryStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MasteryStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MasteryStatus value)  $default,){
final _that = this;
switch (_that) {
case _MasteryStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MasteryStatus value)?  $default,){
final _that = this;
switch (_that) {
case _MasteryStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ContentCategory category,  Difficulty difficulty,  bool isMastered,  DateTime evaluatedAt,  int? passCountInLastFive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MasteryStatus() when $default != null:
return $default(_that.category,_that.difficulty,_that.isMastered,_that.evaluatedAt,_that.passCountInLastFive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ContentCategory category,  Difficulty difficulty,  bool isMastered,  DateTime evaluatedAt,  int? passCountInLastFive)  $default,) {final _that = this;
switch (_that) {
case _MasteryStatus():
return $default(_that.category,_that.difficulty,_that.isMastered,_that.evaluatedAt,_that.passCountInLastFive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ContentCategory category,  Difficulty difficulty,  bool isMastered,  DateTime evaluatedAt,  int? passCountInLastFive)?  $default,) {final _that = this;
switch (_that) {
case _MasteryStatus() when $default != null:
return $default(_that.category,_that.difficulty,_that.isMastered,_that.evaluatedAt,_that.passCountInLastFive);case _:
  return null;

}
}

}

/// @nodoc


class _MasteryStatus implements MasteryStatus {
  const _MasteryStatus({required this.category, required this.difficulty, required this.isMastered, required this.evaluatedAt, this.passCountInLastFive});
  

@override final  ContentCategory category;
@override final  Difficulty difficulty;
@override final  bool isMastered;
@override final  DateTime evaluatedAt;
@override final  int? passCountInLastFive;

/// Create a copy of MasteryStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MasteryStatusCopyWith<_MasteryStatus> get copyWith => __$MasteryStatusCopyWithImpl<_MasteryStatus>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MasteryStatus&&(identical(other.category, category) || other.category == category)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.isMastered, isMastered) || other.isMastered == isMastered)&&(identical(other.evaluatedAt, evaluatedAt) || other.evaluatedAt == evaluatedAt)&&(identical(other.passCountInLastFive, passCountInLastFive) || other.passCountInLastFive == passCountInLastFive));
}


@override
int get hashCode {
    return Object.hash(runtimeType,category,difficulty,isMastered,evaluatedAt,passCountInLastFive);
}

@override
String toString() {
    return 'MasteryStatus(category: $category, difficulty: $difficulty, isMastered: $isMastered, evaluatedAt: $evaluatedAt, passCountInLastFive: $passCountInLastFive)';
}


}

/// @nodoc
abstract mixin class _$MasteryStatusCopyWith<$Res> implements $MasteryStatusCopyWith<$Res> {
  factory _$MasteryStatusCopyWith(_MasteryStatus value, $Res Function(_MasteryStatus) _then) = __$MasteryStatusCopyWithImpl;
@override @useResult
$Res call({
 ContentCategory category, Difficulty difficulty, bool isMastered, DateTime evaluatedAt, int? passCountInLastFive
});




}
/// @nodoc
class __$MasteryStatusCopyWithImpl<$Res>
    implements _$MasteryStatusCopyWith<$Res> {
  __$MasteryStatusCopyWithImpl(this._self, this._then);

  final _MasteryStatus _self;
  final $Res Function(_MasteryStatus) _then;

/// Create a copy of MasteryStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? difficulty = null,Object? isMastered = null,Object? evaluatedAt = null,Object? passCountInLastFive = freezed,}) {
  return _then(_MasteryStatus(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ContentCategory,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as Difficulty,isMastered: null == isMastered ? _self.isMastered : isMastered // ignore: cast_nullable_to_non_nullable
as bool,evaluatedAt: null == evaluatedAt ? _self.evaluatedAt : evaluatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,passCountInLastFive: freezed == passCountInLastFive ? _self.passCountInLastFive : passCountInLastFive // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
