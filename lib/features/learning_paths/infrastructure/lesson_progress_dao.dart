import 'package:drift/drift.dart';

import 'package:ridge/core/persistence/drift/app_database.dart';
import 'package:ridge/features/learning_paths/infrastructure/tables/lesson_progress_cache_table.dart';
import 'package:ridge/features/practice/infrastructure/tables/typing_sessions_table.dart';

part 'lesson_progress_dao.g.dart';

/// `learning_paths`-owned queries issued directly against `practice`'s
/// [TypingSessions] table (an allowed infrastructure-to-infrastructure
/// import — mirrors `progression`'s `ProgressionDao`; see its class doc)
/// plus `learning_paths`' own [LessonProgressCache] table.
@DriftAccessor(tables: [TypingSessions, LessonProgressCache])
class LessonProgressDao extends DatabaseAccessor<AppDatabase>
    with _$LessonProgressDaoMixin {
  /// Creates the DAO bound to the shared [AppDatabase].
  new(super.attachedDatabase);

  /// Every one of [profileId]'s sessions tagged with a `learning_paths`
  /// lesson id, oldest first — passed or not.
  Future<List<TypingSessionRow>> getLessonSessions(String profileId) {
    return (select(typingSessions)
          ..where(
            (row) => row.profileId.equals(profileId) & row.lessonId.isNotNull(),
          )
          ..orderBy([(row) => OrderingTerm.asc(row.startedAtUtcMicros)]))
        .get();
  }

  /// Emits every cached [LessonProgressCache] row for [profileId], and
  /// every subsequent change.
  Stream<List<LessonProgressCacheRow>> watchProgressCache(String profileId) {
    return (select(
      lessonProgressCache,
    )..where((row) => row.profileId.equals(profileId))).watch();
  }

  /// Idempotently replaces every cached row for [profileId] with [rows],
  /// in one transaction — a full recompute's output always fully
  /// replaces whatever was cached before, never patched incrementally.
  Future<void> replaceProgressForProfile({
    required String profileId,
    required List<LessonProgressCacheCompanion> rows,
  }) {
    return transaction(() async {
      await (delete(
        lessonProgressCache,
      )..where((row) => row.profileId.equals(profileId))).go();
      if (rows.isNotEmpty) {
        await batch((batch) => batch.insertAll(lessonProgressCache, rows));
      }
    });
  }
}
