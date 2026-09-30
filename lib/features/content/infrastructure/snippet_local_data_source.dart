import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/content/domain/repositories/snippet_catalog_source.dart';
import 'package:ridge/features/content/infrastructure/snippet_dto.dart';
import 'package:ridge/features/content/infrastructure/snippet_mapper.dart';

/// Loads the bundled, curated snippet catalog from its JSON assets — one
/// file per language, merged into a single catalog (ids are globally
/// unique and content is curated, so no de-duplication is needed here;
/// `CompositeSnippetCatalogSource` is what guards against id collisions
/// with third-party packs).
class SnippetLocalDataSource implements SnippetCatalogSource {
  /// Creates the data source, optionally over custom [_assetPaths] —
  /// tests can point at fixture assets.
  const new([this._assetPaths = defaultAssetPaths]);

  /// Every bundled catalog asset (see `pubspec.yaml`).
  static const defaultAssetPaths = [
    'assets/content/snippets/go_v1.json',
    'assets/content/snippets/bash_v1.json',
    'assets/content/snippets/sql_v1.json',
    'assets/content/snippets/rust_v1.json',
    'assets/content/snippets/zig_v1.json',
    'assets/content/snippets/python_v1.json',
    'assets/content/snippets/javascript_v1.json',
    'assets/content/snippets/typescript_v1.json',
    'assets/content/snippets/haskell_v1.json',
    'assets/content/snippets/c_v1.json',
    'assets/content/snippets/cpp_v1.json',
    'assets/content/snippets/java_v1.json',
    'assets/content/snippets/crystal_v1.json',
    'assets/content/snippets/css_v1.json',
    'assets/content/snippets/csharp_v1.json',
    'assets/content/snippets/swift_v1.json',
    'assets/content/snippets/kotlin_v1.json',
    'assets/content/snippets/android_v1.json',
    'assets/content/snippets/dart_v1.json',
    'assets/content/snippets/php_v1.json',
    'assets/content/snippets/git_v1.json',
    'assets/content/snippets/linux_v1.json',
    'assets/content/snippets/docker_v1.json',
    'assets/content/snippets/github_actions_v1.json',
  ];

  final List<String> _assetPaths;

  @override
  Future<List<Snippet>> loadBundledCatalog() async {
    final snippets = <Snippet>[];
    for (final assetPath in _assetPaths) {
      final raw = await rootBundle.loadString(assetPath);
      final decoded = jsonDecode(raw) as List<Object?>;
      snippets.addAll([
        for (final entry in decoded)
          SnippetDto.fromJson(entry! as Map<String, Object?>).toDomain(),
      ]);
    }
    return snippets;
  }
}
