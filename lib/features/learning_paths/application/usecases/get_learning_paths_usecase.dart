import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/content/domain/entities/snippet.dart';
import 'package:just_in_time/features/content/domain/repositories/snippet_repository.dart';
import 'package:just_in_time/features/content/domain/value_objects/snippet_id.dart';
import 'package:just_in_time/features/learning_paths/domain/entities/learning_path.dart';
import 'package:just_in_time/features/learning_paths/domain/repositories/learning_path_repository.dart';

/// One bundled [LearningPath] paired with the [Snippet] each of its
/// lessons references — the read view `learning_paths`' presentation
/// layer needs to show real snippet titles/previews/difficulty per
/// lesson without every screen re-joining against `content` itself.
typedef LearningPathOverview = ({
  LearningPath path,
  Map<SnippetId, Snippet> snippetsById,
});

/// Loads every bundled [LearningPath], joined against `content`'s
/// [SnippetRepository] for each lesson's display info (SPEC.md §5.7) —
/// `learning_paths` depending on `content` is an established, allowed
/// direction (see the project plan's feature dependency order).
class GetLearningPathsUseCase {
  /// Creates the use case over the given ports.
  const new(this._pathRepository, this._snippetRepository);

  final LearningPathRepository _pathRepository;
  final SnippetRepository _snippetRepository;

  /// Returns every bundled path, each paired with its lessons' snippets.
  Future<Result<List<LearningPathOverview>, AppFailure>> call() async {
    final paths = await _pathRepository.watchPaths().first;

    final overviews = <LearningPathOverview>[];
    for (final path in paths) {
      final snippetsById = <SnippetId, Snippet>{};
      for (final lesson in path.lessons) {
        if (snippetsById.containsKey(lesson.snippetId)) continue;
        final snippetResult = await _snippetRepository.getById(
          lesson.snippetId,
        );
        if (snippetResult.isErr) {
          return Result.err(snippetResult.failureOrNull!);
        }
        snippetsById[lesson.snippetId] = snippetResult.valueOrNull!;
      }
      overviews.add((path: path, snippetsById: snippetsById));
    }
    return Result.ok(overviews);
  }
}
