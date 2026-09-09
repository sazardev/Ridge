// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_achievement_input.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionAchievementInput {

 TypingSessionId get sessionId; double get accuracyPct; double get handBalanceRatio; int get correctionsCount; int get forwardKeystrokeCount;
/// Create a copy of SessionAchievementInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionAchievementInputCopyWith<SessionAchievementInput> get copyWith => _$SessionAchievementInputCopyWithImpl<SessionAchievementInput>(this as SessionAchievementInput, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SessionAchievementInput;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionAchievementInput&&(identical(other.sessionId, _this.sessionId) || other.sessionId == _this.sessionId)&&(identical(other.accuracyPct, _this.accuracyPct) || other.accuracyPct == _this.accuracyPct)&&(identical(other.handBalanceRatio, _this.handBalanceRatio) || other.handBalanceRatio == _this.handBalanceRatio)&&(identical(other.correctionsCount, _this.correctionsCount) || other.correctionsCount == _this.correctionsCount)&&(identical(other.forwardKeystrokeCount, _this.forwardKeystrokeCount) || other.forwardKeystrokeCount == _this.forwardKeystrokeCount));
}


@override
int get hashCode {
  final _this = this as SessionAchievementInput;
  return Object.hash(runtimeType,_this.sessionId,_this.accuracyPct,_this.handBalanceRatio,_this.correctionsCount,_this.forwardKeystrokeCount);
}

@override
String toString() {
  final _this = this as SessionAchievementInput;
  return 'SessionAchievementInput(sessionId: ${_this.sessionId}, accuracyPct: ${_this.accuracyPct}, handBalanceRatio: ${_this.handBalanceRatio}, correctionsCount: ${_this.correctionsCount}, forwardKeystrokeCount: ${_this.forwardKeystrokeCount})';
}


}

