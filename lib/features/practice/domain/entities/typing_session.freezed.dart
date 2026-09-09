// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'typing_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TypingSession {

 TypingSessionId get id; ProfileId get profileId; PracticeMode get mode; SnippetId get snippetId; int get snippetRevision; ContentCategory get category; Difficulty get difficulty; DateTime get startedAtUtc; Duration get duration; double get rawSpeedCpm; double get netSpeedCpm; double get accuracyPct; double get consistencyScore; int get maxStreak; double get fatigueFirstThirdCpm; double get fatigueMiddleThirdCpm; double get fatigueLastThirdCpm; double get handBalanceRatio; bool? get passed; int get xpAwarded; bool get isFirstCompletion;
/// Create a copy of TypingSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TypingSessionCopyWith<TypingSession> get copyWith => _$TypingSessionCopyWithImpl<TypingSession>(this as TypingSession, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TypingSession;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TypingSession&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.profileId, _this.profileId) || other.profileId == _this.profileId)&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.snippetId, _this.snippetId) || other.snippetId == _this.snippetId)&&(identical(other.snippetRevision, _this.snippetRevision) || other.snippetRevision == _this.snippetRevision)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.difficulty, _this.difficulty) || other.difficulty == _this.difficulty)&&(identical(other.startedAtUtc, _this.startedAtUtc) || other.startedAtUtc == _this.startedAtUtc)&&(identical(other.duration, _this.duration) || other.duration == _this.duration)&&(identical(other.rawSpeedCpm, _this.rawSpeedCpm) || other.rawSpeedCpm == _this.rawSpeedCpm)&&(identical(other.netSpeedCpm, _this.netSpeedCpm) || other.netSpeedCpm == _this.netSpeedCpm)&&(identical(other.accuracyPct, _this.accuracyPct) || other.accuracyPct == _this.accuracyPct)&&(identical(other.consistencyScore, _this.consistencyScore) || other.consistencyScore == _this.consistencyScore)&&(identical(other.maxStreak, _this.maxStreak) || other.maxStreak == _this.maxStreak)&&(identical(other.fatigueFirstThirdCpm, _this.fatigueFirstThirdCpm) || other.fatigueFirstThirdCpm == _this.fatigueFirstThirdCpm)&&(identical(other.fatigueMiddleThirdCpm, _this.fatigueMiddleThirdCpm) || other.fatigueMiddleThirdCpm == _this.fatigueMiddleThirdCpm)&&(identical(other.fatigueLastThirdCpm, _this.fatigueLastThirdCpm) || other.fatigueLastThirdCpm == _this.fatigueLastThirdCpm)&&(identical(other.handBalanceRatio, _this.handBalanceRatio) || other.handBalanceRatio == _this.handBalanceRatio)&&(identical(other.passed, _this.passed) || other.passed == _this.passed)&&(identical(other.xpAwarded, _this.xpAwarded) || other.xpAwarded == _this.xpAwarded)&&(identical(other.isFirstCompletion, _this.isFirstCompletion) || other.isFirstCompletion == _this.isFirstCompletion));
}


@override
int get hashCode {
  final _this = this as TypingSession;
  return Object.hashAll([runtimeType,_this.id,_this.profileId,_this.mode,_this.snippetId,_this.snippetRevision,_this.category,_this.difficulty,_this.startedAtUtc,_this.duration,_this.rawSpeedCpm,_this.netSpeedCpm,_this.accuracyPct,_this.consistencyScore,_this.maxStreak,_this.fatigueFirstThirdCpm,_this.fatigueMiddleThirdCpm,_this.fatigueLastThirdCpm,_this.handBalanceRatio,_this.passed,_this.xpAwarded,_this.isFirstCompletion]);
}

