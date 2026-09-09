import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/content/domain/repositories/snippet_catalog_source.dart';
import 'package:just_in_time/features/content/domain/repositories/snippet_repository.dart';

/// Idempotently seeds the local catalog from the bundled content asset.
///
/// Given the realistic row count here (tens, not millions, of curated
/// snippets), a straightforward "parse the whole bundled catalog, upsert
/// every row keyed by id" on every app start is simpler — and cheap
/// enough — than tracking a separate "have we already seeded this
/// version" bookkeeping table.
class SeedSnippetCatalogUseCase {
  /// Creates the use case over the given ports.
  const new(this._catalogSource, this._repository);

  final SnippetCatalogSource _catalogSource;
  final SnippetRepository _repository;

  /// Loads the bundled catalog and upserts every entry into storage.
  Future<Result<void, AppFailure>> call() async {
    final entries = await _catalogSource.loadBundledCatalog();
    return await _repository.upsertCatalogEntries(entries);
  }
}
