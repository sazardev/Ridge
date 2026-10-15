import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/core/theme/app_typography.dart';
import 'package:ridge/core/widgets/bouncy_tap.dart';
import 'package:ridge/features/content/presentation/widgets/practice_mode_picker_sheet.dart';
import 'package:ridge/features/practice/domain/entities/hand.dart';
import 'package:ridge/features/progression/domain/entities/warm_up_target.dart';
import 'package:ridge/features/progression/presentation/progression_labels.dart';
import 'package:ridge/features/progression/presentation/providers/progression_providers.dart';

/// The "Calentar" entry point (SPEC.md §3.3/§6.3) on `FreePracticeScreen`
/// — one tap straight into a Zen session on whatever the weakness report
/// says to drill: the snippet densest in your weakest characters (the
/// default), in your weakest finger's characters, or in its hand's. The
/// chips switch targets; each option only appears when the profile has
/// history for it and the catalog has a candidate. Renders nothing while
/// there's nothing to recommend.
class WarmUpCard extends ConsumerStatefulWidget {
  /// Creates the warm-up card.
  const new({super.key});

  @override
  ConsumerState<WarmUpCard> createState() => _WarmUpCardState();
}

class _WarmUpCardState extends ConsumerState<WarmUpCard> {
  /// The target the user last picked, if any — resolved against the
  /// currently available options on every build (a picked target can
  /// disappear as history changes).
  WarmUpTarget? _picked;

  @override
  Widget build(BuildContext context) {
    final options = ref.watch(warmUpOptionsProvider).value ?? const [];
    if (options.isEmpty) return const SizedBox.shrink();

    final selected = options.firstWhere(
      (option) => option.target == _picked,
      orElse: () => options.first,
    );
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BouncyTap(
      enabled: true,
      child: Card(
        shape: AppShapes.of(context).mediumShape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push(
            '/practice/session',
            extra: (snippet: selected.snippet, modeKind: practiceModeKindZen),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(LucideIcons.activity300, color: colorScheme.primary),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        l10n.practiceWarmUpTitle,
                        style: textTheme.titleMedium,
                      ),
                    ),
                    Icon(
                      LucideIcons.chevronRight300,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    for (final option in options)
                      _TargetChip(
                        label: _labelFor(option, l10n),
                        selected: option.target == selected.target,
                        onTap: () => setState(() => _picked = option.target),
                      ),
                    for (final character in selected.weakCharacters)
                      _WeakCharChip(character: character),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// The chip label for [option] — "Characters", the weak finger's own
  /// name, or its hand's.
  String _labelFor(WarmUpOption option, AppLocalizations l10n) {
    return switch (option.target) {
      WarmUpTarget.characters => l10n.practiceWarmUpTargetCharacters,
      WarmUpTarget.finger =>
        option.finger?.label(l10n) ?? l10n.practiceWarmUpTargetCharacters,
      WarmUpTarget.hand =>
        option.hand == Hand.left
            ? l10n.practiceWarmUpHandLeft
            : l10n.practiceWarmUpHandRight,
    };
  }
}

/// A selectable drill target — the same tonal fill for every chip, with
/// the selected one promoted to the primary container.
class _TargetChip extends StatelessWidget {
  const new({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BouncyTap(
      enabled: true,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: ShapeDecoration(
            shape: AppShapes.of(context).smallShape,
            color: selected
                ? colorScheme.primaryContainer
                : colorScheme.surfaceContainerHighest,
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: selected
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

/// A small mono chip for one weak character, mapping whitespace to a
/// visible glyph so the chip is never an empty box.
class _WeakCharChip extends StatelessWidget {
  const new({required this.character});

  final String character;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: ShapeDecoration(
        shape: AppShapes.of(context).smallShape,
        color: colorScheme.secondaryContainer,
      ),
      child: Text(
        _display(character),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          fontFamily: AppFonts.mono,
          color: colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }

  String _display(String character) => switch (character) {
    ' ' => '␣',
    '\n' => '⏎',
    '\t' => '⇥',
    _ => character,
  };
}