@override
String toString() {
  final _this = this as TypingSession;
  return 'TypingSession(id: ${_this.id}, profileId: ${_this.profileId}, mode: ${_this.mode}, snippetId: ${_this.snippetId}, snippetRevision: ${_this.snippetRevision}, category: ${_this.category}, difficulty: ${_this.difficulty}, startedAtUtc: ${_this.startedAtUtc}, duration: ${_this.duration}, rawSpeedCpm: ${_this.rawSpeedCpm}, netSpeedCpm: ${_this.netSpeedCpm}, accuracyPct: ${_this.accuracyPct}, consistencyScore: ${_this.consistencyScore}, maxStreak: ${_this.maxStreak}, fatigueFirstThirdCpm: ${_this.fatigueFirstThirdCpm}, fatigueMiddleThirdCpm: ${_this.fatigueMiddleThirdCpm}, fatigueLastThirdCpm: ${_this.fatigueLastThirdCpm}, handBalanceRatio: ${_this.handBalanceRatio}, passed: ${_this.passed}, xpAwarded: ${_this.xpAwarded}, isFirstCompletion: ${_this.isFirstCompletion})';
}


}

/// @nodoc
abstract mixin class $TypingSessionCopyWith<$Res>  {
  factory $TypingSessionCopyWith(TypingSession value, $Res Function(TypingSession) _then) = _$TypingSessionCopyWithImpl;
@useResult
$Res call({
 TypingSessionId id, ProfileId profileId, PracticeMode mode, SnippetId snippetId, int snippetRevision, ContentCategory category, Difficulty difficulty, DateTime startedAtUtc, Duration duration, double rawSpeedCpm, double netSpeedCpm, double accuracyPct, double consistencyScore, int maxStreak, double fatigueFirstThirdCpm, double fatigueMiddleThirdCpm, double fatigueLastThirdCpm, double handBalanceRatio, bool? passed, int xpAwarded, bool isFirstCompletion
});


$TypingSessionIdCopyWith<$Res> get id;$ProfileIdCopyWith<$Res> get profileId;$PracticeModeCopyWith<$Res> get mode;$SnippetIdCopyWith<$Res> get snippetId;

}
/// @nodoc
class _$TypingSessionCopyWithImpl<$Res>
    implements $TypingSessionCopyWith<$Res> {
  _$TypingSessionCopyWithImpl(this._self, this._then);

  final TypingSession _self;
  final $Res Function(TypingSession) _then;

/// Create a copy of TypingSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? profileId = null,Object? mode = null,Object? snippetId = null,Object? snippetRevision = null,Object? category = null,Object? difficulty = null,Object? startedAtUtc = null,Object? duration = null,Object? rawSpeedCpm = null,Object? netSpeedCpm = null,Object? accuracyPct = null,Object? consistencyScore = null,Object? maxStreak = null,Object? fatigueFirstThirdCpm = null,Object? fatigueMiddleThirdCpm = null,Object? fatigueLastThirdCpm = null,Object? handBalanceRatio = null,Object? passed = freezed,Object? xpAwarded = null,Object? isFirstCompletion = null,}) {
  return _then(TypingSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as TypingSessionId,profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as ProfileId,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as PracticeMode,snippetId: null == snippetId ? _self.snippetId : snippetId // ignore: cast_nullable_to_non_nullable
as SnippetId,snippetRevision: null == snippetRevision ? _self.snippetRevision : snippetRevision // ignore: cast_nullable_to_non_nullable
as int,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ContentCategory,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as Difficulty,startedAtUtc: null == startedAtUtc ? _self.startedAtUtc : startedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,rawSpeedCpm: null == rawSpeedCpm ? _self.rawSpeedCpm : rawSpeedCpm // ignore: cast_nullable_to_non_nullable
as double,netSpeedCpm: null == netSpeedCpm ? _self.netSpeedCpm : netSpeedCpm // ignore: cast_nullable_to_non_nullable
as double,accuracyPct: null == accuracyPct ? _self.accuracyPct : accuracyPct // ignore: cast_nullable_to_non_nullable
as double,consistencyScore: null == consistencyScore ? _self.consistencyScore : consistencyScore // ignore: cast_nullable_to_non_nullable
as double,maxStreak: null == maxStreak ? _self.maxStreak : maxStreak // ignore: cast_nullable_to_non_nullable
as int,fatigueFirstThirdCpm: null == fatigueFirstThirdCpm ? _self.fatigueFirstThirdCpm : fatigueFirstThirdCpm // ignore: cast_nullable_to_non_nullable
as double,fatigueMiddleThirdCpm: null == fatigueMiddleThirdCpm ? _self.fatigueMiddleThirdCpm : fatigueMiddleThirdCpm // ignore: cast_nullable_to_non_nullable
as double,fatigueLastThirdCpm: null == fatigueLastThirdCpm ? _self.fatigueLastThirdCpm : fatigueLastThirdCpm // ignore: cast_nullable_to_non_nullable
as double,handBalanceRatio: null == handBalanceRatio ? _self.handBalanceRatio : handBalanceRatio // ignore: cast_nullable_to_non_nullable
as double,passed: freezed == passed ? _self.passed : passed // ignore: cast_nullable_to_non_nullable
as bool?,xpAwarded: null == xpAwarded ? _self.xpAwarded : xpAwarded // ignore: cast_nullable_to_non_nullable
as int,isFirstCompletion: null == isFirstCompletion ? _self.isFirstCompletion : isFirstCompletion // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of TypingSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TypingSessionIdCopyWith<$Res> get id {
  
  return $TypingSessionIdCopyWith<$Res>(_self.id, (value) {
    return _then(_self.copyWith(id: value));
  });
}/// Create a copy of TypingSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileIdCopyWith<$Res> get profileId {
  
  return $ProfileIdCopyWith<$Res>(_self.profileId, (value) {
    return _then(_self.copyWith(profileId: value));
  });
}/// Create a copy of TypingSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PracticeModeCopyWith<$Res> get mode {
  
  return $PracticeModeCopyWith<$Res>(_self.mode, (value) {
    return _then(_self.copyWith(mode: value));
  });
}/// Create a copy of TypingSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SnippetIdCopyWith<$Res> get snippetId {
  
  return $SnippetIdCopyWith<$Res>(_self.snippetId, (value) {
    return _then(_self.copyWith(snippetId: value));
  });
}
}