/// @nodoc
abstract mixin class $SessionAchievementInputCopyWith<$Res>  {
  factory $SessionAchievementInputCopyWith(SessionAchievementInput value, $Res Function(SessionAchievementInput) _then) = _$SessionAchievementInputCopyWithImpl;
@useResult
$Res call({
 TypingSessionId sessionId, double accuracyPct, double handBalanceRatio, int correctionsCount, int forwardKeystrokeCount
});


$TypingSessionIdCopyWith<$Res> get sessionId;

}
/// @nodoc
class _$SessionAchievementInputCopyWithImpl<$Res>
    implements $SessionAchievementInputCopyWith<$Res> {
  _$SessionAchievementInputCopyWithImpl(this._self, this._then);

  final SessionAchievementInput _self;
  final $Res Function(SessionAchievementInput) _then;

/// Create a copy of SessionAchievementInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? accuracyPct = null,Object? handBalanceRatio = null,Object? correctionsCount = null,Object? forwardKeystrokeCount = null,}) {
  return _then(SessionAchievementInput(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as TypingSessionId,accuracyPct: null == accuracyPct ? _self.accuracyPct : accuracyPct // ignore: cast_nullable_to_non_nullable
as double,handBalanceRatio: null == handBalanceRatio ? _self.handBalanceRatio : handBalanceRatio // ignore: cast_nullable_to_non_nullable
as double,correctionsCount: null == correctionsCount ? _self.correctionsCount : correctionsCount // ignore: cast_nullable_to_non_nullable
as int,forwardKeystrokeCount: null == forwardKeystrokeCount ? _self.forwardKeystrokeCount : forwardKeystrokeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of SessionAchievementInput
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TypingSessionIdCopyWith<$Res> get sessionId {
  
  return $TypingSessionIdCopyWith<$Res>(_self.sessionId, (value) {
    return _then(_self.copyWith(sessionId: value));
  });
}
}


/// Adds pattern-matching-related methods to [SessionAchievementInput].
extension SessionAchievementInputPatterns on SessionAchievementInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionAchievementInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionAchievementInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionAchievementInput value)  $default,){
final _that = this;
switch (_that) {
case _SessionAchievementInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionAchievementInput value)?  $default,){
final _that = this;
switch (_that) {
case _SessionAchievementInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TypingSessionId sessionId,  double accuracyPct,  double handBalanceRatio,  int correctionsCount,  int forwardKeystrokeCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionAchievementInput() when $default != null:
return $default(_that.sessionId,_that.accuracyPct,_that.handBalanceRatio,_that.correctionsCount,_that.forwardKeystrokeCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TypingSessionId sessionId,  double accuracyPct,  double handBalanceRatio,  int correctionsCount,  int forwardKeystrokeCount)  $default,) {final _that = this;
switch (_that) {
case _SessionAchievementInput():
return $default(_that.sessionId,_that.accuracyPct,_that.handBalanceRatio,_that.correctionsCount,_that.forwardKeystrokeCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TypingSessionId sessionId,  double accuracyPct,  double handBalanceRatio,  int correctionsCount,  int forwardKeystrokeCount)?  $default,) {final _that = this;
switch (_that) {
case _SessionAchievementInput() when $default != null:
return $default(_that.sessionId,_that.accuracyPct,_that.handBalanceRatio,_that.correctionsCount,_that.forwardKeystrokeCount);case _:
  return null;

}
}

}

/// @nodoc


class _SessionAchievementInput implements SessionAchievementInput {
  const _SessionAchievementInput({required this.sessionId, required this.accuracyPct, required this.handBalanceRatio, required this.correctionsCount, required this.forwardKeystrokeCount});
  

@override final  TypingSessionId sessionId;
@override final  double accuracyPct;
@override final  double handBalanceRatio;
@override final  int correctionsCount;
@override final  int forwardKeystrokeCount;

/// Create a copy of SessionAchievementInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionAchievementInputCopyWith<_SessionAchievementInput> get copyWith => __$SessionAchievementInputCopyWithImpl<_SessionAchievementInput>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionAchievementInput&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.accuracyPct, accuracyPct) || other.accuracyPct == accuracyPct)&&(identical(other.handBalanceRatio, handBalanceRatio) || other.handBalanceRatio == handBalanceRatio)&&(identical(other.correctionsCount, correctionsCount) || other.correctionsCount == correctionsCount)&&(identical(other.forwardKeystrokeCount, forwardKeystrokeCount) || other.forwardKeystrokeCount == forwardKeystrokeCount));
}


@override
int get hashCode {
    return Object.hash(runtimeType,sessionId,accuracyPct,handBalanceRatio,correctionsCount,forwardKeystrokeCount);
}

@override
String toString() {
    return 'SessionAchievementInput(sessionId: $sessionId, accuracyPct: $accuracyPct, handBalanceRatio: $handBalanceRatio, correctionsCount: $correctionsCount, forwardKeystrokeCount: $forwardKeystrokeCount)';
}


}

/// @nodoc
abstract mixin class _$SessionAchievementInputCopyWith<$Res> implements $SessionAchievementInputCopyWith<$Res> {
  factory _$SessionAchievementInputCopyWith(_SessionAchievementInput value, $Res Function(_SessionAchievementInput) _then) = __$SessionAchievementInputCopyWithImpl;
@override @useResult
$Res call({
 TypingSessionId sessionId, double accuracyPct, double handBalanceRatio, int correctionsCount, int forwardKeystrokeCount
});


@override $TypingSessionIdCopyWith<$Res> get sessionId;

}
/// @nodoc
class __$SessionAchievementInputCopyWithImpl<$Res>
    implements _$SessionAchievementInputCopyWith<$Res> {
  __$SessionAchievementInputCopyWithImpl(this._self, this._then);

  final _SessionAchievementInput _self;
  final $Res Function(_SessionAchievementInput) _then;

/// Create a copy of SessionAchievementInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? accuracyPct = null,Object? handBalanceRatio = null,Object? correctionsCount = null,Object? forwardKeystrokeCount = null,}) {
  return _then(_SessionAchievementInput(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as TypingSessionId,accuracyPct: null == accuracyPct ? _self.accuracyPct : accuracyPct // ignore: cast_nullable_to_non_nullable
as double,handBalanceRatio: null == handBalanceRatio ? _self.handBalanceRatio : handBalanceRatio // ignore: cast_nullable_to_non_nullable
as double,correctionsCount: null == correctionsCount ? _self.correctionsCount : correctionsCount // ignore: cast_nullable_to_non_nullable
as int,forwardKeystrokeCount: null == forwardKeystrokeCount ? _self.forwardKeystrokeCount : forwardKeystrokeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of SessionAchievementInput
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
