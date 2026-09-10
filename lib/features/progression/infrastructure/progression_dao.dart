import 'package:drift/drift.dart';

import 'package:ridge/core/persistence/drift/app_database.dart';
import 'package:ridge/features/practice/infrastructure/tables/keystroke_events_table.dart';
import 'package:ridge/features/practice/infrastructure/tables/typing_sessions_table.dart';
import 'package:ridge/features/progression/infrastructure/tables/mastery_status_cache_table.dart';
import 'package:ridge/features/progression/infrastructure/tables/processed_sessions_table.dart';
import 'package:ridge/features/progression/infrastructure/tables/progress_snapshot_cache_table.dart';

part 'progression_dao.g.dart';

/// One raw 2-character n-gram observation, produced by a self-join on
/// [KeystrokeEvents] (`k2.seq = k1.seq + 1`, same session) — not a drift
/// table row of its own, just this query's shape.
class NgramSampleRow {
  /// Creates an immutable raw n-gram row.
  const new({
    required this.text,
    required this.isError,
    required this.flightMicros,
    required this.sessionStartedAtUtcMicros,
  });

  /// The two actually-typed characters, in order.
  final String text;

  /// Whether either half of the pair wasn't a correct keystroke.
  final bool isError;

  /// The second character's flight duration (time since the first
  /// character's keydown) — the pair's own "how long did this take".
  final int flightMicros;

  /// The owning session's start time, denormalized the same way
  /// [KeystrokeEvents] itself denormalizes it — the recency reference
  /// point for weakness ranking (see the project plan: individual
  /// keystrokes don't carry their own absolute timestamp, only relative
  /// dwell/flight durations, so a session's start time stands in for
  /// "when did this roughly happen").
  final int sessionStartedAtUtcMicros;
}

/// One raw physical key-transition observation, produced by the same
/// self-join shape as [NgramSampleRow] (`k2.seq = k1.seq + 1`, same
/// session) but reading each side's `physicalKeyId` instead of its
/// `actualChar` — SPEC.md §4.1's "conexiones" independent of which
/// letter each key produced.
class KeyTransitionSampleRow {
  /// Creates an immutable raw key-transition row.
  const new({
    required this.fromKey,
    required this.toKey,
    required this.isError,
    required this.flightMicros,
    required this.sessionStartedAtUtcMicros,
  });

  /// The first key's `PhysicalKeyId` enum name.
  final String fromKey;

  /// The second key's `PhysicalKeyId` enum name.
  final String toKey;

  /// Whether either half of the pair wasn't a correct keystroke.
  final bool isError;

  /// The second key's flight duration (time since the first key's
  /// keydown) — the pair's own "how long did this transition take".
  final int flightMicros;

  /// The owning session's start time, denormalized the same way
  /// [NgramSampleRow] does — the recency reference point for weakness
  /// ranking.
  final int sessionStartedAtUtcMicros;
}

