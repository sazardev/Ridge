// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'progress_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProgressSnapshot {

 ProfileId get profileId; XpSummary get xpSummary; int get currentStreakDays; WeaknessReport get weaknessReport; List<MasteryStatus> get masteryStatuses; DateTime get computedAt;
/// Create a copy of ProgressSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgressSnapshotCopyWith<ProgressSnapshot> get copyWith => _$ProgressSnapshotCopyWithImpl<ProgressSnapshot>(this as ProgressSnapshot, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProgressSnapshot;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgressSnapshot&&(identical(other.profileId, _this.profileId) || other.profileId == _this.profileId)&&(identical(other.xpSummary, _this.xpSummary) || other.xpSummary == _this.xpSummary)&&(identical(other.currentStreakDays, _this.currentStreakDays) || other.currentStreakDays == _this.currentStreakDays)&&(identical(other.weaknessReport, _this.weaknessReport) || other.weaknessReport == _this.weaknessReport)&&const DeepCollectionEquality().equals(other.masteryStatuses, _this.masteryStatuses)&&(identical(other.computedAt, _this.computedAt) || other.computedAt == _this.computedAt));
}


@override
int get hashCode {
  final _this = this as ProgressSnapshot;
  return Object.hash(runtimeType,_this.profileId,_this.xpSummary,_this.currentStreakDays,_this.weaknessReport,const DeepCollectionEquality().hash(_this.masteryStatuses),_this.computedAt);
}

@override
String toString() {
  final _this = this as ProgressSnapshot;
  return 'ProgressSnapshot(profileId: ${_this.profileId}, xpSummary: ${_this.xpSummary}, currentStreakDays: ${_this.currentStreakDays}, weaknessReport: ${_this.weaknessReport}, masteryStatuses: ${_this.masteryStatuses}, computedAt: ${_this.computedAt})';
}


}

