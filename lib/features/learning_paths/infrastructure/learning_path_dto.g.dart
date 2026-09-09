// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_path_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LessonDto _$LessonDtoFromJson(Map<String, dynamic> json) => _LessonDto(
  id: json['id'] as String,
  snippetId: json['snippetId'] as String,
  titleEn: json['titleEn'] as String,
  titleEs: json['titleEs'] as String,
  order: (json['order'] as num).toInt(),
);

Map<String, dynamic> _$LessonDtoToJson(_LessonDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'snippetId': instance.snippetId,
      'titleEn': instance.titleEn,
      'titleEs': instance.titleEs,
      'order': instance.order,
    };

_LearningPathDto _$LearningPathDtoFromJson(Map<String, dynamic> json) =>
    _LearningPathDto(
      id: json['id'] as String,
      language: json['language'] as String,
      titleEn: json['titleEn'] as String,
      titleEs: json['titleEs'] as String,
      descriptionEn: json['descriptionEn'] as String,
      descriptionEs: json['descriptionEs'] as String,
      lessons: (json['lessons'] as List<dynamic>)
          .map((e) => LessonDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LearningPathDtoToJson(_LearningPathDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'language': instance.language,
      'titleEn': instance.titleEn,
      'titleEs': instance.titleEs,
      'descriptionEn': instance.descriptionEn,
      'descriptionEs': instance.descriptionEs,
      'lessons': instance.lessons,
    };
