import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:just_in_time/features/tasks/domain/entities/task_priority.dart';
import 'package:just_in_time/features/tasks/domain/value_objects/task_id.dart';

part 'task.freezed.dart';

@freezed
abstract class Task with _$Task {
  const factory({
    required TaskId id,
    required String title,
    required TaskPriority priority,
    required bool isDone,
    required DateTime createdAt,
    String? notes,
    DateTime? dueAt,
  }) = _Task;

  const new _();

  bool get isOverdue =>
      !isDone && dueAt != null && dueAt!.isBefore(DateTime.now());
}
