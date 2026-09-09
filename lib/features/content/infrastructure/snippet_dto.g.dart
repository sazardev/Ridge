// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'snippet_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SnippetDto _$SnippetDtoFromJson(Map<String, dynamic> json) => _SnippetDto(
  id: json['id'] as String,
  revision: (json['revision'] as num).toInt(),
  language: json['language'] as String,
  difficulty: json['difficulty'] as String,
  category: json['category'] as String,
  length: json['length'] as String,
  titleEn: json['titleEn'] as String,
  titleEs: json['titleEs'] as String,
  code: json['code'] as String,
  sourceAttribution: json['sourceAttribution'] as String,
  isActive: json['isActive'] as bool,
  explanationEn: json['explanationEn'] as String,
  explanationEs: json['explanationEs'] as String,
  tldrEn: json['tldrEn'] as String? ?? '',
  tldrEs: json['tldrEs'] as String? ?? '',
  symbolFocus:
      (json['symbolFocus'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
);

Map<String, dynamic> _$SnippetDtoToJson(_SnippetDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'revision': instance.revision,
      'language': instance.language,
      'difficulty': instance.difficulty,
      'category': instance.category,
      'length': instance.length,
      'titleEn': instance.titleEn,
      'titleEs': instance.titleEs,
      'code': instance.code,
      'sourceAttribution': instance.sourceAttribution,
      'isActive': instance.isActive,
      'explanationEn': instance.explanationEn,
      'explanationEs': instance.explanationEs,
      'tldrEn': instance.tldrEn,
      'tldrEs': instance.tldrEs,
      'symbolFocus': instance.symbolFocus,
    };