/// `progression`-owned queries issued directly against `practice`'s
/// [TypingSessions]/[KeystrokeEvents] drift tables (an allowed
/// infrastructure-to-infrastructure import — see the project plan), plus
/// `progression`'s own cache/marker tables. `practice`'s own
/// `SessionRepository` port is deliberately too narrow for any of this
/// (see its class doc) — this DAO is the reason why.
@DriftAccessor(
  tables: [
    TypingSessions,
    KeystrokeEvents,
    ProgressSnapshotCache,
    MasteryStatusCache,
    ProcessedSessions,
  ],
)
class ProgressionDao extends DatabaseAccessor<AppDatabase>
    with _$ProgressionDaoMixin {
  /// Creates the DAO bound to the shared [AppDatabase].
  new(super.attachedDatabase);

  /// Every session for [profileId] not yet marked processed in
  /// [ProcessedSessions], oldest first.
  Future<List<TypingSessionRow>> getUnprocessedSessionsOldestFirst(
    String profileId,
  ) async {
    final processedIds =
        await (selectOnly(processedSessions)
              ..addColumns([processedSessions.sessionId])
              ..where(processedSessions.profileId.equals(profileId)))
            .map((row) => row.read(processedSessions.sessionId)!)
            .get();
    final processedSet = processedIds.toSet();

    final allSessions =
        await (select(typingSessions)
              ..where((row) => row.profileId.equals(profileId))
              ..orderBy([(row) => OrderingTerm.asc(row.startedAtUtcMicros)]))
            .get();
    return [
      for (final session in allSessions)
        if (!processedSet.contains(session.id)) session,
    ];
  }

  /// How many correct, forward (non-correction) keystrokes [sessionId]
  /// has — the XP formula's `correctFirstTryChars`.
  Future<int> countCorrectForwardKeystrokes(String sessionId) {
    final countExpr = keystrokeEvents.sessionId.count();
    final query = selectOnly(keystrokeEvents)
      ..addColumns([countExpr])
      ..where(
        keystrokeEvents.sessionId.equals(sessionId) &
            keystrokeEvents.isCorrection.equals(false) &
            keystrokeEvents.result.equals('correct'),
      );
    return query.getSingle().then((row) => row.read(countExpr) ?? 0);
  }

  /// Whether [profileId] has ever completed [snippetId] before (any
  /// revision) — a session already marked as that snippet's first
  /// completion exists.
  Future<bool> hasFirstCompletionForSnippet({
    required String profileId,
    required String snippetId,
  }) async {
    final row =
        await (select(typingSessions)
              ..where(
                (r) =>
                    r.profileId.equals(profileId) &
                    r.snippetId.equals(snippetId) &
                    r.isFirstCompletion.equals(true),
              )
              ..limit(1))
            .getSingleOrNull();
    return row != null;
  }

  /// Backfills [sessionId]'s derived XP columns and marks it processed,
  /// in one transaction — the one narrow exception to session
  /// immutability (SPEC.md §8.1).
  Future<void> markSessionProcessed({
    required String sessionId,
    required String profileId,
    required int xpAwarded,
    required bool isFirstCompletion,
    required int processedAtUtcMicros,
  }) {
    return transaction(() async {
      await (update(
        typingSessions,
      )..where((r) => r.id.equals(sessionId))).write(
        TypingSessionsCompanion(
          xpAwarded: Value(xpAwarded),
          isFirstCompletion: Value(isFirstCompletion),
        ),
      );
      await into(processedSessions).insertOnConflictUpdate(
        ProcessedSessionsCompanion.insert(
          sessionId: sessionId,
          profileId: profileId,
          processedAtUtcMicros: processedAtUtcMicros,
        ),
      );
    });
  }

  /// Every finished session's start time for [profileId], raw.
  Future<List<int>> getSessionStartUtcMicrosForProfile(String profileId) {
    final query = selectOnly(typingSessions)
      ..addColumns([typingSessions.startedAtUtcMicros])
      ..where(typingSessions.profileId.equals(profileId));
    return query
        .map((row) => row.read(typingSessions.startedAtUtcMicros)!)
        .get();
  }

  /// The sum of `xp_awarded` across every session for [profileId].
  Future<int> getTotalXpAwarded(String profileId) {
    final sumExpr = typingSessions.xpAwarded.sum();
    final query = selectOnly(typingSessions)
      ..addColumns([sumExpr])
      ..where(typingSessions.profileId.equals(profileId));
    return query.getSingle().then((row) => row.read(sumExpr) ?? 0);
  }

  /// Raw forward-keystroke rows for [profileId] since [sinceUtcMicros],
  /// for character/finger weakness ranking.
  Future<List<KeystrokeEventRow>> getKeystrokeSamplesRaw({
    required String profileId,
    required int sinceUtcMicros,
  }) async {
    final query =
        select(keystrokeEvents).join([
            innerJoin(
              typingSessions,
              typingSessions.id.equalsExp(keystrokeEvents.sessionId),
            ),
          ])
          ..where(typingSessions.profileId.equals(profileId))
          ..where(keystrokeEvents.isCorrection.equals(false))
          ..where(
            keystrokeEvents.sessionStartedAtUtcMicros.isBiggerOrEqualValue(
              sinceUtcMicros,
            ),
          );
    final rows = await query.get();
    return [for (final row in rows) row.readTable(keystrokeEvents)];
  }

  /// Raw 2-character n-gram rows for [profileId] since [sinceUtcMicros]
  /// — a self-join of adjacent forward keystrokes within the same
  /// session (`k2.seq = k1.seq + 1`), for n-gram weakness ranking.
  Future<List<NgramSampleRow>> getNgramSamplesRaw({
    required String profileId,
    required int sinceUtcMicros,
  }) async {
    final k1 = alias(keystrokeEvents, 'k1');
    final k2 = alias(keystrokeEvents, 'k2');
    final query =
        select(k1).join([
            innerJoin(
              k2,
              k2.sessionId.equalsExp(k1.sessionId) &
                  k2.seq.equalsExp(k1.seq + const Constant(1)),
            ),
            innerJoin(
              typingSessions,
              typingSessions.id.equalsExp(k1.sessionId),
            ),
          ])
          ..where(typingSessions.profileId.equals(profileId))
          ..where(k1.isCorrection.equals(false))
          ..where(k2.isCorrection.equals(false))
          ..where(
            k1.sessionStartedAtUtcMicros.isBiggerOrEqualValue(sinceUtcMicros),
          );

    final rows = await query.get();
    return [
      for (final row in rows)
        NgramSampleRow(
          text:
              '${row.readTable(k1).actualChar ?? ''}'
              '${row.readTable(k2).actualChar ?? ''}',
          isError:
              row.readTable(k1).result != 'correct' ||
              row.readTable(k2).result != 'correct',
          flightMicros: row.readTable(k2).flightMicros ?? 0,
          sessionStartedAtUtcMicros: row
              .readTable(k1)
              .sessionStartedAtUtcMicros,
        ),
    ];
  }

  /// Raw physical key-transition rows for [profileId] since
  /// [sinceUtcMicros] — the same self-join shape as
  /// [getNgramSamplesRaw], but reading `physical_key_id` instead of
  /// `actual_char`, for key-transition weakness ranking (SPEC.md §4.1).
  Future<List<KeyTransitionSampleRow>> getKeyTransitionSamplesRaw({
    required String profileId,
    required int sinceUtcMicros,
  }) async {
    final k1 = alias(keystrokeEvents, 'k1');
    final k2 = alias(keystrokeEvents, 'k2');
    final query =
        select(k1).join([
            innerJoin(
              k2,
              k2.sessionId.equalsExp(k1.sessionId) &
                  k2.seq.equalsExp(k1.seq + const Constant(1)),
            ),
            innerJoin(
              typingSessions,
              typingSessions.id.equalsExp(k1.sessionId),
            ),
          ])
          ..where(typingSessions.profileId.equals(profileId))
          ..where(k1.isCorrection.equals(false))
          ..where(k2.isCorrection.equals(false))
          ..where(
            k1.sessionStartedAtUtcMicros.isBiggerOrEqualValue(sinceUtcMicros),
          );

    final rows = await query.get();
    return [
      for (final row in rows)
        KeyTransitionSampleRow(
          fromKey: row.readTable(k1).physicalKeyId,
          toKey: row.readTable(k2).physicalKeyId,
          isError:
              row.readTable(k1).result != 'correct' ||
              row.readTable(k2).result != 'correct',
          flightMicros: row.readTable(k2).flightMicros ?? 0,
          sessionStartedAtUtcMicros: row
              .readTable(k1)
              .sessionStartedAtUtcMicros,
        ),
    ];
  }

  /// Every finished session for [profileId], reduced to exactly what
  /// activity ranking needs — no `since` filter, since
  /// `ActivityRankingCalculator` itself partitions "most practiced"
  /// (lifetime) from "lowest scoring" (recency-windowed) internally.
  Future<List<TypingSessionRow>> getSessionActivityRaw(String profileId) {
    return (select(
      typingSessions,
    )..where((r) => r.profileId.equals(profileId))).get();
  }

  /// The most recent Precision-mode sessions for [profileId] on
  /// [category]/[difficulty], newest first, capped at [limit].
  Future<List<TypingSessionRow>> getRecentPrecisionSessions({
    required String profileId,
    required String category,
    required String difficulty,
    required int limit,
  }) {
    return (select(typingSessions)
          ..where(
            (r) =>
                r.profileId.equals(profileId) &
                r.category.equals(category) &
                r.difficulty.equals(difficulty) &
                r.mode.equals('precision'),
          )
          ..orderBy([(r) => OrderingTerm.desc(r.startedAtUtcMicros)])
          ..limit(limit))
        .get();
  }

  /// The most recent sessions for [profileId] on [snippetId] (any
  /// revision), newest first, capped at [limit] — personal-history
  /// comparison's snippet-scoped view.
  Future<List<TypingSessionRow>> getRecentSessionsForSnippet({
    required String profileId,
    required String snippetId,
    required int limit,
  }) {
    return (select(typingSessions)
          ..where(
            (r) =>
                r.profileId.equals(profileId) & r.snippetId.equals(snippetId),
          )
          ..orderBy([(r) => OrderingTerm.desc(r.startedAtUtcMicros)])
          ..limit(limit))
        .get();
  }

  /// The most recent sessions for [profileId] on [category], newest
  /// first, capped at [limit] — personal-history comparison's
  /// category-scoped view.
  Future<List<TypingSessionRow>> getRecentSessionsForCategory({
    required String profileId,
    required String category,
    required int limit,
  }) {
    return (select(typingSessions)
          ..where(
            (r) => r.profileId.equals(profileId) & r.category.equals(category),
          )
          ..orderBy([(r) => OrderingTerm.desc(r.startedAtUtcMicros)])
          ..limit(limit))
        .get();
  }

  /// Emits the cached snapshot row for [profileId], and every subsequent
  /// change.
  Stream<ProgressSnapshotCacheRow?> watchSnapshotCache(String profileId) {
    return (select(
      progressSnapshotCache,
    )..where((r) => r.profileId.equals(profileId))).watchSingleOrNull();
  }

  /// Inserts or replaces the cached snapshot row for the profile [row]
  /// belongs to.
  Future<void> upsertSnapshotCache(ProgressSnapshotCacheCompanion row) {
    return into(progressSnapshotCache).insertOnConflictUpdate(row);
  }

  /// The cached mastery status row for [profileId] on
  /// [category]/[difficulty], or `null` if never evaluated.
  Future<MasteryStatusCacheRow?> getMasteryStatusCache({
    required String profileId,
    required String category,
    required String difficulty,
  }) {
    return (select(masteryStatusCache)..where(
          (r) =>
              r.profileId.equals(profileId) &
              r.category.equals(category) &
              r.difficulty.equals(difficulty),
        ))
        .getSingleOrNull();
  }

  /// Every cached mastery status row for [profileId].
  Future<List<MasteryStatusCacheRow>> getAllMasteryStatusCache(
    String profileId,
  ) {
    return (select(
      masteryStatusCache,
    )..where((r) => r.profileId.equals(profileId))).get();
  }

  /// Inserts or replaces one cached mastery status row.
  Future<void> upsertMasteryStatusCache(MasteryStatusCacheCompanion row) {
    return into(masteryStatusCache).insertOnConflictUpdate(row);
  }
}
