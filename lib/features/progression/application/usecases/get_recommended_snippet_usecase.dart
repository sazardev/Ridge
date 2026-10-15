import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/content/domain/repositories/snippet_repository.dart';
import 'package:ridge/features/practice/domain/services/char_key_map.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';
import 'package:ridge/features/progression/domain/entities/warm_up_target.dart';
import 'package:ridge/features/progression/domain/repositories/progression_repository.dart';

/// SPEC.md §3.3/§6.3's "Lección recomendada": surfaces the catalog entry
/// densest in whatever the profile's weakness report ranks worst, so
/// practicing the recommendation has the largest possible impact per
/// minute invested. The [WarmUpTarget] picks which ranking drives the
/// search — weak characters (the default), the weakest finger's
/// character set, or its hand's.
class GetRecommendedSnippetUseCase {
  /// Creates the use case over the given [ProgressionRepository] (for the
  /// weakness report) and [SnippetRepository] (for the catalog search).
  const new(this._progressionRepository, this._snippetRepository);

  final ProgressionRepository _progressionRepository;
  final SnippetRepository _snippetRepository;

  /// Returns the recommended snippet for [profileId] under [target], or
  /// `null` if there isn't enough history yet to rank that target, or
  /// nothing in the catalog contains any of its characters.
  Future<Result<Snippet?, AppFailure>> call(
    ProfileId profileId, {
    WarmUpTarget target = WarmUpTarget.characters,
  }) async {
    final snapshot = await _progressionRepository
        .watchSnapshot(profileId)
        .first;
    if (snapshot == null) return const Result.ok(null);

    final report = snapshot.weaknessReport;
    final targetCharacters = switch (target) {
      WarmUpTarget.characters => {
        for (final entry in report.weakCharacters) entry.character,
      },
      WarmUpTarget.finger =>
        report.weakFingers.isEmpty
            ? const <String>{}
            : charactersForFinger(report.weakFingers.first.finger),
      WarmUpTarget.hand =>
        report.weakFingers.isEmpty
            ? const <String>{}
            : charactersForHand(report.weakFingers.first.finger.hand),
    };
    if (targetCharacters.isEmpty) return const Result.ok(null);

    final candidatesResult = await _snippetRepository.findContainingSymbols(
      targetCharacters,
    );
    return candidatesResult.map(
      (candidates) => _densest(candidates, targetCharacters),
    );
  }

  /// The candidate containing the most distinct [targetCharacters],
  /// tie-broken by the shortest code (quicker to practice) — a simple
  /// density heuristic for "most impact per minute".
  Snippet? _densest(List<Snippet> candidates, Set<String> targetCharacters) {
    if (candidates.isEmpty) return null;
    var best = candidates.first;
    var bestDensity = _density(best, targetCharacters);
    for (final candidate in candidates.skip(1)) {
      final density = _density(candidate, targetCharacters);
      final isDenser = density > bestDensity;
      final isTiedButShorter =
          density == bestDensity && candidate.charCount < best.charCount;
      if (isDenser || isTiedButShorter) {
        best = candidate;
        bestDensity = density;
      }
    }
    return best;
  }

  int _density(Snippet snippet, Set<String> targetCharacters) {
    return targetCharacters.where(snippet.code.contains).length;
  }
}
