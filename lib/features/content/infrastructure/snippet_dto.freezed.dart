// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'snippet_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SnippetDto {

 String get id; int get revision; String get language; String get difficulty; String get category; String get length; String get titleEn; String get titleEs; String get code; String get sourceAttribution; bool get isActive; String get explanationEn; String get explanationEs; String get tldrEn; String get tldrEs; List<String> get symbolFocus;
/// Create a copy of SnippetDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SnippetDtoCopyWith<SnippetDto> get copyWith => _$SnippetDtoCopyWithImpl<SnippetDto>(this as SnippetDto, _$identity);

  /// Serializes this SnippetDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SnippetDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SnippetDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.revision, _this.revision) || other.revision == _this.revision)&&(identical(other.language, _this.language) || other.language == _this.language)&&(identical(other.difficulty, _this.difficulty) || other.difficulty == _this.difficulty)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.length, _this.length) || other.length == _this.length)&&(identical(other.titleEn, _this.titleEn) || other.titleEn == _this.titleEn)&&(identical(other.titleEs, _this.titleEs) || other.titleEs == _this.titleEs)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.sourceAttribution, _this.sourceAttribution) || other.sourceAttribution == _this.sourceAttribution)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.explanationEn, _this.explanationEn) || other.explanationEn == _this.explanationEn)&&(identical(other.explanationEs, _this.explanationEs) || other.explanationEs == _this.explanationEs)&&(identical(other.tldrEn, _this.tldrEn) || other.tldrEn == _this.tldrEn)&&(identical(other.tldrEs, _this.tldrEs) || other.tldrEs == _this.tldrEs)&&const DeepCollectionEquality().equals(other.symbolFocus, _this.symbolFocus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SnippetDto;
  return Object.hash(runtimeType,_this.id,_this.revision,_this.language,_this.difficulty,_this.category,_this.length,_this.titleEn,_this.titleEs,_this.code,_this.sourceAttribution,_this.isActive,_this.explanationEn,_this.explanationEs,_this.tldrEn,_this.tldrEs,const DeepCollectionEquality().hash(_this.symbolFocus));
}

@override
String toString() {
  final _this = this as SnippetDto;
  return 'SnippetDto(id: ${_this.id}, revision: ${_this.revision}, language: ${_this.language}, difficulty: ${_this.difficulty}, category: ${_this.category}, length: ${_this.length}, titleEn: ${_this.titleEn}, titleEs: ${_this.titleEs}, code: ${_this.code}, sourceAttribution: ${_this.sourceAttribution}, isActive: ${_this.isActive}, explanationEn: ${_this.explanationEn}, explanationEs: ${_this.explanationEs}, tldrEn: ${_this.tldrEn}, tldrEs: ${_this.tldrEs}, symbolFocus: ${_this.symbolFocus})';
}


}

