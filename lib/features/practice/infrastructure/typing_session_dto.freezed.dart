// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'typing_session_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TypingSessionDto {

 String get id; String get profileId; String get mode; String get snippetId; int get snippetRevision; String get category; String get difficulty; int get startedAtUtcMicros; int get durationMicros; double get rawSpeedCpm; double get netSpeedCpm; double get accuracyPct; double get consistencyScore; int get maxStreak; double get fatigueFirstThirdCpm; double get fatigueMiddleThirdCpm; double get fatigueLastThirdCpm; double get handBalanceRatio; String? get lessonId; bool? get passed; int get xpAwarded; bool get isFirstCompletion;
/// Create a copy of TypingSessionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TypingSessionDtoCopyWith<TypingSessionDto> get copyWith => _$TypingSessionDtoCopyWithImpl<TypingSessionDto>(this as TypingSessionDto, _$identity);

  /// Serializes this TypingSessionDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TypingSessionDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TypingSessionDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.profileId, _this.profileId) || other.profileId == _this.profileId)&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.snippetId, _this.snippetId) || other.snippetId == _this.snippetId)&&(identical(other.snippetRevision, _this.snippetRevision) || other.snippetRevision == _this.snippetRevision)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.difficulty, _this.difficulty) || other.difficulty == _this.difficulty)&&(identical(other.startedAtUtcMicros, _this.startedAtUtcMicros) || other.startedAtUtcMicros == _this.startedAtUtcMicros)&&(identical(other.durationMicros, _this.durationMicros) || other.durationMicros == _this.durationMicros)&&(identical(other.rawSpeedCpm, _this.rawSpeedCpm) || other.rawSpeedCpm == _this.rawSpeedCpm)&&(identical(other.netSpeedCpm, _this.netSpeedCpm) || other.netSpeedCpm == _this.netSpeedCpm)&&(identical(other.accuracyPct, _this.accuracyPct) || other.accuracyPct == _this.accuracyPct)&&(identical(other.consistencyScore, _this.consistencyScore) || other.consistencyScore == _this.consistencyScore)&&(identical(other.maxStreak, _this.maxStreak) || other.maxStreak == _this.maxStreak)&&(identical(other.fatigueFirstThirdCpm, _this.fatigueFirstThirdCpm) || other.fatigueFirstThirdCpm == _this.fatigueFirstThirdCpm)&&(identical(other.fatigueMiddleThirdCpm, _this.fatigueMiddleThirdCpm) || other.fatigueMiddleThirdCpm == _this.fatigueMiddleThirdCpm)&&(identical(other.fatigueLastThirdCpm, _this.fatigueLastThirdCpm) || other.fatigueLastThirdCpm == _this.fatigueLastThirdCpm)&&(identical(other.handBalanceRatio, _this.handBalanceRatio) || other.handBalanceRatio == _this.handBalanceRatio)&&(identical(other.lessonId, _this.lessonId) || other.lessonId == _this.lessonId)&&(identical(other.passed, _this.passed) || other.passed == _this.passed)&&(identical(other.xpAwarded, _this.xpAwarded) || other.xpAwarded == _this.xpAwarded)&&(identical(other.isFirstCompletion, _this.isFirstCompletion) || other.isFirstCompletion == _this.isFirstCompletion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TypingSessionDto;
  return Object.hashAll([runtimeType,_this.id,_this.profileId,_this.mode,_this.snippetId,_this.snippetRevision,_this.category,_this.difficulty,_this.startedAtUtcMicros,_this.durationMicros,_this.rawSpeedCpm,_this.netSpeedCpm,_this.accuracyPct,_this.consistencyScore,_this.maxStreak,_this.fatigueFirstThirdCpm,_this.fatigueMiddleThirdCpm,_this.fatigueLastThirdCpm,_this.handBalanceRatio,_this.lessonId,_this.passed,_this.xpAwarded,_this.isFirstCompletion]);
}

