// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_metrics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionMetrics {

 double get rawSpeedCpm; double get netSpeedCpm; double get accuracyPct; double get consistencyScore; int get maxStreak; double get fatigueFirstThirdCpm; double get fatigueMiddleThirdCpm; double get fatigueLastThirdCpm; double get handBalanceRatio; Map<String, CharacterStat> get characterStats; Map<Finger, FingerStat> get fingerStats; List<NgramStat> get ngramStats; Map<PhysicalKeyId, KeyHeatmapEntry> get keyHeatmap;
/// Create a copy of SessionMetrics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionMetricsCopyWith<SessionMetrics> get copyWith => _$SessionMetricsCopyWithImpl<SessionMetrics>(this as SessionMetrics, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SessionMetrics;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionMetrics&&(identical(other.rawSpeedCpm, _this.rawSpeedCpm) || other.rawSpeedCpm == _this.rawSpeedCpm)&&(identical(other.netSpeedCpm, _this.netSpeedCpm) || other.netSpeedCpm == _this.netSpeedCpm)&&(identical(other.accuracyPct, _this.accuracyPct) || other.accuracyPct == _this.accuracyPct)&&(identical(other.consistencyScore, _this.consistencyScore) || other.consistencyScore == _this.consistencyScore)&&(identical(other.maxStreak, _this.maxStreak) || other.maxStreak == _this.maxStreak)&&(identical(other.fatigueFirstThirdCpm, _this.fatigueFirstThirdCpm) || other.fatigueFirstThirdCpm == _this.fatigueFirstThirdCpm)&&(identical(other.fatigueMiddleThirdCpm, _this.fatigueMiddleThirdCpm) || other.fatigueMiddleThirdCpm == _this.fatigueMiddleThirdCpm)&&(identical(other.fatigueLastThirdCpm, _this.fatigueLastThirdCpm) || other.fatigueLastThirdCpm == _this.fatigueLastThirdCpm)&&(identical(other.handBalanceRatio, _this.handBalanceRatio) || other.handBalanceRatio == _this.handBalanceRatio)&&const DeepCollectionEquality().equals(other.characterStats, _this.characterStats)&&const DeepCollectionEquality().equals(other.fingerStats, _this.fingerStats)&&const DeepCollectionEquality().equals(other.ngramStats, _this.ngramStats)&&const DeepCollectionEquality().equals(other.keyHeatmap, _this.keyHeatmap));
}


@override
int get hashCode {
  final _this = this as SessionMetrics;
  return Object.hash(runtimeType,_this.rawSpeedCpm,_this.netSpeedCpm,_this.accuracyPct,_this.consistencyScore,_this.maxStreak,_this.fatigueFirstThirdCpm,_this.fatigueMiddleThirdCpm,_this.fatigueLastThirdCpm,_this.handBalanceRatio,const DeepCollectionEquality().hash(_this.characterStats),const DeepCollectionEquality().hash(_this.fingerStats),const DeepCollectionEquality().hash(_this.ngramStats),const DeepCollectionEquality().hash(_this.keyHeatmap));
}

@override
String toString() {
  final _this = this as SessionMetrics;
  return 'SessionMetrics(rawSpeedCpm: ${_this.rawSpeedCpm}, netSpeedCpm: ${_this.netSpeedCpm}, accuracyPct: ${_this.accuracyPct}, consistencyScore: ${_this.consistencyScore}, maxStreak: ${_this.maxStreak}, fatigueFirstThirdCpm: ${_this.fatigueFirstThirdCpm}, fatigueMiddleThirdCpm: ${_this.fatigueMiddleThirdCpm}, fatigueLastThirdCpm: ${_this.fatigueLastThirdCpm}, handBalanceRatio: ${_this.handBalanceRatio}, characterStats: ${_this.characterStats}, fingerStats: ${_this.fingerStats}, ngramStats: ${_this.ngramStats}, keyHeatmap: ${_this.keyHeatmap})';
}


}

