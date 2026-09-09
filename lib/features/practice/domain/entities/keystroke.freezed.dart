// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'keystroke.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Keystroke {

 PhysicalKeyId get physicalKeyId; KeystrokeResult get result; bool get isCorrection; Finger get finger; KeyboardRow get keyboardRow; int get sequenceIndex; String? get expectedChar; String? get actualChar; Duration? get dwell; Duration? get flight;
/// Create a copy of Keystroke
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KeystrokeCopyWith<Keystroke> get copyWith => _$KeystrokeCopyWithImpl<Keystroke>(this as Keystroke, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Keystroke;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Keystroke&&(identical(other.physicalKeyId, _this.physicalKeyId) || other.physicalKeyId == _this.physicalKeyId)&&(identical(other.result, _this.result) || other.result == _this.result)&&(identical(other.isCorrection, _this.isCorrection) || other.isCorrection == _this.isCorrection)&&(identical(other.finger, _this.finger) || other.finger == _this.finger)&&(identical(other.keyboardRow, _this.keyboardRow) || other.keyboardRow == _this.keyboardRow)&&(identical(other.sequenceIndex, _this.sequenceIndex) || other.sequenceIndex == _this.sequenceIndex)&&(identical(other.expectedChar, _this.expectedChar) || other.expectedChar == _this.expectedChar)&&(identical(other.actualChar, _this.actualChar) || other.actualChar == _this.actualChar)&&(identical(other.dwell, _this.dwell) || other.dwell == _this.dwell)&&(identical(other.flight, _this.flight) || other.flight == _this.flight));
}


@override
int get hashCode {
  final _this = this as Keystroke;
  return Object.hash(runtimeType,_this.physicalKeyId,_this.result,_this.isCorrection,_this.finger,_this.keyboardRow,_this.sequenceIndex,_this.expectedChar,_this.actualChar,_this.dwell,_this.flight);
}

@override
String toString() {
  final _this = this as Keystroke;
  return 'Keystroke(physicalKeyId: ${_this.physicalKeyId}, result: ${_this.result}, isCorrection: ${_this.isCorrection}, finger: ${_this.finger}, keyboardRow: ${_this.keyboardRow}, sequenceIndex: ${_this.sequenceIndex}, expectedChar: ${_this.expectedChar}, actualChar: ${_this.actualChar}, dwell: ${_this.dwell}, flight: ${_this.flight})';
}


}

/// @nodoc
abstract mixin class $KeystrokeCopyWith<$Res>  {
  factory $KeystrokeCopyWith(Keystroke value, $Res Function(Keystroke) _then) = _$KeystrokeCopyWithImpl;
@useResult
$Res call({
 PhysicalKeyId physicalKeyId, KeystrokeResult result, bool isCorrection, Finger finger, KeyboardRow keyboardRow, int sequenceIndex, String? expectedChar, String? actualChar, Duration? dwell, Duration? flight
});




}
/// @nodoc
class _$KeystrokeCopyWithImpl<$Res>
    implements $KeystrokeCopyWith<$Res> {
  _$KeystrokeCopyWithImpl(this._self, this._then);

  final Keystroke _self;
  final $Res Function(Keystroke) _then;

/// Create a copy of Keystroke
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? physicalKeyId = null,Object? result = null,Object? isCorrection = null,Object? finger = null,Object? keyboardRow = null,Object? sequenceIndex = null,Object? expectedChar = freezed,Object? actualChar = freezed,Object? dwell = freezed,Object? flight = freezed,}) {
  return _then(Keystroke(
physicalKeyId: null == physicalKeyId ? _self.physicalKeyId : physicalKeyId // ignore: cast_nullable_to_non_nullable
as PhysicalKeyId,result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as KeystrokeResult,isCorrection: null == isCorrection ? _self.isCorrection : isCorrection // ignore: cast_nullable_to_non_nullable
as bool,finger: null == finger ? _self.finger : finger // ignore: cast_nullable_to_non_nullable
as Finger,keyboardRow: null == keyboardRow ? _self.keyboardRow : keyboardRow // ignore: cast_nullable_to_non_nullable
as KeyboardRow,sequenceIndex: null == sequenceIndex ? _self.sequenceIndex : sequenceIndex // ignore: cast_nullable_to_non_nullable
as int,expectedChar: freezed == expectedChar ? _self.expectedChar : expectedChar // ignore: cast_nullable_to_non_nullable
as String?,actualChar: freezed == actualChar ? _self.actualChar : actualChar // ignore: cast_nullable_to_non_nullable
as String?,dwell: freezed == dwell ? _self.dwell : dwell // ignore: cast_nullable_to_non_nullable
as Duration?,flight: freezed == flight ? _self.flight : flight // ignore: cast_nullable_to_non_nullable
as Duration?,
  ));
}

}


