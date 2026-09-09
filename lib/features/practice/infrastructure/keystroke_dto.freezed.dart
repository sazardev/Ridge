// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'keystroke_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KeystrokeDto {

 String get sessionId; int get seq; int get sessionStartedAtUtcMicros; String get result; bool get isCorrection; String get physicalKeyId; String get finger; String get keyboardRow; int get thirdIndex; String? get expectedChar; String? get actualChar; int? get dwellMicros; int? get flightMicros;
/// Create a copy of KeystrokeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KeystrokeDtoCopyWith<KeystrokeDto> get copyWith => _$KeystrokeDtoCopyWithImpl<KeystrokeDto>(this as KeystrokeDto, _$identity);

  /// Serializes this KeystrokeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as KeystrokeDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KeystrokeDto&&(identical(other.sessionId, _this.sessionId) || other.sessionId == _this.sessionId)&&(identical(other.seq, _this.seq) || other.seq == _this.seq)&&(identical(other.sessionStartedAtUtcMicros, _this.sessionStartedAtUtcMicros) || other.sessionStartedAtUtcMicros == _this.sessionStartedAtUtcMicros)&&(identical(other.result, _this.result) || other.result == _this.result)&&(identical(other.isCorrection, _this.isCorrection) || other.isCorrection == _this.isCorrection)&&(identical(other.physicalKeyId, _this.physicalKeyId) || other.physicalKeyId == _this.physicalKeyId)&&(identical(other.finger, _this.finger) || other.finger == _this.finger)&&(identical(other.keyboardRow, _this.keyboardRow) || other.keyboardRow == _this.keyboardRow)&&(identical(other.thirdIndex, _this.thirdIndex) || other.thirdIndex == _this.thirdIndex)&&(identical(other.expectedChar, _this.expectedChar) || other.expectedChar == _this.expectedChar)&&(identical(other.actualChar, _this.actualChar) || other.actualChar == _this.actualChar)&&(identical(other.dwellMicros, _this.dwellMicros) || other.dwellMicros == _this.dwellMicros)&&(identical(other.flightMicros, _this.flightMicros) || other.flightMicros == _this.flightMicros));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as KeystrokeDto;
  return Object.hash(runtimeType,_this.sessionId,_this.seq,_this.sessionStartedAtUtcMicros,_this.result,_this.isCorrection,_this.physicalKeyId,_this.finger,_this.keyboardRow,_this.thirdIndex,_this.expectedChar,_this.actualChar,_this.dwellMicros,_this.flightMicros);
}

@override
String toString() {
  final _this = this as KeystrokeDto;
  return 'KeystrokeDto(sessionId: ${_this.sessionId}, seq: ${_this.seq}, sessionStartedAtUtcMicros: ${_this.sessionStartedAtUtcMicros}, result: ${_this.result}, isCorrection: ${_this.isCorrection}, physicalKeyId: ${_this.physicalKeyId}, finger: ${_this.finger}, keyboardRow: ${_this.keyboardRow}, thirdIndex: ${_this.thirdIndex}, expectedChar: ${_this.expectedChar}, actualChar: ${_this.actualChar}, dwellMicros: ${_this.dwellMicros}, flightMicros: ${_this.flightMicros})';
}


}

