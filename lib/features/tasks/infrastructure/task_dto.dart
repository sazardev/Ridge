import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_dto.freezed.dart';
part 'task_dto.g.dart';

@freezed
abstract class TaskDto with _$TaskDto {
  const factory({
    required String id,
    required String title,
    required String priority,
    required bool isDone,
    required String createdAt,
    String? notes,
    String? dueAt,
  }) = _TaskDto;

  factory fromJson(Map<String, Object?> json) => _$TaskDtoFromJson(json);
}
