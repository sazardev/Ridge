import 'package:drift/drift.dart';

/// Drift table caching one profile's fully recomputed XP/level/streak/
/// weakness snapshot — rebuildable from `typing_sessions`/
/// `keystroke_events` at any time, never itself authoritative (see the
/// project plan's cache-table design). [weaknessReportJson] stores the
/// nested ranked-lists shape as JSON text rather than normalized rows,
/// since it's never queried at the SQL level — only ever read back
/// wholesale for display, exactly like a cache entry should be.
@DataClassName('ProgressSnapshotCacheRow')
class ProgressSnapshotCache extends Table {
  /// The `ProfileId` this snapshot belongs to — one row per profile.
  TextColumn get profileId => text()();

  /// Lifetime XP total.
  IntColumn get totalXp => integer()();

  /// Current account level.
  IntColumn get level => integer()();

  /// The XP threshold the current level started at.
  IntColumn get xpAtCurrentLevel => integer()();

  /// The XP threshold the next level requires.
  IntColumn get xpForNextLevel => integer()();

  /// Consecutive local-calendar days with at least one finished session.
  IntColumn get currentStreakDays => integer()();

  /// JSON-encoded `WeaknessReportDto` — see this table's class doc.
  TextColumn get weaknessReportJson => text()();

  /// When this snapshot was computed, as UTC microseconds since epoch.
  IntColumn get computedAtUtcMicros => integer()();

  @override
  Set<Column> get primaryKey => {profileId};
}
