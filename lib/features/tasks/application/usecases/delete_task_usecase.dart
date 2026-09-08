import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/tasks/domain/repositories/task_repository.dart';
import 'package:just_in_time/features/tasks/domain/value_objects/task_id.dart';

class DeleteTaskUseCase {
  const new(this._repository);

  final TaskRepository _repository;

  Future<Result<void, AppFailure>> call(TaskId id) => _repository.delete(id);
}
