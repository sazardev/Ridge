import 'package:just_in_time/features/content/domain/entities/programming_language.dart';
import 'package:just_in_time/features/content/domain/value_objects/snippet_id.dart';
import 'package:just_in_time/features/learning_paths/domain/entities/learning_path.dart';
import 'package:just_in_time/features/learning_paths/domain/entities/lesson.dart';
import 'package:just_in_time/features/learning_paths/domain/value_objects/learning_path_id.dart';
import 'package:just_in_time/features/learning_paths/domain/value_objects/lesson_id.dart';
import 'package:just_in_time/features/learning_paths/infrastructure/learning_path_dto.dart';

/// Converts a [LessonDto] into its domain [Lesson] representation.
extension LessonDtoMapper on LessonDto {
  /// Maps this DTO to the domain entity.
  Lesson toDomain() {
    return Lesson(
      id: LessonId(id),
      snippetId: SnippetId(snippetId),
      titleEn: titleEn,
      titleEs: titleEs,
      order: order,
    );
  }
}

/// Converts a [LearningPathDto] into its domain [LearningPath]
/// representation.
extension LearningPathDtoMapper on LearningPathDto {
  /// Maps this DTO to the domain entity. [lessons] is sorted by
  /// `Lesson.order` here, once, so every caller always sees an
  /// already-ordered list, regardless of the authored JSON's own order.
  LearningPath toDomain() {
    final domainLessons = [for (final lesson in lessons) lesson.toDomain()]
      ..sort((a, b) => a.order.compareTo(b.order));
    return LearningPath(
      id: LearningPathId(id),
      language: ProgrammingLanguage.values.byName(language),
      titleEn: titleEn,
      titleEs: titleEs,
      descriptionEn: descriptionEn,
      descriptionEs: descriptionEs,
      lessons: domainLessons,
    );
  }
}
