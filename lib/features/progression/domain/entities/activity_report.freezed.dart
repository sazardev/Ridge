// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActivityReport {

 List<CategoryActivityStat> get mostPracticedCategories; List<CategoryActivityStat> get lowestScoringCategories; List<ExerciseActivityStat> get mostPracticedExercises; List<ExerciseActivityStat> get lowestScoringExercises;
/// Create a copy of ActivityReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityReportCopyWith<ActivityReport> get copyWith => _$ActivityReportCopyWithImpl<ActivityReport>(this as ActivityReport, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ActivityReport;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityReport&&const DeepCollectionEquality().equals(other.mostPracticedCategories, _this.mostPracticedCategories)&&const DeepCollectionEquality().equals(other.lowestScoringCategories, _this.lowestScoringCategories)&&const DeepCollectionEquality().equals(other.mostPracticedExercises, _this.mostPracticedExercises)&&const DeepCollectionEquality().equals(other.lowestScoringExercises, _this.lowestScoringExercises));
}


@override
int get hashCode {
  final _this = this as ActivityReport;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.mostPracticedCategories),const DeepCollectionEquality().hash(_this.lowestScoringCategories),const DeepCollectionEquality().hash(_this.mostPracticedExercises),const DeepCollectionEquality().hash(_this.lowestScoringExercises));
}

@override
String toString() {
  final _this = this as ActivityReport;
  return 'ActivityReport(mostPracticedCategories: ${_this.mostPracticedCategories}, lowestScoringCategories: ${_this.lowestScoringCategories}, mostPracticedExercises: ${_this.mostPracticedExercises}, lowestScoringExercises: ${_this.lowestScoringExercises})';
}


}

/// @nodoc
abstract mixin class $ActivityReportCopyWith<$Res>  {
  factory $ActivityReportCopyWith(ActivityReport value, $Res Function(ActivityReport) _then) = _$ActivityReportCopyWithImpl;
@useResult
$Res call({
 List<CategoryActivityStat> mostPracticedCategories, List<CategoryActivityStat> lowestScoringCategories, List<ExerciseActivityStat> mostPracticedExercises, List<ExerciseActivityStat> lowestScoringExercises
});




}
/// @nodoc
class _$ActivityReportCopyWithImpl<$Res>
    implements $ActivityReportCopyWith<$Res> {
  _$ActivityReportCopyWithImpl(this._self, this._then);

  final ActivityReport _self;
  final $Res Function(ActivityReport) _then;

/// Create a copy of ActivityReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mostPracticedCategories = null,Object? lowestScoringCategories = null,Object? mostPracticedExercises = null,Object? lowestScoringExercises = null,}) {
  return _then(ActivityReport(
mostPracticedCategories: null == mostPracticedCategories ? _self.mostPracticedCategories : mostPracticedCategories // ignore: cast_nullable_to_non_nullable
as List<CategoryActivityStat>,lowestScoringCategories: null == lowestScoringCategories ? _self.lowestScoringCategories : lowestScoringCategories // ignore: cast_nullable_to_non_nullable
as List<CategoryActivityStat>,mostPracticedExercises: null == mostPracticedExercises ? _self.mostPracticedExercises : mostPracticedExercises // ignore: cast_nullable_to_non_nullable
as List<ExerciseActivityStat>,lowestScoringExercises: null == lowestScoringExercises ? _self.lowestScoringExercises : lowestScoringExercises // ignore: cast_nullable_to_non_nullable
as List<ExerciseActivityStat>,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityReport].
extension ActivityReportPatterns on ActivityReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityReport value)  $default,){
final _that = this;
switch (_that) {
case _ActivityReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityReport value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CategoryActivityStat> mostPracticedCategories,  List<CategoryActivityStat> lowestScoringCategories,  List<ExerciseActivityStat> mostPracticedExercises,  List<ExerciseActivityStat> lowestScoringExercises)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityReport() when $default != null:
return $default(_that.mostPracticedCategories,_that.lowestScoringCategories,_that.mostPracticedExercises,_that.lowestScoringExercises);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CategoryActivityStat> mostPracticedCategories,  List<CategoryActivityStat> lowestScoringCategories,  List<ExerciseActivityStat> mostPracticedExercises,  List<ExerciseActivityStat> lowestScoringExercises)  $default,) {final _that = this;
switch (_that) {
case _ActivityReport():
return $default(_that.mostPracticedCategories,_that.lowestScoringCategories,_that.mostPracticedExercises,_that.lowestScoringExercises);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CategoryActivityStat> mostPracticedCategories,  List<CategoryActivityStat> lowestScoringCategories,  List<ExerciseActivityStat> mostPracticedExercises,  List<ExerciseActivityStat> lowestScoringExercises)?  $default,) {final _that = this;
switch (_that) {
case _ActivityReport() when $default != null:
return $default(_that.mostPracticedCategories,_that.lowestScoringCategories,_that.mostPracticedExercises,_that.lowestScoringExercises);case _:
  return null;

}
}

}

