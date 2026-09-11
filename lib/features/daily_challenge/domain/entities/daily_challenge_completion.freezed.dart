// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_challenge_completion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DailyChallengeCompletion {

 ProfileId get profileId; ChallengeDate get date; SnippetId get snippetId; int get snippetRevision; TypingSessionId get sessionId; int get score; bool get passed; DateTime get completedAtUtc;
/// Create a copy of DailyChallengeCompletion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyChallengeCompletionCopyWith<DailyChallengeCompletion> get copyWith => _$DailyChallengeCompletionCopyWithImpl<DailyChallengeCompletion>(this as DailyChallengeCompletion, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DailyChallengeCompletion;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyChallengeCompletion&&(identical(other.profileId, _this.profileId) || other.profileId == _this.profileId)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.snippetId, _this.snippetId) || other.snippetId == _this.snippetId)&&(identical(other.snippetRevision, _this.snippetRevision) || other.snippetRevision == _this.snippetRevision)&&(identical(other.sessionId, _this.sessionId) || other.sessionId == _this.sessionId)&&(identical(other.score, _this.score) || other.score == _this.score)&&(identical(other.passed, _this.passed) || other.passed == _this.passed)&&(identical(other.completedAtUtc, _this.completedAtUtc) || other.completedAtUtc == _this.completedAtUtc));
}


@override
int get hashCode {
  final _this = this as DailyChallengeCompletion;
  return Object.hash(runtimeType,_this.profileId,_this.date,_this.snippetId,_this.snippetRevision,_this.sessionId,_this.score,_this.passed,_this.completedAtUtc);
}

@override
String toString() {
  final _this = this as DailyChallengeCompletion;
  return 'DailyChallengeCompletion(profileId: ${_this.profileId}, date: ${_this.date}, snippetId: ${_this.snippetId}, snippetRevision: ${_this.snippetRevision}, sessionId: ${_this.sessionId}, score: ${_this.score}, passed: ${_this.passed}, completedAtUtc: ${_this.completedAtUtc})';
}


}

/// @nodoc
abstract mixin class $DailyChallengeCompletionCopyWith<$Res>  {
  factory $DailyChallengeCompletionCopyWith(DailyChallengeCompletion value, $Res Function(DailyChallengeCompletion) _then) = _$DailyChallengeCompletionCopyWithImpl;
@useResult
$Res call({
 ProfileId profileId, ChallengeDate date, SnippetId snippetId, int snippetRevision, TypingSessionId sessionId, int score, bool passed, DateTime completedAtUtc
});


$ProfileIdCopyWith<$Res> get profileId;$ChallengeDateCopyWith<$Res> get date;$SnippetIdCopyWith<$Res> get snippetId;$TypingSessionIdCopyWith<$Res> get sessionId;

}
/// @nodoc
class _$DailyChallengeCompletionCopyWithImpl<$Res>
    implements $DailyChallengeCompletionCopyWith<$Res> {
  _$DailyChallengeCompletionCopyWithImpl(this._self, this._then);

  final DailyChallengeCompletion _self;
  final $Res Function(DailyChallengeCompletion) _then;

/// Create a copy of DailyChallengeCompletion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profileId = null,Object? date = null,Object? snippetId = null,Object? snippetRevision = null,Object? sessionId = null,Object? score = null,Object? passed = null,Object? completedAtUtc = null,}) {
  return _then(DailyChallengeCompletion(
profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as ProfileId,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as ChallengeDate,snippetId: null == snippetId ? _self.snippetId : snippetId // ignore: cast_nullable_to_non_nullable
as SnippetId,snippetRevision: null == snippetRevision ? _self.snippetRevision : snippetRevision // ignore: cast_nullable_to_non_nullable
as int,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as TypingSessionId,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,passed: null == passed ? _self.passed : passed // ignore: cast_nullable_to_non_nullable
as bool,completedAtUtc: null == completedAtUtc ? _self.completedAtUtc : completedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of DailyChallengeCompletion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileIdCopyWith<$Res> get profileId {
  
  return $ProfileIdCopyWith<$Res>(_self.profileId, (value) {
    return _then(_self.copyWith(profileId: value));
  });
}/// Create a copy of DailyChallengeCompletion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChallengeDateCopyWith<$Res> get date {
  
  return $ChallengeDateCopyWith<$Res>(_self.date, (value) {
    return _then(_self.copyWith(date: value));
  });
}/// Create a copy of DailyChallengeCompletion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SnippetIdCopyWith<$Res> get snippetId {
  
  return $SnippetIdCopyWith<$Res>(_self.snippetId, (value) {
    return _then(_self.copyWith(snippetId: value));
  });
}/// Create a copy of DailyChallengeCompletion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TypingSessionIdCopyWith<$Res> get sessionId {
  
  return $TypingSessionIdCopyWith<$Res>(_self.sessionId, (value) {
    return _then(_self.copyWith(sessionId: value));
  });
}
}