/// @nodoc
abstract mixin class $SnippetDtoCopyWith<$Res>  {
  factory $SnippetDtoCopyWith(SnippetDto value, $Res Function(SnippetDto) _then) = _$SnippetDtoCopyWithImpl;
@useResult
$Res call({
 String id, int revision, String language, String difficulty, String category, String length, String titleEn, String titleEs, String code, String sourceAttribution, bool isActive, String explanationEn, String explanationEs, String tldrEn, String tldrEs, List<String> symbolFocus
});




}
/// @nodoc
class _$SnippetDtoCopyWithImpl<$Res>
    implements $SnippetDtoCopyWith<$Res> {
  _$SnippetDtoCopyWithImpl(this._self, this._then);

  final SnippetDto _self;
  final $Res Function(SnippetDto) _then;

/// Create a copy of SnippetDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? revision = null,Object? language = null,Object? difficulty = null,Object? category = null,Object? length = null,Object? titleEn = null,Object? titleEs = null,Object? code = null,Object? sourceAttribution = null,Object? isActive = null,Object? explanationEn = null,Object? explanationEs = null,Object? tldrEn = null,Object? tldrEs = null,Object? symbolFocus = null,}) {
  return _then(SnippetDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,length: null == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as String,titleEn: null == titleEn ? _self.titleEn : titleEn // ignore: cast_nullable_to_non_nullable
as String,titleEs: null == titleEs ? _self.titleEs : titleEs // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,sourceAttribution: null == sourceAttribution ? _self.sourceAttribution : sourceAttribution // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,explanationEn: null == explanationEn ? _self.explanationEn : explanationEn // ignore: cast_nullable_to_non_nullable
as String,explanationEs: null == explanationEs ? _self.explanationEs : explanationEs // ignore: cast_nullable_to_non_nullable
as String,tldrEn: null == tldrEn ? _self.tldrEn : tldrEn // ignore: cast_nullable_to_non_nullable
as String,tldrEs: null == tldrEs ? _self.tldrEs : tldrEs // ignore: cast_nullable_to_non_nullable
as String,symbolFocus: null == symbolFocus ? _self.symbolFocus : symbolFocus // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SnippetDto].
extension SnippetDtoPatterns on SnippetDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SnippetDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SnippetDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SnippetDto value)  $default,){
final _that = this;
switch (_that) {
case _SnippetDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SnippetDto value)?  $default,){
final _that = this;
switch (_that) {
case _SnippetDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int revision,  String language,  String difficulty,  String category,  String length,  String titleEn,  String titleEs,  String code,  String sourceAttribution,  bool isActive,  String explanationEn,  String explanationEs,  String tldrEn,  String tldrEs,  List<String> symbolFocus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SnippetDto() when $default != null:
return $default(_that.id,_that.revision,_that.language,_that.difficulty,_that.category,_that.length,_that.titleEn,_that.titleEs,_that.code,_that.sourceAttribution,_that.isActive,_that.explanationEn,_that.explanationEs,_that.tldrEn,_that.tldrEs,_that.symbolFocus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int revision,  String language,  String difficulty,  String category,  String length,  String titleEn,  String titleEs,  String code,  String sourceAttribution,  bool isActive,  String explanationEn,  String explanationEs,  String tldrEn,  String tldrEs,  List<String> symbolFocus)  $default,) {final _that = this;
switch (_that) {
case _SnippetDto():
return $default(_that.id,_that.revision,_that.language,_that.difficulty,_that.category,_that.length,_that.titleEn,_that.titleEs,_that.code,_that.sourceAttribution,_that.isActive,_that.explanationEn,_that.explanationEs,_that.tldrEn,_that.tldrEs,_that.symbolFocus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int revision,  String language,  String difficulty,  String category,  String length,  String titleEn,  String titleEs,  String code,  String sourceAttribution,  bool isActive,  String explanationEn,  String explanationEs,  String tldrEn,  String tldrEs,  List<String> symbolFocus)?  $default,) {final _that = this;
switch (_that) {
case _SnippetDto() when $default != null:
return $default(_that.id,_that.revision,_that.language,_that.difficulty,_that.category,_that.length,_that.titleEn,_that.titleEs,_that.code,_that.sourceAttribution,_that.isActive,_that.explanationEn,_that.explanationEs,_that.tldrEn,_that.tldrEs,_that.symbolFocus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SnippetDto implements SnippetDto {
  const _SnippetDto({required this.id, required this.revision, required this.language, required this.difficulty, required this.category, required this.length, required this.titleEn, required this.titleEs, required this.code, required this.sourceAttribution, required this.isActive, required this.explanationEn, required this.explanationEs, this.tldrEn = '', this.tldrEs = '',  List<String> symbolFocus = const <String>[]}): _symbolFocus = symbolFocus;
  factory _SnippetDto.fromJson(Map<String, dynamic> json) => _$SnippetDtoFromJson(json);

@override final  String id;
@override final  int revision;
@override final  String language;
@override final  String difficulty;
@override final  String category;
@override final  String length;
@override final  String titleEn;
@override final  String titleEs;
@override final  String code;
@override final  String sourceAttribution;
@override final  bool isActive;
@override final  String explanationEn;
@override final  String explanationEs;
@override@JsonKey() final  String tldrEn;
@override@JsonKey() final  String tldrEs;
 final  List<String> _symbolFocus;
@override@JsonKey() List<String> get symbolFocus {
  if (_symbolFocus is EqualUnmodifiableListView) return _symbolFocus;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_symbolFocus);
}


/// Create a copy of SnippetDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SnippetDtoCopyWith<_SnippetDto> get copyWith => __$SnippetDtoCopyWithImpl<_SnippetDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SnippetDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SnippetDto&&(identical(other.id, id) || other.id == id)&&(identical(other.revision, revision) || other.revision == revision)&&(identical(other.language, language) || other.language == language)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.category, category) || other.category == category)&&(identical(other.length, length) || other.length == length)&&(identical(other.titleEn, titleEn) || other.titleEn == titleEn)&&(identical(other.titleEs, titleEs) || other.titleEs == titleEs)&&(identical(other.code, code) || other.code == code)&&(identical(other.sourceAttribution, sourceAttribution) || other.sourceAttribution == sourceAttribution)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.explanationEn, explanationEn) || other.explanationEn == explanationEn)&&(identical(other.explanationEs, explanationEs) || other.explanationEs == explanationEs)&&(identical(other.tldrEn, tldrEn) || other.tldrEn == tldrEn)&&(identical(other.tldrEs, tldrEs) || other.tldrEs == tldrEs)&&const DeepCollectionEquality().equals(other.symbolFocus, _symbolFocus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,revision,language,difficulty,category,length,titleEn,titleEs,code,sourceAttribution,isActive,explanationEn,explanationEs,tldrEn,tldrEs,const DeepCollectionEquality().hash(_symbolFocus));
}

@override
String toString() {
    return 'SnippetDto(id: $id, revision: $revision, language: $language, difficulty: $difficulty, category: $category, length: $length, titleEn: $titleEn, titleEs: $titleEs, code: $code, sourceAttribution: $sourceAttribution, isActive: $isActive, explanationEn: $explanationEn, explanationEs: $explanationEs, tldrEn: $tldrEn, tldrEs: $tldrEs, symbolFocus: $symbolFocus)';
}


}

/// @nodoc
abstract mixin class _$SnippetDtoCopyWith<$Res> implements $SnippetDtoCopyWith<$Res> {
  factory _$SnippetDtoCopyWith(_SnippetDto value, $Res Function(_SnippetDto) _then) = __$SnippetDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, int revision, String language, String difficulty, String category, String length, String titleEn, String titleEs, String code, String sourceAttribution, bool isActive, String explanationEn, String explanationEs, String tldrEn, String tldrEs, List<String> symbolFocus
});




}
/// @nodoc
class __$SnippetDtoCopyWithImpl<$Res>
    implements _$SnippetDtoCopyWith<$Res> {
  __$SnippetDtoCopyWithImpl(this._self, this._then);

  final _SnippetDto _self;
  final $Res Function(_SnippetDto) _then;

/// Create a copy of SnippetDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? revision = null,Object? language = null,Object? difficulty = null,Object? category = null,Object? length = null,Object? titleEn = null,Object? titleEs = null,Object? code = null,Object? sourceAttribution = null,Object? isActive = null,Object? explanationEn = null,Object? explanationEs = null,Object? tldrEn = null,Object? tldrEs = null,Object? symbolFocus = null,}) {
  return _then(_SnippetDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,length: null == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as String,titleEn: null == titleEn ? _self.titleEn : titleEn // ignore: cast_nullable_to_non_nullable
as String,titleEs: null == titleEs ? _self.titleEs : titleEs // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,sourceAttribution: null == sourceAttribution ? _self.sourceAttribution : sourceAttribution // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,explanationEn: null == explanationEn ? _self.explanationEn : explanationEn // ignore: cast_nullable_to_non_nullable
as String,explanationEs: null == explanationEs ? _self.explanationEs : explanationEs // ignore: cast_nullable_to_non_nullable
as String,tldrEn: null == tldrEn ? _self.tldrEn : tldrEn // ignore: cast_nullable_to_non_nullable
as String,tldrEs: null == tldrEs ? _self.tldrEs : tldrEs // ignore: cast_nullable_to_non_nullable
as String,symbolFocus: null == symbolFocus ? _self._symbolFocus : symbolFocus // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
