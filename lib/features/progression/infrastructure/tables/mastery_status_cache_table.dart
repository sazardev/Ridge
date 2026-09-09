import 'package:drift/drift.dart';

/// Drift table caching one profile's per-(category, difficulty) mastery
/// certification (SPEC.md §6.4) — rebuildable from `typing_sessions` at
/// any time, never itself authoritative.
@DataClassName('MasteryStatusCacheRow')
class MasteryStatusCache extends Table {
  /// The `ProfileId` this status belongs to.
  TextColumn get profileId => text()();

  /// `ContentCategory`'s enum name.
  TextColumn get category => text()();

  /// `Difficulty`'s enum name.
  TextColumn get difficulty => text()();

  /// Whether this (category, difficulty) is currently certified as
  /// mastered.
  BoolColumn get isMastered => boolean()();

  /// How many of the trailing 5 Precision results passed — `null` when
  /// fewer than 5 have ever been played (not enough history to certify
  /// or decay yet).
  IntColumn get passCountInLastFive => integer().nullable()();

  /// When this status was last evaluated, as UTC microseconds since
  /// epoch.
  IntColumn get evaluatedAtUtcMicros => integer()();

  @override
  Set<Column> get primaryKey => {profileId, category, difficulty};
}
