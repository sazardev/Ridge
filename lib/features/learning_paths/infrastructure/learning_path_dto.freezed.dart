// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'learning_path_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LessonDto {

 String get id; String get snippetId; String get titleEn; String get titleEs; int get order;
/// Create a copy of LessonDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonDtoCopyWith<LessonDto> get copyWith => _$LessonDtoCopyWithImpl<LessonDto>(this as LessonDto, _$identity);

  /// Serializes this LessonDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LessonDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.snippetId, _this.snippetId) || other.snippetId == _this.snippetId)&&(identical(other.titleEn, _this.titleEn) || other.titleEn == _this.titleEn)&&(identical(other.titleEs, _this.titleEs) || other.titleEs == _this.titleEs)&&(identical(other.order, _this.order) || other.order == _this.order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LessonDto;
  return Object.hash(runtimeType,_this.id,_this.snippetId,_this.titleEn,_this.titleEs,_this.order);
}

@override
String toString() {
  final _this = this as LessonDto;
  return 'LessonDto(id: ${_this.id}, snippetId: ${_this.snippetId}, titleEn: ${_this.titleEn}, titleEs: ${_this.titleEs}, order: ${_this.order})';
}


}

/// @nodoc
abstract mixin class $LessonDtoCopyWith<$Res>  {
  factory $LessonDtoCopyWith(LessonDto value, $Res Function(LessonDto) _then) = _$LessonDtoCopyWithImpl;
@useResult
$Res call({
 String id, String snippetId, String titleEn, String titleEs, int order
});




}
/// @nodoc
class _$LessonDtoCopyWithImpl<$Res>
    implements $LessonDtoCopyWith<$Res> {
  _$LessonDtoCopyWithImpl(this._self, this._then);

  final LessonDto _self;
  final $Res Function(LessonDto) _then;

/// Create a copy of LessonDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? snippetId = null,Object? titleEn = null,Object? titleEs = null,Object? order = null,}) {
  return _then(LessonDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,snippetId: null == snippetId ? _self.snippetId : snippetId // ignore: cast_nullable_to_non_nullable
as String,titleEn: null == titleEn ? _self.titleEn : titleEn // ignore: cast_nullable_to_non_nullable
as String,titleEs: null == titleEs ? _self.titleEs : titleEs // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LessonDto].
extension LessonDtoPatterns on LessonDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonDto value)  $default,){
final _that = this;
switch (_that) {
case _LessonDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonDto value)?  $default,){
final _that = this;
switch (_that) {
case _LessonDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String snippetId,  String titleEn,  String titleEs,  int order)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonDto() when $default != null:
return $default(_that.id,_that.snippetId,_that.titleEn,_that.titleEs,_that.order);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String snippetId,  String titleEn,  String titleEs,  int order)  $default,) {final _that = this;
switch (_that) {
case _LessonDto():
return $default(_that.id,_that.snippetId,_that.titleEn,_that.titleEs,_that.order);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String snippetId,  String titleEn,  String titleEs,  int order)?  $default,) {final _that = this;
switch (_that) {
case _LessonDto() when $default != null:
return $default(_that.id,_that.snippetId,_that.titleEn,_that.titleEs,_that.order);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LessonDto implements LessonDto {
  const _LessonDto({required this.id, required this.snippetId, required this.titleEn, required this.titleEs, required this.order});
  factory _LessonDto.fromJson(Map<String, dynamic> json) => _$LessonDtoFromJson(json);

@override final  String id;
@override final  String snippetId;
@override final  String titleEn;
@override final  String titleEs;
@override final  int order;

/// Create a copy of LessonDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonDtoCopyWith<_LessonDto> get copyWith => __$LessonDtoCopyWithImpl<_LessonDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonDto&&(identical(other.id, id) || other.id == id)&&(identical(other.snippetId, snippetId) || other.snippetId == snippetId)&&(identical(other.titleEn, titleEn) || other.titleEn == titleEn)&&(identical(other.titleEs, titleEs) || other.titleEs == titleEs)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,snippetId,titleEn,titleEs,order);
}

@override
String toString() {
    return 'LessonDto(id: $id, snippetId: $snippetId, titleEn: $titleEn, titleEs: $titleEs, order: $order)';
}


}

/// @nodoc
abstract mixin class _$LessonDtoCopyWith<$Res> implements $LessonDtoCopyWith<$Res> {
  factory _$LessonDtoCopyWith(_LessonDto value, $Res Function(_LessonDto) _then) = __$LessonDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String snippetId, String titleEn, String titleEs, int order
});




}
/// @nodoc
class __$LessonDtoCopyWithImpl<$Res>
    implements _$LessonDtoCopyWith<$Res> {
  __$LessonDtoCopyWithImpl(this._self, this._then);

  final _LessonDto _self;
  final $Res Function(_LessonDto) _then;

/// Create a copy of LessonDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? snippetId = null,Object? titleEn = null,Object? titleEs = null,Object? order = null,}) {
  return _then(_LessonDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,snippetId: null == snippetId ? _self.snippetId : snippetId // ignore: cast_nullable_to_non_nullable
as String,titleEn: null == titleEn ? _self.titleEn : titleEn // ignore: cast_nullable_to_non_nullable
as String,titleEs: null == titleEs ? _self.titleEs : titleEs // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$LearningPathDto {

 String get id; String get language; String get titleEn; String get titleEs; String get descriptionEn; String get descriptionEs; String get tagEn; String get tagEs; List<LessonDto> get lessons;
/// Create a copy of LearningPathDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LearningPathDtoCopyWith<LearningPathDto> get copyWith => _$LearningPathDtoCopyWithImpl<LearningPathDto>(this as LearningPathDto, _$identity);

  /// Serializes this LearningPathDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LearningPathDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LearningPathDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.language, _this.language) || other.language == _this.language)&&(identical(other.titleEn, _this.titleEn) || other.titleEn == _this.titleEn)&&(identical(other.titleEs, _this.titleEs) || other.titleEs == _this.titleEs)&&(identical(other.descriptionEn, _this.descriptionEn) || other.descriptionEn == _this.descriptionEn)&&(identical(other.descriptionEs, _this.descriptionEs) || other.descriptionEs == _this.descriptionEs)&&(identical(other.tagEn, _this.tagEn) || other.tagEn == _this.tagEn)&&(identical(other.tagEs, _this.tagEs) || other.tagEs == _this.tagEs)&&const DeepCollectionEquality().equals(other.lessons, _this.lessons));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LearningPathDto;
  return Object.hash(runtimeType,_this.id,_this.language,_this.titleEn,_this.titleEs,_this.descriptionEn,_this.descriptionEs,_this.tagEn,_this.tagEs,const DeepCollectionEquality().hash(_this.lessons));
}

@override
String toString() {
  final _this = this as LearningPathDto;
  return 'LearningPathDto(id: ${_this.id}, language: ${_this.language}, titleEn: ${_this.titleEn}, titleEs: ${_this.titleEs}, descriptionEn: ${_this.descriptionEn}, descriptionEs: ${_this.descriptionEs}, tagEn: ${_this.tagEn}, tagEs: ${_this.tagEs}, lessons: ${_this.lessons})';
}


}

