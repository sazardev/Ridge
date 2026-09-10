import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/persistence/drift/app_database.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
import 'package:ridge/features/practice/domain/value_objects/typing_session_id.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';
import 'package:ridge/features/progression/domain/entities/key_transition_sample.dart';
import 'package:ridge/features/progression/domain/entities/keystroke_sample.dart';
import 'package:ridge/features/progression/domain/entities/mastery_status.dart';
import 'package:ridge/features/progression/domain/entities/ngram_sample.dart';
import 'package:ridge/features/progression/domain/entities/personal_history_comparison.dart';
import 'package:ridge/features/progression/domain/entities/precision_result.dart';
import 'package:ridge/features/progression/domain/entities/progress_snapshot.dart';
import 'package:ridge/features/progression/domain/entities/session_activity_sample.dart';
import 'package:ridge/features/progression/domain/entities/unprocessed_session.dart';
import 'package:ridge/features/progression/domain/repositories/progression_repository.dart';
import 'package:ridge/features/progression/infrastructure/progression_dao.dart';
import 'package:ridge/features/progression/infrastructure/progression_mapper.dart';

/// Drift-backed adapter for [ProgressionRepository], over [ProgressionDao]
/// (which owns every query — see its class doc for why this lives
/// outside `practice`'s own narrow `SessionRepository`).
class ProgressionRepositoryImpl implements ProgressionRepository {
  /// Creates the adapter over the given [ProgressionDao].
  const new(this._dao);

  final ProgressionDao _dao;

  @override
  Stream<ProgressSnapshot?> watchSnapshot(ProfileId profileId) {
    return _dao.watchSnapshotCache(profileId.value).asyncMap((row) async {
      if (row == null) return null;
      final masteryRows = await _dao.getAllMasteryStatusCache(profileId.value);
      return row.toDomain(
        masteryStatuses: [for (final m in masteryRows) m.toDomain()],
      );
    });
  }

  @override
  Future<Result<List<UnprocessedSession>, AppFailure>> getUnprocessedSessions(
    ProfileId profileId,
  ) async {
    try {
      final rows = await _dao.getUnprocessedSessionsOldestFirst(
        profileId.value,
      );
      final sessions = <UnprocessedSession>[];
      for (final row in rows) {
        final correctCount = await _dao.countCorrectForwardKeystrokes(row.id);
        sessions.add(
          row.toUnprocessedSession(correctFirstTryChars: correctCount),
        );
      }
      return Result.ok(sessions);
    } on Exception catch (e) {
      return Result.err(
        StorageFailure('Could not load unprocessed sessions', cause: e),
      );
    }
  }

  @override
  Future<Result<bool, AppFailure>> hasCompletedSnippetBefore({
    required ProfileId profileId,
    required SnippetId snippetId,
  }) async {
    try {
      final has = await _dao.hasFirstCompletionForSnippet(
        profileId: profileId.value,
        snippetId: snippetId.value,
      );
      return Result.ok(has);
    } on Exception catch (e) {
      return Result.err(
        StorageFailure('Could not check snippet completion history', cause: e),
      );
    }
  }

  @override
  Future<Result<void, AppFailure>> markSessionProcessed({
    required ProfileId profileId,
    required TypingSessionId sessionId,
    required int xpAwarded,
    required bool isFirstCompletion,
  }) async {
    try {
      await _dao.markSessionProcessed(
        sessionId: sessionId.value,
        profileId: profileId.value,
        xpAwarded: xpAwarded,
        isFirstCompletion: isFirstCompletion,
        processedAtUtcMicros: DateTime.now().toUtc().microsecondsSinceEpoch,
      );
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.err(
        StorageFailure('Could not mark session processed', cause: e),
      );
    }
  }

  @override
  Future<Result<List<DateTime>, AppFailure>> getSessionStartTimestamps(
    ProfileId profileId,
  ) async {
    try {
      final micros = await _dao.getSessionStartUtcMicrosForProfile(
        profileId.value,
      );
      return Result.ok([
        for (final m in micros)
          DateTime.fromMicrosecondsSinceEpoch(m, isUtc: true),
      ]);
    } on Exception catch (e) {
      return Result.err(
        StorageFailure('Could not load session history', cause: e),
      );
    }
  }

  @override
  Future<Result<int, AppFailure>> getTotalXpAwarded(ProfileId profileId) async {
    try {
      return Result.ok(await _dao.getTotalXpAwarded(profileId.value));
    } on Exception catch (e) {
      return Result.err(StorageFailure('Could not total XP', cause: e));
    }
  }

  @override
  Future<Result<List<KeystrokeSample>, AppFailure>> getKeystrokeSamples({
    required ProfileId profileId,
    required DateTime since,
  }) async {
    try {
      final rows = await _dao.getKeystrokeSamplesRaw(
        profileId: profileId.value,
        sinceUtcMicros: since.toUtc().microsecondsSinceEpoch,
      );
      return Result.ok([for (final r in rows) r.toKeystrokeSample()]);
    } on Exception catch (e) {
      return Result.err(
        StorageFailure('Could not load keystroke samples', cause: e),
      );
    }
  }

