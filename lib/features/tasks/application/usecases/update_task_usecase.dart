import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/tasks/domain/entities/task.dart';
import 'package:just_in_time/features/tasks/domain/repositories/task_repository.dart';

class UpdateTaskUseCase {
  const new(this._repository);

  final TaskRepository _repository;

  Future<Result<void, AppFailure>> call(Task task) {
    if (task.title.trim().isEmpty) {
      return Future.value(
        const Result.err(ValidationFailure('Title cannot be empty')),
      );
    }
    return _repository.upsert(task);
  }
}
