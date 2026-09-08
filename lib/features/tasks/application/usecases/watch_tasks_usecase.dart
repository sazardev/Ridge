import 'package:just_in_time/features/tasks/domain/entities/task.dart';
import 'package:just_in_time/features/tasks/domain/repositories/task_repository.dart';

class WatchTasksUseCase {
  const new(this._repository);

  final TaskRepository _repository;

  Stream<List<Task>> call() => _repository.watchAll();
}
