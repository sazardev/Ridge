import 'package:flutter_test/flutter_test.dart';
import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/tasks/application/usecases/create_task_usecase.dart';
import 'package:just_in_time/features/tasks/domain/entities/task.dart';
import 'package:just_in_time/features/tasks/domain/entities/task_priority.dart';
import 'package:just_in_time/features/tasks/domain/repositories/task_repository.dart';
import 'package:just_in_time/features/tasks/domain/value_objects/task_id.dart';

/// In-memory fake standing in for the storage adapter — this is the whole
/// point of the port/adapter split: the use case is tested with zero
/// Flutter, zero platform channels, zero storage.
class _FakeTaskRepository implements TaskRepository {
  final List<Task> saved = [];

  @override
  Stream<List<Task>> watchAll() => Stream.value(saved);

  @override
  Future<Result<void, AppFailure>> upsert(Task task) async {
    saved.add(task);
    return const Result.ok(null);
  }

  @override
  Future<Result<void, AppFailure>> delete(TaskId id) async {
    saved.removeWhere((t) => t.id == id);
    return const Result.ok(null);
  }
}

void main() {
  group('CreateTaskUseCase', () {
    test('rejects a blank title without touching the repository', () async {
      final repository = _FakeTaskRepository();
      final useCase = CreateTaskUseCase(repository);

      final result = await useCase(title: '   ', priority: TaskPriority.medium);

      expect(result.isErr, isTrue);
      expect(result.failureOrNull, isA<ValidationFailure>());
      expect(repository.saved, isEmpty);
    });

    test('trims title/notes and persists a new task', () async {
      final repository = _FakeTaskRepository();
      final useCase = CreateTaskUseCase(repository);

      final result = await useCase(
        title: '  Ship the release  ',
        notes: '  ',
        priority: TaskPriority.high,
      );

      expect(result.isOk, isTrue);
      final task = result.valueOrNull!;
      expect(task.title, 'Ship the release');
      expect(task.notes, isNull);
      expect(task.isDone, isFalse);
      expect(repository.saved, [task]);
    });
  });
}
