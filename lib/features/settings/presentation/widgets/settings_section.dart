import 'package:flutter/material.dart';

import 'package:just_in_time/core/theme/app_shapes.dart';

/// A titled card grouping related settings tiles, per the flat design
/// system (see `AppShapes`, `app_theme.dart`).
class SettingsSection extends StatelessWidget {
  /// Creates a settings section labeled [title] wrapping [children].
  const new({required this.title, required this.children, super.key});

  /// Section label shown above the card.
  final String title;

  /// The tiles rendered inside the card.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                letterSpacing: 0.4,
              ),
            ),
          ),
          Material(
            color: colorScheme.surfaceContainerLow,
            shape: AppShapes.of(context).largeShape,
            clipBehavior: Clip.antiAlias,
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}