/// Adds pattern-matching-related methods to [TypingSession].
extension TypingSessionPatterns on TypingSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TypingSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TypingSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TypingSession value)  $default,){
final _that = this;
switch (_that) {
case _TypingSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TypingSession value)?  $default,){
final _that = this;
switch (_that) {
case _TypingSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TypingSessionId id,  ProfileId profileId,  PracticeMode mode,  SnippetId snippetId,  int snippetRevision,  ContentCategory category,  Difficulty difficulty,  DateTime startedAtUtc,  Duration duration,  double rawSpeedCpm,  double netSpeedCpm,  double accuracyPct,  double consistencyScore,  int maxStreak,  double fatigueFirstThirdCpm,  double fatigueMiddleThirdCpm,  double fatigueLastThirdCpm,  double handBalanceRatio,  bool? passed,  int xpAwarded,  bool isFirstCompletion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TypingSession() when $default != null:
return $default(_that.id,_that.profileId,_that.mode,_that.snippetId,_that.snippetRevision,_that.category,_that.difficulty,_that.startedAtUtc,_that.duration,_that.rawSpeedCpm,_that.netSpeedCpm,_that.accuracyPct,_that.consistencyScore,_that.maxStreak,_that.fatigueFirstThirdCpm,_that.fatigueMiddleThirdCpm,_that.fatigueLastThirdCpm,_that.handBalanceRatio,_that.passed,_that.xpAwarded,_that.isFirstCompletion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TypingSessionId id,  ProfileId profileId,  PracticeMode mode,  SnippetId snippetId,  int snippetRevision,  ContentCategory category,  Difficulty difficulty,  DateTime startedAtUtc,  Duration duration,  double rawSpeedCpm,  double netSpeedCpm,  double accuracyPct,  double consistencyScore,  int maxStreak,  double fatigueFirstThirdCpm,  double fatigueMiddleThirdCpm,  double fatigueLastThirdCpm,  double handBalanceRatio,  bool? passed,  int xpAwarded,  bool isFirstCompletion)  $default,) {final _that = this;
switch (_that) {
case _TypingSession():
return $default(_that.id,_that.profileId,_that.mode,_that.snippetId,_that.snippetRevision,_that.category,_that.difficulty,_that.startedAtUtc,_that.duration,_that.rawSpeedCpm,_that.netSpeedCpm,_that.accuracyPct,_that.consistencyScore,_that.maxStreak,_that.fatigueFirstThirdCpm,_that.fatigueMiddleThirdCpm,_that.fatigueLastThirdCpm,_that.handBalanceRatio,_that.passed,_that.xpAwarded,_that.isFirstCompletion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TypingSessionId id,  ProfileId profileId,  PracticeMode mode,  SnippetId snippetId,  int snippetRevision,  ContentCategory category,  Difficulty difficulty,  DateTime startedAtUtc,  Duration duration,  double rawSpeedCpm,  double netSpeedCpm,  double accuracyPct,  double consistencyScore,  int maxStreak,  double fatigueFirstThirdCpm,  double fatigueMiddleThirdCpm,  double fatigueLastThirdCpm,  double handBalanceRatio,  bool? passed,  int xpAwarded,  bool isFirstCompletion)?  $default,) {final _that = this;
switch (_that) {
case _TypingSession() when $default != null:
return $default(_that.id,_that.profileId,_that.mode,_that.snippetId,_that.snippetRevision,_that.category,_that.difficulty,_that.startedAtUtc,_that.duration,_that.rawSpeedCpm,_that.netSpeedCpm,_that.accuracyPct,_that.consistencyScore,_that.maxStreak,_that.fatigueFirstThirdCpm,_that.fatigueMiddleThirdCpm,_that.fatigueLastThirdCpm,_that.handBalanceRatio,_that.passed,_that.xpAwarded,_that.isFirstCompletion);case _:
  return null;

}
}

}

/// @nodoc


class _TypingSession implements TypingSession {
  const _TypingSession({required this.id, required this.profileId, required this.mode, required this.snippetId, required this.snippetRevision, required this.category, required this.difficulty, required this.startedAtUtc, required this.duration, required this.rawSpeedCpm, required this.netSpeedCpm, required this.accuracyPct, required this.consistencyScore, required this.maxStreak, required this.fatigueFirstThirdCpm, required this.fatigueMiddleThirdCpm, required this.fatigueLastThirdCpm, required this.handBalanceRatio, this.passed, this.xpAwarded = 0, this.isFirstCompletion = false});
  

@override final  TypingSessionId id;
@override final  ProfileId profileId;
@override final  PracticeMode mode;
@override final  SnippetId snippetId;
@override final  int snippetRevision;
@override final  ContentCategory category;
@override final  Difficulty difficulty;
@override final  DateTime startedAtUtc;
@override final  Duration duration;
@override final  double rawSpeedCpm;
@override final  double netSpeedCpm;
@override final  double accuracyPct;
@override final  double consistencyScore;
@override final  int maxStreak;
@override final  double fatigueFirstThirdCpm;
@override final  double fatigueMiddleThirdCpm;
@override final  double fatigueLastThirdCpm;
@override final  double handBalanceRatio;
@override final  bool? passed;
@override@JsonKey() final  int xpAwarded;
@override@JsonKey() final  bool isFirstCompletion;

/// Create a copy of TypingSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TypingSessionCopyWith<_TypingSession> get copyWith => __$TypingSessionCopyWithImpl<_TypingSession>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TypingSession&&(identical(other.id, id) || other.id == id)&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.snippetId, snippetId) || other.snippetId == snippetId)&&(identical(other.snippetRevision, snippetRevision) || other.snippetRevision == snippetRevision)&&(identical(other.category, category) || other.category == category)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.startedAtUtc, startedAtUtc) || other.startedAtUtc == startedAtUtc)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.rawSpeedCpm, rawSpeedCpm) || other.rawSpeedCpm == rawSpeedCpm)&&(identical(other.netSpeedCpm, netSpeedCpm) || other.netSpeedCpm == netSpeedCpm)&&(identical(other.accuracyPct, accuracyPct) || other.accuracyPct == accuracyPct)&&(identical(other.consistencyScore, consistencyScore) || other.consistencyScore == consistencyScore)&&(identical(other.maxStreak, maxStreak) || other.maxStreak == maxStreak)&&(identical(other.fatigueFirstThirdCpm, fatigueFirstThirdCpm) || other.fatigueFirstThirdCpm == fatigueFirstThirdCpm)&&(identical(other.fatigueMiddleThirdCpm, fatigueMiddleThirdCpm) || other.fatigueMiddleThirdCpm == fatigueMiddleThirdCpm)&&(identical(other.fatigueLastThirdCpm, fatigueLastThirdCpm) || other.fatigueLastThirdCpm == fatigueLastThirdCpm)&&(identical(other.handBalanceRatio, handBalanceRatio) || other.handBalanceRatio == handBalanceRatio)&&(identical(other.passed, passed) || other.passed == passed)&&(identical(other.xpAwarded, xpAwarded) || other.xpAwarded == xpAwarded)&&(identical(other.isFirstCompletion, isFirstCompletion) || other.isFirstCompletion == isFirstCompletion));
}


@override
int get hashCode {
    return Object.hashAll([runtimeType,id,profileId,mode,snippetId,snippetRevision,category,difficulty,startedAtUtc,duration,rawSpeedCpm,netSpeedCpm,accuracyPct,consistencyScore,maxStreak,fatigueFirstThirdCpm,fatigueMiddleThirdCpm,fatigueLastThirdCpm,handBalanceRatio,passed,xpAwarded,isFirstCompletion]);
}

@override
String toString() {
    return 'TypingSession(id: $id, profileId: $profileId, mode: $mode, snippetId: $snippetId, snippetRevision: $snippetRevision, category: $category, difficulty: $difficulty, startedAtUtc: $startedAtUtc, duration: $duration, rawSpeedCpm: $rawSpeedCpm, netSpeedCpm: $netSpeedCpm, accuracyPct: $accuracyPct, consistencyScore: $consistencyScore, maxStreak: $maxStreak, fatigueFirstThirdCpm: $fatigueFirstThirdCpm, fatigueMiddleThirdCpm: $fatigueMiddleThirdCpm, fatigueLastThirdCpm: $fatigueLastThirdCpm, handBalanceRatio: $handBalanceRatio, passed: $passed, xpAwarded: $xpAwarded, isFirstCompletion: $isFirstCompletion)';
}


}

