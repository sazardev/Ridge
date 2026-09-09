import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/learning_paths/domain/entities/learning_path.dart';
import 'package:just_in_time/features/learning_paths/domain/value_objects/learning_path_id.dart';

/// Driven port: read-only access to the bundled, curated curriculum
/// (SPEC.md §5.7) — no user data lives behind this port, only authored
/// content (mirrors `content`'s bundled-JSON-asset design, but with no
/// drift-seeding step: see `LearningPathRepositoryImpl`'s class doc).
abstract interface class LearningPathRepository {
  /// Emits every bundled learning path, and every subsequent change
  /// (curriculum content is static once loaded, so in practice this
  /// only ever emits once per call).
  Stream<List<LearningPath>> watchPaths();

  /// Returns the bundled path identified by [id].
  Future<Result<LearningPath, AppFailure>> getById(LearningPathId id);
}
