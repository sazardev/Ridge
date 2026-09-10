import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/content/domain/repositories/snippet_repository.dart';

/// Driven port for the bundled, curated snippet catalog (SPEC.md §3.2).
///
/// Kept separate from [SnippetRepository]: this is a read-only source of
/// *authored* content (a JSON asset shipped with the app), never the
/// queryable persistence store the repository owns — separating them
/// lets `SeedSnippetCatalogUseCase` depend on two narrow domain ports
/// instead of reaching into infrastructure directly.
abstract interface class SnippetCatalogSource {
  /// Loads every entry currently shipped in the bundled content asset,
  /// already mapped to the domain model.
  Future<List<Snippet>> loadBundledCatalog();
}
