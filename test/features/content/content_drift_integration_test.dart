// Exercises the content feature's full stack — usecases, repository,
// DAO, and the shared `AppDatabase` — against a *real* in-memory drift
// (SQLite) database AND the *real* bundled JSON asset (not a hand-fake
// repository, not fabricated in-test data). Mirrors
// `test/features/profile/profile_drift_integration_test.dart`: table
// creation via the drift migration, the seed usecase actually parsing
// every bundled catalog asset (`go_v1.json`, `bash_v1.json`,
// `sql_v1.json`, `rust_v1.json`, `python_v1.json`, `javascript_v1.json`,
// `typescript_v1.json`, `haskell_v1.json`, `c_v1.json`, and
// `cpp_v1.json`) and writing
// every row through SQL, and
// every read port
// (`findByFilters`, `getById`, `findContainingSymbols`) queried back out
// for real.
import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/persistence/drift/app_database.dart';
import 'package:ridge/core/persistence/drift/database_provider.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
import 'package:ridge/features/content/infrastructure/snippet_local_data_source.dart';
import 'package:ridge/features/content/presentation/providers/content_providers.dart';

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
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        // This test's concern is the bundled catalog's seed/query path,
        // not `CompositeSnippetCatalogSource`'s external-pack merging
        // (see `external_snippet_pack_source_test.dart` for that) —
        // pinning the bundled-only source here also means this test
        // never touches `path_provider`'s platform channel, which
        // `flutter_test`'s binding doesn't implement.
        snippetCatalogSourceProvider.overrideWithValue(
          const SnippetLocalDataSource(),
        ),
      ],
    );
    addTearDown(() => database.close());

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
    // Registered last so it tears down first (addTearDown runs LIFO):
    // disposing the container cancels the `listen` above, so no
    // trailing emission can ever land on `catalogUpdates` after it's
    // closed — a real race once seeding became a single batched write
    // (one notification arriving on its own timing) rather than one
    // write per row.
    addTearDown(container.dispose);
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
        .firstWhere((snippets) => snippets.length == 1367)
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
    expect(catalog, hasLength(1367));
    expect(catalog.every((s) => s.isActive), isTrue);
  });

  test(
    'seeding is idempotent: running it twice does not duplicate rows',
    () async {
      await seed();
      final settled = settledCatalog();
      await seed();

      final catalog = await settled;
      expect(catalog, hasLength(1367));
    },
  );

  test('the reactive watchCatalog stream picks up the seed without a manual '
      'refresh', () async {
    final settled = settledCatalog();

    await seed();

    final result = await settled;
    expect(result, hasLength(1367));
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
    expect(beginnerSnippets, hasLength(495));
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
      'bash-func-003',
      'bash-func-004',
      'bash-profile-007',
      'bash-ssh-005',
      'bash-ssh-007',
      'bash-sshserv-001',
      'bash-sshserv-002',
      'bash-sshserv-003',
      'bash-sshserv-004',
      'c-algo-001',
      'c-algo-002',
      'c-algo-003',
      'c-algo-004',
      'c-algo-005',
      'c-algo-006',
      'c-algo-007',
      'c-algo-008',
      'c-algo-009',
      'c-algo-010',
      'c-algo-011',
      'c-algo-012',
      'c-arr-004',
      'c-cond-002',
      'c-func-002',
      'c-func-003',
      'c-pre-001',
      'c-pre-003',
      'c-vars-003',
      'c-vars-004',
      'cpp-algo-001',
      'cpp-algo-002',
      'cpp-algo-003',
      'cpp-algo-004',
      'cpp-algo-005',
      'cpp-algo-006',
      'cpp-algo-008',
      'cpp-algo-009',
      'cpp-algo-010',
      'cpp-algo-011',
      'cpp-algo-012',
      'cpp-class-001',
      'cpp-class-002',
      'cpp-conc-001',
      'cpp-cond-003',
      'cpp-err-001',
      'cpp-mem-001',
      'cpp-mem-002',
      'cpp-mem-003',
      'cpp-mem-004',
      'cpp-stl-001',
      'cpp-stl-005',
      'cpp-stl-006',
      'cpp-tmpl-002',
      'crystal-algo-001',
      'crystal-algo-002',
      'crystal-algo-003',
      'crystal-algo-004',
      'crystal-algo-005',
      'crystal-algo-006',
      'crystal-algo-007',
      'crystal-algo-008',
      'crystal-algo-009',
      'crystal-algo-012',
      'crystal-arr-001',
      'crystal-nil-001',
      'crystal-struct-001',
      'crystal-vars-003',
      'csharp-algo-009',
      'csharp-algo-012',
      'csharp-del-002',
      'csharp-err-003',
      'csharp-gen-002',
      'csharp-oop-004',
      'csharp-pat-002',
      'csharp-vars-001',
      'css-cap-001',
      'css-grid-002',
      'css-pos-002',
      'css-pos-005',
      'css-var-002',
      'dart-adv-gen-002',
      'dart-algo-006',
      'dart-algo-007',
      'dart-algo-008',
      'dart-cond-002',
      'dart-rec-002',
      'docker-compose-006',
      'docker-compose-011',
      'docker-compose-012',
      'docker-compose-016',
      'docker-file-004',
      'gha-container-001',
      'gha-deploy-001',
      'gha-deploy-002',
      'gha-deploy-003',
      'gha-deploy-004',
      'gha-docker-001',
      'gha-docker-002',
      'gha-expr-001',
      'gha-expr-002',
      'gha-expr-003',
      'gha-job-001',
      'gha-job-002',
      'gha-job-004',
      'gha-job-006',
      'gha-matrix-004',
      'gha-pattern-002',
      'gha-pattern-003',
      'gha-pattern-004',
      'gha-pattern-005',
      'gha-release-001',
      'gha-release-004',
      'gha-reusable-001',
      'gha-secret-001',
      'gha-secret-002',
      'gha-secret-003',
      'gha-security-003',
      'gha-security-004',
      'gha-security-005',
      'gha-security-006',
      'gha-security-007',
      'gha-security-008',
      'gha-service-001',
      'gha-trigger-001',
      'gha-trigger-002',
      'gha-trigger-003',
      'gha-trigger-004',
      'gha-trigger-005',
      'gha-workflow-003',
      'gha-workflow-004',
      'git-collab-009',
      'go-algo-010',
      'go-algo-011',
      'go-algo-012',
      'go-apidesign-002',
      'go-clichal-003',
      'go-clichal-004',
      'go-climenu-005',
      'go-clitext-003',
      'go-clitext-004',
      'go-concpat-001',
      'go-concpat-003',
      'go-concpat-004',
      'go-concpat-005',
      'go-cond-007',
      'go-err-009',
      'go-err-010',
      'go-err-012',
      'go-errpat-002',
      'go-evol-004',
      'go-func-002',
      'go-func-006',
      'go-func-010',
      'go-func-012',
      'go-generics-003',
      'go-genmeth-002',
      'go-genmeth-004',
      'go-http-007',
      'go-http-009',
      'go-http-010',
      'go-httptest-003',
      'go-idiom-003',
      'go-iface-010',
      'go-iface-027',
      'go-jsonv2-004',
      'go-leak-001',
      'go-leak-002',
      'go-loop-002',
      'go-loop-007',
      'go-loop-011',
      'go-loop-013',
      'go-obs-001',
      'go-obs-003',
      'go-perf-001',
      'go-perf-002',
      'go-perf-003',
      'go-persist-001',
      'go-persist-002',
      'go-persist-003',
      'go-persist-004',
      'go-rest-001',
      'go-slice-002',
      'go-slice-003',
      'go-slice-004',
      'go-sqlite-002',
      'go-sqlite-003',
      'go-sqlite-004',
      'go-sqlite-005',
      'go-sqlite-006',
      'go-stdlib-005',
      'go-struct-001',
      'go-struct-004',
      'go-testadv-001',
      'go-testadv-004',
      'go-testfakes-001',
      'go-testfakes-002',
      'go-tui-008',
      'go-tui-009',
      'go-tui-010',
      'go-tui-011',
      'go-tui-013',
      'go-tui-027',
      'go-tui-028',
      'go-tui-029',
      'go-vars-009',
      'go-vars-011',
      'go-vars-012',
      'haskell-algo-001',
      'haskell-algo-002',
      'haskell-algo-004',
      'haskell-algo-008',
      'haskell-algo-010',
      'haskell-algo-011',
      'haskell-algo-012',
      'haskell-cond-003',
      'java-algo-012',
      'java-vars-001',
      'javascript-vars-002',
      'kotlin-algo-012',
      'kotlin-oop-002',
      'linux-net-011',
      'linux-net-013',
      'linux-net-014',
      'php-algo-006',
      'php-algo-010',
      'php-algo-011',
      'php-algo-012',
      'php-arr-001',
      'php-arr-002',
      'php-arr-003',
      'php-arr-004',
      'php-class-001',
      'php-class-002',
      'php-class-003',
      'php-cond-001',
      'php-cond-002',
      'php-enum-001',
      'php-err-001',
      'php-err-002',
      'php-func-001',
      'php-func-002',
      'php-func-003',
      'php-loop-001',
      'php-loop-002',
      'php-ns-001',
      'php-str-001',
      'php-str-002',
      'php-vars-002',
      'php-vars-003',
      'php-vars-004',
      'php-web-001',
      'php-web-002',
      'php-web-003',
      'php-web-004',
      'php-web-005',
      'php-web-006',
      'php-web-007',
      'php-web-008',
      'php-web-009',
      'php-web-010',
      'php-web-011',
      'php-web-012',
      'python-algo-001',
      'python-algo-002',
      'python-algo-003',
      'python-algo-004',
      'python-algo-005',
      'python-algo-006',
      'python-algo-007',
      'python-algo-008',
      'python-algo-009',
      'python-algo-011',
      'python-algo-012',
      'python-django-admin-002',
      'python-django-form-001',
      'python-django-form-003',
      'python-django-migration-001',
      'python-django-migration-002',
      'python-django-model-001',
      'python-django-model-003',
      'python-django-model-004',
      'python-django-orm-001',
      'python-django-orm-002',
      'python-django-orm-003',
      'python-django-orm-004',
      'python-django-orm-005',
      'python-django-orm-006',
      'python-django-orm-007',
      'python-django-orm-008',
      'python-django-orm-009',
      'python-django-orm-010',
      'python-django-project-002',
      'python-django-project-003',
      'python-django-relation-001',
      'python-django-relation-003',
      'python-django-relation-004',
      'python-django-rest-001',
      'python-django-rest-002',
      'python-django-rest-003',
      'python-django-rest-004',
      'python-django-rest-005',
      'python-django-rest-006',
      'python-django-rest-007',
      'python-django-rest-008',
      'python-django-rest-009',
      'python-django-rest-010',
      'python-django-rest-011',
      'python-django-rest-012',
      'python-django-rest-013',
      'python-django-rest-014',
      'python-django-rest-015',
      'python-django-rest-016',
      'python-django-rest-017',
      'python-django-template-001',
      'python-django-template-003',
      'python-django-test-001',
      'python-django-test-002',
      'python-django-view-001',
      'python-django-view-002',
      'python-django-view-003',
      'python-django-view-004',
      'python-func-002',
      'python-func-003',
      'rust-algo-001',
      'rust-algo-002',
      'rust-algo-003',
      'rust-algo-004',
      'rust-algo-005',
      'rust-algo-006',
      'rust-algo-007',
      'rust-algo-008',
      'rust-algo-009',
      'rust-algo-010',
      'rust-algo-011',
      'rust-algo-012',
      'rust-func-003',
      'sql-advanced-002',
      'sql-advanced-003',
      'sql-advanced-004',
      'sql-aggregation-001',
      'sql-aggregation-002',
      'sql-aggregation-003',
      'sql-aggregation-004',
      'sql-aggregation-005',
      'sql-basics-004',
      'sql-filtering-001',
      'sql-filtering-002',
      'sql-filtering-005',
      'sql-filtering-006',
      'sql-joins-001',
      'sql-joins-002',
      'sql-joins-003',
      'sql-joins-004',
      'sql-joins-005',
      'sql-joins-006',
      'sql-joins-007',
      'sql-modifications-002',
      'sql-modifications-003',
      'sql-modifications-004',
      'sql-modifications-005',
      'sql-queries-003',
      'sql-schema-004',
      'sql-schema-005',
      'sql-schema-006',
      'sql-schema-007',
      'sql-schema-011',
      'sql-schema-012',
      'sql-schema-013',
      'swift-algo-001',
      'swift-algo-002',
      'swift-algo-003',
      'swift-algo-004',
      'swift-algo-005',
      'swift-algo-006',
      'swift-algo-007',
      'swift-algo-008',
      'swift-algo-009',
      'swift-algo-010',
      'swift-algo-011',
      'swift-algo-012',
      'swift-closure-002',
      'swift-codable-001',
      'swift-conc-003',
      'swift-err-002',
      'swift-func-001',
      'swift-func-002',
      'swift-func-003',
      'swift-prop-001',
      'swift-proto-002',
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
      'bash-files-006',
      'bash-vars-007',
      'c-algo-010',
      'c-algo-011',
      'c-arr-001',
      'c-arr-002',
      'c-arr-004',
      'c-err-002',
      'c-func-003',
      'c-io-001',
      'c-io-002',
      'c-loop-001',
      'c-loop-002',
      'c-mem-001',
      'c-mem-002',
      'c-mem-003',
      'c-mem-004',
      'c-pre-001',
      'c-pre-002',
      'c-ptr-001',
      'c-ptr-002',
      'c-ptr-003',
      'c-struct-001',
      'c-struct-002',
      'c-struct-003',
      'c-vars-002',
      'c-vars-003',
      'c-vars-004',
      'cpp-loop-002',
      'csharp-del-001',
      'csharp-linq-002',
      'csharp-loops-003',
      'css-box-004',
      'css-color-002',
      'css-resp-001',
      'css-resp-002',
      'css-resp-003',
      'dart-func-004',
      'git-log-002',
      'go-clichal-002',
      'go-clichal-003',
      'go-clichal-004',
      'go-clichal-005',
      'go-climath-001',
      'go-climath-002',
      'go-climath-003',
      'go-climath-004',
      'go-climath-005',
      'go-climenu-003',
      'go-climenu-004',
      'go-climenu-005',
      'go-clitext-003',
      'go-clitext-004',
      'go-client-001',
      'go-client-002',
      'go-client-003',
      'go-client-005',
      'go-cond-005',
      'go-cond-007',
      'go-cond-010',
      'go-err-002',
      'go-err-003',
      'go-err-008',
      'go-err-010',
      'go-errpat-002',
      'go-evol-003',
      'go-func-004',
      'go-func-008',
      'go-http-003',
      'go-http-004',
      'go-http-005',
      'go-http-006',
      'go-http-008',
      'go-http-010',
      'go-http-015',
      'go-http-016',
      'go-http-017',
      'go-httptest-001',
      'go-httptest-002',
      'go-httptest-003',
      'go-iface-011',
      'go-iface-013',
      'go-iface-015',
      'go-iface-016',
      'go-iface-021',
      'go-iface-022',
      'go-iter-003',
      'go-leak-003',
      'go-loop-004',
      'go-loop-011',
      'go-loop-013',
      'go-modern-004',
      'go-persist-002',
      'go-persist-003',
      'go-rest-002',
      'go-rest-008',
      'go-sqlite-006',
      'go-testadv-001',
      'go-testadv-002',
      'go-testadv-003',
      'go-testadv-005',
      'go-testfakes-002',
      'go-tui-005',
      'go-tui-006',
      'go-tui-007',
      'go-tui-012',
      'go-tui-013',
      'go-tui-025',
      'go-tui-028',
      'go-tui-029',
      'go-usecase-001',
      'go-usecase-002',
      'go-usecase-003',
      'go-usecase-004',
      'go-vars-003',
      'go-vars-006',
      'java-cond-003',
      'java-func-003',
      'javascript-func-003',
      'kotlin-func-003',
      'kotlin-lambda-002',
      'kotlin-lambda-003',
      'linux-net-011',
      'linux-net-013',
      'linux-net-014',
      'linux-perm-001',
      'linux-perm-003',
      'linux-perm-004',
      'linux-perm-005',
      'linux-perm-006',
      'linux-perm-007',
      'python-django-form-003',
      'python-django-template-002',
      'python-django-template-003',
      'python-func-003',
      'rust-cond-002',
      'rust-func-003',
      'sql-filtering-008',
      'sql-filtering-009',
      'typescript-func-004',
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
