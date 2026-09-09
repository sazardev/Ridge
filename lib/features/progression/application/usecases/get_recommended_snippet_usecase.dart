import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/content/domain/entities/snippet.dart';
import 'package:just_in_time/features/content/domain/repositories/snippet_repository.dart';
import 'package:just_in_time/features/profile/domain/value_objects/profile_id.dart';
import 'package:just_in_time/features/progression/domain/repositories/progression_repository.dart';

/// SPEC.md §3.3/§6.3's "Lección recomendada": surfaces the catalog entry
/// densest in whatever characters the profile's weakness report ranks
/// worst, so practicing the recommendation has the largest possible
/// impact per minute invested.
class GetRecommendedSnippetUseCase {
  /// Creates the use case over the given [ProgressionRepository] (for the
  /// weakness report) and [SnippetRepository] (for the catalog search).
  const new(this._progressionRepository, this._snippetRepository);

  final ProgressionRepository _progressionRepository;
  final SnippetRepository _snippetRepository;

  /// Returns the recommended snippet for [profileId], or `null` if there
  /// isn't enough history yet to have a weakness report, or nothing in
  /// the catalog contains any of its weak characters.
  Future<Result<Snippet?, AppFailure>> call(ProfileId profileId) async {
    final snapshot = await _progressionRepository
        .watchSnapshot(profileId)
        .first;
    if (snapshot == null) return const Result.ok(null);

    final weakCharacters = {
      for (final w in snapshot.weaknessReport.weakCharacters) w.character,
    };
    if (weakCharacters.isEmpty) return const Result.ok(null);

    final candidatesResult = await _snippetRepository.findContainingSymbols(
      weakCharacters,
    );
    return candidatesResult.map(
      (candidates) => _densest(candidates, weakCharacters),
    );
  }

  /// The candidate containing the most distinct [weakCharacters],
  /// tie-broken by the shortest code (quicker to practice) — a simple
  /// density heuristic for "most impact per minute".
  Snippet? _densest(List<Snippet> candidates, Set<String> weakCharacters) {
    if (candidates.isEmpty) return null;
    var best = candidates.first;
    var bestDensity = _density(best, weakCharacters);
    for (final candidate in candidates.skip(1)) {
      final density = _density(candidate, weakCharacters);
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

  int _density(Snippet snippet, Set<String> weakCharacters) {
    return weakCharacters.where(snippet.code.contains).length;
  }
}
