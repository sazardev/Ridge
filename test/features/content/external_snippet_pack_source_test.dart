// Exercises `ExternalSnippetPackSource`/`CompositeSnippetCatalogSource`
// against a *real* temp directory on disk (not a hand-fake filesystem) —
// mirrors this codebase's existing `shared_preferences_platform_interface`
// pattern (see `data_management_drift_integration_test.dart`) for
// substituting a plugin's platform channel in a test environment:
// `path_provider`'s platform interface is swapped for a fake pointing at
// a temp directory, rather than the real OS application-support path.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:ridge/core/content_packs/content_packs_directory.dart';
import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/content/domain/entities/snippet_length.dart';
import 'package:ridge/features/content/domain/repositories/snippet_catalog_source.dart';
import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
import 'package:ridge/features/content/infrastructure/composite_snippet_catalog_source.dart';
import 'package:ridge/features/content/infrastructure/external_snippet_pack_source.dart';

// `with MockPlatformInterfaceMixin`: `PathProviderPlatform.instance`'s
// setter runs `PlatformInterface.verify`, which deliberately rejects any
// substitute built with a bare `implements` (the guard every real
// platform-interface package uses to stop third parties silently
// bypassing the token-based interface contract) — this mixin is the
// documented, intentional opt-out for tests.
class _FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  new(this._path);

  final String _path;

  @override
  Future<String?> getApplicationSupportPath() async => _path;
}

class _FakeBundledSource implements SnippetCatalogSource {
  const new(this._snippets);

  final List<Snippet> _snippets;

  @override
  Future<List<Snippet>> loadBundledCatalog() async => _snippets;
}

Snippet _snippet(String id, {String title = 'Title'}) => Snippet(
  id: SnippetId(id),
  revision: 1,
  language: ProgrammingLanguage.go,
  difficulty: Difficulty.beginner,
  category: ContentCategory.variablesAndTypes,
  symbolFocus: const {},
  length: SnippetLength.short,
  titleEn: title,
  titleEs: title,
  code: 'x := 1',
  sourceAttribution: 'test',
  isActive: true,
  tldrEn: 'tldr',
  tldrEs: 'tldr',
  explanationEn: 'explanation',
  explanationEs: 'explicacion',
);

Map<String, Object?> _validSnippetMap(String id) => {
  'id': id,
  'revision': 1,
  'language': 'go',
  'difficulty': 'beginner',
  'category': 'variablesAndTypes',
  'symbolFocus': <String>[],
  'length': 'short',
  'titleEn': 'External $id',
  'titleEs': 'Externo $id',
  'code': 'y := 2',
  'sourceAttribution': 'external pack',
  'isActive': true,
  'tldrEn': 'tldr',
  'tldrEs': 'tldr',
  'explanationEn': 'explanation',
  'explanationEs': 'explicacion',
};

String _pack(List<Map<String, Object?>> entries) => jsonEncode(entries);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory supportDir;
  late Directory packsDir;

  setUp(() async {
    supportDir = await Directory.systemTemp.createTemp('jit_test_support_');
    PathProviderPlatform.instance = _FakePathProviderPlatform(supportDir.path);
    packsDir = (await contentPacksSnippetsDir())!;
  });

  tearDown(() async {
    if (supportDir.existsSync()) supportDir.deleteSync(recursive: true);
  });

  test(
    'contentPacksSnippetsDir creates the directory if it does not exist',
    () async {
      expect(packsDir.existsSync(), isTrue);
      expect(packsDir.path, endsWith('content_packs/snippets'));
    },
  );

  test('an empty packs directory yields an empty catalog', () async {
    final result = await const ExternalSnippetPackSource().loadBundledCatalog();
    expect(result, isEmpty);
  });

  test('a valid external pack file loads correctly', () async {
    File('${packsDir.path}/pack1.json')
        .writeAsStringSync(_pack([_validSnippetMap('ext-001')]));

    final result = await const ExternalSnippetPackSource().loadBundledCatalog();

    expect(result, hasLength(1));
    expect(result.single.id.value, 'ext-001');
    expect(result.single.titleEn, 'External ext-001');
  });

  test(
    'an entry with an unrecognized category is skipped, siblings still load',
    () async {
      final badEntry = Map<String, Object?>.of(_validSnippetMap('ext-bad'))
        ..['category'] = 'notARealCategory';
      File('${packsDir.path}/pack1.json')
          .writeAsStringSync(_pack([badEntry, _validSnippetMap('ext-good')]));

      final result = await const ExternalSnippetPackSource()
          .loadBundledCatalog();

      expect(result, hasLength(1));
      expect(result.single.id.value, 'ext-good');
    },
  );

  test('a malformed JSON file is skipped without throwing', () async {
    File('${packsDir.path}/broken.json').writeAsStringSync('{not valid json');
    File('${packsDir.path}/good.json')
        .writeAsStringSync(_pack([_validSnippetMap('ext-still-loads')]));

    final result = await const ExternalSnippetPackSource().loadBundledCatalog();

    expect(result, hasLength(1));
    expect(result.single.id.value, 'ext-still-loads');
  });

  test('a file over the size limit is skipped without throwing, siblings still '
      'load', () async {
    File('${packsDir.path}/huge.json')
        .writeAsBytesSync(List.filled(maxContentPackFileBytes + 1, 0x20));
    File('${packsDir.path}/good.json')
        .writeAsStringSync(_pack([_validSnippetMap('ext-still-loads')]));

    final result = await const ExternalSnippetPackSource().loadBundledCatalog();

    expect(result, hasLength(1));
    expect(result.single.id.value, 'ext-still-loads');
  });

  test('non-.json files in the directory are ignored', () async {
    File('${packsDir.path}/readme.txt').writeAsStringSync('not json at all');

    final result = await const ExternalSnippetPackSource().loadBundledCatalog();

    expect(result, isEmpty);
  });

  group('CompositeSnippetCatalogSource', () {
    test('merges bundled and external snippets', () async {
      File('${packsDir.path}/pack1.json')
          .writeAsStringSync(_pack([_validSnippetMap('ext-001')]));

      final bundled = _snippet('bundled-001');
      final result = await CompositeSnippetCatalogSource(
        _FakeBundledSource([bundled]),
      ).loadBundledCatalog();

      expect(
        result.map((s) => s.id.value),
        containsAll(['bundled-001', 'ext-001']),
      );
    });

    test(
      'an external snippet whose id collides with a bundled one is skipped',
      () async {
        File('${packsDir.path}/pack1.json')
            .writeAsStringSync(_pack([_validSnippetMap('shared-id')]));

        final bundled = _snippet('shared-id', title: 'Bundled version');
        final result = await CompositeSnippetCatalogSource(
          _FakeBundledSource([bundled]),
        ).loadBundledCatalog();

        expect(result, hasLength(1));
        expect(result.single.titleEn, 'Bundled version');
      },
    );
  });
}
