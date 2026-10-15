import 'dart:async';

import 'package:ridge/core/persistence/drift/app_database.dart';
import 'package:ridge/core/persistence/drift/database_provider.dart';
import 'package:ridge/features/content/presentation/providers/content_providers.dart';
import 'package:ridge/features/learning_paths/application/usecases/get_learning_paths_usecase.dart';
import 'package:ridge/features/learning_paths/application/usecases/recompute_lesson_progress_usecase.dart';
import 'package:ridge/features/learning_paths/domain/entities/lesson_status.dart';
import 'package:ridge/features/learning_paths/domain/repositories/learning_path_repository.dart';
import 'package:ridge/features/learning_paths/domain/repositories/lesson_progress_repository.dart';
import 'package:ridge/features/learning_paths/domain/services/lesson_status_resolver.dart';
import 'package:ridge/features/learning_paths/domain/value_objects/learning_path_id.dart';
import 'package:ridge/features/learning_paths/domain/value_objects/lesson_id.dart';
import 'package:ridge/features/learning_paths/infrastructure/learning_path_repository_impl.dart';
import 'package:ridge/features/learning_paths/infrastructure/lesson_progress_dao.dart';
import 'package:ridge/features/learning_paths/infrastructure/lesson_progress_repository_impl.dart';
import 'package:ridge/features/learning_paths/presentation/providers/active_language_providers.dart';
import 'package:ridge/features/profile/presentation/providers/profile_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'learning_paths_providers.g.dart';

/// Provides the [LessonProgressDao] bound to the shared [AppDatabase].
@Riverpod(keepAlive: true)
LessonProgressDao lessonProgressDao(Ref ref) {
  return ref.watch(appDatabaseProvider).lessonProgressDao;
}

/// Provides the [LearningPathRepository] implementation used across the
/// app.
@Riverpod(keepAlive: true)
LearningPathRepository learningPathRepository(Ref ref) {
  return LearningPathRepositoryImpl();
}

/// Provides the [LessonProgressRepository] implementation used across the
/// app.
@Riverpod(keepAlive: true)
LessonProgressRepository lessonProgressRepository(Ref ref) {
  return LessonProgressRepositoryImpl(ref.watch(lessonProgressDaoProvider));
}

/// Provides the [GetLearningPathsUseCase] for the Learning Paths screen.
@riverpod
GetLearningPathsUseCase getLearningPathsUseCase(Ref ref) {
  return GetLearningPathsUseCase(
    ref.watch(learningPathRepositoryProvider),
    ref.watch(snippetRepositoryProvider),
  );
}

/// Provides the [RecomputeLessonProgressUseCase], fired right after every
/// finished `practice` session tagged with a lesson id.
@riverpod
RecomputeLessonProgressUseCase recomputeLessonProgressUseCase(Ref ref) {
  return RecomputeLessonProgressUseCase(
    ref.watch(learningPathRepositoryProvider),
    ref.watch(lessonProgressRepositoryProvider),
  );
}

/// Exposes every bundled path, joined against `content`, reactively.
@Riverpod(keepAlive: true)
class LearningPathsController extends _$LearningPathsController {
  @override
  Future<List<LearningPathOverview>> build() async {
    // The joined view needs `content`'s snippets already in the DB — but
    // that catalog is seeded asynchronously at app startup, so this
    // future can resolve empty before the seed lands and would otherwise
    // stay empty forever (a `Future` never recomputes on its own; only a
    // hot reload was masking it). Watching the reactive catalog
    // recomputes this the moment the rows arrive — same self-healing
    // guarantee `FreePracticeScreen` already gets from that stream.
    final catalog = ref.watch(snippetCatalogControllerProvider);
    if (catalog.value == null || catalog.value!.isEmpty) return const [];

    final result = await ref.watch(getLearningPathsUseCaseProvider)();
    return result.valueOrNull ?? const [];
  }
}

/// Exposes the active profile's cached lesson statuses reactively,
/// recomputing on first load as a safety net for anything a prior
/// fire-and-forget recompute might have missed (mirrors `progression`'s
/// `ProgressSnapshotController`).
@Riverpod(keepAlive: true)
class LessonProgressController extends _$LessonProgressController {
  @override
  Stream<Map<LessonId, LessonStatus>> build() {
    final profile = ref.watch(activeProfileControllerProvider).value;
    if (profile == null) return const Stream.empty();

    unawaited(ref.read(recomputeLessonProgressUseCaseProvider)(profile.id));

    return ref
        .watch(lessonProgressRepositoryProvider)
        .watchProgress(profile.id)
        .map(
          (records) => {
            for (final record in records) record.lessonId: record.status,
          },
        );
  }
}

/// The Practice-tab "pick up where you left off" card's data: the active
/// language's path the profile most recently worked on that still has an
/// unlocked next lesson, plus that lesson's index within the path.
typedef ResumeCourseCardData = ({
  LearningPathOverview overview,
  int nextLessonIndex,
});

/// Resolves [ResumeCourseCardData] for the active profile — `null` while
/// there's no active language, no bundled paths for it, or every path is
/// already completed.
@riverpod
Future<ResumeCourseCardData?> resumeCourse(Ref ref) async {
  final profile = ref.watch(activeProfileControllerProvider).value;
  if (profile == null) return null;
  final language = ref.watch(activeLanguageControllerProvider).value;
  if (language == null) return null;

  final overviews = await ref.watch(learningPathsControllerProvider.future);
  final paths = [
    for (final overview in overviews)
      if (overview.path.language == language) overview,
  ];
  if (paths.isEmpty) return null;

  final progress =
      ref.watch(lessonProgressControllerProvider).value ??
      const <LessonId, LessonStatus>{};
  // "Most recently worked on" = the latest lesson completion in the path.
  // The reactive status map has no timestamps, so this one extra read of
  // the same cache is what makes the choice stable across sessions.
  final records = await ref
      .watch(lessonProgressRepositoryProvider)
      .watchProgress(profile.id)
      .first;
  final lastCompletedByPath = <LearningPathId, DateTime>{};
  for (final record in records) {
    final completedAt = record.completedAt;
    if (completedAt == null) continue;
    final current = lastCompletedByPath[record.pathId];
    if (current == null || completedAt.isAfter(current)) {
      lastCompletedByPath[record.pathId] = completedAt;
    }
  }

  ResumeCourseCardData? best;
  for (final overview in paths) {
    final nextIndex = LessonStatusResolver.findNextIndex(
      overview.path.lessons,
      progress,
    );
    if (nextIndex == null) continue;
    final candidate = (overview: overview, nextLessonIndex: nextIndex);
    if (best == null) {
      best = candidate;
      continue;
    }
    final lastCompleted = lastCompletedByPath[overview.path.id];
    final bestLastCompleted = lastCompletedByPath[best.overview.path.id];
    if (lastCompleted != null &&
        (bestLastCompleted == null ||
            lastCompleted.isAfter(bestLastCompleted))) {
      best = candidate;
    }
  }
  return best;
}
