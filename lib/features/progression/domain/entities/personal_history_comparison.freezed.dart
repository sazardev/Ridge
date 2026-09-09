// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'personal_history_comparison.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PersonalHistoryComparison {

 int get sampleSize; double get averageNetSpeedCpm; double get averageAccuracyPct; List<double> get recentNetSpeedCpm; List<double> get recentAccuracyPct;
/// Create a copy of PersonalHistoryComparison
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonalHistoryComparisonCopyWith<PersonalHistoryComparison> get copyWith => _$PersonalHistoryComparisonCopyWithImpl<PersonalHistoryComparison>(this as PersonalHistoryComparison, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PersonalHistoryComparison;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonalHistoryComparison&&(identical(other.sampleSize, _this.sampleSize) || other.sampleSize == _this.sampleSize)&&(identical(other.averageNetSpeedCpm, _this.averageNetSpeedCpm) || other.averageNetSpeedCpm == _this.averageNetSpeedCpm)&&(identical(other.averageAccuracyPct, _this.averageAccuracyPct) || other.averageAccuracyPct == _this.averageAccuracyPct)&&const DeepCollectionEquality().equals(other.recentNetSpeedCpm, _this.recentNetSpeedCpm)&&const DeepCollectionEquality().equals(other.recentAccuracyPct, _this.recentAccuracyPct));
}


@override
int get hashCode {
  final _this = this as PersonalHistoryComparison;
  return Object.hash(runtimeType,_this.sampleSize,_this.averageNetSpeedCpm,_this.averageAccuracyPct,const DeepCollectionEquality().hash(_this.recentNetSpeedCpm),const DeepCollectionEquality().hash(_this.recentAccuracyPct));
}

@override
String toString() {
  final _this = this as PersonalHistoryComparison;
  return 'PersonalHistoryComparison(sampleSize: ${_this.sampleSize}, averageNetSpeedCpm: ${_this.averageNetSpeedCpm}, averageAccuracyPct: ${_this.averageAccuracyPct}, recentNetSpeedCpm: ${_this.recentNetSpeedCpm}, recentAccuracyPct: ${_this.recentAccuracyPct})';
}


}

/// @nodoc
abstract mixin class $PersonalHistoryComparisonCopyWith<$Res>  {
  factory $PersonalHistoryComparisonCopyWith(PersonalHistoryComparison value, $Res Function(PersonalHistoryComparison) _then) = _$PersonalHistoryComparisonCopyWithImpl;
@useResult
$Res call({
 int sampleSize, double averageNetSpeedCpm, double averageAccuracyPct, List<double> recentNetSpeedCpm, List<double> recentAccuracyPct
});




}
/// @nodoc
class _$PersonalHistoryComparisonCopyWithImpl<$Res>
    implements $PersonalHistoryComparisonCopyWith<$Res> {
  _$PersonalHistoryComparisonCopyWithImpl(this._self, this._then);

  final PersonalHistoryComparison _self;
  final $Res Function(PersonalHistoryComparison) _then;

/// Create a copy of PersonalHistoryComparison
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sampleSize = null,Object? averageNetSpeedCpm = null,Object? averageAccuracyPct = null,Object? recentNetSpeedCpm = null,Object? recentAccuracyPct = null,}) {
  return _then(PersonalHistoryComparison(
sampleSize: null == sampleSize ? _self.sampleSize : sampleSize // ignore: cast_nullable_to_non_nullable
as int,averageNetSpeedCpm: null == averageNetSpeedCpm ? _self.averageNetSpeedCpm : averageNetSpeedCpm // ignore: cast_nullable_to_non_nullable
as double,averageAccuracyPct: null == averageAccuracyPct ? _self.averageAccuracyPct : averageAccuracyPct // ignore: cast_nullable_to_non_nullable
as double,recentNetSpeedCpm: null == recentNetSpeedCpm ? _self.recentNetSpeedCpm : recentNetSpeedCpm // ignore: cast_nullable_to_non_nullable
as List<double>,recentAccuracyPct: null == recentAccuracyPct ? _self.recentAccuracyPct : recentAccuracyPct // ignore: cast_nullable_to_non_nullable
as List<double>,
  ));
}

}


/// Adds pattern-matching-related methods to [PersonalHistoryComparison].
extension PersonalHistoryComparisonPatterns on PersonalHistoryComparison {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonalHistoryComparison value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonalHistoryComparison() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonalHistoryComparison value)  $default,){
final _that = this;
switch (_that) {
case _PersonalHistoryComparison():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonalHistoryComparison value)?  $default,){
final _that = this;
switch (_that) {
case _PersonalHistoryComparison() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int sampleSize,  double averageNetSpeedCpm,  double averageAccuracyPct,  List<double> recentNetSpeedCpm,  List<double> recentAccuracyPct)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonalHistoryComparison() when $default != null:
return $default(_that.sampleSize,_that.averageNetSpeedCpm,_that.averageAccuracyPct,_that.recentNetSpeedCpm,_that.recentAccuracyPct);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int sampleSize,  double averageNetSpeedCpm,  double averageAccuracyPct,  List<double> recentNetSpeedCpm,  List<double> recentAccuracyPct)  $default,) {final _that = this;
switch (_that) {
case _PersonalHistoryComparison():
return $default(_that.sampleSize,_that.averageNetSpeedCpm,_that.averageAccuracyPct,_that.recentNetSpeedCpm,_that.recentAccuracyPct);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int sampleSize,  double averageNetSpeedCpm,  double averageAccuracyPct,  List<double> recentNetSpeedCpm,  List<double> recentAccuracyPct)?  $default,) {final _that = this;
switch (_that) {
case _PersonalHistoryComparison() when $default != null:
return $default(_that.sampleSize,_that.averageNetSpeedCpm,_that.averageAccuracyPct,_that.recentNetSpeedCpm,_that.recentAccuracyPct);case _:
  return null;

}
}

}

