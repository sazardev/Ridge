// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_attempt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LessonAttempt {

 LessonId get lessonId; bool get passed; double get accuracyPct; DateTime get startedAtUtc;
/// Create a copy of LessonAttempt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonAttemptCopyWith<LessonAttempt> get copyWith => _$LessonAttemptCopyWithImpl<LessonAttempt>(this as LessonAttempt, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LessonAttempt;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonAttempt&&(identical(other.lessonId, _this.lessonId) || other.lessonId == _this.lessonId)&&(identical(other.passed, _this.passed) || other.passed == _this.passed)&&(identical(other.accuracyPct, _this.accuracyPct) || other.accuracyPct == _this.accuracyPct)&&(identical(other.startedAtUtc, _this.startedAtUtc) || other.startedAtUtc == _this.startedAtUtc));
}


@override
int get hashCode {
  final _this = this as LessonAttempt;
  return Object.hash(runtimeType,_this.lessonId,_this.passed,_this.accuracyPct,_this.startedAtUtc);
}

@override
String toString() {
  final _this = this as LessonAttempt;
  return 'LessonAttempt(lessonId: ${_this.lessonId}, passed: ${_this.passed}, accuracyPct: ${_this.accuracyPct}, startedAtUtc: ${_this.startedAtUtc})';
}


}

/// @nodoc
abstract mixin class $LessonAttemptCopyWith<$Res>  {
  factory $LessonAttemptCopyWith(LessonAttempt value, $Res Function(LessonAttempt) _then) = _$LessonAttemptCopyWithImpl;
@useResult
$Res call({
 LessonId lessonId, bool passed, double accuracyPct, DateTime startedAtUtc
});


$LessonIdCopyWith<$Res> get lessonId;

}
/// @nodoc
class _$LessonAttemptCopyWithImpl<$Res>
    implements $LessonAttemptCopyWith<$Res> {
  _$LessonAttemptCopyWithImpl(this._self, this._then);

  final LessonAttempt _self;
  final $Res Function(LessonAttempt) _then;

/// Create a copy of LessonAttempt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lessonId = null,Object? passed = null,Object? accuracyPct = null,Object? startedAtUtc = null,}) {
  return _then(LessonAttempt(
lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as LessonId,passed: null == passed ? _self.passed : passed // ignore: cast_nullable_to_non_nullable
as bool,accuracyPct: null == accuracyPct ? _self.accuracyPct : accuracyPct // ignore: cast_nullable_to_non_nullable
as double,startedAtUtc: null == startedAtUtc ? _self.startedAtUtc : startedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of LessonAttempt
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonIdCopyWith<$Res> get lessonId {
  
  return $LessonIdCopyWith<$Res>(_self.lessonId, (value) {
    return _then(_self.copyWith(lessonId: value));
  });
}
}


/// Adds pattern-matching-related methods to [LessonAttempt].
extension LessonAttemptPatterns on LessonAttempt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonAttempt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonAttempt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonAttempt value)  $default,){
final _that = this;
switch (_that) {
case _LessonAttempt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonAttempt value)?  $default,){
final _that = this;
switch (_that) {
case _LessonAttempt() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LessonId lessonId,  bool passed,  double accuracyPct,  DateTime startedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonAttempt() when $default != null:
return $default(_that.lessonId,_that.passed,_that.accuracyPct,_that.startedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LessonId lessonId,  bool passed,  double accuracyPct,  DateTime startedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _LessonAttempt():
return $default(_that.lessonId,_that.passed,_that.accuracyPct,_that.startedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LessonId lessonId,  bool passed,  double accuracyPct,  DateTime startedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _LessonAttempt() when $default != null:
return $default(_that.lessonId,_that.passed,_that.accuracyPct,_that.startedAtUtc);case _:
  return null;

}
}

}

/// @nodoc


class _LessonAttempt implements LessonAttempt {
  const _LessonAttempt({required this.lessonId, required this.passed, required this.accuracyPct, required this.startedAtUtc});
  

@override final  LessonId lessonId;
@override final  bool passed;
@override final  double accuracyPct;
@override final  DateTime startedAtUtc;

/// Create a copy of LessonAttempt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonAttemptCopyWith<_LessonAttempt> get copyWith => __$LessonAttemptCopyWithImpl<_LessonAttempt>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonAttempt&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.passed, passed) || other.passed == passed)&&(identical(other.accuracyPct, accuracyPct) || other.accuracyPct == accuracyPct)&&(identical(other.startedAtUtc, startedAtUtc) || other.startedAtUtc == startedAtUtc));
}


@override
int get hashCode {
    return Object.hash(runtimeType,lessonId,passed,accuracyPct,startedAtUtc);
}

@override
String toString() {
    return 'LessonAttempt(lessonId: $lessonId, passed: $passed, accuracyPct: $accuracyPct, startedAtUtc: $startedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$LessonAttemptCopyWith<$Res> implements $LessonAttemptCopyWith<$Res> {
  factory _$LessonAttemptCopyWith(_LessonAttempt value, $Res Function(_LessonAttempt) _then) = __$LessonAttemptCopyWithImpl;
@override @useResult
$Res call({
 LessonId lessonId, bool passed, double accuracyPct, DateTime startedAtUtc
});


@override $LessonIdCopyWith<$Res> get lessonId;

}
/// @nodoc
class __$LessonAttemptCopyWithImpl<$Res>
    implements _$LessonAttemptCopyWith<$Res> {
  __$LessonAttemptCopyWithImpl(this._self, this._then);

  final _LessonAttempt _self;
  final $Res Function(_LessonAttempt) _then;

/// Create a copy of LessonAttempt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lessonId = null,Object? passed = null,Object? accuracyPct = null,Object? startedAtUtc = null,}) {
  return _then(_LessonAttempt(
lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as LessonId,passed: null == passed ? _self.passed : passed // ignore: cast_nullable_to_non_nullable
as bool,accuracyPct: null == accuracyPct ? _self.accuracyPct : accuracyPct // ignore: cast_nullable_to_non_nullable
as double,startedAtUtc: null == startedAtUtc ? _self.startedAtUtc : startedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of LessonAttempt
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
