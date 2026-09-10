import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/services.dart' show rootBundle;

import 'package:ridge/core/content_packs/content_packs_directory.dart';
import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/learning_paths/domain/entities/learning_path.dart';
import 'package:ridge/features/learning_paths/domain/repositories/learning_path_repository.dart';
import 'package:ridge/features/learning_paths/domain/value_objects/learning_path_id.dart';
import 'package:ridge/features/learning_paths/infrastructure/learning_path_dto.dart';
import 'package:ridge/features/learning_paths/infrastructure/learning_path_mapper.dart';

/// Loads the bundled, curated curriculum from its JSON asset — read-only,
/// no user data (mirrors `content`'s `SnippetLocalDataSource`, but with
/// no drift-seeding step: curriculum content is tiny and never
/// user-mutated, so there's no need to make it SQL-joinable the way
/// `content`'s much larger, filterable snippet catalog is) — plus every
/// Learning Path contributed by a third-party pack under
/// `contentPacksLearningPathsDir()`. Unlike `content`'s
/// `CompositeSnippetCatalogSource`, bundled and external loading live in
/// one adapter here rather than two composed sources: learning paths
/// never had a separate seeding seam to preserve, so there was no
/// existing composition point to keep symmetric with. The merged result
/// is loaded from disk once and memoized for this instance's lifetime
/// (see [_cachedPaths]) — picking up a newly-added external pack still
/// only needs an app restart, same as before.
class LearningPathRepositoryImpl implements LearningPathRepository {
  /// Creates the adapter, optionally over custom [_assetPaths] — tests
  /// can point at fixture assets.
  new([this._assetPaths = defaultAssetPaths]);

  /// Every bundled curriculum asset (see `pubspec.yaml`) — one file per
  /// Learning Path, each still a JSON array (of exactly one path object
  /// today, but the shape allows more per file too).
  static const defaultAssetPaths = [
    'assets/content/learning_paths/go_foundations_v1.json',
    'assets/content/learning_paths/go_ddd_hexagonal_notes_v1.json',
    'assets/content/learning_paths/go_intermediate_syntax_v1.json',
    'assets/content/learning_paths/go_tui_notes_v1.json',
    'assets/content/learning_paths/bash_foundations_v1.json',
    'assets/content/learning_paths/bash_toolkit_v1.json',
    'assets/content/learning_paths/sql_foundations_v1.json',
    'assets/content/learning_paths/rust_foundations_v1.json',
  ];

  final List<String> _assetPaths;

  /// Memoizes [_loadAll]'s result for this instance's lifetime — the
  /// port's own contract says the curriculum "only ever emits once per
  /// call" in practice, so re-reading every bundled asset plus rescanning
  /// the external content-packs directory on every `watchPaths()`/
  /// `getById()` call (this class is `keepAlive`, so those calls can
  /// happen many times across the app's life) is pure waste.
  Future<List<LearningPath>>? _cachedPaths;

  Future<List<LearningPath>> _loadAll() {
    return _cachedPaths ??= _loadAllUncached();
  }

  Future<List<LearningPath>> _loadAllUncached() async {
    final byId = <LearningPathId, LearningPath>{};

    for (final assetPath in _assetPaths) {
      final raw = await rootBundle.loadString(assetPath);
      final decoded = jsonDecode(raw) as List<Object?>;
      for (final entry in decoded) {
        final path = LearningPathDto.fromJson(entry! as Map<String, Object?>)
            .toDomain();
        byId[path.id] = path;
      }
    }

    await _loadExternalInto(byId);
    return byId.values.toList();
  }

  /// Scans `contentPacksLearningPathsDir()` for third-party Learning Path
  /// packs, merging any into [byId] — bundled entries (already present)
  /// always win an id collision. Deliberately never throws: a malformed
  /// file, or an entry referencing an unrecognized enum value, is
  /// skipped with a logged warning, same defensive contract as
  /// `content`'s `ExternalSnippetPackSource`.
  Future<void> _loadExternalInto(Map<LearningPathId, LearningPath> byId) async {
    final dir = await contentPacksLearningPathsDir();
    final files = dir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.json'))
        .toList();

    for (final file in files) {
      try {
        final raw = await file.readAsString();
        final decoded = jsonDecode(raw) as List<Object?>;
        for (final entry in decoded) {
          try {
            final path = LearningPathDto.fromJson(
              entry! as Map<String, Object?>,
            ).toDomain();
            if (byId.containsKey(path.id)) {
              debugPrint(
                'LearningPathRepositoryImpl: external path '
                '"${path.id.value}" in ${file.path} collides with an '
                'existing id — skipped.',
              );
              continue;
            }
            byId[path.id] = path;
            // Broad catch deliberately: an unrecognized enum value
            // throws `ArgumentError` (an `Error`, not an `Exception`),
            // and a wrong-shaped JSON value throws `TypeError` — both
            // must be caught here too, or one bad entry would still
            // take down the whole pack.
            // ignore: avoid_catches_without_on_clauses
          } catch (e) {
            debugPrint(
              'LearningPathRepositoryImpl: skipped an entry in '
              '${file.path} — $e',
            );
          }
        }
        // A whole-file failure (malformed JSON, wrong top-level shape)
        // gets the same broad catch, for the same reason as above.
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        debugPrint('LearningPathRepositoryImpl: skipped ${file.path} — $e');
      }
    }
  }

  @override
  Stream<List<LearningPath>> watchPaths() {
    return Stream.fromFuture(_loadAll());
  }

  @override
  Future<Result<LearningPath, AppFailure>> getById(LearningPathId id) async {
    try {
      final all = await _loadAll();
      for (final path in all) {
        if (path.id == id) return Result.ok(path);
      }
      return Result.err(
        NotFoundFailure('No learning path with id ${id.value}'),
      );
    } on Exception catch (e) {
      return Result.err(
        StorageFailure('Could not load learning path', cause: e),
      );
    }
  }
}
