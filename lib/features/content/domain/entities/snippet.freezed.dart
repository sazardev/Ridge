// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'snippet.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Snippet {

 SnippetId get id; int get revision; ProgrammingLanguage get language; Difficulty get difficulty; ContentCategory get category; Set<SymbolFocus> get symbolFocus; SnippetLength get length; String get titleEn; String get titleEs; String get code; String get sourceAttribution; bool get isActive; String get tldrEn; String get tldrEs; String get explanationEn; String get explanationEs;
/// Create a copy of Snippet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SnippetCopyWith<Snippet> get copyWith => _$SnippetCopyWithImpl<Snippet>(this as Snippet, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Snippet;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Snippet&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.revision, _this.revision) || other.revision == _this.revision)&&(identical(other.language, _this.language) || other.language == _this.language)&&(identical(other.difficulty, _this.difficulty) || other.difficulty == _this.difficulty)&&(identical(other.category, _this.category) || other.category == _this.category)&&const DeepCollectionEquality().equals(other.symbolFocus, _this.symbolFocus)&&(identical(other.length, _this.length) || other.length == _this.length)&&(identical(other.titleEn, _this.titleEn) || other.titleEn == _this.titleEn)&&(identical(other.titleEs, _this.titleEs) || other.titleEs == _this.titleEs)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.sourceAttribution, _this.sourceAttribution) || other.sourceAttribution == _this.sourceAttribution)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.tldrEn, _this.tldrEn) || other.tldrEn == _this.tldrEn)&&(identical(other.tldrEs, _this.tldrEs) || other.tldrEs == _this.tldrEs)&&(identical(other.explanationEn, _this.explanationEn) || other.explanationEn == _this.explanationEn)&&(identical(other.explanationEs, _this.explanationEs) || other.explanationEs == _this.explanationEs));
}


@override
int get hashCode {
  final _this = this as Snippet;
  return Object.hash(runtimeType,_this.id,_this.revision,_this.language,_this.difficulty,_this.category,const DeepCollectionEquality().hash(_this.symbolFocus),_this.length,_this.titleEn,_this.titleEs,_this.code,_this.sourceAttribution,_this.isActive,_this.tldrEn,_this.tldrEs,_this.explanationEn,_this.explanationEs);
}

@override
String toString() {
  final _this = this as Snippet;
  return 'Snippet(id: ${_this.id}, revision: ${_this.revision}, language: ${_this.language}, difficulty: ${_this.difficulty}, category: ${_this.category}, symbolFocus: ${_this.symbolFocus}, length: ${_this.length}, titleEn: ${_this.titleEn}, titleEs: ${_this.titleEs}, code: ${_this.code}, sourceAttribution: ${_this.sourceAttribution}, isActive: ${_this.isActive}, tldrEn: ${_this.tldrEn}, tldrEs: ${_this.tldrEs}, explanationEn: ${_this.explanationEn}, explanationEs: ${_this.explanationEs})';
}


}

