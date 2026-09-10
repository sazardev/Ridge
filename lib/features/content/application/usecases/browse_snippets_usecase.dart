import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/content/domain/entities/content_category.dart';
import 'package:just_in_time/features/content/domain/entities/difficulty.dart';
import 'package:just_in_time/features/content/domain/entities/programming_language.dart';
import 'package:just_in_time/features/content/domain/entities/snippet.dart';
import 'package:just_in_time/features/content/domain/entities/snippet_length.dart';
import 'package:just_in_time/features/content/domain/repositories/snippet_repository.dart';

/// Looks up catalog entries by an optional combination of filters
/// (SPEC.md §3.3's "manual choice": the user browses by category and
/// difficulty).
class BrowseSnippetsUseCase {
  /// Creates the use case over the given [SnippetRepository] port.
  const new(this._repository);

  final SnippetRepository _repository;

  /// Returns every active catalog entry matching all given filters.
  Future<Result<List<Snippet>, AppFailure>> call({
    ProgrammingLanguage? language,
    Difficulty? difficulty,
    ContentCategory? category,
    SnippetLength? length,
  }) {
    return _repository.findByFilters(
      language: language,
      difficulty: difficulty,
      category: category,
      length: length,
    );
  }
}
