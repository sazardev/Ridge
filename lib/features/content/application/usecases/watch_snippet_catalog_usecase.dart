import 'package:just_in_time/features/content/domain/entities/snippet.dart';
import 'package:just_in_time/features/content/domain/repositories/snippet_repository.dart';

/// Streams the full active catalog and every subsequent change.
class WatchSnippetCatalogUseCase {
  /// Creates the use case over the given [SnippetRepository] port.
  const new(this._repository);

  final SnippetRepository _repository;

  /// Returns a stream that emits whenever the catalog changes.
  Stream<List<Snippet>> call() => _repository.watchCatalog();
}
