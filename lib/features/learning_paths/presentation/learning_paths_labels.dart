import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/features/learning_paths/domain/entities/learning_path.dart';
import 'package:ridge/features/learning_paths/domain/entities/lesson.dart';
import 'package:ridge/features/learning_paths/domain/entities/lesson_status.dart';

/// Locale-resolved access to a bilingual [LearningPath]'s title/
/// description — free-form curriculum prose, so (like `content`'s
/// `SnippetTitleLabel`/`SnippetExplanationLabel`) it lives directly on
/// the entity/content JSON rather than in the ARB catalog.
extension LearningPathLabel on LearningPath {
  /// Returns [LearningPath.titleEs] under a Spanish app locale, else
  /// [LearningPath.titleEn].
  String titleFor(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'es' ? titleEs : titleEn;

  /// Returns [LearningPath.descriptionEs] under a Spanish app locale,
  /// else [LearningPath.descriptionEn].
  String descriptionFor(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'es'
      ? descriptionEs
      : descriptionEn;

  /// Returns [LearningPath.tagEs] under a Spanish app locale, else
  /// [LearningPath.tagEn].
  String tagFor(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'es' ? tagEs : tagEn;
}

/// Locale-resolved access to a bilingual [Lesson]'s title.
extension LessonLabel on Lesson {
  /// Returns [Lesson.titleEs] under a Spanish app locale, else
  /// [Lesson.titleEn].
  String titleFor(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'es' ? titleEs : titleEn;
}

/// Localized display label and icon for a [LessonStatus], shared by
/// every widget that renders one (mirrors `content`'s `DifficultyLabel`/
/// `progression`'s `TrendPresentation`).
extension LessonStatusPresentation on LessonStatus {
  /// Returns this status's localized display label.
  String label(AppLocalizations l10n) => switch (this) {
    LessonStatus.locked => l10n.learningLessonLocked,
    LessonStatus.unlocked => l10n.learningLessonUnlocked,
    LessonStatus.completed => l10n.learningLessonCompleted,
  };

  /// Returns this status's display icon.
  IconData get icon => switch (this) {
    LessonStatus.locked => LucideIcons.lock300,
    LessonStatus.unlocked => LucideIcons.circlePlay300,
    LessonStatus.completed => LucideIcons.circleCheck300,
  };
}
