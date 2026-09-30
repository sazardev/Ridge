import 'package:flutter/material.dart';

import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/core/widgets/bouncy_tap.dart';

/// A single direct-entry practice-mode shortcut on the Practice hub
/// (SPEC.md §5.1-§5.3) — unlike `showPracticeModePickerSheet`, tapping
/// this starts the session immediately in the mode it advertises, no
/// picker in between.
class QuickModeTile extends StatelessWidget {
  /// Creates a quick-mode tile.
  const new({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  /// The glyph representing this mode.
  final IconData icon;

  /// This mode's display label.
  final String label;

  /// A one-line description of what this mode does.
  final String subtitle;

  /// Called when the tile is tapped, or `null` to render it disabled
  /// (e.g. no snippet is available yet to start with).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isEnabled = onTap != null;

    return BouncyTap(
      enabled: isEnabled,
      child: Card(
        shape: AppShapes.of(context).mediumShape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isEnabled
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: textTheme.labelLarge,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