/// @nodoc


class _ActivityReport implements ActivityReport {
  const _ActivityReport({required  List<CategoryActivityStat> mostPracticedCategories, required  List<CategoryActivityStat> lowestScoringCategories, required  List<ExerciseActivityStat> mostPracticedExercises, required  List<ExerciseActivityStat> lowestScoringExercises}): _mostPracticedCategories = mostPracticedCategories,_lowestScoringCategories = lowestScoringCategories,_mostPracticedExercises = mostPracticedExercises,_lowestScoringExercises = lowestScoringExercises;
  

 final  List<CategoryActivityStat> _mostPracticedCategories;
@override List<CategoryActivityStat> get mostPracticedCategories {
  if (_mostPracticedCategories is EqualUnmodifiableListView) return _mostPracticedCategories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mostPracticedCategories);
}

 final  List<CategoryActivityStat> _lowestScoringCategories;
@override List<CategoryActivityStat> get lowestScoringCategories {
  if (_lowestScoringCategories is EqualUnmodifiableListView) return _lowestScoringCategories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lowestScoringCategories);
}

 final  List<ExerciseActivityStat> _mostPracticedExercises;
@override List<ExerciseActivityStat> get mostPracticedExercises {
  if (_mostPracticedExercises is EqualUnmodifiableListView) return _mostPracticedExercises;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mostPracticedExercises);
}

 final  List<ExerciseActivityStat> _lowestScoringExercises;
@override List<ExerciseActivityStat> get lowestScoringExercises {
  if (_lowestScoringExercises is EqualUnmodifiableListView) return _lowestScoringExercises;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lowestScoringExercises);
}


/// Create a copy of ActivityReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityReportCopyWith<_ActivityReport> get copyWith => __$ActivityReportCopyWithImpl<_ActivityReport>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityReport&&const DeepCollectionEquality().equals(other.mostPracticedCategories, _mostPracticedCategories)&&const DeepCollectionEquality().equals(other.lowestScoringCategories, _lowestScoringCategories)&&const DeepCollectionEquality().equals(other.mostPracticedExercises, _mostPracticedExercises)&&const DeepCollectionEquality().equals(other.lowestScoringExercises, _lowestScoringExercises));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_mostPracticedCategories),const DeepCollectionEquality().hash(_lowestScoringCategories),const DeepCollectionEquality().hash(_mostPracticedExercises),const DeepCollectionEquality().hash(_lowestScoringExercises));
}

@override
String toString() {
    return 'ActivityReport(mostPracticedCategories: $mostPracticedCategories, lowestScoringCategories: $lowestScoringCategories, mostPracticedExercises: $mostPracticedExercises, lowestScoringExercises: $lowestScoringExercises)';
}


}

/// @nodoc
abstract mixin class _$ActivityReportCopyWith<$Res> implements $ActivityReportCopyWith<$Res> {
  factory _$ActivityReportCopyWith(_ActivityReport value, $Res Function(_ActivityReport) _then) = __$ActivityReportCopyWithImpl;
@override @useResult
$Res call({
 List<CategoryActivityStat> mostPracticedCategories, List<CategoryActivityStat> lowestScoringCategories, List<ExerciseActivityStat> mostPracticedExercises, List<ExerciseActivityStat> lowestScoringExercises
});




}
/// @nodoc
class __$ActivityReportCopyWithImpl<$Res>
    implements _$ActivityReportCopyWith<$Res> {
  __$ActivityReportCopyWithImpl(this._self, this._then);

  final _ActivityReport _self;
  final $Res Function(_ActivityReport) _then;

/// Create a copy of ActivityReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mostPracticedCategories = null,Object? lowestScoringCategories = null,Object? mostPracticedExercises = null,Object? lowestScoringExercises = null,}) {
  return _then(_ActivityReport(
mostPracticedCategories: null == mostPracticedCategories ? _self._mostPracticedCategories : mostPracticedCategories // ignore: cast_nullable_to_non_nullable
as List<CategoryActivityStat>,lowestScoringCategories: null == lowestScoringCategories ? _self._lowestScoringCategories : lowestScoringCategories // ignore: cast_nullable_to_non_nullable
as List<CategoryActivityStat>,mostPracticedExercises: null == mostPracticedExercises ? _self._mostPracticedExercises : mostPracticedExercises // ignore: cast_nullable_to_non_nullable
as List<ExerciseActivityStat>,lowestScoringExercises: null == lowestScoringExercises ? _self._lowestScoringExercises : lowestScoringExercises // ignore: cast_nullable_to_non_nullable
as List<ExerciseActivityStat>,
  ));
}


}

// dart format on