/// @nodoc
abstract mixin class $SessionMetricsCopyWith<$Res>  {
  factory $SessionMetricsCopyWith(SessionMetrics value, $Res Function(SessionMetrics) _then) = _$SessionMetricsCopyWithImpl;
@useResult
$Res call({
 double rawSpeedCpm, double netSpeedCpm, double accuracyPct, double consistencyScore, int maxStreak, double fatigueFirstThirdCpm, double fatigueMiddleThirdCpm, double fatigueLastThirdCpm, double handBalanceRatio, Map<String, CharacterStat> characterStats, Map<Finger, FingerStat> fingerStats, List<NgramStat> ngramStats, Map<PhysicalKeyId, KeyHeatmapEntry> keyHeatmap
});




}
/// @nodoc
class _$SessionMetricsCopyWithImpl<$Res>
    implements $SessionMetricsCopyWith<$Res> {
  _$SessionMetricsCopyWithImpl(this._self, this._then);

  final SessionMetrics _self;
  final $Res Function(SessionMetrics) _then;

/// Create a copy of SessionMetrics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rawSpeedCpm = null,Object? netSpeedCpm = null,Object? accuracyPct = null,Object? consistencyScore = null,Object? maxStreak = null,Object? fatigueFirstThirdCpm = null,Object? fatigueMiddleThirdCpm = null,Object? fatigueLastThirdCpm = null,Object? handBalanceRatio = null,Object? characterStats = null,Object? fingerStats = null,Object? ngramStats = null,Object? keyHeatmap = null,}) {
  return _then(SessionMetrics(
rawSpeedCpm: null == rawSpeedCpm ? _self.rawSpeedCpm : rawSpeedCpm // ignore: cast_nullable_to_non_nullable
as double,netSpeedCpm: null == netSpeedCpm ? _self.netSpeedCpm : netSpeedCpm // ignore: cast_nullable_to_non_nullable
as double,accuracyPct: null == accuracyPct ? _self.accuracyPct : accuracyPct // ignore: cast_nullable_to_non_nullable
as double,consistencyScore: null == consistencyScore ? _self.consistencyScore : consistencyScore // ignore: cast_nullable_to_non_nullable
as double,maxStreak: null == maxStreak ? _self.maxStreak : maxStreak // ignore: cast_nullable_to_non_nullable
as int,fatigueFirstThirdCpm: null == fatigueFirstThirdCpm ? _self.fatigueFirstThirdCpm : fatigueFirstThirdCpm // ignore: cast_nullable_to_non_nullable
as double,fatigueMiddleThirdCpm: null == fatigueMiddleThirdCpm ? _self.fatigueMiddleThirdCpm : fatigueMiddleThirdCpm // ignore: cast_nullable_to_non_nullable
as double,fatigueLastThirdCpm: null == fatigueLastThirdCpm ? _self.fatigueLastThirdCpm : fatigueLastThirdCpm // ignore: cast_nullable_to_non_nullable
as double,handBalanceRatio: null == handBalanceRatio ? _self.handBalanceRatio : handBalanceRatio // ignore: cast_nullable_to_non_nullable
as double,characterStats: null == characterStats ? _self.characterStats : characterStats // ignore: cast_nullable_to_non_nullable
as Map<String, CharacterStat>,fingerStats: null == fingerStats ? _self.fingerStats : fingerStats // ignore: cast_nullable_to_non_nullable
as Map<Finger, FingerStat>,ngramStats: null == ngramStats ? _self.ngramStats : ngramStats // ignore: cast_nullable_to_non_nullable
as List<NgramStat>,keyHeatmap: null == keyHeatmap ? _self.keyHeatmap : keyHeatmap // ignore: cast_nullable_to_non_nullable
as Map<PhysicalKeyId, KeyHeatmapEntry>,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionMetrics].
extension SessionMetricsPatterns on SessionMetrics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionMetrics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionMetrics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionMetrics value)  $default,){
final _that = this;
switch (_that) {
case _SessionMetrics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionMetrics value)?  $default,){
final _that = this;
switch (_that) {
case _SessionMetrics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double rawSpeedCpm,  double netSpeedCpm,  double accuracyPct,  double consistencyScore,  int maxStreak,  double fatigueFirstThirdCpm,  double fatigueMiddleThirdCpm,  double fatigueLastThirdCpm,  double handBalanceRatio,  Map<String, CharacterStat> characterStats,  Map<Finger, FingerStat> fingerStats,  List<NgramStat> ngramStats,  Map<PhysicalKeyId, KeyHeatmapEntry> keyHeatmap)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionMetrics() when $default != null:
return $default(_that.rawSpeedCpm,_that.netSpeedCpm,_that.accuracyPct,_that.consistencyScore,_that.maxStreak,_that.fatigueFirstThirdCpm,_that.fatigueMiddleThirdCpm,_that.fatigueLastThirdCpm,_that.handBalanceRatio,_that.characterStats,_that.fingerStats,_that.ngramStats,_that.keyHeatmap);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double rawSpeedCpm,  double netSpeedCpm,  double accuracyPct,  double consistencyScore,  int maxStreak,  double fatigueFirstThirdCpm,  double fatigueMiddleThirdCpm,  double fatigueLastThirdCpm,  double handBalanceRatio,  Map<String, CharacterStat> characterStats,  Map<Finger, FingerStat> fingerStats,  List<NgramStat> ngramStats,  Map<PhysicalKeyId, KeyHeatmapEntry> keyHeatmap)  $default,) {final _that = this;
switch (_that) {
case _SessionMetrics():
return $default(_that.rawSpeedCpm,_that.netSpeedCpm,_that.accuracyPct,_that.consistencyScore,_that.maxStreak,_that.fatigueFirstThirdCpm,_that.fatigueMiddleThirdCpm,_that.fatigueLastThirdCpm,_that.handBalanceRatio,_that.characterStats,_that.fingerStats,_that.ngramStats,_that.keyHeatmap);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double rawSpeedCpm,  double netSpeedCpm,  double accuracyPct,  double consistencyScore,  int maxStreak,  double fatigueFirstThirdCpm,  double fatigueMiddleThirdCpm,  double fatigueLastThirdCpm,  double handBalanceRatio,  Map<String, CharacterStat> characterStats,  Map<Finger, FingerStat> fingerStats,  List<NgramStat> ngramStats,  Map<PhysicalKeyId, KeyHeatmapEntry> keyHeatmap)?  $default,) {final _that = this;
switch (_that) {
case _SessionMetrics() when $default != null:
return $default(_that.rawSpeedCpm,_that.netSpeedCpm,_that.accuracyPct,_that.consistencyScore,_that.maxStreak,_that.fatigueFirstThirdCpm,_that.fatigueMiddleThirdCpm,_that.fatigueLastThirdCpm,_that.handBalanceRatio,_that.characterStats,_that.fingerStats,_that.ngramStats,_that.keyHeatmap);case _:
  return null;

}
}

}