/// @nodoc


class _PersonalHistoryComparison implements PersonalHistoryComparison {
  const _PersonalHistoryComparison({required this.sampleSize, required this.averageNetSpeedCpm, required this.averageAccuracyPct, required  List<double> recentNetSpeedCpm, required  List<double> recentAccuracyPct}): _recentNetSpeedCpm = recentNetSpeedCpm,_recentAccuracyPct = recentAccuracyPct;
  

@override final  int sampleSize;
@override final  double averageNetSpeedCpm;
@override final  double averageAccuracyPct;
 final  List<double> _recentNetSpeedCpm;
@override List<double> get recentNetSpeedCpm {
  if (_recentNetSpeedCpm is EqualUnmodifiableListView) return _recentNetSpeedCpm;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentNetSpeedCpm);
}

 final  List<double> _recentAccuracyPct;
@override List<double> get recentAccuracyPct {
  if (_recentAccuracyPct is EqualUnmodifiableListView) return _recentAccuracyPct;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentAccuracyPct);
}


/// Create a copy of PersonalHistoryComparison
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonalHistoryComparisonCopyWith<_PersonalHistoryComparison> get copyWith => __$PersonalHistoryComparisonCopyWithImpl<_PersonalHistoryComparison>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonalHistoryComparison&&(identical(other.sampleSize, sampleSize) || other.sampleSize == sampleSize)&&(identical(other.averageNetSpeedCpm, averageNetSpeedCpm) || other.averageNetSpeedCpm == averageNetSpeedCpm)&&(identical(other.averageAccuracyPct, averageAccuracyPct) || other.averageAccuracyPct == averageAccuracyPct)&&const DeepCollectionEquality().equals(other.recentNetSpeedCpm, _recentNetSpeedCpm)&&const DeepCollectionEquality().equals(other.recentAccuracyPct, _recentAccuracyPct));
}


@override
int get hashCode {
    return Object.hash(runtimeType,sampleSize,averageNetSpeedCpm,averageAccuracyPct,const DeepCollectionEquality().hash(_recentNetSpeedCpm),const DeepCollectionEquality().hash(_recentAccuracyPct));
}

@override
String toString() {
    return 'PersonalHistoryComparison(sampleSize: $sampleSize, averageNetSpeedCpm: $averageNetSpeedCpm, averageAccuracyPct: $averageAccuracyPct, recentNetSpeedCpm: $recentNetSpeedCpm, recentAccuracyPct: $recentAccuracyPct)';
}


}

/// @nodoc
abstract mixin class _$PersonalHistoryComparisonCopyWith<$Res> implements $PersonalHistoryComparisonCopyWith<$Res> {
  factory _$PersonalHistoryComparisonCopyWith(_PersonalHistoryComparison value, $Res Function(_PersonalHistoryComparison) _then) = __$PersonalHistoryComparisonCopyWithImpl;
@override @useResult
$Res call({
 int sampleSize, double averageNetSpeedCpm, double averageAccuracyPct, List<double> recentNetSpeedCpm, List<double> recentAccuracyPct
});




}
/// @nodoc
class __$PersonalHistoryComparisonCopyWithImpl<$Res>
    implements _$PersonalHistoryComparisonCopyWith<$Res> {
  __$PersonalHistoryComparisonCopyWithImpl(this._self, this._then);

  final _PersonalHistoryComparison _self;
  final $Res Function(_PersonalHistoryComparison) _then;

/// Create a copy of PersonalHistoryComparison
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sampleSize = null,Object? averageNetSpeedCpm = null,Object? averageAccuracyPct = null,Object? recentNetSpeedCpm = null,Object? recentAccuracyPct = null,}) {
  return _then(_PersonalHistoryComparison(
sampleSize: null == sampleSize ? _self.sampleSize : sampleSize // ignore: cast_nullable_to_non_nullable
as int,averageNetSpeedCpm: null == averageNetSpeedCpm ? _self.averageNetSpeedCpm : averageNetSpeedCpm // ignore: cast_nullable_to_non_nullable
as double,averageAccuracyPct: null == averageAccuracyPct ? _self.averageAccuracyPct : averageAccuracyPct // ignore: cast_nullable_to_non_nullable
as double,recentNetSpeedCpm: null == recentNetSpeedCpm ? _self._recentNetSpeedCpm : recentNetSpeedCpm // ignore: cast_nullable_to_non_nullable
as List<double>,recentAccuracyPct: null == recentAccuracyPct ? _self._recentAccuracyPct : recentAccuracyPct // ignore: cast_nullable_to_non_nullable
as List<double>,
  ));
}


}

// dart format on
