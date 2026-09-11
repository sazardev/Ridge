import 'package:drift/drift.dart';

import 'package:ridge/core/persistence/drift/app_database.dart';
import 'package:ridge/features/daily_challenge/infrastructure/tables/daily_challenge_completions_table.dart';

part 'daily_challenge_dao.g.dart';

/// `daily_challenge`-owned queries against its own
/// [DailyChallengeCompletions] table.
@DriftAccessor(tables: [DailyChallengeCompletions])
class DailyChallengeDao extends DatabaseAccessor<AppDatabase>
    with _$DailyChallengeDaoMixin {
  /// Creates the DAO bound to the shared [AppDatabase].
  new(super.attachedDatabase);

  /// [profileId]'s completion row for [challengeDate], or `null` if that
  /// day hasn't been played yet.
  Future<DailyChallengeCompletionRow?> getCompletion({
    required String profileId,
    required String challengeDate,
  }) {
    return (select(dailyChallengeCompletions)..where(
          (row) =>
              row.profileId.equals(profileId) &
              row.challengeDate.equals(challengeDate),
        ))
        .getSingleOrNull();
  }

  /// Idempotently writes [row] — replaces an existing row for the same
  /// (profileId, challengeDate) primary key, which never happens in
  /// practice since each day is only ever finished once, but keeps this
  /// call safe to retry.
  Future<void> upsertCompletion(DailyChallengeCompletionsCompanion row) async {
    await into(dailyChallengeCompletions).insertOnConflictUpdate(row);
  }

  /// Every distinct `ChallengeDate.isoKey` [profileId] has completed, and
  /// every subsequent change.
  Stream<List<String>> watchCompletedDates(String profileId) {
    return (selectOnly(dailyChallengeCompletions, distinct: true)
          ..addColumns([dailyChallengeCompletions.challengeDate])
          ..where(dailyChallengeCompletions.profileId.equals(profileId)))
        .map((row) => row.read(dailyChallengeCompletions.challengeDate)!)
        .watch();
  }

  /// [profileId]'s most recent completions, newest challenge day first,
  /// capped at [limit].
  Future<List<DailyChallengeCompletionRow>> getRecentCompletions({
    required String profileId,
    required int limit,
  }) {
    return (select(dailyChallengeCompletions)
          ..where((row) => row.profileId.equals(profileId))
          ..orderBy([
            (row) => OrderingTerm(
              expression: row.challengeDate,
              mode: OrderingMode.desc,
            ),
          ])
          ..limit(limit))
        .get();
  }
}