/// @nodoc


class _SessionMetrics implements SessionMetrics {
  const _SessionMetrics({required this.rawSpeedCpm, required this.netSpeedCpm, required this.accuracyPct, required this.consistencyScore, required this.maxStreak, required this.fatigueFirstThirdCpm, required this.fatigueMiddleThirdCpm, required this.fatigueLastThirdCpm, required this.handBalanceRatio, required  Map<String, CharacterStat> characterStats, required  Map<Finger, FingerStat> fingerStats, required  List<NgramStat> ngramStats, required  Map<PhysicalKeyId, KeyHeatmapEntry> keyHeatmap}): _characterStats = characterStats,_fingerStats = fingerStats,_ngramStats = ngramStats,_keyHeatmap = keyHeatmap;
  

@override final  double rawSpeedCpm;
@override final  double netSpeedCpm;
@override final  double accuracyPct;
@override final  double consistencyScore;
@override final  int maxStreak;
@override final  double fatigueFirstThirdCpm;
@override final  double fatigueMiddleThirdCpm;
@override final  double fatigueLastThirdCpm;
@override final  double handBalanceRatio;
 final  Map<String, CharacterStat> _characterStats;
@override Map<String, CharacterStat> get characterStats {
  if (_characterStats is EqualUnmodifiableMapView) return _characterStats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_characterStats);
}

 final  Map<Finger, FingerStat> _fingerStats;