/// Adds pattern-matching-related methods to [Keystroke].
extension KeystrokePatterns on Keystroke {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Keystroke value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Keystroke() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Keystroke value)  $default,){
final _that = this;
switch (_that) {
case _Keystroke():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Keystroke value)?  $default,){
final _that = this;
switch (_that) {
case _Keystroke() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PhysicalKeyId physicalKeyId,  KeystrokeResult result,  bool isCorrection,  Finger finger,  KeyboardRow keyboardRow,  int sequenceIndex,  String? expectedChar,  String? actualChar,  Duration? dwell,  Duration? flight)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Keystroke() when $default != null:
return $default(_that.physicalKeyId,_that.result,_that.isCorrection,_that.finger,_that.keyboardRow,_that.sequenceIndex,_that.expectedChar,_that.actualChar,_that.dwell,_that.flight);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PhysicalKeyId physicalKeyId,  KeystrokeResult result,  bool isCorrection,  Finger finger,  KeyboardRow keyboardRow,  int sequenceIndex,  String? expectedChar,  String? actualChar,  Duration? dwell,  Duration? flight)  $default,) {final _that = this;
switch (_that) {
case _Keystroke():
return $default(_that.physicalKeyId,_that.result,_that.isCorrection,_that.finger,_that.keyboardRow,_that.sequenceIndex,_that.expectedChar,_that.actualChar,_that.dwell,_that.flight);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PhysicalKeyId physicalKeyId,  KeystrokeResult result,  bool isCorrection,  Finger finger,  KeyboardRow keyboardRow,  int sequenceIndex,  String? expectedChar,  String? actualChar,  Duration? dwell,  Duration? flight)?  $default,) {final _that = this;
switch (_that) {
case _Keystroke() when $default != null:
return $default(_that.physicalKeyId,_that.result,_that.isCorrection,_that.finger,_that.keyboardRow,_that.sequenceIndex,_that.expectedChar,_that.actualChar,_that.dwell,_that.flight);case _:
  return null;

}
}

}

/// @nodoc


class _Keystroke implements Keystroke {
  const _Keystroke({required this.physicalKeyId, required this.result, required this.isCorrection, required this.finger, required this.keyboardRow, required this.sequenceIndex, this.expectedChar, this.actualChar, this.dwell, this.flight});
  

@override final  PhysicalKeyId physicalKeyId;
@override final  KeystrokeResult result;
@override final  bool isCorrection;
@override final  Finger finger;
@override final  KeyboardRow keyboardRow;
@override final  int sequenceIndex;
@override final  String? expectedChar;
@override final  String? actualChar;
@override final  Duration? dwell;
@override final  Duration? flight;

/// Create a copy of Keystroke
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KeystrokeCopyWith<_Keystroke> get copyWith => __$KeystrokeCopyWithImpl<_Keystroke>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Keystroke&&(identical(other.physicalKeyId, physicalKeyId) || other.physicalKeyId == physicalKeyId)&&(identical(other.result, result) || other.result == result)&&(identical(other.isCorrection, isCorrection) || other.isCorrection == isCorrection)&&(identical(other.finger, finger) || other.finger == finger)&&(identical(other.keyboardRow, keyboardRow) || other.keyboardRow == keyboardRow)&&(identical(other.sequenceIndex, sequenceIndex) || other.sequenceIndex == sequenceIndex)&&(identical(other.expectedChar, expectedChar) || other.expectedChar == expectedChar)&&(identical(other.actualChar, actualChar) || other.actualChar == actualChar)&&(identical(other.dwell, dwell) || other.dwell == dwell)&&(identical(other.flight, flight) || other.flight == flight));
}


@override
int get hashCode {
    return Object.hash(runtimeType,physicalKeyId,result,isCorrection,finger,keyboardRow,sequenceIndex,expectedChar,actualChar,dwell,flight);
}

@override
String toString() {
    return 'Keystroke(physicalKeyId: $physicalKeyId, result: $result, isCorrection: $isCorrection, finger: $finger, keyboardRow: $keyboardRow, sequenceIndex: $sequenceIndex, expectedChar: $expectedChar, actualChar: $actualChar, dwell: $dwell, flight: $flight)';
}


}

/// @nodoc
abstract mixin class _$KeystrokeCopyWith<$Res> implements $KeystrokeCopyWith<$Res> {
  factory _$KeystrokeCopyWith(_Keystroke value, $Res Function(_Keystroke) _then) = __$KeystrokeCopyWithImpl;
@override @useResult
$Res call({
 PhysicalKeyId physicalKeyId, KeystrokeResult result, bool isCorrection, Finger finger, KeyboardRow keyboardRow, int sequenceIndex, String? expectedChar, String? actualChar, Duration? dwell, Duration? flight
});




}
/// @nodoc
class __$KeystrokeCopyWithImpl<$Res>
    implements _$KeystrokeCopyWith<$Res> {
  __$KeystrokeCopyWithImpl(this._self, this._then);

  final _Keystroke _self;
  final $Res Function(_Keystroke) _then;

/// Create a copy of Keystroke
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? physicalKeyId = null,Object? result = null,Object? isCorrection = null,Object? finger = null,Object? keyboardRow = null,Object? sequenceIndex = null,Object? expectedChar = freezed,Object? actualChar = freezed,Object? dwell = freezed,Object? flight = freezed,}) {
  return _then(_Keystroke(
physicalKeyId: null == physicalKeyId ? _self.physicalKeyId : physicalKeyId // ignore: cast_nullable_to_non_nullable
as PhysicalKeyId,result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as KeystrokeResult,isCorrection: null == isCorrection ? _self.isCorrection : isCorrection // ignore: cast_nullable_to_non_nullable
as bool,finger: null == finger ? _self.finger : finger // ignore: cast_nullable_to_non_nullable
as Finger,keyboardRow: null == keyboardRow ? _self.keyboardRow : keyboardRow // ignore: cast_nullable_to_non_nullable
as KeyboardRow,sequenceIndex: null == sequenceIndex ? _self.sequenceIndex : sequenceIndex // ignore: cast_nullable_to_non_nullable
as int,expectedChar: freezed == expectedChar ? _self.expectedChar : expectedChar // ignore: cast_nullable_to_non_nullable
as String?,actualChar: freezed == actualChar ? _self.actualChar : actualChar // ignore: cast_nullable_to_non_nullable
as String?,dwell: freezed == dwell ? _self.dwell : dwell // ignore: cast_nullable_to_non_nullable
as Duration?,flight: freezed == flight ? _self.flight : flight // ignore: cast_nullable_to_non_nullable
as Duration?,
  ));
}


}

// dart format on
