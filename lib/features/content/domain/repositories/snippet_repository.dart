import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/content/domain/entities/content_category.dart';
import 'package:just_in_time/features/content/domain/entities/difficulty.dart';
import 'package:just_in_time/features/content/domain/entities/snippet.dart';
import 'package:just_in_time/features/content/domain/entities/snippet_length.dart';
import 'package:just_in_time/features/content/domain/repositories/snippet_catalog_source.dart';
import 'package:just_in_time/features/content/domain/value_objects/snippet_id.dart';

/// Driven port: the application core depends on this abstraction only.
/// Infrastructure provides the adapter (currently a local drift table
/// seeded from a bundled JSON asset — see [SnippetCatalogSource]).
abstract interface class SnippetRepository {
  /// Emits every active catalog entry, and every subsequent change.
  Stream<List<Snippet>> watchCatalog();

  /// Returns the catalog entry identified by [id].
  Future<Result<Snippet, AppFailure>> getById(SnippetId id);

  /// Returns every active catalog entry matching all of the given,
  /// optional filters. A `null` filter means "don't filter on this".
  Future<Result<List<Snippet>, AppFailure>> findByFilters({
    Difficulty? difficulty,
    ContentCategory? category,
    SnippetLength? length,
  });

  /// Returns every active catalog entry whose code contains at least one
  /// of the given literal [characters] — powers weakness-based
  /// recommendation (SPEC.md §3.3, §4): the app recommends snippets that
  /// exercise the characters a user historically struggles with.
  Future<Result<List<Snippet>, AppFailure>> findContainingSymbols(
    Set<String> characters,
  );

  /// Idempotently writes [entries] into storage, keyed by [Snippet.id] —
  /// an existing row for the same id is replaced. This is the only write
  /// path this repository exposes: catalog content is curated, not
  /// user-authored, so the sole mutation is re-seeding from the bundled
  /// catalog (see `SeedSnippetCatalogUseCase`).
  Future<Result<void, AppFailure>> upsertCatalogEntries(List<Snippet> entries);
}