@override Map<Finger, FingerStat> get fingerStats {
  if (_fingerStats is EqualUnmodifiableMapView) return _fingerStats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_fingerStats);
}

 final  List<NgramStat> _ngramStats;
@override List<NgramStat> get ngramStats {
  if (_ngramStats is EqualUnmodifiableListView) return _ngramStats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ngramStats);
}

 final  Map<PhysicalKeyId, KeyHeatmapEntry> _keyHeatmap;
@override Map<PhysicalKeyId, KeyHeatmapEntry> get keyHeatmap {
  if (_keyHeatmap is EqualUnmodifiableMapView) return _keyHeatmap;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_keyHeatmap);
}


/// Create a copy of SessionMetrics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionMetricsCopyWith<_SessionMetrics> get copyWith => __$SessionMetricsCopyWithImpl<_SessionMetrics>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionMetrics&&(identical(other.rawSpeedCpm, rawSpeedCpm) || other.rawSpeedCpm == rawSpeedCpm)&&(identical(other.netSpeedCpm, netSpeedCpm) || other.netSpeedCpm == netSpeedCpm)&&(identical(other.accuracyPct, accuracyPct) || other.accuracyPct == accuracyPct)&&(identical(other.consistencyScore, consistencyScore) || other.consistencyScore == consistencyScore)&&(identical(other.maxStreak, maxStreak) || other.maxStreak == maxStreak)&&(identical(other.fatigueFirstThirdCpm, fatigueFirstThirdCpm) || other.fatigueFirstThirdCpm == fatigueFirstThirdCpm)&&(identical(other.fatigueMiddleThirdCpm, fatigueMiddleThirdCpm) || other.fatigueMiddleThirdCpm == fatigueMiddleThirdCpm)&&(identical(other.fatigueLastThirdCpm, fatigueLastThirdCpm) || other.fatigueLastThirdCpm == fatigueLastThirdCpm)&&(identical(other.handBalanceRatio, handBalanceRatio) || other.handBalanceRatio == handBalanceRatio)&&const DeepCollectionEquality().equals(other.characterStats, _characterStats)&&const DeepCollectionEquality().equals(other.fingerStats, _fingerStats)&&const DeepCollectionEquality().equals(other.ngramStats, _ngramStats)&&const DeepCollectionEquality().equals(other.keyHeatmap, _keyHeatmap));
}


@override
int get hashCode {
    return Object.hash(runtimeType,rawSpeedCpm,netSpeedCpm,accuracyPct,consistencyScore,maxStreak,fatigueFirstThirdCpm,fatigueMiddleThirdCpm,fatigueLastThirdCpm,handBalanceRatio,const DeepCollectionEquality().hash(_characterStats),const DeepCollectionEquality().hash(_fingerStats),const DeepCollectionEquality().hash(_ngramStats),const DeepCollectionEquality().hash(_keyHeatmap));
}

@override
String toString() {
    return 'SessionMetrics(rawSpeedCpm: $rawSpeedCpm, netSpeedCpm: $netSpeedCpm, accuracyPct: $accuracyPct, consistencyScore: $consistencyScore, maxStreak: $maxStreak, fatigueFirstThirdCpm: $fatigueFirstThirdCpm, fatigueMiddleThirdCpm: $fatigueMiddleThirdCpm, fatigueLastThirdCpm: $fatigueLastThirdCpm, handBalanceRatio: $handBalanceRatio, characterStats: $characterStats, fingerStats: $fingerStats, ngramStats: $ngramStats, keyHeatmap: $keyHeatmap)';
}


}

