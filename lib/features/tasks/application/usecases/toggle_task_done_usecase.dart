import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/tasks/domain/entities/task.dart';
import 'package:just_in_time/features/tasks/domain/repositories/task_repository.dart';

class ToggleTaskDoneUseCase {
  const new(this._repository);

  final TaskRepository _repository;

  Future<Result<void, AppFailure>> call(Task task) {
    return _repository.upsert(task.copyWith(isDone: !task.isDone));
  }
}
