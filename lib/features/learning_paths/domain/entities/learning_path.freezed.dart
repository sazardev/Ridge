// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'learning_path.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LearningPath {

 LearningPathId get id; ProgrammingLanguage get language; String get titleEn; String get titleEs; String get descriptionEn; String get descriptionEs;/// A single short topic label (e.g. "Backend", "Fundamentals") shown
/// as a chip on the path's card — never a replacement for the fuller
/// [descriptionEn]/[descriptionEs], just a skimmable identifier.
 String get tagEn; String get tagEs; List<Lesson> get lessons;
/// Create a copy of LearningPath
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LearningPathCopyWith<LearningPath> get copyWith => _$LearningPathCopyWithImpl<LearningPath>(this as LearningPath, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LearningPath;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LearningPath&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.language, _this.language) || other.language == _this.language)&&(identical(other.titleEn, _this.titleEn) || other.titleEn == _this.titleEn)&&(identical(other.titleEs, _this.titleEs) || other.titleEs == _this.titleEs)&&(identical(other.descriptionEn, _this.descriptionEn) || other.descriptionEn == _this.descriptionEn)&&(identical(other.descriptionEs, _this.descriptionEs) || other.descriptionEs == _this.descriptionEs)&&(identical(other.tagEn, _this.tagEn) || other.tagEn == _this.tagEn)&&(identical(other.tagEs, _this.tagEs) || other.tagEs == _this.tagEs)&&const DeepCollectionEquality().equals(other.lessons, _this.lessons));
}


@override
int get hashCode {
  final _this = this as LearningPath;
  return Object.hash(runtimeType,_this.id,_this.language,_this.titleEn,_this.titleEs,_this.descriptionEn,_this.descriptionEs,_this.tagEn,_this.tagEs,const DeepCollectionEquality().hash(_this.lessons));
}

@override
String toString() {
  final _this = this as LearningPath;
  return 'LearningPath(id: ${_this.id}, language: ${_this.language}, titleEn: ${_this.titleEn}, titleEs: ${_this.titleEs}, descriptionEn: ${_this.descriptionEn}, descriptionEs: ${_this.descriptionEs}, tagEn: ${_this.tagEn}, tagEs: ${_this.tagEs}, lessons: ${_this.lessons})';
}


}

/// @nodoc
abstract mixin class $LearningPathCopyWith<$Res>  {
  factory $LearningPathCopyWith(LearningPath value, $Res Function(LearningPath) _then) = _$LearningPathCopyWithImpl;
@useResult
$Res call({
 LearningPathId id, ProgrammingLanguage language, String titleEn, String titleEs, String descriptionEn, String descriptionEs, String tagEn, String tagEs, List<Lesson> lessons
});


$LearningPathIdCopyWith<$Res> get id;

}
/// @nodoc
class _$LearningPathCopyWithImpl<$Res>
    implements $LearningPathCopyWith<$Res> {
  _$LearningPathCopyWithImpl(this._self, this._then);

  final LearningPath _self;
  final $Res Function(LearningPath) _then;

/// Create a copy of LearningPath
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? language = null,Object? titleEn = null,Object? titleEs = null,Object? descriptionEn = null,Object? descriptionEs = null,Object? tagEn = null,Object? tagEs = null,Object? lessons = null,}) {
  return _then(LearningPath(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as LearningPathId,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as ProgrammingLanguage,titleEn: null == titleEn ? _self.titleEn : titleEn // ignore: cast_nullable_to_non_nullable
as String,titleEs: null == titleEs ? _self.titleEs : titleEs // ignore: cast_nullable_to_non_nullable
as String,descriptionEn: null == descriptionEn ? _self.descriptionEn : descriptionEn // ignore: cast_nullable_to_non_nullable
as String,descriptionEs: null == descriptionEs ? _self.descriptionEs : descriptionEs // ignore: cast_nullable_to_non_nullable
as String,tagEn: null == tagEn ? _self.tagEn : tagEn // ignore: cast_nullable_to_non_nullable
as String,tagEs: null == tagEs ? _self.tagEs : tagEs // ignore: cast_nullable_to_non_nullable
as String,lessons: null == lessons ? _self.lessons : lessons // ignore: cast_nullable_to_non_nullable
as List<Lesson>,
  ));
}
/// Create a copy of LearningPath
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LearningPathIdCopyWith<$Res> get id {
  
  return $LearningPathIdCopyWith<$Res>(_self.id, (value) {
    return _then(_self.copyWith(id: value));
  });
}
}


/// Adds pattern-matching-related methods to [LearningPath].
extension LearningPathPatterns on LearningPath {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LearningPath value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LearningPath() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LearningPath value)  $default,){
final _that = this;
switch (_that) {
case _LearningPath():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LearningPath value)?  $default,){
final _that = this;
switch (_that) {
case _LearningPath() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LearningPathId id,  ProgrammingLanguage language,  String titleEn,  String titleEs,  String descriptionEn,  String descriptionEs,  String tagEn,  String tagEs,  List<Lesson> lessons)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LearningPath() when $default != null:
return $default(_that.id,_that.language,_that.titleEn,_that.titleEs,_that.descriptionEn,_that.descriptionEs,_that.tagEn,_that.tagEs,_that.lessons);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LearningPathId id,  ProgrammingLanguage language,  String titleEn,  String titleEs,  String descriptionEn,  String descriptionEs,  String tagEn,  String tagEs,  List<Lesson> lessons)  $default,) {final _that = this;
switch (_that) {
case _LearningPath():
return $default(_that.id,_that.language,_that.titleEn,_that.titleEs,_that.descriptionEn,_that.descriptionEs,_that.tagEn,_that.tagEs,_that.lessons);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LearningPathId id,  ProgrammingLanguage language,  String titleEn,  String titleEs,  String descriptionEn,  String descriptionEs,  String tagEn,  String tagEs,  List<Lesson> lessons)?  $default,) {final _that = this;
switch (_that) {
case _LearningPath() when $default != null:
return $default(_that.id,_that.language,_that.titleEn,_that.titleEs,_that.descriptionEn,_that.descriptionEs,_that.tagEn,_that.tagEs,_that.lessons);case _:
  return null;

}
}

}

