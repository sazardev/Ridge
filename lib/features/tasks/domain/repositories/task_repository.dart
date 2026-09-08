import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/tasks/domain/entities/task.dart';
import 'package:just_in_time/features/tasks/domain/value_objects/task_id.dart';

abstract interface class TaskRepository {
  Stream<List<Task>> watchAll();

  Future<Result<void, AppFailure>> upsert(Task task);

  Future<Result<void, AppFailure>> delete(TaskId id);
}