/// @nodoc
abstract mixin class $KeystrokeDtoCopyWith<$Res>  {
  factory $KeystrokeDtoCopyWith(KeystrokeDto value, $Res Function(KeystrokeDto) _then) = _$KeystrokeDtoCopyWithImpl;
@useResult
$Res call({
 String sessionId, int seq, int sessionStartedAtUtcMicros, String result, bool isCorrection, String physicalKeyId, String finger, String keyboardRow, int thirdIndex, String? expectedChar, String? actualChar, int? dwellMicros, int? flightMicros
});




}
/// @nodoc
class _$KeystrokeDtoCopyWithImpl<$Res>
    implements $KeystrokeDtoCopyWith<$Res> {
  _$KeystrokeDtoCopyWithImpl(this._self, this._then);

  final KeystrokeDto _self;
  final $Res Function(KeystrokeDto) _then;

/// Create a copy of KeystrokeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? seq = null,Object? sessionStartedAtUtcMicros = null,Object? result = null,Object? isCorrection = null,Object? physicalKeyId = null,Object? finger = null,Object? keyboardRow = null,Object? thirdIndex = null,Object? expectedChar = freezed,Object? actualChar = freezed,Object? dwellMicros = freezed,Object? flightMicros = freezed,}) {
  return _then(KeystrokeDto(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,seq: null == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int,sessionStartedAtUtcMicros: null == sessionStartedAtUtcMicros ? _self.sessionStartedAtUtcMicros : sessionStartedAtUtcMicros // ignore: cast_nullable_to_non_nullable
as int,result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as String,isCorrection: null == isCorrection ? _self.isCorrection : isCorrection // ignore: cast_nullable_to_non_nullable
as bool,physicalKeyId: null == physicalKeyId ? _self.physicalKeyId : physicalKeyId // ignore: cast_nullable_to_non_nullable
as String,finger: null == finger ? _self.finger : finger // ignore: cast_nullable_to_non_nullable
as String,keyboardRow: null == keyboardRow ? _self.keyboardRow : keyboardRow // ignore: cast_nullable_to_non_nullable
as String,thirdIndex: null == thirdIndex ? _self.thirdIndex : thirdIndex // ignore: cast_nullable_to_non_nullable
as int,expectedChar: freezed == expectedChar ? _self.expectedChar : expectedChar // ignore: cast_nullable_to_non_nullable
as String?,actualChar: freezed == actualChar ? _self.actualChar : actualChar // ignore: cast_nullable_to_non_nullable
as String?,dwellMicros: freezed == dwellMicros ? _self.dwellMicros : dwellMicros // ignore: cast_nullable_to_non_nullable
as int?,flightMicros: freezed == flightMicros ? _self.flightMicros : flightMicros // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [KeystrokeDto].
extension KeystrokeDtoPatterns on KeystrokeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KeystrokeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KeystrokeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KeystrokeDto value)  $default,){
final _that = this;
switch (_that) {
case _KeystrokeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KeystrokeDto value)?  $default,){
final _that = this;
switch (_that) {
case _KeystrokeDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sessionId,  int seq,  int sessionStartedAtUtcMicros,  String result,  bool isCorrection,  String physicalKeyId,  String finger,  String keyboardRow,  int thirdIndex,  String? expectedChar,  String? actualChar,  int? dwellMicros,  int? flightMicros)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KeystrokeDto() when $default != null:
return $default(_that.sessionId,_that.seq,_that.sessionStartedAtUtcMicros,_that.result,_that.isCorrection,_that.physicalKeyId,_that.finger,_that.keyboardRow,_that.thirdIndex,_that.expectedChar,_that.actualChar,_that.dwellMicros,_that.flightMicros);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sessionId,  int seq,  int sessionStartedAtUtcMicros,  String result,  bool isCorrection,  String physicalKeyId,  String finger,  String keyboardRow,  int thirdIndex,  String? expectedChar,  String? actualChar,  int? dwellMicros,  int? flightMicros)  $default,) {final _that = this;
switch (_that) {
case _KeystrokeDto():
return $default(_that.sessionId,_that.seq,_that.sessionStartedAtUtcMicros,_that.result,_that.isCorrection,_that.physicalKeyId,_that.finger,_that.keyboardRow,_that.thirdIndex,_that.expectedChar,_that.actualChar,_that.dwellMicros,_that.flightMicros);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sessionId,  int seq,  int sessionStartedAtUtcMicros,  String result,  bool isCorrection,  String physicalKeyId,  String finger,  String keyboardRow,  int thirdIndex,  String? expectedChar,  String? actualChar,  int? dwellMicros,  int? flightMicros)?  $default,) {final _that = this;
switch (_that) {
case _KeystrokeDto() when $default != null:
return $default(_that.sessionId,_that.seq,_that.sessionStartedAtUtcMicros,_that.result,_that.isCorrection,_that.physicalKeyId,_that.finger,_that.keyboardRow,_that.thirdIndex,_that.expectedChar,_that.actualChar,_that.dwellMicros,_that.flightMicros);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KeystrokeDto implements KeystrokeDto {
  const _KeystrokeDto({required this.sessionId, required this.seq, required this.sessionStartedAtUtcMicros, required this.result, required this.isCorrection, required this.physicalKeyId, required this.finger, required this.keyboardRow, required this.thirdIndex, this.expectedChar, this.actualChar, this.dwellMicros, this.flightMicros});
  factory _KeystrokeDto.fromJson(Map<String, dynamic> json) => _$KeystrokeDtoFromJson(json);

@override final  String sessionId;
@override final  int seq;
@override final  int sessionStartedAtUtcMicros;
@override final  String result;
@override final  bool isCorrection;
@override final  String physicalKeyId;
@override final  String finger;
@override final  String keyboardRow;
@override final  int thirdIndex;
@override final  String? expectedChar;
@override final  String? actualChar;
@override final  int? dwellMicros;
@override final  int? flightMicros;

/// Create a copy of KeystrokeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KeystrokeDtoCopyWith<_KeystrokeDto> get copyWith => __$KeystrokeDtoCopyWithImpl<_KeystrokeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KeystrokeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _KeystrokeDto&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.seq, seq) || other.seq == seq)&&(identical(other.sessionStartedAtUtcMicros, sessionStartedAtUtcMicros) || other.sessionStartedAtUtcMicros == sessionStartedAtUtcMicros)&&(identical(other.result, result) || other.result == result)&&(identical(other.isCorrection, isCorrection) || other.isCorrection == isCorrection)&&(identical(other.physicalKeyId, physicalKeyId) || other.physicalKeyId == physicalKeyId)&&(identical(other.finger, finger) || other.finger == finger)&&(identical(other.keyboardRow, keyboardRow) || other.keyboardRow == keyboardRow)&&(identical(other.thirdIndex, thirdIndex) || other.thirdIndex == thirdIndex)&&(identical(other.expectedChar, expectedChar) || other.expectedChar == expectedChar)&&(identical(other.actualChar, actualChar) || other.actualChar == actualChar)&&(identical(other.dwellMicros, dwellMicros) || other.dwellMicros == dwellMicros)&&(identical(other.flightMicros, flightMicros) || other.flightMicros == flightMicros));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,sessionId,seq,sessionStartedAtUtcMicros,result,isCorrection,physicalKeyId,finger,keyboardRow,thirdIndex,expectedChar,actualChar,dwellMicros,flightMicros);
}

@override
String toString() {
    return 'KeystrokeDto(sessionId: $sessionId, seq: $seq, sessionStartedAtUtcMicros: $sessionStartedAtUtcMicros, result: $result, isCorrection: $isCorrection, physicalKeyId: $physicalKeyId, finger: $finger, keyboardRow: $keyboardRow, thirdIndex: $thirdIndex, expectedChar: $expectedChar, actualChar: $actualChar, dwellMicros: $dwellMicros, flightMicros: $flightMicros)';
}


}

/// @nodoc
abstract mixin class _$KeystrokeDtoCopyWith<$Res> implements $KeystrokeDtoCopyWith<$Res> {
  factory _$KeystrokeDtoCopyWith(_KeystrokeDto value, $Res Function(_KeystrokeDto) _then) = __$KeystrokeDtoCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, int seq, int sessionStartedAtUtcMicros, String result, bool isCorrection, String physicalKeyId, String finger, String keyboardRow, int thirdIndex, String? expectedChar, String? actualChar, int? dwellMicros, int? flightMicros
});




}
/// @nodoc
class __$KeystrokeDtoCopyWithImpl<$Res>
    implements _$KeystrokeDtoCopyWith<$Res> {
  __$KeystrokeDtoCopyWithImpl(this._self, this._then);

  final _KeystrokeDto _self;
  final $Res Function(_KeystrokeDto) _then;

/// Create a copy of KeystrokeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? seq = null,Object? sessionStartedAtUtcMicros = null,Object? result = null,Object? isCorrection = null,Object? physicalKeyId = null,Object? finger = null,Object? keyboardRow = null,Object? thirdIndex = null,Object? expectedChar = freezed,Object? actualChar = freezed,Object? dwellMicros = freezed,Object? flightMicros = freezed,}) {
  return _then(_KeystrokeDto(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,seq: null == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int,sessionStartedAtUtcMicros: null == sessionStartedAtUtcMicros ? _self.sessionStartedAtUtcMicros : sessionStartedAtUtcMicros // ignore: cast_nullable_to_non_nullable
as int,result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as String,isCorrection: null == isCorrection ? _self.isCorrection : isCorrection // ignore: cast_nullable_to_non_nullable
as bool,physicalKeyId: null == physicalKeyId ? _self.physicalKeyId : physicalKeyId // ignore: cast_nullable_to_non_nullable
as String,finger: null == finger ? _self.finger : finger // ignore: cast_nullable_to_non_nullable
as String,keyboardRow: null == keyboardRow ? _self.keyboardRow : keyboardRow // ignore: cast_nullable_to_non_nullable
as String,thirdIndex: null == thirdIndex ? _self.thirdIndex : thirdIndex // ignore: cast_nullable_to_non_nullable
as int,expectedChar: freezed == expectedChar ? _self.expectedChar : expectedChar // ignore: cast_nullable_to_non_nullable
as String?,actualChar: freezed == actualChar ? _self.actualChar : actualChar // ignore: cast_nullable_to_non_nullable
as String?,dwellMicros: freezed == dwellMicros ? _self.dwellMicros : dwellMicros // ignore: cast_nullable_to_non_nullable
as int?,flightMicros: freezed == flightMicros ? _self.flightMicros : flightMicros // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
