import 'package:drift/drift.dart';

import 'package:just_in_time/core/persistence/drift/app_database.dart';
import 'package:just_in_time/features/achievements/infrastructure/tables/achievements_unlocked_table.dart';
import 'package:just_in_time/features/practice/infrastructure/tables/keystroke_events_table.dart';
import 'package:just_in_time/features/practice/infrastructure/tables/typing_sessions_table.dart';

part 'achievement_dao.g.dart';

/// One session's raw per-session achievement-rule inputs — not a drift
/// table row of its own, just this query's shape (mirrors
/// `progression`'s `NgramSampleRow`).
class SessionAchievementInputRow {
  /// Creates an immutable raw per-session input row.
  const new({
    required this.sessionId,
    required this.accuracyPct,
    required this.handBalanceRatio,
    required this.correctionsCount,
    required this.forwardKeystrokeCount,
  });

  /// The session's `TypingSessionId` value.
  final String sessionId;

  /// The session's already-persisted accuracy percentage.
  final double accuracyPct;

  /// The session's already-persisted hand-balance ratio.
  final double handBalanceRatio;

  /// How many backspace/correction keystroke rows this session has.
  final int correctionsCount;

  /// How many non-correction (forward) keystroke rows this session has.
  final int forwardKeystrokeCount;
}

/// `achievements`-owned queries issued directly against `practice`'s
/// [TypingSessions]/[KeystrokeEvents] drift tables (an allowed
/// infrastructure-to-infrastructure import — mirrors `progression`'s
/// `ProgressionDao`; see its class doc) plus this feature's own
/// [AchievementsUnlocked] table.
@DriftAccessor(tables: [TypingSessions, KeystrokeEvents, AchievementsUnlocked])
class AchievementDao extends DatabaseAccessor<AppDatabase>
    with _$AchievementDaoMixin {
  /// Creates the DAO bound to the shared [AppDatabase].
  new(super.attachedDatabase);

  /// Per-session correction/forward-keystroke counts (plus the
  /// session's already-persisted accuracy/hand-balance) for every one of
  /// [profileId]'s finished sessions — "Cero Errores"/"Ambidiestro"'s
  /// rule inputs, one row per session.
  Future<List<SessionAchievementInputRow>> getSessionAchievementInputs(
    String profileId,
  ) async {
    final correctionsExpr = keystrokeEvents.sessionId.count(
      filter: keystrokeEvents.isCorrection.equals(true),
    );
    final forwardExpr = keystrokeEvents.sessionId.count(
      filter: keystrokeEvents.isCorrection.equals(false),
    );
    final query =
        select(typingSessions).join([
            leftOuterJoin(
              keystrokeEvents,
              keystrokeEvents.sessionId.equalsExp(typingSessions.id),
            ),
          ])
          ..addColumns([correctionsExpr, forwardExpr])
          ..where(typingSessions.profileId.equals(profileId))
          ..groupBy([typingSessions.id]);

    final rows = await query.get();
    return [
      for (final row in rows)
        SessionAchievementInputRow(
          sessionId: row.readTable(typingSessions).id,
          accuracyPct: row.readTable(typingSessions).accuracyPct,
          handBalanceRatio: row.readTable(typingSessions).handBalanceRatio,
          correctionsCount: row.read(correctionsExpr) ?? 0,
          forwardKeystrokeCount: row.read(forwardExpr) ?? 0,
        ),
    ];
  }

  /// The lifetime sum of correct, forward (non-correction) keystrokes
  /// across every one of [profileId]'s sessions — no recency window,
  /// "Maratonista"'s true career total (unlike `progression`'s windowed
  /// weakness queries).
  Future<int> getLifetimeCorrectForwardKeystrokeCount(String profileId) {
    final countExpr = keystrokeEvents.sessionId.count();
    final query =
        select(keystrokeEvents).join([
            innerJoin(
              typingSessions,
              typingSessions.id.equalsExp(keystrokeEvents.sessionId),
            ),
          ])
          ..addColumns([countExpr])
          ..where(typingSessions.profileId.equals(profileId))
          ..where(keystrokeEvents.isCorrection.equals(false))
          ..where(keystrokeEvents.result.equals('correct'));
    return query.getSingle().then((row) => row.read(countExpr) ?? 0);
  }

  /// Every currently-unlocked achievement row for [profileId], and every
  /// subsequent change.
  Stream<List<AchievementUnlockedRow>> watchUnlocked(String profileId) {
    return (select(
      achievementsUnlocked,
    )..where((r) => r.profileId.equals(profileId))).watch();
  }

  /// Every currently-unlocked achievement row for [profileId], read
  /// once.
  Future<List<AchievementUnlockedRow>> getUnlocked(String profileId) {
    return (select(
      achievementsUnlocked,
    )..where((r) => r.profileId.equals(profileId))).get();
  }

  /// Idempotently inserts [row] — a no-op (via `INSERT OR IGNORE`) if its
  /// (profileId, achievementId) primary key already exists, so an
  /// already-unlocked achievement's original `unlockedAt`/
  /// `triggerSessionId` is never overwritten by a later re-evaluation.
  Future<void> insertUnlockIfAbsent(AchievementsUnlockedCompanion row) {
    return into(achievementsUnlocked)
        .insert(row, mode: InsertMode.insertOrIgnore);
  }
}
