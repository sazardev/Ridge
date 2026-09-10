import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/content/domain/repositories/snippet_repository.dart';
import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';

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
