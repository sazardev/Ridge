import 'package:freezed_annotation/freezed_annotation.dart';

part 'learning_path_dto.freezed.dart';
part 'learning_path_dto.g.dart';

/// Wire shape for one lesson within the bundled curriculum JSON asset.
/// Mirrors `content`'s `SnippetDto`: kept separate from the domain
/// `Lesson` entity so a future content-format change never leaks into
/// business logic — only `LearningPathMapper` needs to change.
@freezed
abstract class LessonDto with _$LessonDto {
  /// Creates a DTO snapshot ready for JSON serialization.
  const factory({
    required String id,
    required String snippetId,
    required String titleEn,
    required String titleEs,
    required int order,
  }) = _LessonDto;

  /// Deserializes a DTO from decoded JSON.
  factory fromJson(Map<String, Object?> json) => _$LessonDtoFromJson(json);
}

/// Wire shape for one learning path within the bundled curriculum JSON
/// asset (`assets/content/learning_paths/go_foundations_v1.json`).
@freezed
abstract class LearningPathDto with _$LearningPathDto {
  /// Creates a DTO snapshot ready for JSON serialization.
  const factory({
    required String id,
    required String language,
    required String titleEn,
    required String titleEs,
    required String descriptionEn,
    required String descriptionEs,
    required List<LessonDto> lessons,
  }) = _LearningPathDto;

  /// Deserializes a DTO from decoded JSON.
  factory fromJson(Map<String, Object?> json) =>
      _$LearningPathDtoFromJson(json);
}
