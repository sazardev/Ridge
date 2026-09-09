import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/features/learning_paths/domain/entities/lesson_status.dart';
import 'package:just_in_time/features/learning_paths/domain/value_objects/lesson_id.dart';
import 'package:just_in_time/features/learning_paths/presentation/learning_paths_labels.dart';
import 'package:just_in_time/features/learning_paths/presentation/providers/learning_paths_providers.dart';

/// Prompts the user to pick one [LessonId] to reset, grouped by learning
/// path — every bundled lesson is offered, not just completed ones,
/// since resetting an already-locked or never-attempted lesson is a
/// harmless no-op the repository already handles (deleting zero rows).
/// Returns `null` if the user dismisses the dialog without choosing.
Future<LessonId?> showLessonPickerDialog(BuildContext context) {
  return showDialog<LessonId>(
    context: context,
    builder: (context) => const _LessonPickerDialog(),
  );
}

class _LessonPickerDialog extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final pathsAsync = ref.watch(learningPathsControllerProvider);
    final statusByLesson =
        ref.watch(lessonProgressControllerProvider).value ?? const {};

    return AlertDialog(
      title: Text(l10n.settingsPickLessonTitle),
      content: SizedBox(
        width: double.maxFinite,
        child: switch (pathsAsync) {
          AsyncData(:final value) when value.isEmpty => Text(
            l10n.settingsPickLessonEmpty,
          ),
          AsyncData(:final value) => ListView(
            shrinkWrap: true,
            children: [
              for (final overview in value) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    overview.path.titleFor(context),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                for (final lesson in overview.path.lessons)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      (statusByLesson[lesson.id] ?? LessonStatus.locked).icon,
                    ),
                    title: Text(lesson.titleFor(context)),
                    onTap: () => Navigator.of(context).pop(lesson.id),
                  ),
              ],
            ],
          ),
          AsyncError() => Text(l10n.settingsPickLessonEmpty),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.settingsDataActionCancel),
        ),
      ],
    );
  }
}
