import 'dart:async';

import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/tasks/domain/entities/task.dart';
import 'package:just_in_time/features/tasks/domain/repositories/task_repository.dart';
import 'package:just_in_time/features/tasks/domain/value_objects/task_id.dart';
import 'package:just_in_time/features/tasks/infrastructure/task_local_data_source.dart';
import 'package:just_in_time/features/tasks/infrastructure/task_mapper.dart';

class TaskRepositoryImpl implements TaskRepository {
  new(this._dataSource) {
    _controller = StreamController<List<Task>>.broadcast(
      onListen: () => _controller.add(List.unmodifiable(_current)),
    );
    unawaited(_hydrate());
  }

  final TaskLocalDataSource _dataSource;
  late final StreamController<List<Task>> _controller;
  List<Task> _current = [];

  Future<void> _hydrate() async {
    final dtos = await _dataSource.readAll();
    _current = dtos.map((d) => d.toDomain()).toList();
    _controller.add(List.unmodifiable(_current));
  }

  @override
  Stream<List<Task>> watchAll() => _controller.stream;

  @override
  Future<Result<void, AppFailure>> upsert(Task task) async {
    final previous = _current;
    final next = [..._current];
    final index = next.indexWhere((t) => t.id == task.id);
    if (index == -1) {
      next.add(task);
    } else {
      next[index] = task;
    }
    // Optimistic: apply in-memory and notify immediately, then persist.
    // Keeps swipe-to-dismiss and toggles feeling instant, and avoids a
    // Dismissible outliving its list item during the storage write.
    _current = next;
    _controller.add(List.unmodifiable(_current));
    try {
      await _dataSource.writeAll(next.map((t) => t.toDto()).toList());
      return const Result.ok(null);
    } on Exception catch (e) {
      _current = previous;
      _controller.add(List.unmodifiable(_current));
      return Result.err(StorageFailure('Could not save task', cause: e));
    }
  }

  @override
  Future<Result<void, AppFailure>> delete(TaskId id) async {
    final previous = _current;
    final next = _current.where((t) => t.id != id).toList();
    _current = next;
    _controller.add(List.unmodifiable(_current));
    try {
      await _dataSource.writeAll(next.map((t) => t.toDto()).toList());
      return const Result.ok(null);
    } on Exception catch (e) {
      _current = previous;
      _controller.add(List.unmodifiable(_current));
      return Result.err(StorageFailure('Could not delete task', cause: e));
    }
  }
}