/// @nodoc
abstract mixin class $SnippetCopyWith<$Res>  {
  factory $SnippetCopyWith(Snippet value, $Res Function(Snippet) _then) = _$SnippetCopyWithImpl;
@useResult
$Res call({
 SnippetId id, int revision, ProgrammingLanguage language, Difficulty difficulty, ContentCategory category, Set<SymbolFocus> symbolFocus, SnippetLength length, String titleEn, String titleEs, String code, String sourceAttribution, bool isActive, String tldrEn, String tldrEs, String explanationEn, String explanationEs
});


$SnippetIdCopyWith<$Res> get id;

}
/// @nodoc
class _$SnippetCopyWithImpl<$Res>
    implements $SnippetCopyWith<$Res> {
  _$SnippetCopyWithImpl(this._self, this._then);

  final Snippet _self;
  final $Res Function(Snippet) _then;

/// Create a copy of Snippet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? revision = null,Object? language = null,Object? difficulty = null,Object? category = null,Object? symbolFocus = null,Object? length = null,Object? titleEn = null,Object? titleEs = null,Object? code = null,Object? sourceAttribution = null,Object? isActive = null,Object? tldrEn = null,Object? tldrEs = null,Object? explanationEn = null,Object? explanationEs = null,}) {
  return _then(Snippet(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as SnippetId,revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as ProgrammingLanguage,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as Difficulty,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ContentCategory,symbolFocus: null == symbolFocus ? _self.symbolFocus : symbolFocus // ignore: cast_nullable_to_non_nullable
as Set<SymbolFocus>,length: null == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as SnippetLength,titleEn: null == titleEn ? _self.titleEn : titleEn // ignore: cast_nullable_to_non_nullable
as String,titleEs: null == titleEs ? _self.titleEs : titleEs // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,sourceAttribution: null == sourceAttribution ? _self.sourceAttribution : sourceAttribution // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,tldrEn: null == tldrEn ? _self.tldrEn : tldrEn // ignore: cast_nullable_to_non_nullable
as String,tldrEs: null == tldrEs ? _self.tldrEs : tldrEs // ignore: cast_nullable_to_non_nullable
as String,explanationEn: null == explanationEn ? _self.explanationEn : explanationEn // ignore: cast_nullable_to_non_nullable
as String,explanationEs: null == explanationEs ? _self.explanationEs : explanationEs // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of Snippet
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SnippetIdCopyWith<$Res> get id {
  
  return $SnippetIdCopyWith<$Res>(_self.id, (value) {
    return _then(_self.copyWith(id: value));
  });
}
}


/// Adds pattern-matching-related methods to [Snippet].
extension SnippetPatterns on Snippet {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Snippet value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Snippet() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Snippet value)  $default,){
final _that = this;
switch (_that) {
case _Snippet():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Snippet value)?  $default,){
final _that = this;
switch (_that) {
case _Snippet() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SnippetId id,  int revision,  ProgrammingLanguage language,  Difficulty difficulty,  ContentCategory category,  Set<SymbolFocus> symbolFocus,  SnippetLength length,  String titleEn,  String titleEs,  String code,  String sourceAttribution,  bool isActive,  String tldrEn,  String tldrEs,  String explanationEn,  String explanationEs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Snippet() when $default != null:
return $default(_that.id,_that.revision,_that.language,_that.difficulty,_that.category,_that.symbolFocus,_that.length,_that.titleEn,_that.titleEs,_that.code,_that.sourceAttribution,_that.isActive,_that.tldrEn,_that.tldrEs,_that.explanationEn,_that.explanationEs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SnippetId id,  int revision,  ProgrammingLanguage language,  Difficulty difficulty,  ContentCategory category,  Set<SymbolFocus> symbolFocus,  SnippetLength length,  String titleEn,  String titleEs,  String code,  String sourceAttribution,  bool isActive,  String tldrEn,  String tldrEs,  String explanationEn,  String explanationEs)  $default,) {final _that = this;
switch (_that) {
case _Snippet():
return $default(_that.id,_that.revision,_that.language,_that.difficulty,_that.category,_that.symbolFocus,_that.length,_that.titleEn,_that.titleEs,_that.code,_that.sourceAttribution,_that.isActive,_that.tldrEn,_that.tldrEs,_that.explanationEn,_that.explanationEs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SnippetId id,  int revision,  ProgrammingLanguage language,  Difficulty difficulty,  ContentCategory category,  Set<SymbolFocus> symbolFocus,  SnippetLength length,  String titleEn,  String titleEs,  String code,  String sourceAttribution,  bool isActive,  String tldrEn,  String tldrEs,  String explanationEn,  String explanationEs)?  $default,) {final _that = this;
switch (_that) {
case _Snippet() when $default != null:
return $default(_that.id,_that.revision,_that.language,_that.difficulty,_that.category,_that.symbolFocus,_that.length,_that.titleEn,_that.titleEs,_that.code,_that.sourceAttribution,_that.isActive,_that.tldrEn,_that.tldrEs,_that.explanationEn,_that.explanationEs);case _:
  return null;

}
}

}

/// @nodoc


class _Snippet extends Snippet {
  const _Snippet({required this.id, required this.revision, required this.language, required this.difficulty, required this.category, required  Set<SymbolFocus> symbolFocus, required this.length, required this.titleEn, required this.titleEs, required this.code, required this.sourceAttribution, required this.isActive, required this.tldrEn, required this.tldrEs, required this.explanationEn, required this.explanationEs}): _symbolFocus = symbolFocus,super._();
  

@override final  SnippetId id;
@override final  int revision;
@override final  ProgrammingLanguage language;
@override final  Difficulty difficulty;
@override final  ContentCategory category;
 final  Set<SymbolFocus> _symbolFocus;
@override Set<SymbolFocus> get symbolFocus {
  if (_symbolFocus is EqualUnmodifiableSetView) return _symbolFocus;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_symbolFocus);
}

@override final  SnippetLength length;
@override final  String titleEn;
@override final  String titleEs;
@override final  String code;
@override final  String sourceAttribution;
@override final  bool isActive;
@override final  String tldrEn;
@override final  String tldrEs;
@override final  String explanationEn;
@override final  String explanationEs;

/// Create a copy of Snippet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SnippetCopyWith<_Snippet> get copyWith => __$SnippetCopyWithImpl<_Snippet>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Snippet&&(identical(other.id, id) || other.id == id)&&(identical(other.revision, revision) || other.revision == revision)&&(identical(other.language, language) || other.language == language)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other.symbolFocus, _symbolFocus)&&(identical(other.length, length) || other.length == length)&&(identical(other.titleEn, titleEn) || other.titleEn == titleEn)&&(identical(other.titleEs, titleEs) || other.titleEs == titleEs)&&(identical(other.code, code) || other.code == code)&&(identical(other.sourceAttribution, sourceAttribution) || other.sourceAttribution == sourceAttribution)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.tldrEn, tldrEn) || other.tldrEn == tldrEn)&&(identical(other.tldrEs, tldrEs) || other.tldrEs == tldrEs)&&(identical(other.explanationEn, explanationEn) || other.explanationEn == explanationEn)&&(identical(other.explanationEs, explanationEs) || other.explanationEs == explanationEs));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,revision,language,difficulty,category,const DeepCollectionEquality().hash(_symbolFocus),length,titleEn,titleEs,code,sourceAttribution,isActive,tldrEn,tldrEs,explanationEn,explanationEs);
}

@override
String toString() {
    return 'Snippet(id: $id, revision: $revision, language: $language, difficulty: $difficulty, category: $category, symbolFocus: $symbolFocus, length: $length, titleEn: $titleEn, titleEs: $titleEs, code: $code, sourceAttribution: $sourceAttribution, isActive: $isActive, tldrEn: $tldrEn, tldrEs: $tldrEs, explanationEn: $explanationEn, explanationEs: $explanationEs)';
}


}

