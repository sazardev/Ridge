import 'package:drift/drift.dart';

/// Drift table recording one profile's completion of one day's shared
/// Daily Challenge snippet (SPEC.md §5.4) — the one *primary* (not cache)
/// table this feature owns: a completion, once recorded, is a permanent
/// fact never rebuilt from anything else. The composite primary key
/// enforces "one attempt counts per day" at the schema level.
@DataClassName('DailyChallengeCompletionRow')
class DailyChallengeCompletions extends Table {
  /// The `ProfileId` this completion belongs to.
  TextColumn get profileId => text()();

  /// `ChallengeDate.isoKey` (UTC, `yyyy-MM-dd`) — which day's shared
  /// snippet this completion is for.
  TextColumn get challengeDate => text()();

  /// The `SnippetId` played, frozen at the moment of completion.
  TextColumn get snippetId => text()();

  /// The snippet's `revision` at the moment of completion — together
  /// with [snippetId], this never changes even if the catalog entry is
  /// later revised (SPEC.md §3.2).
  IntColumn get snippetRevision => integer()();

  /// The `TypingSessionId` of the session that produced this completion.
  TextColumn get sessionId => text()();

  /// The 1-10 score `PrecisionScoreCalculator` derived from this
  /// attempt's accuracy.
  IntColumn get score => integer()();

  /// Whether [score] cleared `PrecisionScoreCalculator.passingScore`.
  BoolColumn get passed => boolean()();

  /// When this completion was recorded, as UTC microseconds since epoch.
  IntColumn get completedAtUtcMicros => integer()();

  @override
  Set<Column> get primaryKey => {profileId, challengeDate};
}
