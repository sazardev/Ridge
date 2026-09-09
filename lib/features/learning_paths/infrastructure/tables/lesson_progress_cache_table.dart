import 'package:drift/drift.dart';

/// Drift table caching one profile's per-lesson unlock/completion status
/// — rebuildable from `practice`'s `typing_sessions` at any time (SPEC.md
/// §5.7), never itself authoritative (mirrors `progression`'s cache
/// tables' design). Fully replaced (never incrementally patched) on
/// every `RecomputeLessonProgressUseCase` run, so this table's rows are
/// always the last full recompute's output.
@DataClassName('LessonProgressCacheRow')
class LessonProgressCache extends Table {
  /// The `ProfileId` this row belongs to.
  TextColumn get profileId => text()();

  /// The `LearningPathId` the lesson in this row belongs to.
  TextColumn get pathId => text()();

  /// The `LessonId` this row is about.
  TextColumn get lessonId => text()();

  /// `LessonStatus` enum name, stored as plain text.
  TextColumn get status => text()();

  /// The best accuracy ever recorded across every attempt at this
  /// lesson, or `null` if it's never been attempted.
  RealColumn get bestAccuracyPct => real().nullable()();

  /// When this lesson was first completed, as UTC microseconds since
  /// epoch, or `null` if it isn't completed yet.
  IntColumn get completedAtUtcMicros => integer().nullable()();

  @override
  Set<Column> get primaryKey => {profileId, lessonId};
}
