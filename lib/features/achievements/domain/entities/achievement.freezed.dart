// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'achievement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Achievement {

 AchievementId get id; DateTime get unlockedAt; TypingSessionId? get triggerSessionId;
/// Create a copy of Achievement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AchievementCopyWith<Achievement> get copyWith => _$AchievementCopyWithImpl<Achievement>(this as Achievement, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Achievement;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Achievement&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.unlockedAt, _this.unlockedAt) || other.unlockedAt == _this.unlockedAt)&&(identical(other.triggerSessionId, _this.triggerSessionId) || other.triggerSessionId == _this.triggerSessionId));
}


@override
int get hashCode {
  final _this = this as Achievement;
  return Object.hash(runtimeType,_this.id,_this.unlockedAt,_this.triggerSessionId);
}

@override
String toString() {
  final _this = this as Achievement;
  return 'Achievement(id: ${_this.id}, unlockedAt: ${_this.unlockedAt}, triggerSessionId: ${_this.triggerSessionId})';
}


}

/// @nodoc
abstract mixin class $AchievementCopyWith<$Res>  {
  factory $AchievementCopyWith(Achievement value, $Res Function(Achievement) _then) = _$AchievementCopyWithImpl;
@useResult
$Res call({
 AchievementId id, DateTime unlockedAt, TypingSessionId? triggerSessionId
});


$AchievementIdCopyWith<$Res> get id;$TypingSessionIdCopyWith<$Res>? get triggerSessionId;

}
/// @nodoc
class _$AchievementCopyWithImpl<$Res>
    implements $AchievementCopyWith<$Res> {
  _$AchievementCopyWithImpl(this._self, this._then);

  final Achievement _self;
  final $Res Function(Achievement) _then;

/// Create a copy of Achievement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? unlockedAt = null,Object? triggerSessionId = freezed,}) {
  return _then(Achievement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as AchievementId,unlockedAt: null == unlockedAt ? _self.unlockedAt : unlockedAt // ignore: cast_nullable_to_non_nullable
as DateTime,triggerSessionId: freezed == triggerSessionId ? _self.triggerSessionId : triggerSessionId // ignore: cast_nullable_to_non_nullable
as TypingSessionId?,
  ));
}
/// Create a copy of Achievement
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AchievementIdCopyWith<$Res> get id {
  
  return $AchievementIdCopyWith<$Res>(_self.id, (value) {
    return _then(_self.copyWith(id: value));
  });
}/// Create a copy of Achievement
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TypingSessionIdCopyWith<$Res>? get triggerSessionId {
    if (_self.triggerSessionId == null) {
    return null;
  }

  return $TypingSessionIdCopyWith<$Res>(_self.triggerSessionId!, (value) {
    return _then(_self.copyWith(triggerSessionId: value));
  });
}
}


/// Adds pattern-matching-related methods to [Achievement].
extension AchievementPatterns on Achievement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Achievement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Achievement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Achievement value)  $default,){
final _that = this;
switch (_that) {
case _Achievement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Achievement value)?  $default,){
final _that = this;
switch (_that) {
case _Achievement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AchievementId id,  DateTime unlockedAt,  TypingSessionId? triggerSessionId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Achievement() when $default != null:
return $default(_that.id,_that.unlockedAt,_that.triggerSessionId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AchievementId id,  DateTime unlockedAt,  TypingSessionId? triggerSessionId)  $default,) {final _that = this;
switch (_that) {
case _Achievement():
return $default(_that.id,_that.unlockedAt,_that.triggerSessionId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AchievementId id,  DateTime unlockedAt,  TypingSessionId? triggerSessionId)?  $default,) {final _that = this;
switch (_that) {
case _Achievement() when $default != null:
return $default(_that.id,_that.unlockedAt,_that.triggerSessionId);case _:
  return null;

}
}

}

/// @nodoc


class _Achievement implements Achievement {
  const _Achievement({required this.id, required this.unlockedAt, this.triggerSessionId});
  

@override final  AchievementId id;
@override final  DateTime unlockedAt;
@override final  TypingSessionId? triggerSessionId;

/// Create a copy of Achievement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AchievementCopyWith<_Achievement> get copyWith => __$AchievementCopyWithImpl<_Achievement>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Achievement&&(identical(other.id, id) || other.id == id)&&(identical(other.unlockedAt, unlockedAt) || other.unlockedAt == unlockedAt)&&(identical(other.triggerSessionId, triggerSessionId) || other.triggerSessionId == triggerSessionId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,unlockedAt,triggerSessionId);
}

@override
String toString() {
    return 'Achievement(id: $id, unlockedAt: $unlockedAt, triggerSessionId: $triggerSessionId)';
}


}

/// @nodoc
abstract mixin class _$AchievementCopyWith<$Res> implements $AchievementCopyWith<$Res> {
  factory _$AchievementCopyWith(_Achievement value, $Res Function(_Achievement) _then) = __$AchievementCopyWithImpl;
@override @useResult
$Res call({
 AchievementId id, DateTime unlockedAt, TypingSessionId? triggerSessionId
});


@override $AchievementIdCopyWith<$Res> get id;@override $TypingSessionIdCopyWith<$Res>? get triggerSessionId;

}
/// @nodoc
class __$AchievementCopyWithImpl<$Res>
    implements _$AchievementCopyWith<$Res> {
  __$AchievementCopyWithImpl(this._self, this._then);

  final _Achievement _self;
  final $Res Function(_Achievement) _then;

/// Create a copy of Achievement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? unlockedAt = null,Object? triggerSessionId = freezed,}) {
  return _then(_Achievement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as AchievementId,unlockedAt: null == unlockedAt ? _self.unlockedAt : unlockedAt // ignore: cast_nullable_to_non_nullable
as DateTime,triggerSessionId: freezed == triggerSessionId ? _self.triggerSessionId : triggerSessionId // ignore: cast_nullable_to_non_nullable
as TypingSessionId?,
  ));
}

/// Create a copy of Achievement
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AchievementIdCopyWith<$Res> get id {
  
  return $AchievementIdCopyWith<$Res>(_self.id, (value) {
    return _then(_self.copyWith(id: value));
  });
}/// Create a copy of Achievement
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TypingSessionIdCopyWith<$Res>? get triggerSessionId {
    if (_self.triggerSessionId == null) {
    return null;
  }

  return $TypingSessionIdCopyWith<$Res>(_self.triggerSessionId!, (value) {
    return _then(_self.copyWith(triggerSessionId: value));
  });
}
}

// dart format on
