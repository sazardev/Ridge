import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/persistence/drift/app_database.dart';
import 'package:ridge/core/persistence/drift/database_provider.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/data_management/application/usecases/reset_all_lessons_usecase.dart';
import 'package:ridge/features/data_management/application/usecases/reset_lesson_usecase.dart';
import 'package:ridge/features/data_management/application/usecases/wipe_all_data_usecase.dart';
import 'package:ridge/features/data_management/domain/repositories/data_reset_repository.dart';
import 'package:ridge/features/data_management/infrastructure/data_reset_dao.dart';
import 'package:ridge/features/data_management/infrastructure/data_reset_repository_impl.dart';
import 'package:ridge/features/learning_paths/domain/value_objects/lesson_id.dart';
import 'package:ridge/features/learning_paths/presentation/providers/learning_paths_providers.dart';
import 'package:ridge/features/lock/presentation/providers/lock_providers.dart';
import 'package:ridge/features/profile/presentation/providers/profile_providers.dart';
import 'package:ridge/features/progression/presentation/providers/progression_providers.dart';
import 'package:ridge/features/settings/presentation/providers/settings_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'data_management_providers.g.dart';

/// Provides the [DataResetDao] bound to the shared [AppDatabase].
@Riverpod(keepAlive: true)
DataResetDao dataResetDao(Ref ref) {
  return ref.watch(appDatabaseProvider).dataResetDao;
}

/// Provides the [DataResetRepository] implementation used across the app.
@Riverpod(keepAlive: true)
DataResetRepository dataResetRepository(Ref ref) {
  return DataResetRepositoryImpl(ref.watch(dataResetDaoProvider));
}

/// Provides the [ResetLessonUseCase].
@riverpod
ResetLessonUseCase resetLessonUseCase(Ref ref) {
  return ResetLessonUseCase(ref.watch(dataResetRepositoryProvider));
}

/// Provides the [ResetAllLessonsUseCase].
@riverpod
ResetAllLessonsUseCase resetAllLessonsUseCase(Ref ref) {
  return ResetAllLessonsUseCase(ref.watch(dataResetRepositoryProvider));
}

/// Provides the [WipeAllDataUseCase].
@riverpod
WipeAllDataUseCase wipeAllDataUseCase(Ref ref) {
  return WipeAllDataUseCase(ref.watch(dataResetRepositoryProvider));
}

/// Composes the Settings screen's "danger zone" actions: each one is more
/// than a single repository call — a reset must also refresh the derived
/// caches it just invalidated, and a full wipe must also disarm the app
/// lock (a stale `appLockEnabled: true` with no PIN left behind would
/// strand the very next launch on an unpassable lock screen). Mirrors how
/// `practice_session_controller.dart` composes `progression`/
/// `learning_paths`/`achievements` use cases after finishing a session,
/// rather than folding that orchestration into any one repository.
///
/// `keepAlive: true` on purpose — every method here awaits several
/// steps (a repository call, then one or two recomputes), and an
/// autoDispose controller can be torn down mid-flight the moment
/// nothing is left `ref.watch`ing it (a widget's `ref.read(...)` alone
/// doesn't keep it alive across an async gap), which throws on the next
/// `ref.read` inside the very method that's still running. Mirrors
/// every other stateful controller in the app
/// (`ActiveProfileController`, `SettingsController`,
/// `ProgressSnapshotController`, ...) — all `keepAlive: true` for the
/// same reason.
@Riverpod(keepAlive: true)
class DataManagementController extends _$DataManagementController {
  @override
  void build() {}

  /// Deletes every attempt at [lessonId], then recomputes lesson progress
  /// and the XP/streak/weakness snapshot so nothing derived is left
  /// stale.
  Future<Result<void, AppFailure>> resetLesson(LessonId lessonId) async {
    final profileId = ref.read(activeProfileControllerProvider).value?.id;
    if (profileId == null) {
      return const Result.err(NotFoundFailure('No guest profile found'));
    }

    final result = await ref.read(resetLessonUseCaseProvider)(
      profileId: profileId,
      lessonId: lessonId,
    );
    if (result.isErr) return result;

    await ref.read(recomputeLessonProgressUseCaseProvider)(profileId);
    await ref.read(recomputeProgressSnapshotUseCaseProvider)(
      profileId: profileId,
      now: DateTime.now(),
    );
    return result;
  }

  /// Deletes every attempt at every lesson, then recomputes lesson
  /// progress and the XP/streak/weakness snapshot.
  Future<Result<void, AppFailure>> resetAllLessons() async {
    final profileId = ref.read(activeProfileControllerProvider).value?.id;
    if (profileId == null) {
      return const Result.err(NotFoundFailure('No guest profile found'));
    }

    final result = await ref.read(resetAllLessonsUseCaseProvider)(profileId);
    if (result.isErr) return result;

    await ref.read(recomputeLessonProgressUseCaseProvider)(profileId);
    await ref.read(recomputeProgressSnapshotUseCaseProvider)(
      profileId: profileId,
      now: DateTime.now(),
    );
    return result;
  }

  /// Disarms the app lock (clears the PIN and flips the setting off —
  /// see this class's doc), then wipes every table, including the Guest
  /// Profile. The router's own `hasGuestProfileProvider` redirect takes
  /// it from there, back to `/profile/create`.
  Future<Result<void, AppFailure>> wipeAllData() async {
    await ref.read(clearPinUseCaseProvider)();
    await ref
        .read(settingsControllerProvider.notifier)
        .setAppLockEnabled(value: false);
    return await ref.read(wipeAllDataUseCaseProvider)();
  }
}