  @override
  Future<Result<List<NgramSample>, AppFailure>> getNgramSamples({
    required ProfileId profileId,
    required DateTime since,
  }) async {
    try {
      final rows = await _dao.getNgramSamplesRaw(
        profileId: profileId.value,
        sinceUtcMicros: since.toUtc().microsecondsSinceEpoch,
      );
      return Result.ok([for (final r in rows) r.toNgramSample()]);
    } on Exception catch (e) {
      return Result.err(
        StorageFailure('Could not load n-gram samples', cause: e),
      );
    }
  }

  @override
  Future<Result<List<KeyTransitionSample>, AppFailure>>
  getKeyTransitionSamples({
    required ProfileId profileId,
    required DateTime since,
  }) async {
    try {
      final rows = await _dao.getKeyTransitionSamplesRaw(
        profileId: profileId.value,
        sinceUtcMicros: since.toUtc().microsecondsSinceEpoch,
      );
      return Result.ok([for (final r in rows) r.toKeyTransitionSample()]);
    } on Exception catch (e) {
      return Result.err(
        StorageFailure('Could not load key-transition samples', cause: e),
      );
    }
  }

  @override
  Future<Result<List<SessionActivitySample>, AppFailure>>
  getSessionActivitySamples(ProfileId profileId) async {
    try {
      final rows = await _dao.getSessionActivityRaw(profileId.value);
      return Result.ok([for (final r in rows) r.toSessionActivitySample()]);
    } on Exception catch (e) {
      return Result.err(
        StorageFailure('Could not load session activity samples', cause: e),
      );
    }
  }

  @override
  Future<Result<List<PrecisionResult>, AppFailure>> getRecentPrecisionResults({
    required ProfileId profileId,
    required ContentCategory category,
    required Difficulty difficulty,
    int limit = 5,
  }) async {
    try {
      final rows = await _dao.getRecentPrecisionSessions(
        profileId: profileId.value,
        category: category.name,
        difficulty: difficulty.name,
        limit: limit,
      );
      return Result.ok([for (final r in rows) r.toPrecisionResult()]);
    } on Exception catch (e) {
      return Result.err(
        StorageFailure('Could not load recent precision results', cause: e),
      );
    }
  }

  @override
  Future<Result<MasteryStatus?, AppFailure>> getMasteryStatus({
    required ProfileId profileId,
    required ContentCategory category,
    required Difficulty difficulty,
  }) async {
    try {
      final row = await _dao.getMasteryStatusCache(
        profileId: profileId.value,
        category: category.name,
        difficulty: difficulty.name,
      );
      return Result.ok(row?.toDomain());
    } on Exception catch (e) {
      return Result.err(
        StorageFailure('Could not load mastery status', cause: e),
      );
    }
  }

  @override
  Future<Result<List<MasteryStatus>, AppFailure>> getAllMasteryStatuses(
    ProfileId profileId,
  ) async {
    try {
      final rows = await _dao.getAllMasteryStatusCache(profileId.value);
      return Result.ok([for (final r in rows) r.toDomain()]);
    } on Exception catch (e) {
      return Result.err(
        StorageFailure('Could not load mastery statuses', cause: e),
      );
    }
  }

  @override
  Future<Result<void, AppFailure>> persistSnapshot(
    ProgressSnapshot snapshot,
  ) async {
    try {
      await _dao.upsertSnapshotCache(snapshot.toCompanion());
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.err(
        StorageFailure('Could not persist progress snapshot', cause: e),
      );
    }
  }

  @override
  Future<Result<void, AppFailure>> persistMasteryStatus({
    required ProfileId profileId,
    required MasteryStatus status,
  }) async {
    try {
      await _dao.upsertMasteryStatusCache(status.toCompanion(profileId));
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.err(
        StorageFailure('Could not persist mastery status', cause: e),
      );
    }
  }

  @override
  Future<Result<PersonalHistoryComparison, AppFailure>>
  getPersonalHistoryComparison({
    required ProfileId profileId,
    SnippetId? snippetId,
    ContentCategory? category,
    int sampleSize = 5,
  }) async {
    try {
      final List<TypingSessionRow> rows;
      if (snippetId != null) {
        rows = await _dao.getRecentSessionsForSnippet(
          profileId: profileId.value,
          snippetId: snippetId.value,
          limit: sampleSize,
        );
      } else if (category != null) {
        rows = await _dao.getRecentSessionsForCategory(
          profileId: profileId.value,
          category: category.name,
          limit: sampleSize,
        );
      } else {
        rows = const [];
      }
      return Result.ok(toPersonalHistoryComparison(rows));
    } on Exception catch (e) {
      return Result.err(
        StorageFailure('Could not compare personal history', cause: e),
      );
    }
  }
}
