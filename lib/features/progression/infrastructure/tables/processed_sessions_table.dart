import 'package:drift/drift.dart';

/// Drift table marking which `typing_sessions` rows have already been
/// backfilled with real `xp_awarded`/`is_first_completion` values —
/// resolves "have I processed this session yet?" without ambiguity, so
/// `RecomputeProgressSnapshotUseCase` can safely re-run any number of
/// times without double-counting XP or the first-completion bonus.
@DataClassName('ProcessedSessionRow')
class ProcessedSessions extends Table {
  /// The `TypingSessionId` value of the session this row marks processed.
  TextColumn get sessionId => text()();

  /// The `ProfileId` that session belongs to, denormalized so a
  /// per-profile lookup never needs to join back to `typing_sessions`.
  TextColumn get profileId => text()();

  /// When this session was processed, as UTC microseconds since epoch.
  IntColumn get processedAtUtcMicros => integer()();

  @override
  Set<Column> get primaryKey => {sessionId};
}
