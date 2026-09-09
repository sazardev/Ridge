import 'package:drift/drift.dart';

/// Drift table for one finished practice session — mirrors
/// `TypingSession` column-for-column (see the project plan's schema).
/// Indices (category+difficulty, snippet+revision, recency) are created
/// alongside this table in `AppDatabase`'s migration, since drift's
/// `Table` API here doesn't need them declared inline.
@DataClassName('TypingSessionRow')
class TypingSessions extends Table {
  /// The `TypingSessionId` value.
  TextColumn get id => text()();

  /// The `ProfileId` of whoever ran this session.
  TextColumn get profileId => text()();

  /// `PracticeMode`'s discriminator name (`zen`, `sprint`, `precision`,
  /// `learningRouteLesson`).
  TextColumn get mode => text()();

  /// The `learning_paths` lesson id, only set when [mode] is
  /// `learningRouteLesson`.
  TextColumn get lessonId => text().nullable()();

  /// The `SnippetId` typed during this session.
  TextColumn get snippetId => text()();

  /// The snippet revision typed, so historical sessions stay
  /// interpretable even after the snippet is corrected.
  IntColumn get snippetRevision => integer()();

  /// The snippet's `ContentCategory`, denormalized for query convenience.
  TextColumn get category => text()();

  /// The snippet's `Difficulty`, denormalized for query convenience.
  TextColumn get difficulty => text()();

  /// When this session started, as UTC microseconds since epoch.
  IntColumn get startedAtUtcMicros => integer()();

  /// Total elapsed session time, in microseconds.
  IntColumn get durationMicros => integer()();

  /// Raw (all keystrokes) speed, in characters per minute.
  RealColumn get rawSpeedCpm => real()();

  /// Net (correct-only) speed, in characters per minute.
  RealColumn get netSpeedCpm => real()();

  /// Percentage of characters correct on the first try.
  RealColumn get accuracyPct => real()();

  /// 0-100 rhythm-uniformity score; higher is more consistent.
  RealColumn get consistencyScore => real()();

  /// Longest run of consecutive correct-first-try characters.
  IntColumn get maxStreak => integer()();

  /// CPM during the first third of the session.
  RealColumn get fatigueFirstThirdCpm => real()();

  /// CPM during the middle third of the session.
  RealColumn get fatigueMiddleThirdCpm => real()();

  /// CPM during the last third of the session.
  RealColumn get fatigueLastThirdCpm => real()();

  /// Ratio of the less-used hand to the more-used hand (thumb excluded).
  RealColumn get handBalanceRatio => real()();

  /// Pass/fail outcome; always `null` for Zen sessions.
  BoolColumn get passed => boolean().nullable()();

  /// XP granted for this session — written as `0` by `practice`, then
  /// backfilled with the real value by `progression`'s
  /// `RecomputeProgressSnapshotUseCase` right after this row is written.
  IntColumn get xpAwarded => integer().withDefault(const Constant(0))();

  /// Whether this was the first-ever completion of this snippet id —
  /// written as `false` by `practice`, then backfilled by `progression`,
  /// same as [xpAwarded].
  BoolColumn get isFirstCompletion =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
