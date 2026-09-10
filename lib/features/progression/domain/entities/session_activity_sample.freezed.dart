// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_activity_sample.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionActivitySample {

 SnippetId get snippetId; ContentCategory get category; Duration get duration; double get netSpeedCpm; double get accuracyPct; DateTime get occurredAtUtc;
/// Create a copy of SessionActivitySample
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionActivitySampleCopyWith<SessionActivitySample> get copyWith => _$SessionActivitySampleCopyWithImpl<SessionActivitySample>(this as SessionActivitySample, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SessionActivitySample;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionActivitySample&&(identical(other.snippetId, _this.snippetId) || other.snippetId == _this.snippetId)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.duration, _this.duration) || other.duration == _this.duration)&&(identical(other.netSpeedCpm, _this.netSpeedCpm) || other.netSpeedCpm == _this.netSpeedCpm)&&(identical(other.accuracyPct, _this.accuracyPct) || other.accuracyPct == _this.accuracyPct)&&(identical(other.occurredAtUtc, _this.occurredAtUtc) || other.occurredAtUtc == _this.occurredAtUtc));
}


@override
int get hashCode {
  final _this = this as SessionActivitySample;
  return Object.hash(runtimeType,_this.snippetId,_this.category,_this.duration,_this.netSpeedCpm,_this.accuracyPct,_this.occurredAtUtc);
}

@override
String toString() {
  final _this = this as SessionActivitySample;
  return 'SessionActivitySample(snippetId: ${_this.snippetId}, category: ${_this.category}, duration: ${_this.duration}, netSpeedCpm: ${_this.netSpeedCpm}, accuracyPct: ${_this.accuracyPct}, occurredAtUtc: ${_this.occurredAtUtc})';
}


}

/// @nodoc
abstract mixin class $SessionActivitySampleCopyWith<$Res>  {
  factory $SessionActivitySampleCopyWith(SessionActivitySample value, $Res Function(SessionActivitySample) _then) = _$SessionActivitySampleCopyWithImpl;
@useResult
$Res call({
 SnippetId snippetId, ContentCategory category, Duration duration, double netSpeedCpm, double accuracyPct, DateTime occurredAtUtc
});


$SnippetIdCopyWith<$Res> get snippetId;

}
/// @nodoc
class _$SessionActivitySampleCopyWithImpl<$Res>
    implements $SessionActivitySampleCopyWith<$Res> {
  _$SessionActivitySampleCopyWithImpl(this._self, this._then);

  final SessionActivitySample _self;
  final $Res Function(SessionActivitySample) _then;

/// Create a copy of SessionActivitySample
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? snippetId = null,Object? category = null,Object? duration = null,Object? netSpeedCpm = null,Object? accuracyPct = null,Object? occurredAtUtc = null,}) {
  return _then(SessionActivitySample(
snippetId: null == snippetId ? _self.snippetId : snippetId // ignore: cast_nullable_to_non_nullable
as SnippetId,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ContentCategory,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,netSpeedCpm: null == netSpeedCpm ? _self.netSpeedCpm : netSpeedCpm // ignore: cast_nullable_to_non_nullable
as double,accuracyPct: null == accuracyPct ? _self.accuracyPct : accuracyPct // ignore: cast_nullable_to_non_nullable
as double,occurredAtUtc: null == occurredAtUtc ? _self.occurredAtUtc : occurredAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of SessionActivitySample
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SnippetIdCopyWith<$Res> get snippetId {
  
  return $SnippetIdCopyWith<$Res>(_self.snippetId, (value) {
    return _then(_self.copyWith(snippetId: value));
  });
}
}


/// Adds pattern-matching-related methods to [SessionActivitySample].
extension SessionActivitySamplePatterns on SessionActivitySample {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionActivitySample value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionActivitySample() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionActivitySample value)  $default,){
final _that = this;
switch (_that) {
case _SessionActivitySample():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionActivitySample value)?  $default,){
final _that = this;
switch (_that) {
case _SessionActivitySample() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SnippetId snippetId,  ContentCategory category,  Duration duration,  double netSpeedCpm,  double accuracyPct,  DateTime occurredAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionActivitySample() when $default != null:
return $default(_that.snippetId,_that.category,_that.duration,_that.netSpeedCpm,_that.accuracyPct,_that.occurredAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SnippetId snippetId,  ContentCategory category,  Duration duration,  double netSpeedCpm,  double accuracyPct,  DateTime occurredAtUtc)  $default,) {final _that = this;
switch (_that) {
case _SessionActivitySample():
return $default(_that.snippetId,_that.category,_that.duration,_that.netSpeedCpm,_that.accuracyPct,_that.occurredAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SnippetId snippetId,  ContentCategory category,  Duration duration,  double netSpeedCpm,  double accuracyPct,  DateTime occurredAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _SessionActivitySample() when $default != null:
return $default(_that.snippetId,_that.category,_that.duration,_that.netSpeedCpm,_that.accuracyPct,_that.occurredAtUtc);case _:
  return null;

}
}

}

/// @nodoc


class _SessionActivitySample implements SessionActivitySample {
  const _SessionActivitySample({required this.snippetId, required this.category, required this.duration, required this.netSpeedCpm, required this.accuracyPct, required this.occurredAtUtc});
  

@override final  SnippetId snippetId;
@override final  ContentCategory category;
@override final  Duration duration;
@override final  double netSpeedCpm;
@override final  double accuracyPct;
@override final  DateTime occurredAtUtc;

/// Create a copy of SessionActivitySample
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionActivitySampleCopyWith<_SessionActivitySample> get copyWith => __$SessionActivitySampleCopyWithImpl<_SessionActivitySample>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionActivitySample&&(identical(other.snippetId, snippetId) || other.snippetId == snippetId)&&(identical(other.category, category) || other.category == category)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.netSpeedCpm, netSpeedCpm) || other.netSpeedCpm == netSpeedCpm)&&(identical(other.accuracyPct, accuracyPct) || other.accuracyPct == accuracyPct)&&(identical(other.occurredAtUtc, occurredAtUtc) || other.occurredAtUtc == occurredAtUtc));
}


