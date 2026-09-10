import 'package:drift/drift.dart';

import 'package:ridge/core/persistence/drift/app_database.dart';
import 'package:ridge/features/practice/infrastructure/tables/keystroke_events_table.dart';
import 'package:ridge/features/practice/infrastructure/tables/typing_sessions_table.dart';

part 'practice_dao.g.dart';

/// Typed queries against the [TypingSessions]/[KeystrokeEvents] tables.
@DriftAccessor(tables: [TypingSessions, KeystrokeEvents])
class PracticeDao extends DatabaseAccessor<AppDatabase>
    with _$PracticeDaoMixin {
  /// Creates the DAO bound to the shared [AppDatabase].
  new(super.attachedDatabase);

  /// Inserts [session] and every one of its [keystrokes] in a single
  /// transaction — a finished session and its capture data are one
  /// atomic, immutable unit (SPEC.md §8.1).
  Future<void> insertSessionWithKeystrokes({
    required TypingSessionsCompanion session,
    required List<KeystrokeEventsCompanion> keystrokes,
  }) {
    return transaction(() async {
      await into(typingSessions).insert(session);
      await batch((batch) => batch.insertAll(keystrokeEvents, keystrokes));
    });
  }

  /// Emits every session belonging to [profileId], most recent first,
  /// and every subsequent change.
  Stream<List<TypingSessionRow>> watchSessionsForProfile(String profileId) {
    return (select(typingSessions)
          ..where((row) => row.profileId.equals(profileId))
          ..orderBy([(row) => OrderingTerm.desc(row.startedAtUtcMicros)]))
        .watch();
  }

  /// Returns every keystroke belonging to [sessionId], in sequence order
  /// — used by tests to verify the capture-to-persistence pipeline.
  Future<List<KeystrokeEventRow>> getKeystrokesForSession(String sessionId) {
    return (select(keystrokeEvents)
          ..where((row) => row.sessionId.equals(sessionId))
          ..orderBy([(row) => OrderingTerm.asc(row.seq)]))
        .get();
  }
}
