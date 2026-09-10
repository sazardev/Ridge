// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_activity_stat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExerciseActivityStat {

 SnippetId get snippetId; int get sessionCount; Duration get totalPracticeTime; double get avgAccuracyPct; double get avgNetSpeedCpm; double get performanceScore;
/// Create a copy of ExerciseActivityStat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseActivityStatCopyWith<ExerciseActivityStat> get copyWith => _$ExerciseActivityStatCopyWithImpl<ExerciseActivityStat>(this as ExerciseActivityStat, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ExerciseActivityStat;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseActivityStat&&(identical(other.snippetId, _this.snippetId) || other.snippetId == _this.snippetId)&&(identical(other.sessionCount, _this.sessionCount) || other.sessionCount == _this.sessionCount)&&(identical(other.totalPracticeTime, _this.totalPracticeTime) || other.totalPracticeTime == _this.totalPracticeTime)&&(identical(other.avgAccuracyPct, _this.avgAccuracyPct) || other.avgAccuracyPct == _this.avgAccuracyPct)&&(identical(other.avgNetSpeedCpm, _this.avgNetSpeedCpm) || other.avgNetSpeedCpm == _this.avgNetSpeedCpm)&&(identical(other.performanceScore, _this.performanceScore) || other.performanceScore == _this.performanceScore));
}


@override
int get hashCode {
  final _this = this as ExerciseActivityStat;
  return Object.hash(runtimeType,_this.snippetId,_this.sessionCount,_this.totalPracticeTime,_this.avgAccuracyPct,_this.avgNetSpeedCpm,_this.performanceScore);
}

@override
String toString() {
  final _this = this as ExerciseActivityStat;
  return 'ExerciseActivityStat(snippetId: ${_this.snippetId}, sessionCount: ${_this.sessionCount}, totalPracticeTime: ${_this.totalPracticeTime}, avgAccuracyPct: ${_this.avgAccuracyPct}, avgNetSpeedCpm: ${_this.avgNetSpeedCpm}, performanceScore: ${_this.performanceScore})';
}


}

/// @nodoc
abstract mixin class $ExerciseActivityStatCopyWith<$Res>  {
  factory $ExerciseActivityStatCopyWith(ExerciseActivityStat value, $Res Function(ExerciseActivityStat) _then) = _$ExerciseActivityStatCopyWithImpl;
@useResult
$Res call({
 SnippetId snippetId, int sessionCount, Duration totalPracticeTime, double avgAccuracyPct, double avgNetSpeedCpm, double performanceScore
});


$SnippetIdCopyWith<$Res> get snippetId;

}
/// @nodoc
class _$ExerciseActivityStatCopyWithImpl<$Res>
    implements $ExerciseActivityStatCopyWith<$Res> {
  _$ExerciseActivityStatCopyWithImpl(this._self, this._then);

  final ExerciseActivityStat _self;
  final $Res Function(ExerciseActivityStat) _then;

/// Create a copy of ExerciseActivityStat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? snippetId = null,Object? sessionCount = null,Object? totalPracticeTime = null,Object? avgAccuracyPct = null,Object? avgNetSpeedCpm = null,Object? performanceScore = null,}) {
  return _then(ExerciseActivityStat(
snippetId: null == snippetId ? _self.snippetId : snippetId // ignore: cast_nullable_to_non_nullable
as SnippetId,sessionCount: null == sessionCount ? _self.sessionCount : sessionCount // ignore: cast_nullable_to_non_nullable
as int,totalPracticeTime: null == totalPracticeTime ? _self.totalPracticeTime : totalPracticeTime // ignore: cast_nullable_to_non_nullable
as Duration,avgAccuracyPct: null == avgAccuracyPct ? _self.avgAccuracyPct : avgAccuracyPct // ignore: cast_nullable_to_non_nullable
as double,avgNetSpeedCpm: null == avgNetSpeedCpm ? _self.avgNetSpeedCpm : avgNetSpeedCpm // ignore: cast_nullable_to_non_nullable
as double,performanceScore: null == performanceScore ? _self.performanceScore : performanceScore // ignore: cast_nullable_to_non_nullable
as double,
  ));
}
/// Create a copy of ExerciseActivityStat
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SnippetIdCopyWith<$Res> get snippetId {
  
  return $SnippetIdCopyWith<$Res>(_self.snippetId, (value) {
    return _then(_self.copyWith(snippetId: value));
  });
}
}


