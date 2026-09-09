// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unprocessed_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UnprocessedSession {

 TypingSessionId get id; ProfileId get profileId; SnippetId get snippetId; ContentCategory get category; Difficulty get difficulty; String get mode; double get accuracyPct; int get correctFirstTryChars; DateTime get startedAtUtc;
/// Create a copy of UnprocessedSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnprocessedSessionCopyWith<UnprocessedSession> get copyWith => _$UnprocessedSessionCopyWithImpl<UnprocessedSession>(this as UnprocessedSession, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as UnprocessedSession;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnprocessedSession&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.profileId, _this.profileId) || other.profileId == _this.profileId)&&(identical(other.snippetId, _this.snippetId) || other.snippetId == _this.snippetId)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.difficulty, _this.difficulty) || other.difficulty == _this.difficulty)&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.accuracyPct, _this.accuracyPct) || other.accuracyPct == _this.accuracyPct)&&(identical(other.correctFirstTryChars, _this.correctFirstTryChars) || other.correctFirstTryChars == _this.correctFirstTryChars)&&(identical(other.startedAtUtc, _this.startedAtUtc) || other.startedAtUtc == _this.startedAtUtc));
}


@override
int get hashCode {
  final _this = this as UnprocessedSession;
  return Object.hash(runtimeType,_this.id,_this.profileId,_this.snippetId,_this.category,_this.difficulty,_this.mode,_this.accuracyPct,_this.correctFirstTryChars,_this.startedAtUtc);
}

@override
String toString() {
  final _this = this as UnprocessedSession;
  return 'UnprocessedSession(id: ${_this.id}, profileId: ${_this.profileId}, snippetId: ${_this.snippetId}, category: ${_this.category}, difficulty: ${_this.difficulty}, mode: ${_this.mode}, accuracyPct: ${_this.accuracyPct}, correctFirstTryChars: ${_this.correctFirstTryChars}, startedAtUtc: ${_this.startedAtUtc})';
}


}

/// @nodoc
abstract mixin class $UnprocessedSessionCopyWith<$Res>  {
  factory $UnprocessedSessionCopyWith(UnprocessedSession value, $Res Function(UnprocessedSession) _then) = _$UnprocessedSessionCopyWithImpl;
@useResult
$Res call({
 TypingSessionId id, ProfileId profileId, SnippetId snippetId, ContentCategory category, Difficulty difficulty, String mode, double accuracyPct, int correctFirstTryChars, DateTime startedAtUtc
});


$TypingSessionIdCopyWith<$Res> get id;$ProfileIdCopyWith<$Res> get profileId;$SnippetIdCopyWith<$Res> get snippetId;

}
/// @nodoc
class _$UnprocessedSessionCopyWithImpl<$Res>
    implements $UnprocessedSessionCopyWith<$Res> {
  _$UnprocessedSessionCopyWithImpl(this._self, this._then);

  final UnprocessedSession _self;
  final $Res Function(UnprocessedSession) _then;

/// Create a copy of UnprocessedSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? profileId = null,Object? snippetId = null,Object? category = null,Object? difficulty = null,Object? mode = null,Object? accuracyPct = null,Object? correctFirstTryChars = null,Object? startedAtUtc = null,}) {
  return _then(UnprocessedSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as TypingSessionId,profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as ProfileId,snippetId: null == snippetId ? _self.snippetId : snippetId // ignore: cast_nullable_to_non_nullable
as SnippetId,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ContentCategory,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as Difficulty,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,accuracyPct: null == accuracyPct ? _self.accuracyPct : accuracyPct // ignore: cast_nullable_to_non_nullable
as double,correctFirstTryChars: null == correctFirstTryChars ? _self.correctFirstTryChars : correctFirstTryChars // ignore: cast_nullable_to_non_nullable
as int,startedAtUtc: null == startedAtUtc ? _self.startedAtUtc : startedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of UnprocessedSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TypingSessionIdCopyWith<$Res> get id {
  
  return $TypingSessionIdCopyWith<$Res>(_self.id, (value) {
    return _then(_self.copyWith(id: value));
  });
}/// Create a copy of UnprocessedSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileIdCopyWith<$Res> get profileId {
  
  return $ProfileIdCopyWith<$Res>(_self.profileId, (value) {
    return _then(_self.copyWith(profileId: value));
  });
}/// Create a copy of UnprocessedSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SnippetIdCopyWith<$Res> get snippetId {
  
  return $SnippetIdCopyWith<$Res>(_self.snippetId, (value) {
    return _then(_self.copyWith(snippetId: value));
  });
}
}


