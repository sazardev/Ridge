import 'package:flutter/material.dart';
import 'package:ridge/core/theme/app_motion.dart';
import 'package:ridge/core/widgets/bouncy_tap.dart';

/// A [FilterChip] that squishes on press (via [BouncyTap]) and pops with a
/// spring each time it becomes selected.
class AppFilterChip extends StatelessWidget {
  /// Creates a springy filter chip.
  const new({
    required this.label,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  /// The chip's label.
  final Widget label;

  /// Whether the chip is currently selected.
  final bool selected;

  /// Called with the requested new selection state.
  final ValueChanged<bool>? onSelected;

  @override
  Widget build(BuildContext context) {
    return BouncyTap(
      enabled: onSelected != null,
      child: AnimatedScale(
        scale: selected ? 1.05 : 1,
        duration: AppMotion.spatialDefault,
        curve: AppMotion.bouncy,
        child: FilterChip(
          label: label,
          selected: selected,
          onSelected: onSelected,
        ),
      ),
    );
  }
}
