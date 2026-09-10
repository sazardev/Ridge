import 'dart:math';

import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/content/domain/repositories/snippet_repository.dart';
import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';

/// Picks the next same-difficulty snippet a Sprint run (SPEC.md §5.2)
/// advances to once the current snippet is finished before the countdown
/// reaches zero.
///
/// Sprint is a continuous stream within a single timed session, not a new
/// session per snippet (see the project plan's "one `typing_sessions` row
/// per Sprint run" design decision) — this use case only decides *which*
/// snippet comes next; `PracticeSessionController` is what keeps the
/// keystroke sequence and clock running uninterrupted across the swap.
class GetNextSprintSnippetUseCase {
  /// Creates the use case over the given [SnippetRepository] port. An
  /// optional [random] source lets tests make the "which unused
  /// candidate" pick deterministic; production code leaves it `null` and
  /// gets a fresh `Random()` per call.
  const new(this._repository, {this.random});

  final SnippetRepository _repository;

  /// Injectable randomness for the "which unused candidate" pick.
  final Random? random;

  /// Returns a snippet of [difficulty] in [language], preferring one not
  /// already in [usedSnippetIds] this Sprint run. Scoping the pool to the
  /// starting snippet's language keeps a Sprint run single-language (a Go
  /// run never suddenly serves a Bash snippet, and vice versa). If every
  /// candidate of that language/difficulty has already been used, repeats
  /// are allowed rather than dead-ending the timer — a high-skill Sprint
  /// run can plausibly exhaust the local catalog, and repeating content
  /// beats stalling the countdown with nowhere to go. Only genuinely
  /// empty catalog for that language/difficulty (no candidates at all)
  /// is an error.
  Future<Result<Snippet, AppFailure>> call({
    required ProgrammingLanguage language,
    required Difficulty difficulty,
    required Set<SnippetId> usedSnippetIds,
  }) {
    return _repository
        .findByFilters(language: language, difficulty: difficulty)
        .then((result) {
          return result.fold((candidates) {
            if (candidates.isEmpty) {
              return Result.err(
                NotFoundFailure(
                  'No ${language.name} snippets available for difficulty '
                  '${difficulty.name}',
                ),
              );
            }
            final unused = [
              for (final candidate in candidates)
                if (!usedSnippetIds.contains(candidate.id)) candidate,
            ];
            final pool = unused.isNotEmpty ? unused : candidates;
            final index = (random ?? Random()).nextInt(pool.length);
            return Result.ok(pool[index]);
          }, Result.err);
        });
  }
}