/// Adds pattern-matching-related methods to [ExerciseActivityStat].
extension ExerciseActivityStatPatterns on ExerciseActivityStat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExerciseActivityStat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExerciseActivityStat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExerciseActivityStat value)  $default,){
final _that = this;
switch (_that) {
case _ExerciseActivityStat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExerciseActivityStat value)?  $default,){
final _that = this;
switch (_that) {
case _ExerciseActivityStat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SnippetId snippetId,  int sessionCount,  Duration totalPracticeTime,  double avgAccuracyPct,  double avgNetSpeedCpm,  double performanceScore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExerciseActivityStat() when $default != null:
return $default(_that.snippetId,_that.sessionCount,_that.totalPracticeTime,_that.avgAccuracyPct,_that.avgNetSpeedCpm,_that.performanceScore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SnippetId snippetId,  int sessionCount,  Duration totalPracticeTime,  double avgAccuracyPct,  double avgNetSpeedCpm,  double performanceScore)  $default,) {final _that = this;
switch (_that) {
case _ExerciseActivityStat():
return $default(_that.snippetId,_that.sessionCount,_that.totalPracticeTime,_that.avgAccuracyPct,_that.avgNetSpeedCpm,_that.performanceScore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SnippetId snippetId,  int sessionCount,  Duration totalPracticeTime,  double avgAccuracyPct,  double avgNetSpeedCpm,  double performanceScore)?  $default,) {final _that = this;
switch (_that) {
case _ExerciseActivityStat() when $default != null:
return $default(_that.snippetId,_that.sessionCount,_that.totalPracticeTime,_that.avgAccuracyPct,_that.avgNetSpeedCpm,_that.performanceScore);case _:
  return null;

}
}

}

/// @nodoc


class _ExerciseActivityStat implements ExerciseActivityStat {
  const _ExerciseActivityStat({required this.snippetId, required this.sessionCount, required this.totalPracticeTime, required this.avgAccuracyPct, required this.avgNetSpeedCpm, required this.performanceScore});
  

@override final  SnippetId snippetId;
@override final  int sessionCount;
@override final  Duration totalPracticeTime;
@override final  double avgAccuracyPct;
@override final  double avgNetSpeedCpm;
@override final  double performanceScore;

/// Create a copy of ExerciseActivityStat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseActivityStatCopyWith<_ExerciseActivityStat> get copyWith => __$ExerciseActivityStatCopyWithImpl<_ExerciseActivityStat>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExerciseActivityStat&&(identical(other.snippetId, snippetId) || other.snippetId == snippetId)&&(identical(other.sessionCount, sessionCount) || other.sessionCount == sessionCount)&&(identical(other.totalPracticeTime, totalPracticeTime) || other.totalPracticeTime == totalPracticeTime)&&(identical(other.avgAccuracyPct, avgAccuracyPct) || other.avgAccuracyPct == avgAccuracyPct)&&(identical(other.avgNetSpeedCpm, avgNetSpeedCpm) || other.avgNetSpeedCpm == avgNetSpeedCpm)&&(identical(other.performanceScore, performanceScore) || other.performanceScore == performanceScore));
}


@override
int get hashCode {
    return Object.hash(runtimeType,snippetId,sessionCount,totalPracticeTime,avgAccuracyPct,avgNetSpeedCpm,performanceScore);
}

@override
String toString() {
    return 'ExerciseActivityStat(snippetId: $snippetId, sessionCount: $sessionCount, totalPracticeTime: $totalPracticeTime, avgAccuracyPct: $avgAccuracyPct, avgNetSpeedCpm: $avgNetSpeedCpm, performanceScore: $performanceScore)';
}


}

/// @nodoc
abstract mixin class _$ExerciseActivityStatCopyWith<$Res> implements $ExerciseActivityStatCopyWith<$Res> {
  factory _$ExerciseActivityStatCopyWith(_ExerciseActivityStat value, $Res Function(_ExerciseActivityStat) _then) = __$ExerciseActivityStatCopyWithImpl;
@override @useResult
$Res call({
 SnippetId snippetId, int sessionCount, Duration totalPracticeTime, double avgAccuracyPct, double avgNetSpeedCpm, double performanceScore
});


@override $SnippetIdCopyWith<$Res> get snippetId;

}
/// @nodoc
class __$ExerciseActivityStatCopyWithImpl<$Res>
    implements _$ExerciseActivityStatCopyWith<$Res> {
  __$ExerciseActivityStatCopyWithImpl(this._self, this._then);

  final _ExerciseActivityStat _self;
  final $Res Function(_ExerciseActivityStat) _then;

/// Create a copy of ExerciseActivityStat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? snippetId = null,Object? sessionCount = null,Object? totalPracticeTime = null,Object? avgAccuracyPct = null,Object? avgNetSpeedCpm = null,Object? performanceScore = null,}) {
  return _then(_ExerciseActivityStat(
snippetId: null == snippetId ? _self.snippetId : snippetId // ignore: cast_nullable_to_non_nullable
as SnippetId,sessionCount: null == sessionCount ? _self.sessionCount : sessionCount // ignore: cast_nullable_to_non_nullable
as int,totalPracticeTime: null == totalPracticeTime ? _self.totalPracticeTime : totalPracticeTime // ignore: cast_nullable_to_non_nullable
as Duration,avgAccuracyPct: null == avgAccuracyPct ? _self.avgAccuracyPct : avgAccuracyPct // ignore: cast_nullable_to_non_nullable
as double,avgNetSpeedCpm: null == avgNetSpeedCpm ? _self.avgNetSpeedCpm : avgNetSpeedCpm // ignore: cast_nullable_to_non_nullable
as double,performanceScore: null == performanceScore ? _self.performanceScore : performanceScore // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of ExerciseActivityStat
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SnippetIdCopyWith<$Res> get snippetId {
  
  return $SnippetIdCopyWith<$Res>(_self.snippetId, (value) {
    return _then(_self.copyWith(snippetId: value));
  });
}
}

// dart format on
