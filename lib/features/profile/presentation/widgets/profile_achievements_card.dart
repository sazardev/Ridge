import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/features/achievements/presentation/providers/achievements_providers.dart';

/// A compact preview card linking out to the full Achievements screen
/// (SPEC.md §12) — just how many badges are unlocked so far, with a link
/// to `/achievements` for the badge grid/category-mastery matrix that
/// live there (mirrors `ProfileStatsCard`'s preview-and-link-out shape).
class ProfileAchievementsCard extends ConsumerWidget {
  /// Creates the card.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final unlockedCount =
        ref.watch(unlockedAchievementsControllerProvider).value?.length ?? 0;

    return Card(
      shape: AppShapes.of(context).largeShape,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(LucideIcons.trophy300, color: colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.profileAchievementsTitle,
                    style: textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    l10n.profileAchievementsCount(unlockedCount),
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            TextButton.icon(
              onPressed: () => context.push('/achievements'),
              icon: const Icon(LucideIcons.arrowRight300, size: 18),
              label: Text(l10n.profileAchievementsAction),
            ),
          ],
        ),
      ),
    );
  }
}
