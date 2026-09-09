// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ngram_stat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NgramStat {

 String get text; int get occurrences; int get errorCount; double get avgDurationMs;
/// Create a copy of NgramStat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NgramStatCopyWith<NgramStat> get copyWith => _$NgramStatCopyWithImpl<NgramStat>(this as NgramStat, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as NgramStat;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NgramStat&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.occurrences, _this.occurrences) || other.occurrences == _this.occurrences)&&(identical(other.errorCount, _this.errorCount) || other.errorCount == _this.errorCount)&&(identical(other.avgDurationMs, _this.avgDurationMs) || other.avgDurationMs == _this.avgDurationMs));
}


@override
int get hashCode {
  final _this = this as NgramStat;
  return Object.hash(runtimeType,_this.text,_this.occurrences,_this.errorCount,_this.avgDurationMs);
}

@override
String toString() {
  final _this = this as NgramStat;
  return 'NgramStat(text: ${_this.text}, occurrences: ${_this.occurrences}, errorCount: ${_this.errorCount}, avgDurationMs: ${_this.avgDurationMs})';
}


}

/// @nodoc
abstract mixin class $NgramStatCopyWith<$Res>  {
  factory $NgramStatCopyWith(NgramStat value, $Res Function(NgramStat) _then) = _$NgramStatCopyWithImpl;
@useResult
$Res call({
 String text, int occurrences, int errorCount, double avgDurationMs
});




}
/// @nodoc
class _$NgramStatCopyWithImpl<$Res>
    implements $NgramStatCopyWith<$Res> {
  _$NgramStatCopyWithImpl(this._self, this._then);

  final NgramStat _self;
  final $Res Function(NgramStat) _then;

/// Create a copy of NgramStat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? occurrences = null,Object? errorCount = null,Object? avgDurationMs = null,}) {
  return _then(NgramStat(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,occurrences: null == occurrences ? _self.occurrences : occurrences // ignore: cast_nullable_to_non_nullable
as int,errorCount: null == errorCount ? _self.errorCount : errorCount // ignore: cast_nullable_to_non_nullable
as int,avgDurationMs: null == avgDurationMs ? _self.avgDurationMs : avgDurationMs // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [NgramStat].
extension NgramStatPatterns on NgramStat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NgramStat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NgramStat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NgramStat value)  $default,){
final _that = this;
switch (_that) {
case _NgramStat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NgramStat value)?  $default,){
final _that = this;
switch (_that) {
case _NgramStat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  int occurrences,  int errorCount,  double avgDurationMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NgramStat() when $default != null:
return $default(_that.text,_that.occurrences,_that.errorCount,_that.avgDurationMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  int occurrences,  int errorCount,  double avgDurationMs)  $default,) {final _that = this;
switch (_that) {
case _NgramStat():
return $default(_that.text,_that.occurrences,_that.errorCount,_that.avgDurationMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  int occurrences,  int errorCount,  double avgDurationMs)?  $default,) {final _that = this;
switch (_that) {
case _NgramStat() when $default != null:
return $default(_that.text,_that.occurrences,_that.errorCount,_that.avgDurationMs);case _:
  return null;

}
}

}

/// @nodoc


class _NgramStat implements NgramStat {
  const _NgramStat({required this.text, required this.occurrences, required this.errorCount, required this.avgDurationMs});
  

@override final  String text;
@override final  int occurrences;
@override final  int errorCount;
@override final  double avgDurationMs;

/// Create a copy of NgramStat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NgramStatCopyWith<_NgramStat> get copyWith => __$NgramStatCopyWithImpl<_NgramStat>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NgramStat&&(identical(other.text, text) || other.text == text)&&(identical(other.occurrences, occurrences) || other.occurrences == occurrences)&&(identical(other.errorCount, errorCount) || other.errorCount == errorCount)&&(identical(other.avgDurationMs, avgDurationMs) || other.avgDurationMs == avgDurationMs));
}


@override
int get hashCode {
    return Object.hash(runtimeType,text,occurrences,errorCount,avgDurationMs);
}

@override
String toString() {
    return 'NgramStat(text: $text, occurrences: $occurrences, errorCount: $errorCount, avgDurationMs: $avgDurationMs)';
}


}

/// @nodoc
abstract mixin class _$NgramStatCopyWith<$Res> implements $NgramStatCopyWith<$Res> {
  factory _$NgramStatCopyWith(_NgramStat value, $Res Function(_NgramStat) _then) = __$NgramStatCopyWithImpl;
@override @useResult
$Res call({
 String text, int occurrences, int errorCount, double avgDurationMs
});




}
/// @nodoc
class __$NgramStatCopyWithImpl<$Res>
    implements _$NgramStatCopyWith<$Res> {
  __$NgramStatCopyWithImpl(this._self, this._then);

  final _NgramStat _self;
  final $Res Function(_NgramStat) _then;

/// Create a copy of NgramStat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? occurrences = null,Object? errorCount = null,Object? avgDurationMs = null,}) {
  return _then(_NgramStat(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,occurrences: null == occurrences ? _self.occurrences : occurrences // ignore: cast_nullable_to_non_nullable
as int,errorCount: null == errorCount ? _self.errorCount : errorCount // ignore: cast_nullable_to_non_nullable
as int,avgDurationMs: null == avgDurationMs ? _self.avgDurationMs : avgDurationMs // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
