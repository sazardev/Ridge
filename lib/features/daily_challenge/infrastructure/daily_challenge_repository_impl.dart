import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/persistence/drift/app_database.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
import 'package:ridge/features/daily_challenge/domain/entities/daily_challenge_completion.dart';
import 'package:ridge/features/daily_challenge/domain/repositories/daily_challenge_repository.dart';
import 'package:ridge/features/daily_challenge/domain/value_objects/challenge_date.dart';
import 'package:ridge/features/daily_challenge/infrastructure/daily_challenge_dao.dart';
import 'package:ridge/features/practice/domain/value_objects/typing_session_id.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';

/// Maps between [DailyChallengeCompletion] and its drift row shape. Kept
/// inline rather than as a separate DTO — the row is already flat, one
/// column per domain field.
extension _DailyChallengeCompletionRowMapper on DailyChallengeCompletionRow {
  DailyChallengeCompletion toDomain() {
    return DailyChallengeCompletion(
      profileId: ProfileId(profileId),
      date: ChallengeDate.parse(challengeDate),
      snippetId: SnippetId(snippetId),
      snippetRevision: snippetRevision,
      sessionId: TypingSessionId(sessionId),
      score: score,
      passed: passed,
      completedAtUtc: DateTime.fromMicrosecondsSinceEpoch(
        completedAtUtcMicros,
        isUtc: true,
      ),
    );
  }
}

/// Drift-backed adapter for [DailyChallengeRepository].
class DailyChallengeRepositoryImpl implements DailyChallengeRepository {
  /// Creates the adapter over the given [DailyChallengeDao].
  const new(this._dao);

  final DailyChallengeDao _dao;

  @override
  Future<Result<DailyChallengeCompletion?, AppFailure>> getCompletion({
    required ProfileId profileId,
    required ChallengeDate date,
  }) async {
    try {
      final row = await _dao.getCompletion(
        profileId: profileId.value,
        challengeDate: date.isoKey,
      );
      return Result.ok(row?.toDomain());
    } on Exception catch (e) {
      return Result.err(
        StorageFailure('Could not read Daily Challenge completion', cause: e),
      );
    }
  }

  @override
  Future<Result<void, AppFailure>> recordCompletion(
    DailyChallengeCompletion completion,
  ) async {
    try {
      await _dao.upsertCompletion(
        DailyChallengeCompletionsCompanion.insert(
          profileId: completion.profileId.value,
          challengeDate: completion.date.isoKey,
          snippetId: completion.snippetId.value,
          snippetRevision: completion.snippetRevision,
          sessionId: completion.sessionId.value,
          score: completion.score,
          passed: completion.passed,
          completedAtUtcMicros: completion.completedAtUtc
              .toUtc()
              .microsecondsSinceEpoch,
        ),
      );
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.err(
        StorageFailure('Could not record Daily Challenge completion', cause: e),
      );
    }
  }

  @override
  Stream<List<ChallengeDate>> watchCompletedDates(ProfileId profileId) {
    return _dao
        .watchCompletedDates(profileId.value)
        .map(
          (isoKeys) => [for (final key in isoKeys) ChallengeDate.parse(key)],
        );
  }

  @override
  Future<Result<List<DailyChallengeCompletion>, AppFailure>>
  getRecentCompletions({
    required ProfileId profileId,
    required int limit,
  }) async {
    try {
      final rows = await _dao.getRecentCompletions(
        profileId: profileId.value,
        limit: limit,
      );
      return Result.ok([for (final row in rows) row.toDomain()]);
    } on Exception catch (e) {
      return Result.err(
        StorageFailure(
          'Could not read recent Daily Challenge completions',
          cause: e,
        ),
      );
    }
  }
}
