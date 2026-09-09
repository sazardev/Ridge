// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LessonProgress {

 LearningPathId get pathId; LessonId get lessonId; LessonStatus get status; double? get bestAccuracyPct; DateTime? get completedAt;
/// Create a copy of LessonProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonProgressCopyWith<LessonProgress> get copyWith => _$LessonProgressCopyWithImpl<LessonProgress>(this as LessonProgress, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LessonProgress;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonProgress&&(identical(other.pathId, _this.pathId) || other.pathId == _this.pathId)&&(identical(other.lessonId, _this.lessonId) || other.lessonId == _this.lessonId)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.bestAccuracyPct, _this.bestAccuracyPct) || other.bestAccuracyPct == _this.bestAccuracyPct)&&(identical(other.completedAt, _this.completedAt) || other.completedAt == _this.completedAt));
}


@override
int get hashCode {
  final _this = this as LessonProgress;
  return Object.hash(runtimeType,_this.pathId,_this.lessonId,_this.status,_this.bestAccuracyPct,_this.completedAt);
}

@override
String toString() {
  final _this = this as LessonProgress;
  return 'LessonProgress(pathId: ${_this.pathId}, lessonId: ${_this.lessonId}, status: ${_this.status}, bestAccuracyPct: ${_this.bestAccuracyPct}, completedAt: ${_this.completedAt})';
}


}

/// @nodoc
abstract mixin class $LessonProgressCopyWith<$Res>  {
  factory $LessonProgressCopyWith(LessonProgress value, $Res Function(LessonProgress) _then) = _$LessonProgressCopyWithImpl;
@useResult
$Res call({
 LearningPathId pathId, LessonId lessonId, LessonStatus status, double? bestAccuracyPct, DateTime? completedAt
});


$LearningPathIdCopyWith<$Res> get pathId;$LessonIdCopyWith<$Res> get lessonId;

}
/// @nodoc
class _$LessonProgressCopyWithImpl<$Res>
    implements $LessonProgressCopyWith<$Res> {
  _$LessonProgressCopyWithImpl(this._self, this._then);

  final LessonProgress _self;
  final $Res Function(LessonProgress) _then;

/// Create a copy of LessonProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pathId = null,Object? lessonId = null,Object? status = null,Object? bestAccuracyPct = freezed,Object? completedAt = freezed,}) {
  return _then(LessonProgress(
pathId: null == pathId ? _self.pathId : pathId // ignore: cast_nullable_to_non_nullable
as LearningPathId,lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as LessonId,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LessonStatus,bestAccuracyPct: freezed == bestAccuracyPct ? _self.bestAccuracyPct : bestAccuracyPct // ignore: cast_nullable_to_non_nullable
as double?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of LessonProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LearningPathIdCopyWith<$Res> get pathId {
  
  return $LearningPathIdCopyWith<$Res>(_self.pathId, (value) {
    return _then(_self.copyWith(pathId: value));
  });
}/// Create a copy of LessonProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonIdCopyWith<$Res> get lessonId {
  
  return $LessonIdCopyWith<$Res>(_self.lessonId, (value) {
    return _then(_self.copyWith(lessonId: value));
  });
}
}


/// Adds pattern-matching-related methods to [LessonProgress].
extension LessonProgressPatterns on LessonProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonProgress value)  $default,){
final _that = this;
switch (_that) {
case _LessonProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonProgress value)?  $default,){
final _that = this;
switch (_that) {
case _LessonProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LearningPathId pathId,  LessonId lessonId,  LessonStatus status,  double? bestAccuracyPct,  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonProgress() when $default != null:
return $default(_that.pathId,_that.lessonId,_that.status,_that.bestAccuracyPct,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LearningPathId pathId,  LessonId lessonId,  LessonStatus status,  double? bestAccuracyPct,  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _LessonProgress():
return $default(_that.pathId,_that.lessonId,_that.status,_that.bestAccuracyPct,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LearningPathId pathId,  LessonId lessonId,  LessonStatus status,  double? bestAccuracyPct,  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _LessonProgress() when $default != null:
return $default(_that.pathId,_that.lessonId,_that.status,_that.bestAccuracyPct,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc


class _LessonProgress implements LessonProgress {
  const _LessonProgress({required this.pathId, required this.lessonId, required this.status, this.bestAccuracyPct, this.completedAt});
  

@override final  LearningPathId pathId;
@override final  LessonId lessonId;
@override final  LessonStatus status;
@override final  double? bestAccuracyPct;
@override final  DateTime? completedAt;

/// Create a copy of LessonProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonProgressCopyWith<_LessonProgress> get copyWith => __$LessonProgressCopyWithImpl<_LessonProgress>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonProgress&&(identical(other.pathId, pathId) || other.pathId == pathId)&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.status, status) || other.status == status)&&(identical(other.bestAccuracyPct, bestAccuracyPct) || other.bestAccuracyPct == bestAccuracyPct)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,pathId,lessonId,status,bestAccuracyPct,completedAt);
}

@override
String toString() {
    return 'LessonProgress(pathId: $pathId, lessonId: $lessonId, status: $status, bestAccuracyPct: $bestAccuracyPct, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$LessonProgressCopyWith<$Res> implements $LessonProgressCopyWith<$Res> {
  factory _$LessonProgressCopyWith(_LessonProgress value, $Res Function(_LessonProgress) _then) = __$LessonProgressCopyWithImpl;
@override @useResult
$Res call({
 LearningPathId pathId, LessonId lessonId, LessonStatus status, double? bestAccuracyPct, DateTime? completedAt
});


@override $LearningPathIdCopyWith<$Res> get pathId;@override $LessonIdCopyWith<$Res> get lessonId;

}
/// @nodoc
class __$LessonProgressCopyWithImpl<$Res>
    implements _$LessonProgressCopyWith<$Res> {
  __$LessonProgressCopyWithImpl(this._self, this._then);

  final _LessonProgress _self;
  final $Res Function(_LessonProgress) _then;

/// Create a copy of LessonProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pathId = null,Object? lessonId = null,Object? status = null,Object? bestAccuracyPct = freezed,Object? completedAt = freezed,}) {
  return _then(_LessonProgress(
pathId: null == pathId ? _self.pathId : pathId // ignore: cast_nullable_to_non_nullable
as LearningPathId,lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as LessonId,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LessonStatus,bestAccuracyPct: freezed == bestAccuracyPct ? _self.bestAccuracyPct : bestAccuracyPct // ignore: cast_nullable_to_non_nullable
as double?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of LessonProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LearningPathIdCopyWith<$Res> get pathId {
  
  return $LearningPathIdCopyWith<$Res>(_self.pathId, (value) {
    return _then(_self.copyWith(pathId: value));
  });
}/// Create a copy of LessonProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonIdCopyWith<$Res> get lessonId {
  
  return $LessonIdCopyWith<$Res>(_self.lessonId, (value) {
    return _then(_self.copyWith(lessonId: value));
  });
}
}

// dart format on
