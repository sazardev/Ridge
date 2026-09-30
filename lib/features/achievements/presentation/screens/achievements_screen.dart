import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/widgets/escape_to_pop.dart';
import 'package:ridge/core/widgets/keyboard_scroll_shortcuts.dart';
import 'package:ridge/core/widgets/staggered_entrance.dart';
import 'package:ridge/features/achievements/domain/entities/achievement.dart';
import 'package:ridge/features/achievements/domain/entities/achievement_id.dart';
import 'package:ridge/features/achievements/domain/entities/maratonista_tier.dart';
import 'package:ridge/features/achievements/domain/entities/streak_tier.dart';
import 'package:ridge/features/achievements/presentation/achievements_labels.dart';
import 'package:ridge/features/achievements/presentation/providers/achievements_providers.dart';
import 'package:ridge/features/achievements/presentation/widgets/achievement_badge_tile.dart';
import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/content/presentation/content_labels.dart';

/// Every milestone achievement (everything except category mastery) this
/// build can ever award — shown as badge tiles at the top of the screen.
/// Category mastery is excluded here since, at one badge per (category,
/// difficulty) pair, it's rendered as its own compact matrix instead
/// (see [_CategoryMasteryRow]) rather than one tile each.
List<AchievementId> _milestoneIds() => [
  const AchievementId.ceroErrores(),
  const AchievementId.ambidiestro(),
  for (final tier in MaratonistaTier.values) AchievementId.maratonista(tier),
  for (final tier in StreakTier.values) AchievementId.streak(tier),
];

/// The Achievements screen (SPEC.md §12): milestone badges up top as a
/// responsive wrap of tiles, followed by a compact per-category mastery
/// matrix (one row per category, one pip per difficulty) rather than one
/// giant tile per (category, difficulty) pair — the full catalog has 30+
/// categories × 4 difficulties, which doesn't read well as tiles.
/// Unlocked badges show in full color with their unlock date, locked
/// ones greyed out with a hint of what's needed. Reachable from Profile
/// as a pushed non-shell route, same shape as `/practice/session`.
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
    final theme = Theme.of(context);
    final unlockedAsync = ref.watch(unlockedAchievementsControllerProvider);

    return EscapeToPop(
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.achievementsTitle)),
        body: unlockedAsync.when(
          data: (unlocked) {
            final unlockedById = {for (final a in unlocked) a.id.storageKey: a};
            final milestoneIds = _milestoneIds();
            final totalCount =
                milestoneIds.length +
                ContentCategory.values.length * Difficulty.values.length;

            return KeyboardScrollShortcuts(
              controller: _scrollController,
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [
                  Text(
                    l10n.achievementsUnlockedCount(unlocked.length, totalCount),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      for (final (index, id) in milestoneIds.indexed)
                        SizedBox(
                          width: 168,
                          child: AchievementBadgeTile(
                            id: id,
                            unlockedAt: unlockedById[id.storageKey]?.unlockedAt,
                          ),
                        ).poppedIn(context, index),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text(
                    l10n.achievementsCategoryMasterySectionTitle,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.achievementsCategoryMasteryLegend,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Divider(height: 24),
                  for (final category in ContentCategory.values)
                    _CategoryMasteryRow(
                      category: category,
                      unlockedById: unlockedById,
                    ),
                ],
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

/// One category's mastery row: the category label, followed by one
/// [_MasteryPip] per [Difficulty] in the fixed order the section's
/// legend caption spells out (beginner → expert).
class _CategoryMasteryRow extends StatelessWidget {
  const new({required this.category, required this.unlockedById});

  /// Which category this row is for.
  final ContentCategory category;

  /// Every unlocked achievement, keyed by [AchievementId.storageKey].
  final Map<String, Achievement> unlockedById;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              category.label(l10n),
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          for (final difficulty in Difficulty.values)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _MasteryPip(
                category: category,
                difficulty: difficulty,
                unlockedById: unlockedById,
              ),
            ),
        ],
      ),
    );
  }
}

/// One small circular pip in a [_CategoryMasteryRow]: filled with a
/// checkmark when unlocked, an outline when still locked. A [Tooltip]
/// carries the full title (and unlock date, once unlocked) since the
/// pip itself is deliberately too small to hold any text.
class _MasteryPip extends StatelessWidget {
  const new({
    required this.category,
    required this.difficulty,
    required this.unlockedById,
  });

  /// Which category this pip renders mastery for.
  final ContentCategory category;

  /// Which difficulty this pip renders mastery for.
  final Difficulty difficulty;

  /// Every unlocked achievement, keyed by [AchievementId.storageKey].
  final Map<String, Achievement> unlockedById;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final id = AchievementId.categoryMastery(
      category: category,
      difficulty: difficulty,
    );
    final unlockedAt = unlockedById[id.storageKey]?.unlockedAt;
    final isUnlocked = unlockedAt != null;
    final title = id.title(l10n);

    return Tooltip(
      message: isUnlocked
          ? '$title\n${DateFormat.yMMMd().format(unlockedAt)}'
          : title,
      child: Container(
        width: 26,
        height: 26,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isUnlocked ? colors.primaryContainer : Colors.transparent,
          border: isUnlocked ? null : Border.all(color: colors.outlineVariant),
        ),
        child: isUnlocked
            ? Icon(
                LucideIcons.check600,
                size: 14,
                color: colors.onPrimaryContainer,
              )
            : null,
      ),
    );
  }
}
