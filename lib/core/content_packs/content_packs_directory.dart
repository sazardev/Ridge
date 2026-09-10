import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Resolves (creating it first if necessary) the on-device directory
/// where a third-party "content pack" of snippets is expected to live: a
/// plain folder of JSON files, each one a `List<SnippetDto>` (the exact
/// wire shape `assets/content/snippets/go_v1.json` uses). Read by
/// `ExternalSnippetPackSource`; this app never writes to it itself —
/// populating it (by hand today, or via a future in-app import feature)
/// is left to whoever owns the pack.
Future<Directory> contentPacksSnippetsDir() =>
    _resolve(const ['content_packs', 'snippets']);

/// Same as [contentPacksSnippetsDir], for Learning Path packs — each
/// file a `List<LearningPathDto>` matching
/// `assets/content/learning_paths/*.json`'s shape.
Future<Directory> contentPacksLearningPathsDir() =>
    _resolve(const ['content_packs', 'learning_paths']);

Future<Directory> _resolve(List<String> segments) async {
  final supportDir = await getApplicationSupportDirectory();
  final dir = Directory(p.joinAll([supportDir.path, ...segments]));
  if (!dir.existsSync()) {
    await dir.create(recursive: true);
  }
  return dir;
}
