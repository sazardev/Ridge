import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/persistence/preferences_provider.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/tasks/application/usecases/create_task_usecase.dart';
import 'package:just_in_time/features/tasks/application/usecases/delete_task_usecase.dart';
import 'package:just_in_time/features/tasks/application/usecases/toggle_task_done_usecase.dart';
import 'package:just_in_time/features/tasks/application/usecases/update_task_usecase.dart';
import 'package:just_in_time/features/tasks/application/usecases/watch_tasks_usecase.dart';
import 'package:just_in_time/features/tasks/domain/entities/task.dart';
import 'package:just_in_time/features/tasks/domain/entities/task_priority.dart';
import 'package:just_in_time/features/tasks/domain/repositories/task_repository.dart';
import 'package:just_in_time/features/tasks/domain/value_objects/task_id.dart';
import 'package:just_in_time/features/tasks/infrastructure/task_local_data_source.dart';
import 'package:just_in_time/features/tasks/infrastructure/task_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task_providers.g.dart';

@Riverpod(keepAlive: true)
TaskLocalDataSource taskLocalDataSource(Ref ref) {
  return TaskLocalDataSource(ref.watch(sharedPreferencesProvider));
}

@Riverpod(keepAlive: true)
TaskRepository taskRepository(Ref ref) {
  return TaskRepositoryImpl(ref.watch(taskLocalDataSourceProvider));
}

@riverpod
WatchTasksUseCase watchTasksUseCase(Ref ref) {
  return WatchTasksUseCase(ref.watch(taskRepositoryProvider));
}

@riverpod
CreateTaskUseCase createTaskUseCase(Ref ref) {
  return CreateTaskUseCase(ref.watch(taskRepositoryProvider));
}

@riverpod
UpdateTaskUseCase updateTaskUseCase(Ref ref) {
  return UpdateTaskUseCase(ref.watch(taskRepositoryProvider));
}

@riverpod
ToggleTaskDoneUseCase toggleTaskDoneUseCase(Ref ref) {
  return ToggleTaskDoneUseCase(ref.watch(taskRepositoryProvider));
}

@riverpod
DeleteTaskUseCase deleteTaskUseCase(Ref ref) {
  return DeleteTaskUseCase(ref.watch(taskRepositoryProvider));
}

@Riverpod(keepAlive: true)
class TasksController extends _$TasksController {
  @override
  Stream<List<Task>> build() => ref.watch(watchTasksUseCaseProvider)();

  Future<Result<Task, AppFailure>> create({
    required String title,
    required TaskPriority priority,
    String? notes,
    DateTime? dueAt,
  }) {
    return ref.read(createTaskUseCaseProvider)(
      title: title,
      notes: notes,
      priority: priority,
      dueAt: dueAt,
    );
  }

  Future<void> updateTask(Task task) =>
      ref.read(updateTaskUseCaseProvider)(task);

  Future<void> toggleDone(Task task) =>
      ref.read(toggleTaskDoneUseCaseProvider)(task);

  Future<void> delete(TaskId id) => ref.read(deleteTaskUseCaseProvider)(id);
}

/// Tasks grouped for display — derived, read-only, recomputed whenever the
/// underlying list changes. A record instead of a bespoke class since it's
/// pure shape with no behavior.
typedef TaskSections = ({
  List<Task> overdue,
  List<Task> today,
  List<Task> upcoming,
  List<Task> done,
});

@riverpod
TaskSections taskSections(Ref ref) {
  final tasks = ref.watch(tasksControllerProvider).value ?? const [];
  final now = DateTime.now();
  final startOfToday = DateTime(now.year, now.month, now.day);
  final startOfTomorrow = startOfToday.add(const Duration(days: 1));

  final overdue = <Task>[];
  final today = <Task>[];
  final upcoming = <Task>[];
  final done = <Task>[];

  for (final task in tasks) {
    if (task.isDone) {
      done.add(task);
      continue;
    }
    final dueAt = task.dueAt;
    if (dueAt == null) {
      upcoming.add(task);
    } else if (dueAt.isBefore(startOfToday)) {
      overdue.add(task);
    } else if (dueAt.isBefore(startOfTomorrow)) {
      today.add(task);
    } else {
      upcoming.add(task);
    }
  }

  int byDueDate(Task a, Task b) {
    final aDue = a.dueAt;
    final bDue = b.dueAt;
    if (aDue == null && bDue == null) return a.createdAt.compareTo(b.createdAt);
    if (aDue == null) return 1;
    if (bDue == null) return -1;
    return aDue.compareTo(bDue);
  }

  overdue.sort(byDueDate);
  today.sort(byDueDate);
  upcoming.sort(byDueDate);
  done.sort((a, b) => b.createdAt.compareTo(a.createdAt));

  return (overdue: overdue, today: today, upcoming: upcoming, done: done);
}
