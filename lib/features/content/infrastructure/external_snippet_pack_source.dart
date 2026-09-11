import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show debugPrint;

import 'package:ridge/core/content_packs/content_packs_directory.dart';
import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/content/domain/repositories/snippet_catalog_source.dart';
import 'package:ridge/features/content/infrastructure/snippet_dto.dart';
import 'package:ridge/features/content/infrastructure/snippet_mapper.dart';

/// Loads every third-party snippet pack dropped into
/// `contentPacksSnippetsDir()` — each file a `List<SnippetDto>` in the
/// same wire shape the bundled catalog uses (see
/// `assets/content/snippets/go_v1.json`). Packs may only reference this
/// app's *existing* `ContentCategory`/`Difficulty`/`ProgrammingLanguage`/
/// `SnippetLength` values — see
/// `.claude/skills/content-curriculum/references/external-content-packs.md`
/// for why a genuinely new category still needs a code change.
///
/// Deliberately never throws: a malformed file, or a single entry
/// referencing an unrecognized enum value, is skipped with a logged
/// warning rather than aborting the whole load — one bad pack must never
/// break every other pack, let alone the bundled catalog.
class ExternalSnippetPackSource implements SnippetCatalogSource {
  /// Creates the source. Takes no dependencies: the directory it reads
  /// is resolved fresh on every call via `contentPacksSnippetsDir()`.
  const new();

  @override
  Future<List<Snippet>> loadBundledCatalog() async {
    final dir = await contentPacksSnippetsDir();
    final files = dir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.json'))
        .toList();

    final snippets = <Snippet>[];
    for (final file in files) {
      try {
        final raw = await readContentPackFile(file);
        final decoded = jsonDecode(raw) as List<Object?>;
        for (final entry in decoded) {
          try {
            snippets.add(
              SnippetDto.fromJson(entry! as Map<String, Object?>).toDomain(),
            );
            // A malformed entry can throw more than `Exception` — an
            // unrecognized `category`/`difficulty`/etc. name throws
            // `ArgumentError` (an `Error`), and a wrong-shaped JSON value
            // throws `TypeError` — both must be caught here too, or one
            // bad entry would still take down the whole pack.
            // ignore: avoid_catches_without_on_clauses
          } catch (e) {
            debugPrint(
              'ExternalSnippetPackSource: skipped an entry in '
              '${file.path} — $e',
            );
          }
        }
        // A whole-file failure (malformed JSON, wrong top-level shape)
        // gets the same broad catch, for the same reason as above.
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        debugPrint('ExternalSnippetPackSource: skipped ${file.path} — $e');
      }
    }
    return snippets;
  }
}