/// @nodoc


class _LearningPath implements LearningPath {
  const _LearningPath({required this.id, required this.language, required this.titleEn, required this.titleEs, required this.descriptionEn, required this.descriptionEs, required this.tagEn, required this.tagEs, required  List<Lesson> lessons}): _lessons = lessons;
  

@override final  LearningPathId id;
@override final  ProgrammingLanguage language;
@override final  String titleEn;
@override final  String titleEs;
@override final  String descriptionEn;
@override final  String descriptionEs;
/// A single short topic label (e.g. "Backend", "Fundamentals") shown
/// as a chip on the path's card — never a replacement for the fuller
/// [descriptionEn]/[descriptionEs], just a skimmable identifier.
@override final  String tagEn;
@override final  String tagEs;
 final  List<Lesson> _lessons;
@override List<Lesson> get lessons {
  if (_lessons is EqualUnmodifiableListView) return _lessons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lessons);
}


/// Create a copy of LearningPath
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LearningPathCopyWith<_LearningPath> get copyWith => __$LearningPathCopyWithImpl<_LearningPath>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LearningPath&&(identical(other.id, id) || other.id == id)&&(identical(other.language, language) || other.language == language)&&(identical(other.titleEn, titleEn) || other.titleEn == titleEn)&&(identical(other.titleEs, titleEs) || other.titleEs == titleEs)&&(identical(other.descriptionEn, descriptionEn) || other.descriptionEn == descriptionEn)&&(identical(other.descriptionEs, descriptionEs) || other.descriptionEs == descriptionEs)&&(identical(other.tagEn, tagEn) || other.tagEn == tagEn)&&(identical(other.tagEs, tagEs) || other.tagEs == tagEs)&&const DeepCollectionEquality().equals(other.lessons, _lessons));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,language,titleEn,titleEs,descriptionEn,descriptionEs,tagEn,tagEs,const DeepCollectionEquality().hash(_lessons));
}

@override
String toString() {
    return 'LearningPath(id: $id, language: $language, titleEn: $titleEn, titleEs: $titleEs, descriptionEn: $descriptionEn, descriptionEs: $descriptionEs, tagEn: $tagEn, tagEs: $tagEs, lessons: $lessons)';
}


}

/// @nodoc
abstract mixin class _$LearningPathCopyWith<$Res> implements $LearningPathCopyWith<$Res> {
  factory _$LearningPathCopyWith(_LearningPath value, $Res Function(_LearningPath) _then) = __$LearningPathCopyWithImpl;
@override @useResult
$Res call({
 LearningPathId id, ProgrammingLanguage language, String titleEn, String titleEs, String descriptionEn, String descriptionEs, String tagEn, String tagEs, List<Lesson> lessons
});


@override $LearningPathIdCopyWith<$Res> get id;

}
/// @nodoc
class __$LearningPathCopyWithImpl<$Res>
    implements _$LearningPathCopyWith<$Res> {
  __$LearningPathCopyWithImpl(this._self, this._then);

  final _LearningPath _self;
  final $Res Function(_LearningPath) _then;

/// Create a copy of LearningPath
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? language = null,Object? titleEn = null,Object? titleEs = null,Object? descriptionEn = null,Object? descriptionEs = null,Object? tagEn = null,Object? tagEs = null,Object? lessons = null,}) {
  return _then(_LearningPath(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as LearningPathId,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as ProgrammingLanguage,titleEn: null == titleEn ? _self.titleEn : titleEn // ignore: cast_nullable_to_non_nullable
as String,titleEs: null == titleEs ? _self.titleEs : titleEs // ignore: cast_nullable_to_non_nullable
as String,descriptionEn: null == descriptionEn ? _self.descriptionEn : descriptionEn // ignore: cast_nullable_to_non_nullable
as String,descriptionEs: null == descriptionEs ? _self.descriptionEs : descriptionEs // ignore: cast_nullable_to_non_nullable
as String,tagEn: null == tagEn ? _self.tagEn : tagEn // ignore: cast_nullable_to_non_nullable
as String,tagEs: null == tagEs ? _self.tagEs : tagEs // ignore: cast_nullable_to_non_nullable
as String,lessons: null == lessons ? _self._lessons : lessons // ignore: cast_nullable_to_non_nullable
as List<Lesson>,
  ));
}

/// Create a copy of LearningPath
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LearningPathIdCopyWith<$Res> get id {
  
  return $LearningPathIdCopyWith<$Res>(_self.id, (value) {
    return _then(_self.copyWith(id: value));
  });
}
}

// dart format on
