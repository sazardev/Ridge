// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskDto _$TaskDtoFromJson(Map<String, dynamic> json) => _TaskDto(
  id: json['id'] as String,
  title: json['title'] as String,
  notes: json['notes'] as String?,
  priority: json['priority'] as String,
  dueAt: json['dueAt'] as String?,
  isDone: json['isDone'] as bool,
  createdAt: json['createdAt'] as String,
);

Map<String, dynamic> _$TaskDtoToJson(_TaskDto instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'notes': instance.notes,
  'priority': instance.priority,
  'dueAt': instance.dueAt,
  'isDone': instance.isDone,
  'createdAt': instance.createdAt,
};
