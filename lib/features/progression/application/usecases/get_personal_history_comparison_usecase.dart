import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';
import 'package:ridge/features/progression/domain/entities/personal_history_comparison.dart';
import 'package:ridge/features/progression/domain/repositories/progression_repository.dart';

/// SPEC.md §7.1/§11.4's guest-only "local leaderboard": a rolling
/// comparison of the user's own last-N sessions of the same snippet or
/// category — a thin read view over already-persisted sessions, exactly
/// what [ProgressionRepository.getPersonalHistoryComparison] already
/// computes.
class GetPersonalHistoryComparisonUseCase {
  /// Creates the use case over the given [ProgressionRepository] port.
  const new(this._repository);

  final ProgressionRepository _repository;

  /// Returns the rolling comparison for [profileId] against [snippetId]
  /// (if given) or [category] (if given), over the last [sampleSize]
  /// sessions.
  Future<Result<PersonalHistoryComparison, AppFailure>> call({
    required ProfileId profileId,
    SnippetId? snippetId,
    ContentCategory? category,
    int sampleSize = 5,
  }) {
    return _repository.getPersonalHistoryComparison(
      profileId: profileId,
      snippetId: snippetId,
      category: category,
      sampleSize: sampleSize,
    );
  }
}
