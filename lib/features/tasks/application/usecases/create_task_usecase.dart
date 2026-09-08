import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/tasks/domain/entities/task.dart';
import 'package:just_in_time/features/tasks/domain/entities/task_priority.dart';
import 'package:just_in_time/features/tasks/domain/repositories/task_repository.dart';
import 'package:just_in_time/features/tasks/domain/value_objects/task_id.dart';

class CreateTaskUseCase {
  const new(this._repository);

  final TaskRepository _repository;

  Future<Result<Task, AppFailure>> call({
    required String title,
    required TaskPriority priority,
    String? notes,
    DateTime? dueAt,
  }) async {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      return const Result.err(ValidationFailure('Title cannot be empty'));
    }

    final trimmedNotes = notes?.trim();
    final task = Task(
      id: TaskId.generate(),
      title: trimmedTitle,
      notes: (trimmedNotes == null || trimmedNotes.isEmpty)
          ? null
          : trimmedNotes,
      priority: priority,
      dueAt: dueAt,
      isDone: false,
      createdAt: DateTime.now(),
    );

    final result = await _repository.upsert(task);
    return result.fold<Result<Task, AppFailure>>(
      (_) => Result.ok(task),
      Result.err,
    );
  }
}
