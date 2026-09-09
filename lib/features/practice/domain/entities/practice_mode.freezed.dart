// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'practice_mode.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PracticeMode {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PracticeMode);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PracticeMode()';
}


}

/// @nodoc
class $PracticeModeCopyWith<$Res>  {
$PracticeModeCopyWith(PracticeMode _, $Res Function(PracticeMode) __);
}


/// Adds pattern-matching-related methods to [PracticeMode].
extension PracticeModePatterns on PracticeMode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Zen value)?  zen,TResult Function( _Sprint value)?  sprint,TResult Function( _Precision value)?  precision,TResult Function( _LearningRouteLesson value)?  learningRouteLesson,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Zen() when zen != null:
return zen(_that);case _Sprint() when sprint != null:
return sprint(_that);case _Precision() when precision != null:
return precision(_that);case _LearningRouteLesson() when learningRouteLesson != null:
return learningRouteLesson(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Zen value)  zen,required TResult Function( _Sprint value)  sprint,required TResult Function( _Precision value)  precision,required TResult Function( _LearningRouteLesson value)  learningRouteLesson,}){
final _that = this;
switch (_that) {
case _Zen():
return zen(_that);case _Sprint():
return sprint(_that);case _Precision():
return precision(_that);case _LearningRouteLesson():
return learningRouteLesson(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Zen value)?  zen,TResult? Function( _Sprint value)?  sprint,TResult? Function( _Precision value)?  precision,TResult? Function( _LearningRouteLesson value)?  learningRouteLesson,}){
final _that = this;
switch (_that) {
case _Zen() when zen != null:
return zen(_that);case _Sprint() when sprint != null:
return sprint(_that);case _Precision() when precision != null:
return precision(_that);case _LearningRouteLesson() when learningRouteLesson != null:
return learningRouteLesson(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  zen,TResult Function( Duration window)?  sprint,TResult Function()?  precision,TResult Function( String lessonId)?  learningRouteLesson,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Zen() when zen != null:
return zen();case _Sprint() when sprint != null:
return sprint(_that.window);case _Precision() when precision != null:
return precision();case _LearningRouteLesson() when learningRouteLesson != null:
return learningRouteLesson(_that.lessonId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  zen,required TResult Function( Duration window)  sprint,required TResult Function()  precision,required TResult Function( String lessonId)  learningRouteLesson,}) {final _that = this;
switch (_that) {
case _Zen():
return zen();case _Sprint():
return sprint(_that.window);case _Precision():
return precision();case _LearningRouteLesson():
return learningRouteLesson(_that.lessonId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  zen,TResult? Function( Duration window)?  sprint,TResult? Function()?  precision,TResult? Function( String lessonId)?  learningRouteLesson,}) {final _that = this;
switch (_that) {
case _Zen() when zen != null:
return zen();case _Sprint() when sprint != null:
return sprint(_that.window);case _Precision() when precision != null:
return precision();case _LearningRouteLesson() when learningRouteLesson != null:
return learningRouteLesson(_that.lessonId);case _:
  return null;

}
}

}

/// @nodoc


class _Zen implements PracticeMode {
  const _Zen();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Zen);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PracticeMode.zen()';
}


}




/// @nodoc


class _Sprint implements PracticeMode {
  const _Sprint({required this.window});
  

 final  Duration window;

/// Create a copy of PracticeMode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SprintCopyWith<_Sprint> get copyWith => __$SprintCopyWithImpl<_Sprint>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Sprint&&(identical(other.window, window) || other.window == window));
}


@override
int get hashCode {
    return Object.hash(runtimeType,window);
}

@override
String toString() {
    return 'PracticeMode.sprint(window: $window)';
}


}

/// @nodoc
abstract mixin class _$SprintCopyWith<$Res> implements $PracticeModeCopyWith<$Res> {
  factory _$SprintCopyWith(_Sprint value, $Res Function(_Sprint) _then) = __$SprintCopyWithImpl;
@useResult
$Res call({
 Duration window
});




}
/// @nodoc
class __$SprintCopyWithImpl<$Res>
    implements _$SprintCopyWith<$Res> {
  __$SprintCopyWithImpl(this._self, this._then);

  final _Sprint _self;
  final $Res Function(_Sprint) _then;

/// Create a copy of PracticeMode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? window = null,}) {
  return _then(_Sprint(
window: null == window ? _self.window : window // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

/// @nodoc


class _Precision implements PracticeMode {
  const _Precision();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Precision);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PracticeMode.precision()';
}


}




/// @nodoc


class _LearningRouteLesson implements PracticeMode {
  const _LearningRouteLesson({required this.lessonId});
  

 final  String lessonId;

/// Create a copy of PracticeMode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LearningRouteLessonCopyWith<_LearningRouteLesson> get copyWith => __$LearningRouteLessonCopyWithImpl<_LearningRouteLesson>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LearningRouteLesson&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,lessonId);
}

@override
String toString() {
    return 'PracticeMode.learningRouteLesson(lessonId: $lessonId)';
}


}

/// @nodoc
abstract mixin class _$LearningRouteLessonCopyWith<$Res> implements $PracticeModeCopyWith<$Res> {
  factory _$LearningRouteLessonCopyWith(_LearningRouteLesson value, $Res Function(_LearningRouteLesson) _then) = __$LearningRouteLessonCopyWithImpl;
@useResult
$Res call({
 String lessonId
});




}
/// @nodoc
class __$LearningRouteLessonCopyWithImpl<$Res>
    implements _$LearningRouteLessonCopyWith<$Res> {
  __$LearningRouteLessonCopyWithImpl(this._self, this._then);

  final _LearningRouteLesson _self;
  final $Res Function(_LearningRouteLesson) _then;

/// Create a copy of PracticeMode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? lessonId = null,}) {
  return _then(_LearningRouteLesson(
lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
