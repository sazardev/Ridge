import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/content/domain/entities/snippet.dart';
import 'package:just_in_time/features/content/domain/repositories/snippet_repository.dart';
import 'package:just_in_time/features/content/domain/value_objects/snippet_id.dart';

/// Looks up a single catalog entry by its stable [SnippetId].
class GetSnippetByIdUseCase {
  /// Creates the use case over the given [SnippetRepository] port.
  const new(this._repository);

  final SnippetRepository _repository;

  /// Returns the catalog entry identified by [id].
  Future<Result<Snippet, AppFailure>> call(SnippetId id) {
    return _repository.getById(id);
  }
}
