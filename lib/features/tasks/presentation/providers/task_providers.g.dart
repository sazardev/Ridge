// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(taskLocalDataSource)
final taskLocalDataSourceProvider = TaskLocalDataSourceProvider._();

final class TaskLocalDataSourceProvider
    extends
        $FunctionalProvider<
          TaskLocalDataSource,
          TaskLocalDataSource,
          TaskLocalDataSource
        >
    with $Provider<TaskLocalDataSource> {
  TaskLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskLocalDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<TaskLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TaskLocalDataSource create(Ref ref) {
    return taskLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskLocalDataSource>(value),
    );
  }
}

String _$taskLocalDataSourceHash() =>
    r'd26b004d490f5dff91913589d60d2dc8aee83c8a';

@ProviderFor(taskRepository)
final taskRepositoryProvider = TaskRepositoryProvider._();

final class TaskRepositoryProvider
    extends $FunctionalProvider<TaskRepository, TaskRepository, TaskRepository>
    with $Provider<TaskRepository> {
  TaskRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskRepositoryHash();

  @$internal
  @override
  $ProviderElement<TaskRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TaskRepository create(Ref ref) {
    return taskRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskRepository>(value),
    );
  }
}

String _$taskRepositoryHash() => r'b2cad6b7f697aa4e6edd5ce29dbf68e0d14699e2';

@ProviderFor(watchTasksUseCase)
final watchTasksUseCaseProvider = WatchTasksUseCaseProvider._();

final class WatchTasksUseCaseProvider
    extends
        $FunctionalProvider<
          WatchTasksUseCase,
          WatchTasksUseCase,
          WatchTasksUseCase
        >
    with $Provider<WatchTasksUseCase> {
  WatchTasksUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchTasksUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchTasksUseCaseHash();

  @$internal
  @override
  $ProviderElement<WatchTasksUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WatchTasksUseCase create(Ref ref) {
    return watchTasksUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WatchTasksUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WatchTasksUseCase>(value),
    );
  }
}

String _$watchTasksUseCaseHash() => r'd1afe71f10a957632f72572664508cff657ce5f9';

@ProviderFor(createTaskUseCase)
final createTaskUseCaseProvider = CreateTaskUseCaseProvider._();

final class CreateTaskUseCaseProvider
    extends
        $FunctionalProvider<
          CreateTaskUseCase,
          CreateTaskUseCase,
          CreateTaskUseCase
        >
    with $Provider<CreateTaskUseCase> {
  CreateTaskUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createTaskUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createTaskUseCaseHash();

  @$internal
  @override
  $ProviderElement<CreateTaskUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CreateTaskUseCase create(Ref ref) {
    return createTaskUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateTaskUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateTaskUseCase>(value),
    );
  }
}

String _$createTaskUseCaseHash() => r'30da0aa1ce95a757cc504b8de1932976d085c5bd';

@ProviderFor(updateTaskUseCase)
final updateTaskUseCaseProvider = UpdateTaskUseCaseProvider._();

final class UpdateTaskUseCaseProvider
    extends
        $FunctionalProvider<
          UpdateTaskUseCase,
          UpdateTaskUseCase,
          UpdateTaskUseCase
        >
    with $Provider<UpdateTaskUseCase> {
  UpdateTaskUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateTaskUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateTaskUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateTaskUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpdateTaskUseCase create(Ref ref) {
    return updateTaskUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateTaskUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateTaskUseCase>(value),
    );
  }
}

String _$updateTaskUseCaseHash() => r'0bb597a34acd235fa99e3f4c2664ce0ea238d890';

@ProviderFor(toggleTaskDoneUseCase)
final toggleTaskDoneUseCaseProvider = ToggleTaskDoneUseCaseProvider._();

final class ToggleTaskDoneUseCaseProvider
    extends
        $FunctionalProvider<
          ToggleTaskDoneUseCase,
          ToggleTaskDoneUseCase,
          ToggleTaskDoneUseCase
        >
    with $Provider<ToggleTaskDoneUseCase> {
  ToggleTaskDoneUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'toggleTaskDoneUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$toggleTaskDoneUseCaseHash();

  @$internal
  @override
  $ProviderElement<ToggleTaskDoneUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ToggleTaskDoneUseCase create(Ref ref) {
    return toggleTaskDoneUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ToggleTaskDoneUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ToggleTaskDoneUseCase>(value),
    );
  }
}

String _$toggleTaskDoneUseCaseHash() =>
    r'b118bb7f5dc43672d1dad9c0556d62914246c22b';

@ProviderFor(deleteTaskUseCase)
final deleteTaskUseCaseProvider = DeleteTaskUseCaseProvider._();

final class DeleteTaskUseCaseProvider
    extends
        $FunctionalProvider<
          DeleteTaskUseCase,
          DeleteTaskUseCase,
          DeleteTaskUseCase
        >
    with $Provider<DeleteTaskUseCase> {
  DeleteTaskUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteTaskUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteTaskUseCaseHash();

  @$internal
  @override
  $ProviderElement<DeleteTaskUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DeleteTaskUseCase create(Ref ref) {
    return deleteTaskUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeleteTaskUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeleteTaskUseCase>(value),
    );
  }
}

String _$deleteTaskUseCaseHash() => r'4b3751dcee983d369eeee3f47008e34cc87cb09b';

@ProviderFor(TasksController)
final tasksControllerProvider = TasksControllerProvider._();

final class TasksControllerProvider
    extends $StreamNotifierProvider<TasksController, List<Task>> {
  TasksControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tasksControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tasksControllerHash();

  @$internal
  @override
  TasksController create() => TasksController();
}

String _$tasksControllerHash() => r'074026a3bd3b7d36bfda71426c013618bc0ed276';

abstract class _$TasksController extends $StreamNotifier<List<Task>> {
  Stream<List<Task>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Task>>, List<Task>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Task>>, List<Task>>,
              AsyncValue<List<Task>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(taskSections)
final taskSectionsProvider = TaskSectionsProvider._();

final class TaskSectionsProvider
    extends $FunctionalProvider<TaskSections, TaskSections, TaskSections>
    with $Provider<TaskSections> {
  TaskSectionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskSectionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskSectionsHash();

  @$internal
  @override
  $ProviderElement<TaskSections> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TaskSections create(Ref ref) {
    return taskSections(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskSections value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskSections>(value),
    );
  }
}

String _$taskSectionsHash() => r'900714b7bfab889e54e9870feda1b50d241f6632';