@override
String toString() {
  final _this = this as TypingSessionDto;
  return 'TypingSessionDto(id: ${_this.id}, profileId: ${_this.profileId}, mode: ${_this.mode}, snippetId: ${_this.snippetId}, snippetRevision: ${_this.snippetRevision}, category: ${_this.category}, difficulty: ${_this.difficulty}, startedAtUtcMicros: ${_this.startedAtUtcMicros}, durationMicros: ${_this.durationMicros}, rawSpeedCpm: ${_this.rawSpeedCpm}, netSpeedCpm: ${_this.netSpeedCpm}, accuracyPct: ${_this.accuracyPct}, consistencyScore: ${_this.consistencyScore}, maxStreak: ${_this.maxStreak}, fatigueFirstThirdCpm: ${_this.fatigueFirstThirdCpm}, fatigueMiddleThirdCpm: ${_this.fatigueMiddleThirdCpm}, fatigueLastThirdCpm: ${_this.fatigueLastThirdCpm}, handBalanceRatio: ${_this.handBalanceRatio}, lessonId: ${_this.lessonId}, passed: ${_this.passed}, xpAwarded: ${_this.xpAwarded}, isFirstCompletion: ${_this.isFirstCompletion})';
}


}

/// @nodoc
abstract mixin class $TypingSessionDtoCopyWith<$Res>  {
  factory $TypingSessionDtoCopyWith(TypingSessionDto value, $Res Function(TypingSessionDto) _then) = _$TypingSessionDtoCopyWithImpl;
@useResult
$Res call({
 String id, String profileId, String mode, String snippetId, int snippetRevision, String category, String difficulty, int startedAtUtcMicros, int durationMicros, double rawSpeedCpm, double netSpeedCpm, double accuracyPct, double consistencyScore, int maxStreak, double fatigueFirstThirdCpm, double fatigueMiddleThirdCpm, double fatigueLastThirdCpm, double handBalanceRatio, String? lessonId, bool? passed, int xpAwarded, bool isFirstCompletion
});




}
/// @nodoc
class _$TypingSessionDtoCopyWithImpl<$Res>
    implements $TypingSessionDtoCopyWith<$Res> {
  _$TypingSessionDtoCopyWithImpl(this._self, this._then);

  final TypingSessionDto _self;
  final $Res Function(TypingSessionDto) _then;

/// Create a copy of TypingSessionDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? profileId = null,Object? mode = null,Object? snippetId = null,Object? snippetRevision = null,Object? category = null,Object? difficulty = null,Object? startedAtUtcMicros = null,Object? durationMicros = null,Object? rawSpeedCpm = null,Object? netSpeedCpm = null,Object? accuracyPct = null,Object? consistencyScore = null,Object? maxStreak = null,Object? fatigueFirstThirdCpm = null,Object? fatigueMiddleThirdCpm = null,Object? fatigueLastThirdCpm = null,Object? handBalanceRatio = null,Object? lessonId = freezed,Object? passed = freezed,Object? xpAwarded = null,Object? isFirstCompletion = null,}) {
  return _then(TypingSessionDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,snippetId: null == snippetId ? _self.snippetId : snippetId // ignore: cast_nullable_to_non_nullable
as String,snippetRevision: null == snippetRevision ? _self.snippetRevision : snippetRevision // ignore: cast_nullable_to_non_nullable
as int,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,startedAtUtcMicros: null == startedAtUtcMicros ? _self.startedAtUtcMicros : startedAtUtcMicros // ignore: cast_nullable_to_non_nullable
as int,durationMicros: null == durationMicros ? _self.durationMicros : durationMicros // ignore: cast_nullable_to_non_nullable
as int,rawSpeedCpm: null == rawSpeedCpm ? _self.rawSpeedCpm : rawSpeedCpm // ignore: cast_nullable_to_non_nullable
as double,netSpeedCpm: null == netSpeedCpm ? _self.netSpeedCpm : netSpeedCpm // ignore: cast_nullable_to_non_nullable
as double,accuracyPct: null == accuracyPct ? _self.accuracyPct : accuracyPct // ignore: cast_nullable_to_non_nullable
as double,consistencyScore: null == consistencyScore ? _self.consistencyScore : consistencyScore // ignore: cast_nullable_to_non_nullable
as double,maxStreak: null == maxStreak ? _self.maxStreak : maxStreak // ignore: cast_nullable_to_non_nullable
as int,fatigueFirstThirdCpm: null == fatigueFirstThirdCpm ? _self.fatigueFirstThirdCpm : fatigueFirstThirdCpm // ignore: cast_nullable_to_non_nullable
as double,fatigueMiddleThirdCpm: null == fatigueMiddleThirdCpm ? _self.fatigueMiddleThirdCpm : fatigueMiddleThirdCpm // ignore: cast_nullable_to_non_nullable
as double,fatigueLastThirdCpm: null == fatigueLastThirdCpm ? _self.fatigueLastThirdCpm : fatigueLastThirdCpm // ignore: cast_nullable_to_non_nullable
as double,handBalanceRatio: null == handBalanceRatio ? _self.handBalanceRatio : handBalanceRatio // ignore: cast_nullable_to_non_nullable
as double,lessonId: freezed == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String?,passed: freezed == passed ? _self.passed : passed // ignore: cast_nullable_to_non_nullable
as bool?,xpAwarded: null == xpAwarded ? _self.xpAwarded : xpAwarded // ignore: cast_nullable_to_non_nullable
as int,isFirstCompletion: null == isFirstCompletion ? _self.isFirstCompletion : isFirstCompletion // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TypingSessionDto].
extension TypingSessionDtoPatterns on TypingSessionDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TypingSessionDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TypingSessionDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TypingSessionDto value)  $default,){
final _that = this;
switch (_that) {
case _TypingSessionDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TypingSessionDto value)?  $default,){
final _that = this;
switch (_that) {
case _TypingSessionDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String profileId,  String mode,  String snippetId,  int snippetRevision,  String category,  String difficulty,  int startedAtUtcMicros,  int durationMicros,  double rawSpeedCpm,  double netSpeedCpm,  double accuracyPct,  double consistencyScore,  int maxStreak,  double fatigueFirstThirdCpm,  double fatigueMiddleThirdCpm,  double fatigueLastThirdCpm,  double handBalanceRatio,  String? lessonId,  bool? passed,  int xpAwarded,  bool isFirstCompletion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TypingSessionDto() when $default != null:
return $default(_that.id,_that.profileId,_that.mode,_that.snippetId,_that.snippetRevision,_that.category,_that.difficulty,_that.startedAtUtcMicros,_that.durationMicros,_that.rawSpeedCpm,_that.netSpeedCpm,_that.accuracyPct,_that.consistencyScore,_that.maxStreak,_that.fatigueFirstThirdCpm,_that.fatigueMiddleThirdCpm,_that.fatigueLastThirdCpm,_that.handBalanceRatio,_that.lessonId,_that.passed,_that.xpAwarded,_that.isFirstCompletion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String profileId,  String mode,  String snippetId,  int snippetRevision,  String category,  String difficulty,  int startedAtUtcMicros,  int durationMicros,  double rawSpeedCpm,  double netSpeedCpm,  double accuracyPct,  double consistencyScore,  int maxStreak,  double fatigueFirstThirdCpm,  double fatigueMiddleThirdCpm,  double fatigueLastThirdCpm,  double handBalanceRatio,  String? lessonId,  bool? passed,  int xpAwarded,  bool isFirstCompletion)  $default,) {final _that = this;
switch (_that) {
case _TypingSessionDto():
return $default(_that.id,_that.profileId,_that.mode,_that.snippetId,_that.snippetRevision,_that.category,_that.difficulty,_that.startedAtUtcMicros,_that.durationMicros,_that.rawSpeedCpm,_that.netSpeedCpm,_that.accuracyPct,_that.consistencyScore,_that.maxStreak,_that.fatigueFirstThirdCpm,_that.fatigueMiddleThirdCpm,_that.fatigueLastThirdCpm,_that.handBalanceRatio,_that.lessonId,_that.passed,_that.xpAwarded,_that.isFirstCompletion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String profileId,  String mode,  String snippetId,  int snippetRevision,  String category,  String difficulty,  int startedAtUtcMicros,  int durationMicros,  double rawSpeedCpm,  double netSpeedCpm,  double accuracyPct,  double consistencyScore,  int maxStreak,  double fatigueFirstThirdCpm,  double fatigueMiddleThirdCpm,  double fatigueLastThirdCpm,  double handBalanceRatio,  String? lessonId,  bool? passed,  int xpAwarded,  bool isFirstCompletion)?  $default,) {final _that = this;
switch (_that) {
case _TypingSessionDto() when $default != null:
return $default(_that.id,_that.profileId,_that.mode,_that.snippetId,_that.snippetRevision,_that.category,_that.difficulty,_that.startedAtUtcMicros,_that.durationMicros,_that.rawSpeedCpm,_that.netSpeedCpm,_that.accuracyPct,_that.consistencyScore,_that.maxStreak,_that.fatigueFirstThirdCpm,_that.fatigueMiddleThirdCpm,_that.fatigueLastThirdCpm,_that.handBalanceRatio,_that.lessonId,_that.passed,_that.xpAwarded,_that.isFirstCompletion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TypingSessionDto implements TypingSessionDto {
  const _TypingSessionDto({required this.id, required this.profileId, required this.mode, required this.snippetId, required this.snippetRevision, required this.category, required this.difficulty, required this.startedAtUtcMicros, required this.durationMicros, required this.rawSpeedCpm, required this.netSpeedCpm, required this.accuracyPct, required this.consistencyScore, required this.maxStreak, required this.fatigueFirstThirdCpm, required this.fatigueMiddleThirdCpm, required this.fatigueLastThirdCpm, required this.handBalanceRatio, this.lessonId, this.passed, this.xpAwarded = 0, this.isFirstCompletion = false});
  factory _TypingSessionDto.fromJson(Map<String, dynamic> json) => _$TypingSessionDtoFromJson(json);

@override final  String id;
@override final  String profileId;
@override final  String mode;
@override final  String snippetId;
@override final  int snippetRevision;
@override final  String category;
@override final  String difficulty;
@override final  int startedAtUtcMicros;
@override final  int durationMicros;
@override final  double rawSpeedCpm;
@override final  double netSpeedCpm;
@override final  double accuracyPct;
@override final  double consistencyScore;
@override final  int maxStreak;
@override final  double fatigueFirstThirdCpm;
@override final  double fatigueMiddleThirdCpm;
@override final  double fatigueLastThirdCpm;
@override final  double handBalanceRatio;
@override final  String? lessonId;
@override final  bool? passed;
@override@JsonKey() final  int xpAwarded;
@override@JsonKey() final  bool isFirstCompletion;

/// Create a copy of TypingSessionDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TypingSessionDtoCopyWith<_TypingSessionDto> get copyWith => __$TypingSessionDtoCopyWithImpl<_TypingSessionDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TypingSessionDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TypingSessionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.snippetId, snippetId) || other.snippetId == snippetId)&&(identical(other.snippetRevision, snippetRevision) || other.snippetRevision == snippetRevision)&&(identical(other.category, category) || other.category == category)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.startedAtUtcMicros, startedAtUtcMicros) || other.startedAtUtcMicros == startedAtUtcMicros)&&(identical(other.durationMicros, durationMicros) || other.durationMicros == durationMicros)&&(identical(other.rawSpeedCpm, rawSpeedCpm) || other.rawSpeedCpm == rawSpeedCpm)&&(identical(other.netSpeedCpm, netSpeedCpm) || other.netSpeedCpm == netSpeedCpm)&&(identical(other.accuracyPct, accuracyPct) || other.accuracyPct == accuracyPct)&&(identical(other.consistencyScore, consistencyScore) || other.consistencyScore == consistencyScore)&&(identical(other.maxStreak, maxStreak) || other.maxStreak == maxStreak)&&(identical(other.fatigueFirstThirdCpm, fatigueFirstThirdCpm) || other.fatigueFirstThirdCpm == fatigueFirstThirdCpm)&&(identical(other.fatigueMiddleThirdCpm, fatigueMiddleThirdCpm) || other.fatigueMiddleThirdCpm == fatigueMiddleThirdCpm)&&(identical(other.fatigueLastThirdCpm, fatigueLastThirdCpm) || other.fatigueLastThirdCpm == fatigueLastThirdCpm)&&(identical(other.handBalanceRatio, handBalanceRatio) || other.handBalanceRatio == handBalanceRatio)&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.passed, passed) || other.passed == passed)&&(identical(other.xpAwarded, xpAwarded) || other.xpAwarded == xpAwarded)&&(identical(other.isFirstCompletion, isFirstCompletion) || other.isFirstCompletion == isFirstCompletion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,profileId,mode,snippetId,snippetRevision,category,difficulty,startedAtUtcMicros,durationMicros,rawSpeedCpm,netSpeedCpm,accuracyPct,consistencyScore,maxStreak,fatigueFirstThirdCpm,fatigueMiddleThirdCpm,fatigueLastThirdCpm,handBalanceRatio,lessonId,passed,xpAwarded,isFirstCompletion]);
}

@override
String toString() {
    return 'TypingSessionDto(id: $id, profileId: $profileId, mode: $mode, snippetId: $snippetId, snippetRevision: $snippetRevision, category: $category, difficulty: $difficulty, startedAtUtcMicros: $startedAtUtcMicros, durationMicros: $durationMicros, rawSpeedCpm: $rawSpeedCpm, netSpeedCpm: $netSpeedCpm, accuracyPct: $accuracyPct, consistencyScore: $consistencyScore, maxStreak: $maxStreak, fatigueFirstThirdCpm: $fatigueFirstThirdCpm, fatigueMiddleThirdCpm: $fatigueMiddleThirdCpm, fatigueLastThirdCpm: $fatigueLastThirdCpm, handBalanceRatio: $handBalanceRatio, lessonId: $lessonId, passed: $passed, xpAwarded: $xpAwarded, isFirstCompletion: $isFirstCompletion)';
}


}

/// @nodoc
abstract mixin class _$TypingSessionDtoCopyWith<$Res> implements $TypingSessionDtoCopyWith<$Res> {
  factory _$TypingSessionDtoCopyWith(_TypingSessionDto value, $Res Function(_TypingSessionDto) _then) = __$TypingSessionDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String profileId, String mode, String snippetId, int snippetRevision, String category, String difficulty, int startedAtUtcMicros, int durationMicros, double rawSpeedCpm, double netSpeedCpm, double accuracyPct, double consistencyScore, int maxStreak, double fatigueFirstThirdCpm, double fatigueMiddleThirdCpm, double fatigueLastThirdCpm, double handBalanceRatio, String? lessonId, bool? passed, int xpAwarded, bool isFirstCompletion
});




}
/// @nodoc
class __$TypingSessionDtoCopyWithImpl<$Res>
    implements _$TypingSessionDtoCopyWith<$Res> {
  __$TypingSessionDtoCopyWithImpl(this._self, this._then);

  final _TypingSessionDto _self;
  final $Res Function(_TypingSessionDto) _then;

/// Create a copy of TypingSessionDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? profileId = null,Object? mode = null,Object? snippetId = null,Object? snippetRevision = null,Object? category = null,Object? difficulty = null,Object? startedAtUtcMicros = null,Object? durationMicros = null,Object? rawSpeedCpm = null,Object? netSpeedCpm = null,Object? accuracyPct = null,Object? consistencyScore = null,Object? maxStreak = null,Object? fatigueFirstThirdCpm = null,Object? fatigueMiddleThirdCpm = null,Object? fatigueLastThirdCpm = null,Object? handBalanceRatio = null,Object? lessonId = freezed,Object? passed = freezed,Object? xpAwarded = null,Object? isFirstCompletion = null,}) {
  return _then(_TypingSessionDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,snippetId: null == snippetId ? _self.snippetId : snippetId // ignore: cast_nullable_to_non_nullable
as String,snippetRevision: null == snippetRevision ? _self.snippetRevision : snippetRevision // ignore: cast_nullable_to_non_nullable
as int,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,startedAtUtcMicros: null == startedAtUtcMicros ? _self.startedAtUtcMicros : startedAtUtcMicros // ignore: cast_nullable_to_non_nullable
as int,durationMicros: null == durationMicros ? _self.durationMicros : durationMicros // ignore: cast_nullable_to_non_nullable
as int,rawSpeedCpm: null == rawSpeedCpm ? _self.rawSpeedCpm : rawSpeedCpm // ignore: cast_nullable_to_non_nullable
as double,netSpeedCpm: null == netSpeedCpm ? _self.netSpeedCpm : netSpeedCpm // ignore: cast_nullable_to_non_nullable
as double,accuracyPct: null == accuracyPct ? _self.accuracyPct : accuracyPct // ignore: cast_nullable_to_non_nullable
as double,consistencyScore: null == consistencyScore ? _self.consistencyScore : consistencyScore // ignore: cast_nullable_to_non_nullable
as double,maxStreak: null == maxStreak ? _self.maxStreak : maxStreak // ignore: cast_nullable_to_non_nullable
as int,fatigueFirstThirdCpm: null == fatigueFirstThirdCpm ? _self.fatigueFirstThirdCpm : fatigueFirstThirdCpm // ignore: cast_nullable_to_non_nullable
as double,fatigueMiddleThirdCpm: null == fatigueMiddleThirdCpm ? _self.fatigueMiddleThirdCpm : fatigueMiddleThirdCpm // ignore: cast_nullable_to_non_nullable
as double,fatigueLastThirdCpm: null == fatigueLastThirdCpm ? _self.fatigueLastThirdCpm : fatigueLastThirdCpm // ignore: cast_nullable_to_non_nullable
as double,handBalanceRatio: null == handBalanceRatio ? _self.handBalanceRatio : handBalanceRatio // ignore: cast_nullable_to_non_nullable
as double,lessonId: freezed == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String?,passed: freezed == passed ? _self.passed : passed // ignore: cast_nullable_to_non_nullable
as bool?,xpAwarded: null == xpAwarded ? _self.xpAwarded : xpAwarded // ignore: cast_nullable_to_non_nullable
as int,isFirstCompletion: null == isFirstCompletion ? _self.isFirstCompletion : isFirstCompletion // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
