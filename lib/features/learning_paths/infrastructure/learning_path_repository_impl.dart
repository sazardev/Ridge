import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/learning_paths/domain/entities/learning_path.dart';
import 'package:just_in_time/features/learning_paths/domain/repositories/learning_path_repository.dart';
import 'package:just_in_time/features/learning_paths/domain/value_objects/learning_path_id.dart';
import 'package:just_in_time/features/learning_paths/infrastructure/learning_path_dto.dart';
import 'package:just_in_time/features/learning_paths/infrastructure/learning_path_mapper.dart';

/// Loads the bundled, curated curriculum from its JSON asset — read-only,
/// no user data (mirrors `content`'s `SnippetLocalDataSource`, but with
/// no drift-seeding step: curriculum content is tiny and never
/// user-mutated, so there's no need to make it SQL-joinable the way
/// `content`'s much larger, filterable snippet catalog is).
class LearningPathRepositoryImpl implements LearningPathRepository {
  /// Creates the adapter, optionally over a custom [_assetPath] — tests
  /// can point at a fixture asset.
  const new([this._assetPath = defaultAssetPath]);

  /// Path to the bundled Go foundations curriculum asset (see
  /// `pubspec.yaml`).
  static const defaultAssetPath =
      'assets/content/learning_paths/go_foundations_v1.json';

  final String _assetPath;

  Future<List<LearningPath>> _loadAll() async {
    final raw = await rootBundle.loadString(_assetPath);
    final decoded = jsonDecode(raw) as List<Object?>;
    return [
      for (final entry in decoded)
        LearningPathDto.fromJson(entry! as Map<String, Object?>).toDomain(),
    ];
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
