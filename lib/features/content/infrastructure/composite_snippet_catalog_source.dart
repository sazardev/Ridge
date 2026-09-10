import 'package:flutter/foundation.dart' show debugPrint;

import 'package:just_in_time/features/content/domain/entities/snippet.dart';
import 'package:just_in_time/features/content/domain/repositories/snippet_catalog_source.dart';
import 'package:just_in_time/features/content/infrastructure/external_snippet_pack_source.dart';
import 'package:just_in_time/features/content/infrastructure/snippet_local_data_source.dart';

/// The [SnippetCatalogSource] actually bound at runtime
/// (`content_providers.dart`): every bundled snippet, plus every snippet
/// contributed by a third-party pack under `contentPacksSnippetsDir()`
/// (see [ExternalSnippetPackSource]) — merged by id, with the bundled
/// catalog always winning a collision, so an external pack can never
/// silently override curated content.
class CompositeSnippetCatalogSource implements SnippetCatalogSource {
  /// Creates the composite over its two constituent sources — defaults
  /// to the real bundled + external sources; tests can substitute either.
  const new([
    this._bundled = const SnippetLocalDataSource(),
    this._external = const ExternalSnippetPackSource(),
  ]);

  final SnippetCatalogSource _bundled;
  final SnippetCatalogSource _external;

  @override
  Future<List<Snippet>> loadBundledCatalog() async {
    final bundled = await _bundled.loadBundledCatalog();
    final external = await _external.loadBundledCatalog();

    final byId = {for (final s in bundled) s.id.value: s};
    for (final snippet in external) {
      if (byId.containsKey(snippet.id.value)) {
        debugPrint(
          'CompositeSnippetCatalogSource: external snippet '
          '"${snippet.id.value}" collides with an existing id — skipped.',
        );
        continue;
      }
      byId[snippet.id.value] = snippet;
    }
    return byId.values.toList();
  }
}
