import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/features/profile/presentation/keyboard_shape_lookup.dart';
import 'package:ridge/features/profile/presentation/providers/keyboard_visual_layout_providers.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_layout_painter.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/standard_family_key_specs.dart';

/// A 2D keyboard visual for a profile's free-text `keyboardModel` — the
/// single integration point deciding *what* to draw, so callers (the
/// "About me" card, the edit screen's live preview) never need to know
/// about curated layouts or family fallbacks:
/// 1. A curated, real layout from the data bank
///    (`assets/content/keyboard_layouts/`), when [model] has one.
/// 2. Otherwise, `keyboard_shape_lookup.dart`'s generic family
///    silhouette, when [model] is a recognized `kKeyboardModelSuggestions`
///    entry.
/// 3. Otherwise nothing — an unrecognized free-text model has no shape
///    to guess at.
class KeyboardVisual extends ConsumerWidget {
  /// Creates the visual for [model] (a profile's free-text
  /// `keyboardModel`, or `null`/empty if unset).
  const new({required this.model, super.key});

  /// The profile's free-text `keyboardModel`.
  final String? model;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = this.model;
    if (model == null || model.isEmpty) return const SizedBox.shrink();

    final curated = ref.watch(keyboardVisualLayoutsProvider).value?[model];
    final family = keyboardShapeFamilyFor(model);
    final keys =
        curated?.keys ??
        (family != null ? standardFamilyKeySpecsFor(family) : null);
    if (keys == null || keys.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final shapes = AppShapes.of(context);

    return Semantics(
      label: l10n.profileKeyboardShapePreviewSemanticLabel(model),
      child: SizedBox(
        height: 88,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return CustomPaint(
              size: Size(constraints.maxWidth, 88),
              painter: KeyboardLayoutPainter(
                keys: keys,
                keyColor: colorScheme.surfaceContainerHighest,
                caseColor: colorScheme.surfaceContainer,
                borderColor: colorScheme.outlineVariant,
                keyCornerRadius: shapes.extraSmall,
                caseCornerRadius: shapes.medium,
              ),
            );
          },
        ),
      ),
    );
  }
}
