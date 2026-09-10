// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_activity_stat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CategoryActivityStat {

 ContentCategory get category; int get sessionCount; Duration get totalPracticeTime; double get avgAccuracyPct; double get avgNetSpeedCpm; double get performanceScore; Trend get trend;
/// Create a copy of CategoryActivityStat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryActivityStatCopyWith<CategoryActivityStat> get copyWith => _$CategoryActivityStatCopyWithImpl<CategoryActivityStat>(this as CategoryActivityStat, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CategoryActivityStat;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryActivityStat&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.sessionCount, _this.sessionCount) || other.sessionCount == _this.sessionCount)&&(identical(other.totalPracticeTime, _this.totalPracticeTime) || other.totalPracticeTime == _this.totalPracticeTime)&&(identical(other.avgAccuracyPct, _this.avgAccuracyPct) || other.avgAccuracyPct == _this.avgAccuracyPct)&&(identical(other.avgNetSpeedCpm, _this.avgNetSpeedCpm) || other.avgNetSpeedCpm == _this.avgNetSpeedCpm)&&(identical(other.performanceScore, _this.performanceScore) || other.performanceScore == _this.performanceScore)&&(identical(other.trend, _this.trend) || other.trend == _this.trend));
}


@override
int get hashCode {
  final _this = this as CategoryActivityStat;
  return Object.hash(runtimeType,_this.category,_this.sessionCount,_this.totalPracticeTime,_this.avgAccuracyPct,_this.avgNetSpeedCpm,_this.performanceScore,_this.trend);
}

@override
String toString() {
  final _this = this as CategoryActivityStat;
  return 'CategoryActivityStat(category: ${_this.category}, sessionCount: ${_this.sessionCount}, totalPracticeTime: ${_this.totalPracticeTime}, avgAccuracyPct: ${_this.avgAccuracyPct}, avgNetSpeedCpm: ${_this.avgNetSpeedCpm}, performanceScore: ${_this.performanceScore}, trend: ${_this.trend})';
}


}

/// @nodoc
abstract mixin class $CategoryActivityStatCopyWith<$Res>  {
  factory $CategoryActivityStatCopyWith(CategoryActivityStat value, $Res Function(CategoryActivityStat) _then) = _$CategoryActivityStatCopyWithImpl;
@useResult
$Res call({
 ContentCategory category, int sessionCount, Duration totalPracticeTime, double avgAccuracyPct, double avgNetSpeedCpm, double performanceScore, Trend trend
});




}
/// @nodoc
class _$CategoryActivityStatCopyWithImpl<$Res>
    implements $CategoryActivityStatCopyWith<$Res> {
  _$CategoryActivityStatCopyWithImpl(this._self, this._then);

  final CategoryActivityStat _self;
  final $Res Function(CategoryActivityStat) _then;

/// Create a copy of CategoryActivityStat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? sessionCount = null,Object? totalPracticeTime = null,Object? avgAccuracyPct = null,Object? avgNetSpeedCpm = null,Object? performanceScore = null,Object? trend = null,}) {
  return _then(CategoryActivityStat(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ContentCategory,sessionCount: null == sessionCount ? _self.sessionCount : sessionCount // ignore: cast_nullable_to_non_nullable
as int,totalPracticeTime: null == totalPracticeTime ? _self.totalPracticeTime : totalPracticeTime // ignore: cast_nullable_to_non_nullable
as Duration,avgAccuracyPct: null == avgAccuracyPct ? _self.avgAccuracyPct : avgAccuracyPct // ignore: cast_nullable_to_non_nullable
as double,avgNetSpeedCpm: null == avgNetSpeedCpm ? _self.avgNetSpeedCpm : avgNetSpeedCpm // ignore: cast_nullable_to_non_nullable
as double,performanceScore: null == performanceScore ? _self.performanceScore : performanceScore // ignore: cast_nullable_to_non_nullable
as double,trend: null == trend ? _self.trend : trend // ignore: cast_nullable_to_non_nullable
as Trend,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryActivityStat].
extension CategoryActivityStatPatterns on CategoryActivityStat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryActivityStat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryActivityStat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryActivityStat value)  $default,){
final _that = this;
switch (_that) {
case _CategoryActivityStat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryActivityStat value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryActivityStat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ContentCategory category,  int sessionCount,  Duration totalPracticeTime,  double avgAccuracyPct,  double avgNetSpeedCpm,  double performanceScore,  Trend trend)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryActivityStat() when $default != null:
return $default(_that.category,_that.sessionCount,_that.totalPracticeTime,_that.avgAccuracyPct,_that.avgNetSpeedCpm,_that.performanceScore,_that.trend);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ContentCategory category,  int sessionCount,  Duration totalPracticeTime,  double avgAccuracyPct,  double avgNetSpeedCpm,  double performanceScore,  Trend trend)  $default,) {final _that = this;
switch (_that) {
case _CategoryActivityStat():
return $default(_that.category,_that.sessionCount,_that.totalPracticeTime,_that.avgAccuracyPct,_that.avgNetSpeedCpm,_that.performanceScore,_that.trend);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ContentCategory category,  int sessionCount,  Duration totalPracticeTime,  double avgAccuracyPct,  double avgNetSpeedCpm,  double performanceScore,  Trend trend)?  $default,) {final _that = this;
switch (_that) {
case _CategoryActivityStat() when $default != null:
return $default(_that.category,_that.sessionCount,_that.totalPracticeTime,_that.avgAccuracyPct,_that.avgNetSpeedCpm,_that.performanceScore,_that.trend);case _:
  return null;

}
}

}