/// @nodoc
abstract mixin class $LearningPathDtoCopyWith<$Res>  {
  factory $LearningPathDtoCopyWith(LearningPathDto value, $Res Function(LearningPathDto) _then) = _$LearningPathDtoCopyWithImpl;
@useResult
$Res call({
 String id, String language, String titleEn, String titleEs, String descriptionEn, String descriptionEs, String tagEn, String tagEs, List<LessonDto> lessons
});




}
/// @nodoc
class _$LearningPathDtoCopyWithImpl<$Res>
    implements $LearningPathDtoCopyWith<$Res> {
  _$LearningPathDtoCopyWithImpl(this._self, this._then);

  final LearningPathDto _self;
  final $Res Function(LearningPathDto) _then;

/// Create a copy of LearningPathDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? language = null,Object? titleEn = null,Object? titleEs = null,Object? descriptionEn = null,Object? descriptionEs = null,Object? tagEn = null,Object? tagEs = null,Object? lessons = null,}) {
  return _then(LearningPathDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,titleEn: null == titleEn ? _self.titleEn : titleEn // ignore: cast_nullable_to_non_nullable
as String,titleEs: null == titleEs ? _self.titleEs : titleEs // ignore: cast_nullable_to_non_nullable
as String,descriptionEn: null == descriptionEn ? _self.descriptionEn : descriptionEn // ignore: cast_nullable_to_non_nullable
as String,descriptionEs: null == descriptionEs ? _self.descriptionEs : descriptionEs // ignore: cast_nullable_to_non_nullable
as String,tagEn: null == tagEn ? _self.tagEn : tagEn // ignore: cast_nullable_to_non_nullable
as String,tagEs: null == tagEs ? _self.tagEs : tagEs // ignore: cast_nullable_to_non_nullable
as String,lessons: null == lessons ? _self.lessons : lessons // ignore: cast_nullable_to_non_nullable
as List<LessonDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [LearningPathDto].
extension LearningPathDtoPatterns on LearningPathDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LearningPathDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LearningPathDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LearningPathDto value)  $default,){
final _that = this;
switch (_that) {
case _LearningPathDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LearningPathDto value)?  $default,){
final _that = this;
switch (_that) {
case _LearningPathDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String language,  String titleEn,  String titleEs,  String descriptionEn,  String descriptionEs,  String tagEn,  String tagEs,  List<LessonDto> lessons)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LearningPathDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String language,  String titleEn,  String titleEs,  String descriptionEn,  String descriptionEs,  String tagEn,  String tagEs,  List<LessonDto> lessons)  $default,) {final _that = this;
switch (_that) {
case _LearningPathDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String language,  String titleEn,  String titleEs,  String descriptionEn,  String descriptionEs,  String tagEn,  String tagEs,  List<LessonDto> lessons)?  $default,) {final _that = this;
switch (_that) {
case _LearningPathDto() when $default != null:
return $default(_that.id,_that.language,_that.titleEn,_that.titleEs,_that.descriptionEn,_that.descriptionEs,_that.tagEn,_that.tagEs,_that.lessons);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LearningPathDto implements LearningPathDto {
  const _LearningPathDto({required this.id, required this.language, required this.titleEn, required this.titleEs, required this.descriptionEn, required this.descriptionEs, required this.tagEn, required this.tagEs, required  List<LessonDto> lessons}): _lessons = lessons;
  factory _LearningPathDto.fromJson(Map<String, dynamic> json) => _$LearningPathDtoFromJson(json);

@override final  String id;
@override final  String language;
@override final  String titleEn;
@override final  String titleEs;
@override final  String descriptionEn;
@override final  String descriptionEs;
@override final  String tagEn;
@override final  String tagEs;
 final  List<LessonDto> _lessons;
@override List<LessonDto> get lessons {
  if (_lessons is EqualUnmodifiableListView) return _lessons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lessons);
}


/// Create a copy of LearningPathDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LearningPathDtoCopyWith<_LearningPathDto> get copyWith => __$LearningPathDtoCopyWithImpl<_LearningPathDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LearningPathDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LearningPathDto&&(identical(other.id, id) || other.id == id)&&(identical(other.language, language) || other.language == language)&&(identical(other.titleEn, titleEn) || other.titleEn == titleEn)&&(identical(other.titleEs, titleEs) || other.titleEs == titleEs)&&(identical(other.descriptionEn, descriptionEn) || other.descriptionEn == descriptionEn)&&(identical(other.descriptionEs, descriptionEs) || other.descriptionEs == descriptionEs)&&(identical(other.tagEn, tagEn) || other.tagEn == tagEn)&&(identical(other.tagEs, tagEs) || other.tagEs == tagEs)&&const DeepCollectionEquality().equals(other.lessons, _lessons));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,language,titleEn,titleEs,descriptionEn,descriptionEs,tagEn,tagEs,const DeepCollectionEquality().hash(_lessons));
}

@override
String toString() {
    return 'LearningPathDto(id: $id, language: $language, titleEn: $titleEn, titleEs: $titleEs, descriptionEn: $descriptionEn, descriptionEs: $descriptionEs, tagEn: $tagEn, tagEs: $tagEs, lessons: $lessons)';
}


}

