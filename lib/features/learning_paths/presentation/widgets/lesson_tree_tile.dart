import 'package:flutter/material.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/core/theme/app_typography.dart';
import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/content/presentation/content_labels.dart';
import 'package:ridge/features/learning_paths/domain/entities/lesson.dart';
import 'package:ridge/features/learning_paths/domain/entities/lesson_status.dart';
import 'package:ridge/features/learning_paths/presentation/learning_paths_labels.dart';

/// One lesson within a `LessonDetailScreen`'s ordered tree: its locked/
/// unlocked/completed visual state, curriculum title, and the referenced
/// snippet's own title as a preview. Tapping is disabled (via a `null`
/// [onTap]) whenever [status] is [LessonStatus.locked].
class LessonTreeTile extends StatelessWidget {
  /// Creates the tile for [lesson].
  const new({
    required this.lesson,
    required this.status,
    required this.snippet,
    required this.onTap,
    super.key,
  });

  /// The curriculum lesson this tile renders.
  final Lesson lesson;

  /// This lesson's currently derived unlock/completion status.
  final LessonStatus status;

  /// The catalog entry [lesson] references, or `null` if it hasn't
  /// loaded yet.
  final Snippet? snippet;

  /// Called when this tile is tapped, or `null` to render it disabled
  /// (locked, or its snippet hasn't loaded yet).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isLocked = status == LessonStatus.locked;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: AppShapes.of(context).mediumShape,
      // Without this, the ink splash from `ListTile`'s `onTap` paints
      // as a plain rectangle overflowing past the card's own rounded
      // corners, ignoring whatever corner style is currently selected.
      clipBehavior: Clip.antiAlias,
      child: Opacity(
        opacity: isLocked ? 0.5 : 1,
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Icon(status.icon, color: theme.colorScheme.primary),
          title: Text(lesson.titleFor(context)),
          subtitle: snippet == null
              ? null
              : Text(
                  snippet!.titleFor(context),
                  style: TextStyle(
                    fontFamily: AppFonts.mono,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
          trailing: Text(status.label(l10n)),
          onTap: onTap,
        ),
      ),
    );
  }
}
