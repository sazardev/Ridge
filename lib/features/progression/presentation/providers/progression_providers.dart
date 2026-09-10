import 'dart:async';

import 'package:just_in_time/core/persistence/drift/app_database.dart';
import 'package:just_in_time/core/persistence/drift/database_provider.dart';
import 'package:just_in_time/features/content/domain/entities/content_category.dart';
import 'package:just_in_time/features/content/domain/entities/snippet.dart';
import 'package:just_in_time/features/content/domain/value_objects/snippet_id.dart';
import 'package:just_in_time/features/content/presentation/providers/content_providers.dart';
import 'package:just_in_time/features/profile/presentation/providers/profile_providers.dart';
import 'package:just_in_time/features/progression/application/usecases/get_personal_history_comparison_usecase.dart';
import 'package:just_in_time/features/progression/application/usecases/get_recommended_snippet_usecase.dart';
import 'package:just_in_time/features/progression/application/usecases/recompute_progress_snapshot_usecase.dart';
import 'package:just_in_time/features/progression/domain/entities/personal_history_comparison.dart';
import 'package:just_in_time/features/progression/domain/entities/progress_snapshot.dart';
import 'package:just_in_time/features/progression/domain/repositories/progression_repository.dart';
import 'package:just_in_time/features/progression/infrastructure/progression_dao.dart';
import 'package:just_in_time/features/progression/infrastructure/progression_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'progression_providers.g.dart';

/// Provides the [ProgressionDao] bound to the shared [AppDatabase].
@Riverpod(keepAlive: true)
ProgressionDao progressionDao(Ref ref) {
  return ref.watch(appDatabaseProvider).progressionDao;
}

/// Provides the [ProgressionRepository] implementation used across the
/// app.
@Riverpod(keepAlive: true)
ProgressionRepository progressionRepository(Ref ref) {
  return ProgressionRepositoryImpl(ref.watch(progressionDaoProvider));
}

/// Provides the [RecomputeProgressSnapshotUseCase], fired right after
/// every finished `practice` session and again as a safety net when the
/// Progress screen first loads.
@riverpod
RecomputeProgressSnapshotUseCase recomputeProgressSnapshotUseCase(Ref ref) {
  return RecomputeProgressSnapshotUseCase(
    ref.watch(progressionRepositoryProvider),
  );
}

/// Provides the [GetRecommendedSnippetUseCase] for weakness-based
/// snippet recommendation (SPEC.md §3.3/§6.3).
@riverpod
GetRecommendedSnippetUseCase getRecommendedSnippetUseCase(Ref ref) {
  return GetRecommendedSnippetUseCase(
    ref.watch(progressionRepositoryProvider),
    ref.watch(snippetRepositoryProvider),
  );
}

/// Provides the [GetPersonalHistoryComparisonUseCase] for the guest-only
/// "local leaderboard" (SPEC.md §7.1/§11.4).
@riverpod
GetPersonalHistoryComparisonUseCase getPersonalHistoryComparisonUseCase(
  Ref ref,
) {
  return GetPersonalHistoryComparisonUseCase(
    ref.watch(progressionRepositoryProvider),
  );
}

/// The active profile's personal-history comparison for [category] —
/// SPEC.md §7.1/§11.4's guest-only "local leaderboard".
@riverpod
Future<PersonalHistoryComparison> personalHistoryForCategory(
  Ref ref,
  ContentCategory category,
) async {
  final profile = ref.watch(activeProfileControllerProvider).value;
  if (profile == null) return PersonalHistoryComparison.empty;
  final result = await ref.read(getPersonalHistoryComparisonUseCaseProvider)(
    profileId: profile.id,
    category: category,
  );
  return result.valueOrNull ?? PersonalHistoryComparison.empty;
}

/// The catalog entry for [id], for `ActivityReportCard`'s exercise-level
/// lists — those store only a `SnippetId`, resolving its display title
/// is a presentation concern (mirrors `content`'s own id-only-in-domain
/// pattern). `null` if the snippet was deleted after being practiced or
/// the lookup fails.
@riverpod
Future<Snippet?> snippetById(Ref ref, SnippetId id) async {
  final result = await ref.watch(getSnippetByIdUseCaseProvider)(id);
  return result.valueOrNull;
}

/// Exposes the active profile's cached [ProgressSnapshot] reactively,
/// recomputing/backfilling on first load as a safety net for anything a
/// prior fire-and-forget recompute might have missed (e.g. an app crash
/// between a session finishing and that call completing) — cheap and
/// idempotent, so re-running it here is never wasted work.
@Riverpod(keepAlive: true)
class ProgressSnapshotController extends _$ProgressSnapshotController {
  @override
  Stream<ProgressSnapshot?> build() {
    final profile = ref.watch(activeProfileControllerProvider).value;
    if (profile == null) return const Stream.empty();

    unawaited(
      ref.read(recomputeProgressSnapshotUseCaseProvider)(
        profileId: profile.id,
        now: DateTime.now(),
      ),
    );

    return ref.watch(progressionRepositoryProvider).watchSnapshot(profile.id);
  }
}
