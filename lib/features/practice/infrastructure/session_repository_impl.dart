import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/persistence/drift/app_database.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/practice/domain/entities/keystroke.dart';
import 'package:just_in_time/features/practice/domain/entities/typing_session.dart';
import 'package:just_in_time/features/practice/domain/repositories/session_repository.dart';
import 'package:just_in_time/features/practice/infrastructure/practice_dao.dart';
import 'package:just_in_time/features/practice/infrastructure/practice_mapper.dart';
import 'package:just_in_time/features/profile/domain/value_objects/profile_id.dart';

/// Which third (0, 1, or 2) of the session a keystroke at forward-index
/// [forwardIndex] (out of [totalForward] forward keystrokes) falls in —
/// mirrors `MetricsCalculator`'s own thirds split so the persisted
/// `thirdIndex` column stays consistent with the `fatigue_*_third_cpm`
/// values computed from the same data.
int _thirdIndexFor(int forwardIndex, int totalForward) {
  if (totalForward <= 0) return 0;
  final thirdSize = totalForward ~/ 3;
  if (thirdSize == 0) return 0;
  if (forwardIndex < thirdSize) return 0;
  if (forwardIndex < thirdSize * 2) return 1;
  return 2;
}

/// Drift-backed adapter for [SessionRepository].
class SessionRepositoryImpl implements SessionRepository {
  /// Creates the adapter over the given [PracticeDao].
  const new(this._dao);

  final PracticeDao _dao;

  @override
  Future<Result<void, AppFailure>> persistSession({
    required TypingSession session,
    required List<Keystroke> keystrokes,
  }) async {
    try {
      final sessionDto = session.toDto();
      final totalForward = keystrokes.where((k) => !k.isCorrection).length;

      // A running forward-only count, so a correction inherits the
      // third of the forward keystroke it's currently adjacent to
      // (corrections themselves aren't part of the forward sequence
      // `MetricsCalculator`'s thirds split is computed over).
      var forwardSeen = 0;
      final keystrokeCompanions = <KeystrokeEventsCompanion>[];
      for (final keystroke in keystrokes) {
        keystrokeCompanions.add(
          keystroke
              .toDto(
                sessionId: sessionDto.id,
                sessionStartedAtUtcMicros: sessionDto.startedAtUtcMicros,
                thirdIndex: _thirdIndexFor(forwardSeen, totalForward),
              )
              .toCompanion(),
        );
        if (!keystroke.isCorrection) forwardSeen += 1;
      }

      await _dao.insertSessionWithKeystrokes(
        session: sessionDto.toCompanion(),
        keystrokes: keystrokeCompanions,
      );
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.err(
        StorageFailure('Could not persist practice session', cause: e),
      );
    }
  }

  @override
  Stream<List<TypingSession>> watchSessionsForProfile(ProfileId profileId) {
    return _dao
        .watchSessionsForProfile(profileId.value)
        .map((rows) => [for (final row in rows) row.toDto().toDomain()]);
  }
}
