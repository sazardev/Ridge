import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/content/domain/repositories/snippet_repository.dart';
import 'package:ridge/features/daily_challenge/domain/entities/daily_challenge.dart';
import 'package:ridge/features/daily_challenge/domain/services/daily_challenge_selector.dart';
import 'package:ridge/features/daily_challenge/domain/value_objects/challenge_date.dart';

/// Today's computed Daily Challenge assignment, paired with the actual
/// [Snippet] to play — the result screen and the catalog only need the
/// latter, but callers that persist a completion need the former's
/// [DailyChallenge.date].
typedef TodaysDailyChallenge = ({DailyChallenge challenge, Snippet snippet});

/// Resolves today's shared Daily Challenge snippet (SPEC.md §5.4): a
/// deterministic pick — via [DailyChallengeSelector] — from a fixed,
/// approachable pool (Go, beginner/intermediate difficulty only), so the
/// daily habit never depends on the user's own progress or on a server.
class GetTodaysDailyChallengeUseCase {
  /// Creates the use case over the given [SnippetRepository] port and an
  /// optional injected [selector] (defaults to the real one — tests can
  /// supply a fake for isolation, though it's already pure and cheap
  /// enough that most tests just use the default).
  const new(
    this._snippetRepository, {
    this.selector = const DailyChallengeSelector(),
  });

  final SnippetRepository _snippetRepository;

  /// The (pure, stateless) selector used to pick today's snippet.
  final DailyChallengeSelector selector;

  /// Difficulties the shared pool draws from — fixed rather than
  /// rotating through every difficulty, so the daily habit stays
  /// approachable regardless of the user's own skill level.
  static const List<Difficulty> _difficulties = [
    Difficulty.beginner,
    Difficulty.intermediate,
  ];

  /// Resolves today's ([nowUtc]'s UTC calendar day) Daily Challenge.
  Future<Result<TodaysDailyChallenge, AppFailure>> call({
    required DateTime nowUtc,
  }) async {
    final date = ChallengeDate.fromUtc(nowUtc);
    final candidates = <Snippet>[];
    for (final difficulty in _difficulties) {
      final result = await _snippetRepository.findByFilters(
        language: ProgrammingLanguage.go,
        difficulty: difficulty,
      );
      final failure = result.failureOrNull;
      if (failure != null) return Result.err(failure);
      candidates.addAll(result.valueOrNull ?? const []);
    }
    final snippet = selector.selectFor(date: date, candidates: candidates);
    if (snippet == null) {
      return const Result.err(
        NotFoundFailure('No Go snippets available for the Daily Challenge'),
      );
    }
    return Result.ok((
      challenge: DailyChallenge(
        date: date,
        snippetId: snippet.id,
        snippetRevision: snippet.revision,
      ),
      snippet: snippet,
    ));
  }
}