/// @nodoc
abstract mixin class $ProgressSnapshotCopyWith<$Res>  {
  factory $ProgressSnapshotCopyWith(ProgressSnapshot value, $Res Function(ProgressSnapshot) _then) = _$ProgressSnapshotCopyWithImpl;
@useResult
$Res call({
 ProfileId profileId, XpSummary xpSummary, int currentStreakDays, WeaknessReport weaknessReport, List<MasteryStatus> masteryStatuses, DateTime computedAt
});


$ProfileIdCopyWith<$Res> get profileId;$XpSummaryCopyWith<$Res> get xpSummary;$WeaknessReportCopyWith<$Res> get weaknessReport;

}
/// @nodoc
class _$ProgressSnapshotCopyWithImpl<$Res>
    implements $ProgressSnapshotCopyWith<$Res> {
  _$ProgressSnapshotCopyWithImpl(this._self, this._then);

  final ProgressSnapshot _self;
  final $Res Function(ProgressSnapshot) _then;

/// Create a copy of ProgressSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profileId = null,Object? xpSummary = null,Object? currentStreakDays = null,Object? weaknessReport = null,Object? masteryStatuses = null,Object? computedAt = null,}) {
  return _then(ProgressSnapshot(
profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as ProfileId,xpSummary: null == xpSummary ? _self.xpSummary : xpSummary // ignore: cast_nullable_to_non_nullable
as XpSummary,currentStreakDays: null == currentStreakDays ? _self.currentStreakDays : currentStreakDays // ignore: cast_nullable_to_non_nullable
as int,weaknessReport: null == weaknessReport ? _self.weaknessReport : weaknessReport // ignore: cast_nullable_to_non_nullable
as WeaknessReport,masteryStatuses: null == masteryStatuses ? _self.masteryStatuses : masteryStatuses // ignore: cast_nullable_to_non_nullable
as List<MasteryStatus>,computedAt: null == computedAt ? _self.computedAt : computedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of ProgressSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileIdCopyWith<$Res> get profileId {
  
  return $ProfileIdCopyWith<$Res>(_self.profileId, (value) {
    return _then(_self.copyWith(profileId: value));
  });
}/// Create a copy of ProgressSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$XpSummaryCopyWith<$Res> get xpSummary {
  
  return $XpSummaryCopyWith<$Res>(_self.xpSummary, (value) {
    return _then(_self.copyWith(xpSummary: value));
  });
}/// Create a copy of ProgressSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeaknessReportCopyWith<$Res> get weaknessReport {
  
  return $WeaknessReportCopyWith<$Res>(_self.weaknessReport, (value) {
    return _then(_self.copyWith(weaknessReport: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProgressSnapshot].
extension ProgressSnapshotPatterns on ProgressSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgressSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgressSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgressSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _ProgressSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgressSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _ProgressSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProfileId profileId,  XpSummary xpSummary,  int currentStreakDays,  WeaknessReport weaknessReport,  List<MasteryStatus> masteryStatuses,  DateTime computedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgressSnapshot() when $default != null:
return $default(_that.profileId,_that.xpSummary,_that.currentStreakDays,_that.weaknessReport,_that.masteryStatuses,_that.computedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProfileId profileId,  XpSummary xpSummary,  int currentStreakDays,  WeaknessReport weaknessReport,  List<MasteryStatus> masteryStatuses,  DateTime computedAt)  $default,) {final _that = this;
switch (_that) {
case _ProgressSnapshot():
return $default(_that.profileId,_that.xpSummary,_that.currentStreakDays,_that.weaknessReport,_that.masteryStatuses,_that.computedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProfileId profileId,  XpSummary xpSummary,  int currentStreakDays,  WeaknessReport weaknessReport,  List<MasteryStatus> masteryStatuses,  DateTime computedAt)?  $default,) {final _that = this;
switch (_that) {
case _ProgressSnapshot() when $default != null:
return $default(_that.profileId,_that.xpSummary,_that.currentStreakDays,_that.weaknessReport,_that.masteryStatuses,_that.computedAt);case _:
  return null;

}
}

}

/// @nodoc


class _ProgressSnapshot implements ProgressSnapshot {
  const _ProgressSnapshot({required this.profileId, required this.xpSummary, required this.currentStreakDays, required this.weaknessReport, required  List<MasteryStatus> masteryStatuses, required this.computedAt}): _masteryStatuses = masteryStatuses;
  

@override final  ProfileId profileId;
@override final  XpSummary xpSummary;
@override final  int currentStreakDays;
@override final  WeaknessReport weaknessReport;
 final  List<MasteryStatus> _masteryStatuses;
@override List<MasteryStatus> get masteryStatuses {
  if (_masteryStatuses is EqualUnmodifiableListView) return _masteryStatuses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_masteryStatuses);
}

@override final  DateTime computedAt;

/// Create a copy of ProgressSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgressSnapshotCopyWith<_ProgressSnapshot> get copyWith => __$ProgressSnapshotCopyWithImpl<_ProgressSnapshot>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgressSnapshot&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.xpSummary, xpSummary) || other.xpSummary == xpSummary)&&(identical(other.currentStreakDays, currentStreakDays) || other.currentStreakDays == currentStreakDays)&&(identical(other.weaknessReport, weaknessReport) || other.weaknessReport == weaknessReport)&&const DeepCollectionEquality().equals(other.masteryStatuses, _masteryStatuses)&&(identical(other.computedAt, computedAt) || other.computedAt == computedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,profileId,xpSummary,currentStreakDays,weaknessReport,const DeepCollectionEquality().hash(_masteryStatuses),computedAt);
}

@override
String toString() {
    return 'ProgressSnapshot(profileId: $profileId, xpSummary: $xpSummary, currentStreakDays: $currentStreakDays, weaknessReport: $weaknessReport, masteryStatuses: $masteryStatuses, computedAt: $computedAt)';
}


}

/// @nodoc
abstract mixin class _$ProgressSnapshotCopyWith<$Res> implements $ProgressSnapshotCopyWith<$Res> {
  factory _$ProgressSnapshotCopyWith(_ProgressSnapshot value, $Res Function(_ProgressSnapshot) _then) = __$ProgressSnapshotCopyWithImpl;
@override @useResult
$Res call({
 ProfileId profileId, XpSummary xpSummary, int currentStreakDays, WeaknessReport weaknessReport, List<MasteryStatus> masteryStatuses, DateTime computedAt
});


@override $ProfileIdCopyWith<$Res> get profileId;@override $XpSummaryCopyWith<$Res> get xpSummary;@override $WeaknessReportCopyWith<$Res> get weaknessReport;

}
/// @nodoc
class __$ProgressSnapshotCopyWithImpl<$Res>
    implements _$ProgressSnapshotCopyWith<$Res> {
  __$ProgressSnapshotCopyWithImpl(this._self, this._then);

  final _ProgressSnapshot _self;
  final $Res Function(_ProgressSnapshot) _then;

/// Create a copy of ProgressSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profileId = null,Object? xpSummary = null,Object? currentStreakDays = null,Object? weaknessReport = null,Object? masteryStatuses = null,Object? computedAt = null,}) {
  return _then(_ProgressSnapshot(
profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as ProfileId,xpSummary: null == xpSummary ? _self.xpSummary : xpSummary // ignore: cast_nullable_to_non_nullable
as XpSummary,currentStreakDays: null == currentStreakDays ? _self.currentStreakDays : currentStreakDays // ignore: cast_nullable_to_non_nullable
as int,weaknessReport: null == weaknessReport ? _self.weaknessReport : weaknessReport // ignore: cast_nullable_to_non_nullable
as WeaknessReport,masteryStatuses: null == masteryStatuses ? _self._masteryStatuses : masteryStatuses // ignore: cast_nullable_to_non_nullable
as List<MasteryStatus>,computedAt: null == computedAt ? _self.computedAt : computedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of ProgressSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileIdCopyWith<$Res> get profileId {
  
  return $ProfileIdCopyWith<$Res>(_self.profileId, (value) {
    return _then(_self.copyWith(profileId: value));
  });
}/// Create a copy of ProgressSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$XpSummaryCopyWith<$Res> get xpSummary {
  
  return $XpSummaryCopyWith<$Res>(_self.xpSummary, (value) {
    return _then(_self.copyWith(xpSummary: value));
  });
}/// Create a copy of ProgressSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeaknessReportCopyWith<$Res> get weaknessReport {
  
  return $WeaknessReportCopyWith<$Res>(_self.weaknessReport, (value) {
    return _then(_self.copyWith(weaknessReport: value));
  });
}
}

// dart format on
