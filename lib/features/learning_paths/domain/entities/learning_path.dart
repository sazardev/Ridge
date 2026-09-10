import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:just_in_time/features/content/domain/entities/programming_language.dart';
import 'package:just_in_time/features/learning_paths/domain/entities/lesson.dart';
import 'package:just_in_time/features/learning_paths/domain/value_objects/learning_path_id.dart';

part 'learning_path.freezed.dart';

/// A curated, ordered sequence of [Lesson]s with an explicit pedagogical
/// goal (SPEC.md §5.7, e.g. "Fundamentos de sintaxis Go") — bundled
/// curriculum content, read-only, no user data (mirrors `content`'s
/// `Snippet` catalog). [language] scopes which language's roadmap this
/// path belongs to (SPEC.md §18 — v1 only ever populates [language] with
/// [ProgrammingLanguage.go], but the field exists from the start so a
/// second language's curriculum is a content addition, not a schema
/// change).
@freezed
abstract class LearningPath with _$LearningPath {
  /// Creates an immutable curriculum path. [lessons] is already ordered
  /// by `Lesson.order` — callers never need to re-sort it.
  const factory({
    required LearningPathId id,
    required ProgrammingLanguage language,
    required String titleEn,
    required String titleEs,
    required String descriptionEn,
    required String descriptionEs,

    /// A single short topic label (e.g. "Backend", "Fundamentals") shown
    /// as a chip on the path's card — never a replacement for the fuller
    /// [descriptionEn]/[descriptionEs], just a skimmable identifier.
    required String tagEn,
    required String tagEs,
    required List<Lesson> lessons,
  }) = _LearningPath;
}
