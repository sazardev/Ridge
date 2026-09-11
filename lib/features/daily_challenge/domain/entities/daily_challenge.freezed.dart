// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_challenge.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DailyChallenge {

 ChallengeDate get date; SnippetId get snippetId; int get snippetRevision;
/// Create a copy of DailyChallenge
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyChallengeCopyWith<DailyChallenge> get copyWith => _$DailyChallengeCopyWithImpl<DailyChallenge>(this as DailyChallenge, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DailyChallenge;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyChallenge&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.snippetId, _this.snippetId) || other.snippetId == _this.snippetId)&&(identical(other.snippetRevision, _this.snippetRevision) || other.snippetRevision == _this.snippetRevision));
}


@override
int get hashCode {
  final _this = this as DailyChallenge;
  return Object.hash(runtimeType,_this.date,_this.snippetId,_this.snippetRevision);
}

@override
String toString() {
  final _this = this as DailyChallenge;
  return 'DailyChallenge(date: ${_this.date}, snippetId: ${_this.snippetId}, snippetRevision: ${_this.snippetRevision})';
}


}

/// @nodoc
abstract mixin class $DailyChallengeCopyWith<$Res>  {
  factory $DailyChallengeCopyWith(DailyChallenge value, $Res Function(DailyChallenge) _then) = _$DailyChallengeCopyWithImpl;
@useResult
$Res call({
 ChallengeDate date, SnippetId snippetId, int snippetRevision
});


$ChallengeDateCopyWith<$Res> get date;$SnippetIdCopyWith<$Res> get snippetId;

}
/// @nodoc
class _$DailyChallengeCopyWithImpl<$Res>
    implements $DailyChallengeCopyWith<$Res> {
  _$DailyChallengeCopyWithImpl(this._self, this._then);

  final DailyChallenge _self;
  final $Res Function(DailyChallenge) _then;

/// Create a copy of DailyChallenge
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? snippetId = null,Object? snippetRevision = null,}) {
  return _then(DailyChallenge(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as ChallengeDate,snippetId: null == snippetId ? _self.snippetId : snippetId // ignore: cast_nullable_to_non_nullable
as SnippetId,snippetRevision: null == snippetRevision ? _self.snippetRevision : snippetRevision // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of DailyChallenge
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChallengeDateCopyWith<$Res> get date {
  
  return $ChallengeDateCopyWith<$Res>(_self.date, (value) {
    return _then(_self.copyWith(date: value));
  });
}/// Create a copy of DailyChallenge
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SnippetIdCopyWith<$Res> get snippetId {
  
  return $SnippetIdCopyWith<$Res>(_self.snippetId, (value) {
    return _then(_self.copyWith(snippetId: value));
  });
}
}


/// Adds pattern-matching-related methods to [DailyChallenge].
extension DailyChallengePatterns on DailyChallenge {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyChallenge value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyChallenge() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyChallenge value)  $default,){
final _that = this;
switch (_that) {
case _DailyChallenge():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyChallenge value)?  $default,){
final _that = this;
switch (_that) {
case _DailyChallenge() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ChallengeDate date,  SnippetId snippetId,  int snippetRevision)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyChallenge() when $default != null:
return $default(_that.date,_that.snippetId,_that.snippetRevision);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ChallengeDate date,  SnippetId snippetId,  int snippetRevision)  $default,) {final _that = this;
switch (_that) {
case _DailyChallenge():
return $default(_that.date,_that.snippetId,_that.snippetRevision);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ChallengeDate date,  SnippetId snippetId,  int snippetRevision)?  $default,) {final _that = this;
switch (_that) {
case _DailyChallenge() when $default != null:
return $default(_that.date,_that.snippetId,_that.snippetRevision);case _:
  return null;

}
}

}

/// @nodoc


class _DailyChallenge implements DailyChallenge {
  const _DailyChallenge({required this.date, required this.snippetId, required this.snippetRevision});
  

@override final  ChallengeDate date;
@override final  SnippetId snippetId;
@override final  int snippetRevision;

/// Create a copy of DailyChallenge
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyChallengeCopyWith<_DailyChallenge> get copyWith => __$DailyChallengeCopyWithImpl<_DailyChallenge>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyChallenge&&(identical(other.date, date) || other.date == date)&&(identical(other.snippetId, snippetId) || other.snippetId == snippetId)&&(identical(other.snippetRevision, snippetRevision) || other.snippetRevision == snippetRevision));
}


@override
int get hashCode {
    return Object.hash(runtimeType,date,snippetId,snippetRevision);
}

@override
String toString() {
    return 'DailyChallenge(date: $date, snippetId: $snippetId, snippetRevision: $snippetRevision)';
}


}

/// @nodoc
abstract mixin class _$DailyChallengeCopyWith<$Res> implements $DailyChallengeCopyWith<$Res> {
  factory _$DailyChallengeCopyWith(_DailyChallenge value, $Res Function(_DailyChallenge) _then) = __$DailyChallengeCopyWithImpl;
@override @useResult
$Res call({
 ChallengeDate date, SnippetId snippetId, int snippetRevision
});


@override $ChallengeDateCopyWith<$Res> get date;@override $SnippetIdCopyWith<$Res> get snippetId;

}
/// @nodoc
class __$DailyChallengeCopyWithImpl<$Res>
    implements _$DailyChallengeCopyWith<$Res> {
  __$DailyChallengeCopyWithImpl(this._self, this._then);

  final _DailyChallenge _self;
  final $Res Function(_DailyChallenge) _then;

/// Create a copy of DailyChallenge
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? snippetId = null,Object? snippetRevision = null,}) {
  return _then(_DailyChallenge(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as ChallengeDate,snippetId: null == snippetId ? _self.snippetId : snippetId // ignore: cast_nullable_to_non_nullable
as SnippetId,snippetRevision: null == snippetRevision ? _self.snippetRevision : snippetRevision // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of DailyChallenge
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChallengeDateCopyWith<$Res> get date {
  
  return $ChallengeDateCopyWith<$Res>(_self.date, (value) {
    return _then(_self.copyWith(date: value));
  });
}/// Create a copy of DailyChallenge
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
