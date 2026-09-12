import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_key_spec.dart';
import 'package:ridge/features/profile/presentation/keyboard_shape_lookup.dart';
import 'package:ridge/features/profile/presentation/providers/keyboard_visual_layout_providers.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_layout_painter.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/standard_family_key_specs.dart';

/// Resolves [model] to the key geometry [KeyboardVisual] would paint for
/// it — a curated real layout, the generic family silhouette, or `null` if
/// neither exists — factored out so a caller that wraps [KeyboardVisual]
/// in its own decoration (e.g. a hero card) can decide up front whether
/// anything will actually render, without duplicating the lookup order.
List<KeyboardKeySpec>? resolveKeyboardKeySpecs(WidgetRef ref, String model) {
  final curated = ref.watch(keyboardVisualLayoutsProvider).value?[model];
  final family = keyboardShapeFamilyFor(model);
  return curated?.keys ??
      (family != null ? standardFamilyKeySpecsFor(family) : null);
}

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
  /// `keyboardModel`, or `null`/empty if unset), painted at [height].
  const new({required this.model, this.height = 88, super.key});

  /// The profile's free-text `keyboardModel`.
  final String? model;

  /// The painted height, in logical pixels. Every proportion (bezel, key
  /// gap, ...) is derived from the fitted key-unit scale, so this can be
  /// tuned per call site (a compact inline preview vs. a larger hero
  /// visual) without retuning the painter.
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = this.model;
    if (model == null || model.isEmpty) return const SizedBox.shrink();

    final keys = resolveKeyboardKeySpecs(ref, model);
    if (keys == null || keys.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final shapes = AppShapes.of(context);

    return Semantics(
      label: l10n.profileKeyboardShapePreviewSemanticLabel(model),
      child: SizedBox(
        height: height,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return CustomPaint(
              size: Size(constraints.maxWidth, height),
              painter: KeyboardLayoutPainter(
                keys: keys,
                keyColor: colorScheme.surfaceBright,
                accentKeyColor: colorScheme.surfaceContainerHighest,
                caseColor: colorScheme.surfaceDim,
                plateColor: colorScheme.surfaceContainer,
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