/// @nodoc
abstract mixin class _$SnippetCopyWith<$Res> implements $SnippetCopyWith<$Res> {
  factory _$SnippetCopyWith(_Snippet value, $Res Function(_Snippet) _then) = __$SnippetCopyWithImpl;
@override @useResult
$Res call({
 SnippetId id, int revision, ProgrammingLanguage language, Difficulty difficulty, ContentCategory category, Set<SymbolFocus> symbolFocus, SnippetLength length, String titleEn, String titleEs, String code, String sourceAttribution, bool isActive, String tldrEn, String tldrEs, String explanationEn, String explanationEs
});


@override $SnippetIdCopyWith<$Res> get id;

}
/// @nodoc
class __$SnippetCopyWithImpl<$Res>
    implements _$SnippetCopyWith<$Res> {
  __$SnippetCopyWithImpl(this._self, this._then);

  final _Snippet _self;
  final $Res Function(_Snippet) _then;

/// Create a copy of Snippet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? revision = null,Object? language = null,Object? difficulty = null,Object? category = null,Object? symbolFocus = null,Object? length = null,Object? titleEn = null,Object? titleEs = null,Object? code = null,Object? sourceAttribution = null,Object? isActive = null,Object? tldrEn = null,Object? tldrEs = null,Object? explanationEn = null,Object? explanationEs = null,}) {
  return _then(_Snippet(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as SnippetId,revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as ProgrammingLanguage,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as Difficulty,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ContentCategory,symbolFocus: null == symbolFocus ? _self._symbolFocus : symbolFocus // ignore: cast_nullable_to_non_nullable
as Set<SymbolFocus>,length: null == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as SnippetLength,titleEn: null == titleEn ? _self.titleEn : titleEn // ignore: cast_nullable_to_non_nullable
as String,titleEs: null == titleEs ? _self.titleEs : titleEs // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,sourceAttribution: null == sourceAttribution ? _self.sourceAttribution : sourceAttribution // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,tldrEn: null == tldrEn ? _self.tldrEn : tldrEn // ignore: cast_nullable_to_non_nullable
as String,tldrEs: null == tldrEs ? _self.tldrEs : tldrEs // ignore: cast_nullable_to_non_nullable
as String,explanationEn: null == explanationEn ? _self.explanationEn : explanationEn // ignore: cast_nullable_to_non_nullable
as String,explanationEs: null == explanationEs ? _self.explanationEs : explanationEs // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of Snippet
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SnippetIdCopyWith<$Res> get id {
  
  return $SnippetIdCopyWith<$Res>(_self.id, (value) {
    return _then(_self.copyWith(id: value));
  });
}
}

// dart format on