/// @nodoc
abstract mixin class _$TypingSessionCopyWith<$Res> implements $TypingSessionCopyWith<$Res> {
  factory _$TypingSessionCopyWith(_TypingSession value, $Res Function(_TypingSession) _then) = __$TypingSessionCopyWithImpl;
@override @useResult
$Res call({
 TypingSessionId id, ProfileId profileId, PracticeMode mode, SnippetId snippetId, int snippetRevision, ContentCategory category, Difficulty difficulty, DateTime startedAtUtc, Duration duration, double rawSpeedCpm, double netSpeedCpm, double accuracyPct, double consistencyScore, int maxStreak, double fatigueFirstThirdCpm, double fatigueMiddleThirdCpm, double fatigueLastThirdCpm, double handBalanceRatio, bool? passed, int xpAwarded, bool isFirstCompletion
});


@override $TypingSessionIdCopyWith<$Res> get id;@override $ProfileIdCopyWith<$Res> get profileId;@override $PracticeModeCopyWith<$Res> get mode;@override $SnippetIdCopyWith<$Res> get snippetId;

}
/// @nodoc
class __$TypingSessionCopyWithImpl<$Res>
    implements _$TypingSessionCopyWith<$Res> {
  __$TypingSessionCopyWithImpl(this._self, this._then);

  final _TypingSession _self;
  final $Res Function(_TypingSession) _then;

/// Create a copy of TypingSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? profileId = null,Object? mode = null,Object? snippetId = null,Object? snippetRevision = null,Object? category = null,Object? difficulty = null,Object? startedAtUtc = null,Object? duration = null,Object? rawSpeedCpm = null,Object? netSpeedCpm = null,Object? accuracyPct = null,Object? consistencyScore = null,Object? maxStreak = null,Object? fatigueFirstThirdCpm = null,Object? fatigueMiddleThirdCpm = null,Object? fatigueLastThirdCpm = null,Object? handBalanceRatio = null,Object? passed = freezed,Object? xpAwarded = null,Object? isFirstCompletion = null,}) {
  return _then(_TypingSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as TypingSessionId,profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as ProfileId,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as PracticeMode,snippetId: null == snippetId ? _self.snippetId : snippetId // ignore: cast_nullable_to_non_nullable
as SnippetId,snippetRevision: null == snippetRevision ? _self.snippetRevision : snippetRevision // ignore: cast_nullable_to_non_nullable
as int,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ContentCategory,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as Difficulty,startedAtUtc: null == startedAtUtc ? _self.startedAtUtc : startedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,rawSpeedCpm: null == rawSpeedCpm ? _self.rawSpeedCpm : rawSpeedCpm // ignore: cast_nullable_to_non_nullable
as double,netSpeedCpm: null == netSpeedCpm ? _self.netSpeedCpm : netSpeedCpm // ignore: cast_nullable_to_non_nullable
as double,accuracyPct: null == accuracyPct ? _self.accuracyPct : accuracyPct // ignore: cast_nullable_to_non_nullable
as double,consistencyScore: null == consistencyScore ? _self.consistencyScore : consistencyScore // ignore: cast_nullable_to_non_nullable
as double,maxStreak: null == maxStreak ? _self.maxStreak : maxStreak // ignore: cast_nullable_to_non_nullable
as int,fatigueFirstThirdCpm: null == fatigueFirstThirdCpm ? _self.fatigueFirstThirdCpm : fatigueFirstThirdCpm // ignore: cast_nullable_to_non_nullable
as double,fatigueMiddleThirdCpm: null == fatigueMiddleThirdCpm ? _self.fatigueMiddleThirdCpm : fatigueMiddleThirdCpm // ignore: cast_nullable_to_non_nullable
as double,fatigueLastThirdCpm: null == fatigueLastThirdCpm ? _self.fatigueLastThirdCpm : fatigueLastThirdCpm // ignore: cast_nullable_to_non_nullable
as double,handBalanceRatio: null == handBalanceRatio ? _self.handBalanceRatio : handBalanceRatio // ignore: cast_nullable_to_non_nullable
as double,passed: freezed == passed ? _self.passed : passed // ignore: cast_nullable_to_non_nullable
as bool?,xpAwarded: null == xpAwarded ? _self.xpAwarded : xpAwarded // ignore: cast_nullable_to_non_nullable
as int,isFirstCompletion: null == isFirstCompletion ? _self.isFirstCompletion : isFirstCompletion // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of TypingSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TypingSessionIdCopyWith<$Res> get id {
  
  return $TypingSessionIdCopyWith<$Res>(_self.id, (value) {
    return _then(_self.copyWith(id: value));
  });
}/// Create a copy of TypingSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileIdCopyWith<$Res> get profileId {
  
  return $ProfileIdCopyWith<$Res>(_self.profileId, (value) {
    return _then(_self.copyWith(profileId: value));
  });
}/// Create a copy of TypingSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PracticeModeCopyWith<$Res> get mode {
  
  return $PracticeModeCopyWith<$Res>(_self.mode, (value) {
    return _then(_self.copyWith(mode: value));
  });
}/// Create a copy of TypingSession
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