/// @nodoc


class _CategoryActivityStat implements CategoryActivityStat {
  const _CategoryActivityStat({required this.category, required this.sessionCount, required this.totalPracticeTime, required this.avgAccuracyPct, required this.avgNetSpeedCpm, required this.performanceScore, required this.trend});
  

@override final  ContentCategory category;
@override final  int sessionCount;
@override final  Duration totalPracticeTime;
@override final  double avgAccuracyPct;
@override final  double avgNetSpeedCpm;
@override final  double performanceScore;
@override final  Trend trend;

/// Create a copy of CategoryActivityStat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryActivityStatCopyWith<_CategoryActivityStat> get copyWith => __$CategoryActivityStatCopyWithImpl<_CategoryActivityStat>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryActivityStat&&(identical(other.category, category) || other.category == category)&&(identical(other.sessionCount, sessionCount) || other.sessionCount == sessionCount)&&(identical(other.totalPracticeTime, totalPracticeTime) || other.totalPracticeTime == totalPracticeTime)&&(identical(other.avgAccuracyPct, avgAccuracyPct) || other.avgAccuracyPct == avgAccuracyPct)&&(identical(other.avgNetSpeedCpm, avgNetSpeedCpm) || other.avgNetSpeedCpm == avgNetSpeedCpm)&&(identical(other.performanceScore, performanceScore) || other.performanceScore == performanceScore)&&(identical(other.trend, trend) || other.trend == trend));
}


@override
int get hashCode {
    return Object.hash(runtimeType,category,sessionCount,totalPracticeTime,avgAccuracyPct,avgNetSpeedCpm,performanceScore,trend);
}

@override
String toString() {
    return 'CategoryActivityStat(category: $category, sessionCount: $sessionCount, totalPracticeTime: $totalPracticeTime, avgAccuracyPct: $avgAccuracyPct, avgNetSpeedCpm: $avgNetSpeedCpm, performanceScore: $performanceScore, trend: $trend)';
}


}

/// @nodoc
abstract mixin class _$CategoryActivityStatCopyWith<$Res> implements $CategoryActivityStatCopyWith<$Res> {
  factory _$CategoryActivityStatCopyWith(_CategoryActivityStat value, $Res Function(_CategoryActivityStat) _then) = __$CategoryActivityStatCopyWithImpl;
@override @useResult
$Res call({
 ContentCategory category, int sessionCount, Duration totalPracticeTime, double avgAccuracyPct, double avgNetSpeedCpm, double performanceScore, Trend trend
});




}
/// @nodoc
class __$CategoryActivityStatCopyWithImpl<$Res>
    implements _$CategoryActivityStatCopyWith<$Res> {
  __$CategoryActivityStatCopyWithImpl(this._self, this._then);

  final _CategoryActivityStat _self;
  final $Res Function(_CategoryActivityStat) _then;

/// Create a copy of CategoryActivityStat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? sessionCount = null,Object? totalPracticeTime = null,Object? avgAccuracyPct = null,Object? avgNetSpeedCpm = null,Object? performanceScore = null,Object? trend = null,}) {
  return _then(_CategoryActivityStat(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ContentCategory,sessionCount: null == sessionCount ? _self.sessionCount : sessionCount // ignore: cast_nullable_to_non_nullable
as int,totalPracticeTime: null == totalPracticeTime ? _self.totalPracticeTime : totalPracticeTime // ignore: cast_nullable_to_non_nullable
as Duration,avgAccuracyPct: null == avgAccuracyPct ? _self.avgAccuracyPct : avgAccuracyPct // ignore: cast_nullable_to_non_nullable
as double,avgNetSpeedCpm: null == avgNetSpeedCpm ? _self.avgNetSpeedCpm : avgNetSpeedCpm // ignore: cast_nullable_to_non_nullable
as double,performanceScore: null == performanceScore ? _self.performanceScore : performanceScore // ignore: cast_nullable_to_non_nullable
as double,trend: null == trend ? _self.trend : trend // ignore: cast_nullable_to_non_nullable
as Trend,
  ));
}


}

// dart format on
