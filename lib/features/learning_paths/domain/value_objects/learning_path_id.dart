import 'package:freezed_annotation/freezed_annotation.dart';

part 'learning_path_id.freezed.dart';

/// Type-safe identifier for a `LearningPath`.
///
/// Like `SnippetId`, never randomly generated: path ids are stable,
/// human-assigned strings (e.g. `go-foundations-v1`) chosen by whoever
/// curates the bundled curriculum JSON (SPEC.md §5.7), so the content
/// file itself stays reviewable and diffable in source control across
/// revisions.
@freezed
abstract class LearningPathId with _$LearningPathId {
  /// Wraps the raw identifier [value].
  const factory(String value) = _LearningPathId;
}
