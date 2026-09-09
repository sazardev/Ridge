import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/achievements/domain/entities/achievement.dart';
import 'package:just_in_time/features/achievements/domain/entities/session_achievement_input.dart';
import 'package:just_in_time/features/achievements/domain/repositories/achievement_repository.dart';
import 'package:just_in_time/features/achievements/infrastructure/achievement_dao.dart';
import 'package:just_in_time/features/achievements/infrastructure/achievement_mapper.dart';
import 'package:just_in_time/features/profile/domain/value_objects/profile_id.dart';

/// Drift-backed adapter for [AchievementRepository], over [AchievementDao]
/// (which owns every query — see its class doc for why this lives
/// outside `practice`'s own narrow `SessionRepository`).
class AchievementRepositoryImpl implements AchievementRepository {
  /// Creates the adapter over the given [AchievementDao].
  const new(this._dao);

  final AchievementDao _dao;

  @override
  Stream<List<Achievement>> watchUnlocked(ProfileId profileId) {
    return _dao
        .watchUnlocked(profileId.value)
        .map((rows) => [for (final r in rows) r.toDomain()]);
  }

  @override
  Future<Result<List<Achievement>, AppFailure>> getUnlocked(
    ProfileId profileId,
  ) async {
    try {
      final rows = await _dao.getUnlocked(profileId.value);
      return Result.ok([for (final r in rows) r.toDomain()]);
    } on Exception catch (e) {
      return Result.err(
        StorageFailure('Could not load unlocked achievements', cause: e),
      );
    }
  }

  @override
  Future<Result<void, AppFailure>> recordUnlock({
    required ProfileId profileId,
    required Achievement achievement,
  }) async {
    try {
      await _dao.insertUnlockIfAbsent(achievement.toCompanion(profileId));
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.err(
        StorageFailure('Could not record achievement unlock', cause: e),
      );
    }
  }

  @override
  Future<Result<List<SessionAchievementInput>, AppFailure>>
  getSessionAchievementInputs(ProfileId profileId) async {
    try {
      final rows = await _dao.getSessionAchievementInputs(profileId.value);
      return Result.ok([for (final r in rows) r.toDomain()]);
    } on Exception catch (e) {
      return Result.err(
        StorageFailure('Could not load session achievement inputs', cause: e),
      );
    }
  }

  @override
  Future<Result<int, AppFailure>> getLifetimeCorrectFirstTryCharCount(
    ProfileId profileId,
  ) async {
    try {
      final count = await _dao.getLifetimeCorrectForwardKeystrokeCount(
        profileId.value,
      );
      return Result.ok(count);
    } on Exception catch (e) {
      return Result.err(
        StorageFailure('Could not total lifetime correct characters', cause: e),
      );
    }
  }
}
