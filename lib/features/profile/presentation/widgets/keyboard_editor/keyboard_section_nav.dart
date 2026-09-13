import 'package:flutter/material.dart';

import 'package:ridge/core/theme/app_motion.dart';

/// One quick-nav destination: the chip's localized label, its icon, and
/// the `GlobalKey` of the section it scrolls to.
typedef KeyboardSectionNavEntry = ({
  String label,
  IconData icon,
  GlobalKey sectionKey,
});

/// A horizontal strip of section chips pinned under the keyboard editor's
/// preview — the editor's table of contents, so a long configurator stays
/// navigable without scrolling blindly.
class KeyboardSectionNav extends StatelessWidget {
  /// Creates the nav over [entries].
  const new({required this.entries, super.key});

  /// The sections to offer, in display order.
  final List<KeyboardSectionNavEntry> entries;

  void _scrollTo(BuildContext context, GlobalKey sectionKey) {
    final target = sectionKey.currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(
      target,
      duration: AppMotion.spatialDefault,
      curve: AppMotion.spatial,
      alignment: 0.05,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        children: [
          for (final entry in entries)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ActionChip(
                avatar: Icon(entry.icon, size: 15),
                label: Text(entry.label),
                onPressed: () => _scrollTo(context, entry.sectionKey),
              ),
            ),
        ],
      ),
    );
  }
}