/// @nodoc
abstract mixin class _$LearningPathDtoCopyWith<$Res> implements $LearningPathDtoCopyWith<$Res> {
  factory _$LearningPathDtoCopyWith(_LearningPathDto value, $Res Function(_LearningPathDto) _then) = __$LearningPathDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String language, String titleEn, String titleEs, String descriptionEn, String descriptionEs, String tagEn, String tagEs, List<LessonDto> lessons
});




}
/// @nodoc
class __$LearningPathDtoCopyWithImpl<$Res>
    implements _$LearningPathDtoCopyWith<$Res> {
  __$LearningPathDtoCopyWithImpl(this._self, this._then);

  final _LearningPathDto _self;
  final $Res Function(_LearningPathDto) _then;

/// Create a copy of LearningPathDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? language = null,Object? titleEn = null,Object? titleEs = null,Object? descriptionEn = null,Object? descriptionEs = null,Object? tagEn = null,Object? tagEs = null,Object? lessons = null,}) {
  return _then(_LearningPathDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,titleEn: null == titleEn ? _self.titleEn : titleEn // ignore: cast_nullable_to_non_nullable
as String,titleEs: null == titleEs ? _self.titleEs : titleEs // ignore: cast_nullable_to_non_nullable
as String,descriptionEn: null == descriptionEn ? _self.descriptionEn : descriptionEn // ignore: cast_nullable_to_non_nullable
as String,descriptionEs: null == descriptionEs ? _self.descriptionEs : descriptionEs // ignore: cast_nullable_to_non_nullable
as String,tagEn: null == tagEn ? _self.tagEn : tagEn // ignore: cast_nullable_to_non_nullable
as String,tagEs: null == tagEs ? _self.tagEs : tagEs // ignore: cast_nullable_to_non_nullable
as String,lessons: null == lessons ? _self._lessons : lessons // ignore: cast_nullable_to_non_nullable
as List<LessonDto>,
  ));
}


}

// dart format on
