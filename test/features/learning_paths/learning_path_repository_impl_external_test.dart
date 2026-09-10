// Exercises `LearningPathRepositoryImpl`'s external-pack merging against
// a *real* temp directory (not a hand-fake filesystem) — same
// `path_provider` platform-interface substitution pattern as
// `test/features/content/external_snippet_pack_source_test.dart` (see
// that file's header comment for why the `MockPlatformInterfaceMixin` is
// required). Deliberately does NOT touch `test/features/learning_paths/
// learning_paths_drift_integration_test.dart` (that file exercises the
// bundled-only path against the real provider graph and asset bundle).
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:ridge/core/content_packs/content_packs_directory.dart';
import 'package:ridge/features/learning_paths/infrastructure/learning_path_repository_impl.dart';

class _FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  new(this._path);

  final String _path;

  @override
  Future<String?> getApplicationSupportPath() async => _path;
}

Map<String, Object?> _validPathMap(
  String id, {
  List<String> snippetIds = const [],
}) => {
  'id': id,
  'language': 'go',
  'titleEn': 'External path $id',
  'titleEs': 'Ruta externa $id',
  'descriptionEn': 'description',
  'descriptionEs': 'descripcion',
  'tagEn': 'Custom',
  'tagEs': 'Personalizado',
  'lessons': [
    for (final (i, snippetId) in snippetIds.indexed)
      {
        'id': '$id-step${i + 1}',
        'snippetId': snippetId,
        'order': i + 1,
        'titleEn': 'Lesson ${i + 1}',
        'titleEs': 'Lección ${i + 1}',
      },
  ],
};

String _pack(List<Map<String, Object?>> entries) => jsonEncode(entries);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory supportDir;
  late Directory packsDir;

  setUp(() async {
    supportDir = await Directory.systemTemp.createTemp('jit_test_support_');
    PathProviderPlatform.instance = _FakePathProviderPlatform(supportDir.path);
    packsDir = await contentPacksLearningPathsDir();
  });

  tearDown(() async {
    if (supportDir.existsSync()) supportDir.deleteSync(recursive: true);
  });

  test(
    'contentPacksLearningPathsDir creates the directory if it does not exist',
    () async {
      expect(packsDir.existsSync(), isTrue);
      expect(packsDir.path, endsWith('content_packs/learning_paths'));
    },
  );

  test('an empty packs directory yields only the bundled paths', () async {
    final repo = LearningPathRepositoryImpl([]);
    final result = await repo.watchPaths().first;
    expect(result, isEmpty);
  });

  test('a valid external learning path is merged in', () async {
    File('${packsDir.path}/pack1.json').writeAsStringSync(
      _pack([
        _validPathMap('ext-path-001', snippetIds: ['some-snippet']),
      ]),
    );

    final repo = LearningPathRepositoryImpl([]);
    final result = await repo.watchPaths().first;

    expect(result, hasLength(1));
    expect(result.single.id.value, 'ext-path-001');
    expect(result.single.lessons, hasLength(1));
  });

  test(
    'an entry with an unrecognized language is skipped, siblings still load',
    () async {
      final badEntry = Map<String, Object?>.of(_validPathMap('ext-bad'))
        ..['language'] = 'notARealLanguage';
      File('${packsDir.path}/pack1.json')
          .writeAsStringSync(_pack([badEntry, _validPathMap('ext-good')]));

      final repo = LearningPathRepositoryImpl([]);
      final result = await repo.watchPaths().first;

      expect(result, hasLength(1));
      expect(result.single.id.value, 'ext-good');
    },
  );

  test('a malformed JSON file is skipped without throwing', () async {
    File('${packsDir.path}/broken.json').writeAsStringSync('{not valid json');
    File('${packsDir.path}/good.json')
        .writeAsStringSync(_pack([_validPathMap('ext-still-loads')]));

    final repo = LearningPathRepositoryImpl([]);
    final result = await repo.watchPaths().first;

    expect(result, hasLength(1));
    expect(result.single.id.value, 'ext-still-loads');
  });

  test(
    'an external path whose id collides with a bundled one is skipped',
    () async {
      // The real bundled `go_foundations_v1.json` asset's own id
      // (`go-foundations-v1`) — reused here as the colliding id so this
      // exercises the actual bundled-wins-a-collision behavior, not a
      // fabricated one. Its own real asset-loading behavior is exercised
      // by `learning_paths_drift_integration_test.dart`, not duplicated
      // here.
      File('${packsDir.path}/pack1.json').writeAsStringSync(
        _pack([_validPathMap('go-foundations-v1', snippetIds: [])]),
      );

      final repo = LearningPathRepositoryImpl([
        'assets/content/learning_paths/go_foundations_v1.json',
      ]);
      final result = await repo.watchPaths().first;

      final matching = result.where((p) => p.id.value == 'go-foundations-v1');
      expect(matching, hasLength(1));
      // The bundled version's real title survives — the external one
      // ("External path go-foundations-v1") was skipped as a collision.
      expect(matching.single.titleEn, isNot(contains('External path')));
    },
  );
}