@override
int get hashCode {
    return Object.hash(runtimeType,snippetId,category,duration,netSpeedCpm,accuracyPct,occurredAtUtc);
}

@override
String toString() {
    return 'SessionActivitySample(snippetId: $snippetId, category: $category, duration: $duration, netSpeedCpm: $netSpeedCpm, accuracyPct: $accuracyPct, occurredAtUtc: $occurredAtUtc)';
}


}

/// @nodoc
abstract mixin class _$SessionActivitySampleCopyWith<$Res> implements $SessionActivitySampleCopyWith<$Res> {
  factory _$SessionActivitySampleCopyWith(_SessionActivitySample value, $Res Function(_SessionActivitySample) _then) = __$SessionActivitySampleCopyWithImpl;
@override @useResult
$Res call({
 SnippetId snippetId, ContentCategory category, Duration duration, double netSpeedCpm, double accuracyPct, DateTime occurredAtUtc
});


@override $SnippetIdCopyWith<$Res> get snippetId;

}
/// @nodoc
class __$SessionActivitySampleCopyWithImpl<$Res>
    implements _$SessionActivitySampleCopyWith<$Res> {
  __$SessionActivitySampleCopyWithImpl(this._self, this._then);

  final _SessionActivitySample _self;
  final $Res Function(_SessionActivitySample) _then;

/// Create a copy of SessionActivitySample
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? snippetId = null,Object? category = null,Object? duration = null,Object? netSpeedCpm = null,Object? accuracyPct = null,Object? occurredAtUtc = null,}) {
  return _then(_SessionActivitySample(
snippetId: null == snippetId ? _self.snippetId : snippetId // ignore: cast_nullable_to_non_nullable
as SnippetId,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ContentCategory,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,netSpeedCpm: null == netSpeedCpm ? _self.netSpeedCpm : netSpeedCpm // ignore: cast_nullable_to_non_nullable
as double,accuracyPct: null == accuracyPct ? _self.accuracyPct : accuracyPct // ignore: cast_nullable_to_non_nullable
as double,occurredAtUtc: null == occurredAtUtc ? _self.occurredAtUtc : occurredAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of SessionActivitySample
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
