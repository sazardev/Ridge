import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'package:just_in_time/features/content/domain/entities/snippet.dart';
import 'package:just_in_time/features/content/domain/repositories/snippet_catalog_source.dart';
import 'package:just_in_time/features/content/infrastructure/snippet_dto.dart';
import 'package:just_in_time/features/content/infrastructure/snippet_mapper.dart';

/// Loads the bundled, curated snippet catalog from its JSON asset.
class SnippetLocalDataSource implements SnippetCatalogSource {
  /// Creates the data source. Takes no dependencies: the asset path is
  /// fixed content shipped with the app, not a runtime configuration.
  const new();

  /// Path to the bundled Go v1 catalog asset (see `pubspec.yaml`).
  static const assetPath = 'assets/content/snippets/go_v1.json';

  @override
  Future<List<Snippet>> loadBundledCatalog() async {
    final raw = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(raw) as List<Object?>;
    return [
      for (final entry in decoded)
        SnippetDto.fromJson(entry! as Map<String, Object?>).toDomain(),
    ];
  }
}
