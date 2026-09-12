import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Resolves (creating it first if necessary) the on-device directory
/// where a third-party "content pack" of snippets is expected to live: a
/// plain folder of JSON files, each one a `List<SnippetDto>` (the exact
/// wire shape `assets/content/snippets/go_v1.json` uses). Read by
/// `ExternalSnippetPackSource`; this app never writes to it itself —
/// populating it (by hand today, or via a future in-app import feature)
/// is left to whoever owns the pack.
///
/// Returns `null` on web: there is no on-device directory a third party
/// can drop files into (and `path_provider`'s
/// `getApplicationSupportDirectory` throws `MissingPluginException`
/// there), so external packs are a desktop/mobile-only seam.
Future<Directory?> contentPacksSnippetsDir() {
  if (kIsWeb) return Future<Directory?>.value();
  return _resolve(const ['content_packs', 'snippets']);
}

/// Same as [contentPacksSnippetsDir], for Learning Path packs — each
/// file a `List<LearningPathDto>` matching
/// `assets/content/learning_paths/*.json`'s shape. `null` on web, same
/// as [contentPacksSnippetsDir].
Future<Directory?> contentPacksLearningPathsDir() {
  if (kIsWeb) return Future<Directory?>.value();
  return _resolve(const ['content_packs', 'learning_paths']);
}

Future<Directory> _resolve(List<String> segments) async {
  final supportDir = await getApplicationSupportDirectory();
  final dir = Directory(p.joinAll([supportDir.path, ...segments]));
  if (!dir.existsSync()) {
    await dir.create(recursive: true);
  }
  return dir;
}

/// A legitimate content-pack file (a JSON array of snippets or Learning
/// Paths) weighs, at most, a few hundred KiB — orders of magnitude under
/// this. The limit exists so a mistakenly-huge or hostile file gets
/// rejected by its size on disk, before being decoded fully into memory
/// (STACK.md §2.7).
const int maxContentPackFileBytes = 5 * 1024 * 1024;

/// Reads [file] as a string for content-pack parsing, unless it exceeds
/// [maxContentPackFileBytes] — in which case this throws a
/// [FormatException], so callers' existing "skip this file and log a
/// warning" broad catch (`ExternalSnippetPackSource`,
/// `LearningPathRepositoryImpl`) handles an oversized file the same way
/// it already handles a malformed one.
Future<String> readContentPackFile(File file) async {
  final size = await file.length();
  if (size > maxContentPackFileBytes) {
    throw FormatException(
      'content pack file exceeds the $maxContentPackFileBytes byte '
      'limit ($size bytes)',
      file.path,
    );
  }
  return await file.readAsString();
}