/// Adds pattern-matching-related methods to [UnprocessedSession].
extension UnprocessedSessionPatterns on UnprocessedSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UnprocessedSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnprocessedSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UnprocessedSession value)  $default,){
final _that = this;
switch (_that) {
case _UnprocessedSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UnprocessedSession value)?  $default,){
final _that = this;
switch (_that) {
case _UnprocessedSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TypingSessionId id,  ProfileId profileId,  SnippetId snippetId,  ContentCategory category,  Difficulty difficulty,  String mode,  double accuracyPct,  int correctFirstTryChars,  DateTime startedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnprocessedSession() when $default != null:
return $default(_that.id,_that.profileId,_that.snippetId,_that.category,_that.difficulty,_that.mode,_that.accuracyPct,_that.correctFirstTryChars,_that.startedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TypingSessionId id,  ProfileId profileId,  SnippetId snippetId,  ContentCategory category,  Difficulty difficulty,  String mode,  double accuracyPct,  int correctFirstTryChars,  DateTime startedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _UnprocessedSession():
return $default(_that.id,_that.profileId,_that.snippetId,_that.category,_that.difficulty,_that.mode,_that.accuracyPct,_that.correctFirstTryChars,_that.startedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TypingSessionId id,  ProfileId profileId,  SnippetId snippetId,  ContentCategory category,  Difficulty difficulty,  String mode,  double accuracyPct,  int correctFirstTryChars,  DateTime startedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _UnprocessedSession() when $default != null:
return $default(_that.id,_that.profileId,_that.snippetId,_that.category,_that.difficulty,_that.mode,_that.accuracyPct,_that.correctFirstTryChars,_that.startedAtUtc);case _:
  return null;

}
}

}

/// @nodoc


class _UnprocessedSession implements UnprocessedSession {
  const _UnprocessedSession({required this.id, required this.profileId, required this.snippetId, required this.category, required this.difficulty, required this.mode, required this.accuracyPct, required this.correctFirstTryChars, required this.startedAtUtc});
  

@override final  TypingSessionId id;
@override final  ProfileId profileId;
@override final  SnippetId snippetId;
@override final  ContentCategory category;
@override final  Difficulty difficulty;
@override final  String mode;
@override final  double accuracyPct;
@override final  int correctFirstTryChars;
@override final  DateTime startedAtUtc;

/// Create a copy of UnprocessedSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnprocessedSessionCopyWith<_UnprocessedSession> get copyWith => __$UnprocessedSessionCopyWithImpl<_UnprocessedSession>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnprocessedSession&&(identical(other.id, id) || other.id == id)&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.snippetId, snippetId) || other.snippetId == snippetId)&&(identical(other.category, category) || other.category == category)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.accuracyPct, accuracyPct) || other.accuracyPct == accuracyPct)&&(identical(other.correctFirstTryChars, correctFirstTryChars) || other.correctFirstTryChars == correctFirstTryChars)&&(identical(other.startedAtUtc, startedAtUtc) || other.startedAtUtc == startedAtUtc));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,profileId,snippetId,category,difficulty,mode,accuracyPct,correctFirstTryChars,startedAtUtc);
}

@override
String toString() {
    return 'UnprocessedSession(id: $id, profileId: $profileId, snippetId: $snippetId, category: $category, difficulty: $difficulty, mode: $mode, accuracyPct: $accuracyPct, correctFirstTryChars: $correctFirstTryChars, startedAtUtc: $startedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$UnprocessedSessionCopyWith<$Res> implements $UnprocessedSessionCopyWith<$Res> {
  factory _$UnprocessedSessionCopyWith(_UnprocessedSession value, $Res Function(_UnprocessedSession) _then) = __$UnprocessedSessionCopyWithImpl;
@override @useResult
$Res call({
 TypingSessionId id, ProfileId profileId, SnippetId snippetId, ContentCategory category, Difficulty difficulty, String mode, double accuracyPct, int correctFirstTryChars, DateTime startedAtUtc
});


@override $TypingSessionIdCopyWith<$Res> get id;@override $ProfileIdCopyWith<$Res> get profileId;@override $SnippetIdCopyWith<$Res> get snippetId;

}
/// @nodoc
class __$UnprocessedSessionCopyWithImpl<$Res>
    implements _$UnprocessedSessionCopyWith<$Res> {
  __$UnprocessedSessionCopyWithImpl(this._self, this._then);

  final _UnprocessedSession _self;
  final $Res Function(_UnprocessedSession) _then;

/// Create a copy of UnprocessedSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? profileId = null,Object? snippetId = null,Object? category = null,Object? difficulty = null,Object? mode = null,Object? accuracyPct = null,Object? correctFirstTryChars = null,Object? startedAtUtc = null,}) {
  return _then(_UnprocessedSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as TypingSessionId,profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as ProfileId,snippetId: null == snippetId ? _self.snippetId : snippetId // ignore: cast_nullable_to_non_nullable
as SnippetId,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ContentCategory,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as Difficulty,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,accuracyPct: null == accuracyPct ? _self.accuracyPct : accuracyPct // ignore: cast_nullable_to_non_nullable
as double,correctFirstTryChars: null == correctFirstTryChars ? _self.correctFirstTryChars : correctFirstTryChars // ignore: cast_nullable_to_non_nullable
as int,startedAtUtc: null == startedAtUtc ? _self.startedAtUtc : startedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of UnprocessedSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TypingSessionIdCopyWith<$Res> get id {
  
  return $TypingSessionIdCopyWith<$Res>(_self.id, (value) {
    return _then(_self.copyWith(id: value));
  });
}/// Create a copy of UnprocessedSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileIdCopyWith<$Res> get profileId {
  
  return $ProfileIdCopyWith<$Res>(_self.profileId, (value) {
    return _then(_self.copyWith(profileId: value));
  });
}/// Create a copy of UnprocessedSession
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