/// @nodoc
abstract mixin class _$SessionMetricsCopyWith<$Res> implements $SessionMetricsCopyWith<$Res> {
  factory _$SessionMetricsCopyWith(_SessionMetrics value, $Res Function(_SessionMetrics) _then) = __$SessionMetricsCopyWithImpl;
@override @useResult
$Res call({
 double rawSpeedCpm, double netSpeedCpm, double accuracyPct, double consistencyScore, int maxStreak, double fatigueFirstThirdCpm, double fatigueMiddleThirdCpm, double fatigueLastThirdCpm, double handBalanceRatio, Map<String, CharacterStat> characterStats, Map<Finger, FingerStat> fingerStats, List<NgramStat> ngramStats, Map<PhysicalKeyId, KeyHeatmapEntry> keyHeatmap
});




}
/// @nodoc
class __$SessionMetricsCopyWithImpl<$Res>
    implements _$SessionMetricsCopyWith<$Res> {
  __$SessionMetricsCopyWithImpl(this._self, this._then);

  final _SessionMetrics _self;
  final $Res Function(_SessionMetrics) _then;

/// Create a copy of SessionMetrics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rawSpeedCpm = null,Object? netSpeedCpm = null,Object? accuracyPct = null,Object? consistencyScore = null,Object? maxStreak = null,Object? fatigueFirstThirdCpm = null,Object? fatigueMiddleThirdCpm = null,Object? fatigueLastThirdCpm = null,Object? handBalanceRatio = null,Object? characterStats = null,Object? fingerStats = null,Object? ngramStats = null,Object? keyHeatmap = null,}) {
  return _then(_SessionMetrics(
rawSpeedCpm: null == rawSpeedCpm ? _self.rawSpeedCpm : rawSpeedCpm // ignore: cast_nullable_to_non_nullable
as double,netSpeedCpm: null == netSpeedCpm ? _self.netSpeedCpm : netSpeedCpm // ignore: cast_nullable_to_non_nullable
as double,accuracyPct: null == accuracyPct ? _self.accuracyPct : accuracyPct // ignore: cast_nullable_to_non_nullable
as double,consistencyScore: null == consistencyScore ? _self.consistencyScore : consistencyScore // ignore: cast_nullable_to_non_nullable
as double,maxStreak: null == maxStreak ? _self.maxStreak : maxStreak // ignore: cast_nullable_to_non_nullable
as int,fatigueFirstThirdCpm: null == fatigueFirstThirdCpm ? _self.fatigueFirstThirdCpm : fatigueFirstThirdCpm // ignore: cast_nullable_to_non_nullable
as double,fatigueMiddleThirdCpm: null == fatigueMiddleThirdCpm ? _self.fatigueMiddleThirdCpm : fatigueMiddleThirdCpm // ignore: cast_nullable_to_non_nullable
as double,fatigueLastThirdCpm: null == fatigueLastThirdCpm ? _self.fatigueLastThirdCpm : fatigueLastThirdCpm // ignore: cast_nullable_to_non_nullable
as double,handBalanceRatio: null == handBalanceRatio ? _self.handBalanceRatio : handBalanceRatio // ignore: cast_nullable_to_non_nullable
as double,characterStats: null == characterStats ? _self._characterStats : characterStats // ignore: cast_nullable_to_non_nullable
as Map<String, CharacterStat>,fingerStats: null == fingerStats ? _self._fingerStats : fingerStats // ignore: cast_nullable_to_non_nullable
as Map<Finger, FingerStat>,ngramStats: null == ngramStats ? _self._ngramStats : ngramStats // ignore: cast_nullable_to_non_nullable
as List<NgramStat>,keyHeatmap: null == keyHeatmap ? _self._keyHeatmap : keyHeatmap // ignore: cast_nullable_to_non_nullable
as Map<PhysicalKeyId, KeyHeatmapEntry>,
  ));
}


}

// dart format on
