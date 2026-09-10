import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/core/widgets/escape_to_pop.dart';
import 'package:just_in_time/core/widgets/keyboard_scroll_shortcuts.dart';
import 'package:just_in_time/features/achievements/domain/entities/achievement_id.dart';
import 'package:just_in_time/features/achievements/domain/entities/maratonista_tier.dart';
import 'package:just_in_time/features/achievements/domain/entities/streak_tier.dart';
import 'package:just_in_time/features/achievements/presentation/providers/achievements_providers.dart';
import 'package:just_in_time/features/achievements/presentation/widgets/achievement_badge_tile.dart';
import 'package:just_in_time/features/content/domain/entities/content_category.dart';
import 'package:just_in_time/features/content/domain/entities/difficulty.dart';

/// The full catalog of achievements this build can ever award — the
/// fixed badges (Cero Errores/Ambidiestro/tiers) plus one category-
/// mastery badge per (category, difficulty) pair (SPEC.md §12).
List<AchievementId> _fullCatalog() => [
  const AchievementId.ceroErrores(),
  const AchievementId.ambidiestro(),
  for (final tier in MaratonistaTier.values) AchievementId.maratonista(tier),
  for (final tier in StreakTier.values) AchievementId.streak(tier),
  for (final category in ContentCategory.values)
    for (final difficulty in Difficulty.values)
      AchievementId.categoryMastery(category: category, difficulty: difficulty),
];

/// The Achievements screen (SPEC.md §12): a badge grid of every locally-
/// computable achievement — unlocked ones shown in full color with their
/// unlock date, locked ones greyed out with a hint of what's needed.
/// Reachable from Profile as a pushed non-shell route, same shape as
/// `/practice/session`.
class AchievementsScreen extends ConsumerStatefulWidget {
  /// Creates the achievements screen.
  const new({super.key});

  @override
  ConsumerState<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends ConsumerState<AchievementsScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final unlockedAsync = ref.watch(unlockedAchievementsControllerProvider);

    return EscapeToPop(
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.achievementsTitle)),
        body: unlockedAsync.when(
          data: (unlocked) {
            final unlockedById = {for (final a in unlocked) a.id.storageKey: a};
            final catalog = _fullCatalog();
            return KeyboardScrollShortcuts(
              controller: _scrollController,
              child: GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: catalog.length,
                itemBuilder: (context, index) {
                  final id = catalog[index];
                  final achievement = unlockedById[id.storageKey];
                  return AchievementBadgeTile(
                    id: id,
                    unlockedAt: achievement?.unlockedAt,
                  );
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text(l10n.commonSomethingWrong)),
        ),
      ),
    );
  }
}
