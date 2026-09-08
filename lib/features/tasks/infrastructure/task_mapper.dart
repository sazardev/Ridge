import 'package:just_in_time/features/tasks/domain/entities/task.dart';
import 'package:just_in_time/features/tasks/domain/entities/task_priority.dart';
import 'package:just_in_time/features/tasks/domain/value_objects/task_id.dart';
import 'package:just_in_time/features/tasks/infrastructure/task_dto.dart';

extension TaskDtoMapper on TaskDto {
  Task toDomain() {
    return Task(
      id: TaskId(id),
      title: title,
      notes: notes,
      priority: TaskPriority.values.firstWhere(
        (p) => p.name == priority,
        orElse: () => TaskPriority.medium,
      ),
      dueAt: dueAt == null ? null : DateTime.parse(dueAt!),
      isDone: isDone,
      createdAt: DateTime.parse(createdAt),
    );
  }
}

extension TaskMapper on Task {
  TaskDto toDto() {
    return TaskDto(
      id: id.value,
      title: title,
      notes: notes,
      priority: priority.name,
      dueAt: dueAt?.toIso8601String(),
      isDone: isDone,
      createdAt: createdAt.toIso8601String(),
    );
  }
}
