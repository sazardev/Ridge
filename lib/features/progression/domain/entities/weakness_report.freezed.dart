// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weakness_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WeaknessReport {

 List<WeakCharacter> get weakCharacters; List<WeakFinger> get weakFingers; List<WeakNgram> get weakNgrams;
/// Create a copy of WeaknessReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeaknessReportCopyWith<WeaknessReport> get copyWith => _$WeaknessReportCopyWithImpl<WeaknessReport>(this as WeaknessReport, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WeaknessReport;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeaknessReport&&const DeepCollectionEquality().equals(other.weakCharacters, _this.weakCharacters)&&const DeepCollectionEquality().equals(other.weakFingers, _this.weakFingers)&&const DeepCollectionEquality().equals(other.weakNgrams, _this.weakNgrams));
}


@override
int get hashCode {
  final _this = this as WeaknessReport;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.weakCharacters),const DeepCollectionEquality().hash(_this.weakFingers),const DeepCollectionEquality().hash(_this.weakNgrams));
}

@override
String toString() {
  final _this = this as WeaknessReport;
  return 'WeaknessReport(weakCharacters: ${_this.weakCharacters}, weakFingers: ${_this.weakFingers}, weakNgrams: ${_this.weakNgrams})';
}


}

/// @nodoc
abstract mixin class $WeaknessReportCopyWith<$Res>  {
  factory $WeaknessReportCopyWith(WeaknessReport value, $Res Function(WeaknessReport) _then) = _$WeaknessReportCopyWithImpl;
@useResult
$Res call({
 List<WeakCharacter> weakCharacters, List<WeakFinger> weakFingers, List<WeakNgram> weakNgrams
});




}
/// @nodoc
class _$WeaknessReportCopyWithImpl<$Res>
    implements $WeaknessReportCopyWith<$Res> {
  _$WeaknessReportCopyWithImpl(this._self, this._then);

  final WeaknessReport _self;
  final $Res Function(WeaknessReport) _then;

/// Create a copy of WeaknessReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weakCharacters = null,Object? weakFingers = null,Object? weakNgrams = null,}) {
  return _then(WeaknessReport(
weakCharacters: null == weakCharacters ? _self.weakCharacters : weakCharacters // ignore: cast_nullable_to_non_nullable
as List<WeakCharacter>,weakFingers: null == weakFingers ? _self.weakFingers : weakFingers // ignore: cast_nullable_to_non_nullable
as List<WeakFinger>,weakNgrams: null == weakNgrams ? _self.weakNgrams : weakNgrams // ignore: cast_nullable_to_non_nullable
as List<WeakNgram>,
  ));
}

}


/// Adds pattern-matching-related methods to [WeaknessReport].
extension WeaknessReportPatterns on WeaknessReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeaknessReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeaknessReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeaknessReport value)  $default,){
final _that = this;
switch (_that) {
case _WeaknessReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeaknessReport value)?  $default,){
final _that = this;
switch (_that) {
case _WeaknessReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<WeakCharacter> weakCharacters,  List<WeakFinger> weakFingers,  List<WeakNgram> weakNgrams)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeaknessReport() when $default != null:
return $default(_that.weakCharacters,_that.weakFingers,_that.weakNgrams);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<WeakCharacter> weakCharacters,  List<WeakFinger> weakFingers,  List<WeakNgram> weakNgrams)  $default,) {final _that = this;
switch (_that) {
case _WeaknessReport():
return $default(_that.weakCharacters,_that.weakFingers,_that.weakNgrams);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<WeakCharacter> weakCharacters,  List<WeakFinger> weakFingers,  List<WeakNgram> weakNgrams)?  $default,) {final _that = this;
switch (_that) {
case _WeaknessReport() when $default != null:
return $default(_that.weakCharacters,_that.weakFingers,_that.weakNgrams);case _:
  return null;

}
}

}

/// @nodoc


class _WeaknessReport implements WeaknessReport {
  const _WeaknessReport({required  List<WeakCharacter> weakCharacters, required  List<WeakFinger> weakFingers, required  List<WeakNgram> weakNgrams}): _weakCharacters = weakCharacters,_weakFingers = weakFingers,_weakNgrams = weakNgrams;
  

 final  List<WeakCharacter> _weakCharacters;
@override List<WeakCharacter> get weakCharacters {
  if (_weakCharacters is EqualUnmodifiableListView) return _weakCharacters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weakCharacters);
}

 final  List<WeakFinger> _weakFingers;
@override List<WeakFinger> get weakFingers {
  if (_weakFingers is EqualUnmodifiableListView) return _weakFingers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weakFingers);
}

 final  List<WeakNgram> _weakNgrams;
@override List<WeakNgram> get weakNgrams {
  if (_weakNgrams is EqualUnmodifiableListView) return _weakNgrams;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weakNgrams);
}


/// Create a copy of WeaknessReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeaknessReportCopyWith<_WeaknessReport> get copyWith => __$WeaknessReportCopyWithImpl<_WeaknessReport>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeaknessReport&&const DeepCollectionEquality().equals(other.weakCharacters, _weakCharacters)&&const DeepCollectionEquality().equals(other.weakFingers, _weakFingers)&&const DeepCollectionEquality().equals(other.weakNgrams, _weakNgrams));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_weakCharacters),const DeepCollectionEquality().hash(_weakFingers),const DeepCollectionEquality().hash(_weakNgrams));
}

@override
String toString() {
    return 'WeaknessReport(weakCharacters: $weakCharacters, weakFingers: $weakFingers, weakNgrams: $weakNgrams)';
}


}

/// @nodoc
abstract mixin class _$WeaknessReportCopyWith<$Res> implements $WeaknessReportCopyWith<$Res> {
  factory _$WeaknessReportCopyWith(_WeaknessReport value, $Res Function(_WeaknessReport) _then) = __$WeaknessReportCopyWithImpl;
@override @useResult
$Res call({
 List<WeakCharacter> weakCharacters, List<WeakFinger> weakFingers, List<WeakNgram> weakNgrams
});




}
/// @nodoc
class __$WeaknessReportCopyWithImpl<$Res>
    implements _$WeaknessReportCopyWith<$Res> {
  __$WeaknessReportCopyWithImpl(this._self, this._then);

  final _WeaknessReport _self;
  final $Res Function(_WeaknessReport) _then;

/// Create a copy of WeaknessReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weakCharacters = null,Object? weakFingers = null,Object? weakNgrams = null,}) {
  return _then(_WeaknessReport(
weakCharacters: null == weakCharacters ? _self._weakCharacters : weakCharacters // ignore: cast_nullable_to_non_nullable
as List<WeakCharacter>,weakFingers: null == weakFingers ? _self._weakFingers : weakFingers // ignore: cast_nullable_to_non_nullable
as List<WeakFinger>,weakNgrams: null == weakNgrams ? _self._weakNgrams : weakNgrams // ignore: cast_nullable_to_non_nullable
as List<WeakNgram>,
  ));
}


}

// dart format on
