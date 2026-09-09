// Exercises the content feature's full stack — usecases, repository,
// DAO, and the shared `AppDatabase` — against a *real* in-memory drift
// (SQLite) database AND the *real* bundled JSON asset (not a hand-fake
// repository, not fabricated in-test data). Mirrors
// `test/features/profile/profile_drift_integration_test.dart`: table
// creation via the drift migration, the seed usecase actually parsing
// `assets/content/snippets/go_v1.json` and writing every row through
// SQL, and every read port (`findByFilters`, `getById`,
// `findContainingSymbols`) queried back out for real.
import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_in_time/core/persistence/drift/app_database.dart';
import 'package:just_in_time/core/persistence/drift/database_provider.dart';
import 'package:just_in_time/features/content/domain/entities/difficulty.dart';
import 'package:just_in_time/features/content/domain/entities/snippet.dart';
import 'package:just_in_time/features/content/domain/value_objects/snippet_id.dart';
import 'package:just_in_time/features/content/presentation/providers/content_providers.dart';

void main() {
  // Loading the real asset via `rootBundle` requires a real (test)
  // binding to be initialized — this is what makes this an *integration*
  // test rather than a pure-Dart unit test.
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase database;
  late ProviderContainer container;
  late StreamController<List<Snippet>> catalogUpdates;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(database)],
    );
    addTearDown(() => database.close());
    addTearDown(container.dispose);

    // Riverpod only pumps a StreamNotifier's underlying subscription
    // while something is actively watching/listening to it (mirrors
    // `profile_drift_integration_test.dart`'s rationale) — in the real
    // app this is `SnippetBrowserScreen`'s `ref.watch(...)`; here we
    // stand in for it so `.future`/`.watch()` reads below observe a live
    // subscription instead of a cold one.
    catalogUpdates = StreamController<List<Snippet>>.broadcast();
    addTearDown(catalogUpdates.close);
    container.listen(snippetCatalogControllerProvider, (_, next) {
      if (next.hasValue) catalogUpdates.add(next.value!);
    });
  });

  Future<void> seed() async {
    final result = await container.read(seedSnippetCatalogUseCaseProvider)();
    expect(result.isOk, isTrue);
  }

  // Awaiting `seed()` only guarantees every write has been committed to
  // SQLite — drift's `.watch()` re-queries and notifies subscribers
  // asynchronously, so a handful of trailing emissions can still be
  // in-flight the instant `seed()` resolves. Waiting for the stream to
  // report the fully-settled row count (rather than reading a
  // possibly-stale cached `.future` value) avoids racing those
  // in-flight emissions.
  Future<List<Snippet>> settledCatalog() {
    return catalogUpdates.stream
        .firstWhere((snippets) => snippets.length == 90)
        .timeout(const Duration(seconds: 5));
  }

  test('catalog is empty before the seed usecase runs', () async {
    final row = await container.read(snippetDaoProvider).getById('go-vars-001');
    expect(row, isNull);
  });

  test('seeding writes every bundled entry into drift, keyed by id', () async {
    final settled = settledCatalog();
    await seed();

    final catalog = await settled;
    expect(catalog, hasLength(90));
    expect(catalog.every((s) => s.isActive), isTrue);
  });

  test(
    'seeding is idempotent: running it twice does not duplicate rows',
    () async {
      await seed();
      final settled = settledCatalog();
      await seed();

      final catalog = await settled;
      expect(catalog, hasLength(90));
    },
  );

  test('the reactive watchCatalog stream picks up the seed without a manual '
      'refresh', () async {
    final settled = settledCatalog();

    await seed();

    final result = await settled;
    expect(result, hasLength(90));
  });

  test(
    'getById returns a known entry, and NotFoundFailure otherwise',
    () async {
      await seed();

      final found = await container.read(getSnippetByIdUseCaseProvider)(
        const SnippetId('go-ptr-001'),
      );
      expect(found.isOk, isTrue);
      expect(found.valueOrNull?.titleEn, 'Increment through a pointer');
      expect(found.valueOrNull?.titleEs, 'Incrementar a través de un puntero');

      final missing = await container.read(getSnippetByIdUseCaseProvider)(
        const SnippetId('does-not-exist'),
      );
      expect(missing.isErr, isTrue);
    },
  );

  test('findByFilters narrows by difficulty', () async {
    await seed();

    final result = await container.read(browseSnippetsUseCaseProvider)(
      difficulty: Difficulty.beginner,
    );
    expect(result.isOk, isTrue);
    final beginnerSnippets = result.valueOrNull!;
    expect(beginnerSnippets, hasLength(22));
    expect(
      beginnerSnippets.every((s) => s.difficulty == Difficulty.beginner),
      isTrue,
    );
  });

  test('findContainingSymbols matches a literal underscore without treating '
      'it as a SQL LIKE wildcard', () async {
    await seed();

    final result = await container
        .read(snippetRepositoryProvider)
        .findContainingSymbols({'_'});
    expect(result.isOk, isTrue);
    final ids = result.valueOrNull!.map((s) => s.id.value).toSet();
    expect(ids, {
      'go-cond-007',
      'go-err-009',
      'go-err-010',
      'go-err-012',
      'go-func-002',
      'go-func-006',
      'go-func-010',
      'go-func-012',
      'go-generics-003',
      'go-loop-002',
      'go-loop-007',
      'go-loop-011',
      'go-loop-013',
      'go-slice-002',
      'go-slice-003',
      'go-slice-004',
      'go-struct-001',
      'go-struct-004',
      'go-vars-009',
      'go-vars-011',
      'go-vars-012',
    });
  });

  test('findContainingSymbols matches a literal percent sign without treating '
      'it as a SQL LIKE wildcard', () async {
    await seed();

    final result = await container
        .read(snippetRepositoryProvider)
        .findContainingSymbols({'%'});
    expect(result.isOk, isTrue);
    final ids = result.valueOrNull!.map((s) => s.id.value).toSet();
    expect(ids, {
      'go-cond-005',
      'go-cond-007',
      'go-cond-010',
      'go-err-002',
      'go-err-003',
      'go-err-008',
      'go-err-010',
      'go-func-004',
      'go-func-008',
      'go-loop-004',
      'go-loop-011',
      'go-loop-013',
      'go-vars-003',
      'go-vars-006',
    });
  });

  test(
    'findContainingSymbols returns nothing for an empty character set',
    () async {
      await seed();

      final result = await container
          .read(snippetRepositoryProvider)
          .findContainingSymbols(const {});
      expect(result.isOk, isTrue);
      expect(result.valueOrNull, isEmpty);
    },
  );
}
