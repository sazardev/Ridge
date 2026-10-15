import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/core/widgets/bouncy_tap.dart';
import 'package:ridge/features/learning_paths/presentation/learning_paths_labels.dart';
import 'package:ridge/features/learning_paths/presentation/lesson_navigation.dart';
import 'package:ridge/features/learning_paths/presentation/providers/learning_paths_providers.dart';

/// The Practice tab's "pick up where you left off" card — the path the
/// active language's profile most recently worked on, with its next
/// unlocked lesson, one tap from continuing (SPEC.md §5.7's message
/// "retoma donde lo dejaste"). Renders nothing while there's nothing to
/// resume (see `resumeCourse`'s doc), so it never competes with the path
/// list itself.
class ResumeCourseCard extends ConsumerWidget {
  /// Creates the resume card.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(resumeCourseProvider).value;
    if (data == null) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final lessons = data.overview.path.lessons;
    final lesson = lessons[data.nextLessonIndex];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: BouncyTap(
        enabled: true,
        child: Card(
          shape: AppShapes.of(context).mediumShape,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => LessonNavigation.startLesson(
              context,
              data.overview,
              data.nextLessonIndex,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(LucideIcons.play300, color: colorScheme.primary),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.learningPathsResumeTitle,
                          style: textTheme.titleMedium,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          data.overview.path.titleFor(context),
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          l10n.learningPathsResumeLessonLabel(
                            data.nextLessonIndex + 1,
                            lessons.length,
                            lesson.titleFor(context),
                          ),
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    LucideIcons.chevronRight300,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
