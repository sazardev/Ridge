import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
import 'package:ridge/features/practice/domain/entities/ghost_run.dart';
import 'package:ridge/features/practice/domain/repositories/session_repository.dart';
import 'package:ridge/features/practice/domain/services/ghost_run_fold.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';

/// Resolves the ghost run for a profile on one snippet — the fastest
/// prior attempt, folded into a replayable timeline. `null` when there's
/// no prior attempt, or none that committed a single character.
class GetGhostRunUseCase {
  /// Creates the use case over the given session read port.
  const new(this._repository);

  final SessionRepository _repository;

  /// Returns the ghost run for [profileId] on [snippetId].
  Future<Result<GhostRun?, AppFailure>> call({
    required ProfileId profileId,
    required SnippetId snippetId,
  }) async {
    final sessionsResult = await _repository.getSessionsForSnippet(
      profileId: profileId,
      snippetId: snippetId,
    );
    if (sessionsResult.isErr) {
      return Result.err(sessionsResult.failureOrNull!);
    }
    final sessions = sessionsResult.valueOrNull!;
    if (sessions.isEmpty) return const Result.ok(null);

    var best = sessions.first;
    for (final session in sessions.skip(1)) {
      if (session.netSpeedCpm > best.netSpeedCpm) best = session;
    }

    final keystrokesResult = await _repository.getKeystrokesForSession(best.id);
    if (keystrokesResult.isErr) {
      return Result.err(keystrokesResult.failureOrNull!);
    }
    final steps = foldGhostSteps(keystrokesResult.valueOrNull!);
    if (steps.isEmpty) return const Result.ok(null);

    return Result.ok((
      sessionId: best.id,
      steps: steps,
      netSpeedCpm: best.netSpeedCpm,
    ));
  }
}