/// Adds pattern-matching-related methods to [DailyChallengeCompletion].
extension DailyChallengeCompletionPatterns on DailyChallengeCompletion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyChallengeCompletion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyChallengeCompletion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyChallengeCompletion value)  $default,){
final _that = this;
switch (_that) {
case _DailyChallengeCompletion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyChallengeCompletion value)?  $default,){
final _that = this;
switch (_that) {
case _DailyChallengeCompletion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProfileId profileId,  ChallengeDate date,  SnippetId snippetId,  int snippetRevision,  TypingSessionId sessionId,  int score,  bool passed,  DateTime completedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyChallengeCompletion() when $default != null:
return $default(_that.profileId,_that.date,_that.snippetId,_that.snippetRevision,_that.sessionId,_that.score,_that.passed,_that.completedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProfileId profileId,  ChallengeDate date,  SnippetId snippetId,  int snippetRevision,  TypingSessionId sessionId,  int score,  bool passed,  DateTime completedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _DailyChallengeCompletion():
return $default(_that.profileId,_that.date,_that.snippetId,_that.snippetRevision,_that.sessionId,_that.score,_that.passed,_that.completedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProfileId profileId,  ChallengeDate date,  SnippetId snippetId,  int snippetRevision,  TypingSessionId sessionId,  int score,  bool passed,  DateTime completedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _DailyChallengeCompletion() when $default != null:
return $default(_that.profileId,_that.date,_that.snippetId,_that.snippetRevision,_that.sessionId,_that.score,_that.passed,_that.completedAtUtc);case _:
  return null;

}
}

}

/// @nodoc


class _DailyChallengeCompletion implements DailyChallengeCompletion {
  const _DailyChallengeCompletion({required this.profileId, required this.date, required this.snippetId, required this.snippetRevision, required this.sessionId, required this.score, required this.passed, required this.completedAtUtc});
  

@override final  ProfileId profileId;
@override final  ChallengeDate date;
@override final  SnippetId snippetId;
@override final  int snippetRevision;
@override final  TypingSessionId sessionId;
@override final  int score;
@override final  bool passed;
@override final  DateTime completedAtUtc;

/// Create a copy of DailyChallengeCompletion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyChallengeCompletionCopyWith<_DailyChallengeCompletion> get copyWith => __$DailyChallengeCompletionCopyWithImpl<_DailyChallengeCompletion>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyChallengeCompletion&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.date, date) || other.date == date)&&(identical(other.snippetId, snippetId) || other.snippetId == snippetId)&&(identical(other.snippetRevision, snippetRevision) || other.snippetRevision == snippetRevision)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.score, score) || other.score == score)&&(identical(other.passed, passed) || other.passed == passed)&&(identical(other.completedAtUtc, completedAtUtc) || other.completedAtUtc == completedAtUtc));
}


@override
int get hashCode {
    return Object.hash(runtimeType,profileId,date,snippetId,snippetRevision,sessionId,score,passed,completedAtUtc);
}

@override
String toString() {
    return 'DailyChallengeCompletion(profileId: $profileId, date: $date, snippetId: $snippetId, snippetRevision: $snippetRevision, sessionId: $sessionId, score: $score, passed: $passed, completedAtUtc: $completedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$DailyChallengeCompletionCopyWith<$Res> implements $DailyChallengeCompletionCopyWith<$Res> {
  factory _$DailyChallengeCompletionCopyWith(_DailyChallengeCompletion value, $Res Function(_DailyChallengeCompletion) _then) = __$DailyChallengeCompletionCopyWithImpl;
@override @useResult
$Res call({
 ProfileId profileId, ChallengeDate date, SnippetId snippetId, int snippetRevision, TypingSessionId sessionId, int score, bool passed, DateTime completedAtUtc
});


@override $ProfileIdCopyWith<$Res> get profileId;@override $ChallengeDateCopyWith<$Res> get date;@override $SnippetIdCopyWith<$Res> get snippetId;@override $TypingSessionIdCopyWith<$Res> get sessionId;

}
/// @nodoc
class __$DailyChallengeCompletionCopyWithImpl<$Res>
    implements _$DailyChallengeCompletionCopyWith<$Res> {
  __$DailyChallengeCompletionCopyWithImpl(this._self, this._then);

  final _DailyChallengeCompletion _self;
  final $Res Function(_DailyChallengeCompletion) _then;

/// Create a copy of DailyChallengeCompletion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profileId = null,Object? date = null,Object? snippetId = null,Object? snippetRevision = null,Object? sessionId = null,Object? score = null,Object? passed = null,Object? completedAtUtc = null,}) {
  return _then(_DailyChallengeCompletion(
profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as ProfileId,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as ChallengeDate,snippetId: null == snippetId ? _self.snippetId : snippetId // ignore: cast_nullable_to_non_nullable
as SnippetId,snippetRevision: null == snippetRevision ? _self.snippetRevision : snippetRevision // ignore: cast_nullable_to_non_nullable
as int,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as TypingSessionId,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,passed: null == passed ? _self.passed : passed // ignore: cast_nullable_to_non_nullable
as bool,completedAtUtc: null == completedAtUtc ? _self.completedAtUtc : completedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of DailyChallengeCompletion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileIdCopyWith<$Res> get profileId {
  
  return $ProfileIdCopyWith<$Res>(_self.profileId, (value) {
    return _then(_self.copyWith(profileId: value));
  });
}/// Create a copy of DailyChallengeCompletion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChallengeDateCopyWith<$Res> get date {
  
  return $ChallengeDateCopyWith<$Res>(_self.date, (value) {
    return _then(_self.copyWith(date: value));
  });
}/// Create a copy of DailyChallengeCompletion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SnippetIdCopyWith<$Res> get snippetId {
  
  return $SnippetIdCopyWith<$Res>(_self.snippetId, (value) {
    return _then(_self.copyWith(snippetId: value));
  });
}/// Create a copy of DailyChallengeCompletion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TypingSessionIdCopyWith<$Res> get sessionId {
  
  return $TypingSessionIdCopyWith<$Res>(_self.sessionId, (value) {
    return _then(_self.copyWith(sessionId: value));
  });
}
}

// dart format on
