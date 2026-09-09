import 'package:just_in_time/core/persistence/drift/app_database.dart';
import 'package:just_in_time/core/persistence/drift/database_provider.dart';
import 'package:just_in_time/features/content/application/usecases/browse_snippets_usecase.dart';
import 'package:just_in_time/features/content/application/usecases/get_snippet_by_id_usecase.dart';
import 'package:just_in_time/features/content/application/usecases/seed_snippet_catalog_usecase.dart';
import 'package:just_in_time/features/content/application/usecases/watch_snippet_catalog_usecase.dart';
import 'package:just_in_time/features/content/domain/entities/snippet.dart';
import 'package:just_in_time/features/content/domain/repositories/snippet_catalog_source.dart';
import 'package:just_in_time/features/content/domain/repositories/snippet_repository.dart';
import 'package:just_in_time/features/content/infrastructure/snippet_dao.dart';
import 'package:just_in_time/features/content/infrastructure/snippet_local_data_source.dart';
import 'package:just_in_time/features/content/infrastructure/snippet_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'content_providers.g.dart';

/// Provides the [SnippetDao] bound to the shared [AppDatabase].
@Riverpod(keepAlive: true)
SnippetDao snippetDao(Ref ref) {
  return ref.watch(appDatabaseProvider).snippetDao;
}

/// Provides the [SnippetRepository] implementation used across the app.
@Riverpod(keepAlive: true)
SnippetRepository snippetRepository(Ref ref) {
  return SnippetRepositoryImpl(ref.watch(snippetDaoProvider));
}

/// Provides the [SnippetCatalogSource] adapter (bundled JSON asset).
@Riverpod(keepAlive: true)
SnippetCatalogSource snippetCatalogSource(Ref ref) {
  return const SnippetLocalDataSource();
}

/// Provides the [SeedSnippetCatalogUseCase] used to seed the catalog at
/// app startup.
@riverpod
SeedSnippetCatalogUseCase seedSnippetCatalogUseCase(Ref ref) {
  return SeedSnippetCatalogUseCase(
    ref.watch(snippetCatalogSourceProvider),
    ref.watch(snippetRepositoryProvider),
  );
}

/// Provides the [BrowseSnippetsUseCase] for filtered catalog lookups.
@riverpod
BrowseSnippetsUseCase browseSnippetsUseCase(Ref ref) {
  return BrowseSnippetsUseCase(ref.watch(snippetRepositoryProvider));
}

/// Provides the [GetSnippetByIdUseCase] for single-entry lookups.
@riverpod
GetSnippetByIdUseCase getSnippetByIdUseCase(Ref ref) {
  return GetSnippetByIdUseCase(ref.watch(snippetRepositoryProvider));
}

/// Provides the [WatchSnippetCatalogUseCase] for observing the catalog.
@riverpod
WatchSnippetCatalogUseCase watchSnippetCatalogUseCase(Ref ref) {
  return WatchSnippetCatalogUseCase(ref.watch(snippetRepositoryProvider));
}

/// Runs the (idempotent) catalog seed once at app startup. Watched from
/// `JustInTimeApp`'s build method so it fires as soon as the app starts,
/// regardless of which route the router lands on first — `keepAlive`
/// means it only ever runs once for the app's lifetime.
@Riverpod(keepAlive: true)
Future<void> catalogSeed(Ref ref) {
  return ref.watch(seedSnippetCatalogUseCaseProvider)().then((result) {
    if (result.isErr) {
      throw StateError(result.failureOrNull?.message ?? 'Seed failed');
    }
  });
}

/// Exposes the full active catalog as a reactive [AsyncValue].
@Riverpod(keepAlive: true)
class SnippetCatalogController extends _$SnippetCatalogController {
  @override
  Stream<List<Snippet>> build() {
    return ref.watch(watchSnippetCatalogUseCaseProvider)();
  }
}
