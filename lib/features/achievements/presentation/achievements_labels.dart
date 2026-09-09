import 'package:flutter/material.dart';

import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/features/achievements/domain/entities/achievement_id.dart';
import 'package:just_in_time/features/achievements/domain/entities/maratonista_tier.dart';
import 'package:just_in_time/features/achievements/domain/entities/streak_tier.dart';
import 'package:just_in_time/features/content/presentation/content_labels.dart';

/// Localized display title/description/icon for an [AchievementId],
/// shared by every widget that renders one (mirrors `content`'s
/// `DifficultyLabel`/`learning_paths`' `LessonStatusPresentation`).
extension AchievementIdPresentation on AchievementId {
  /// Returns this achievement's localized display title.
  String title(AppLocalizations l10n) => when(
    ceroErrores: () => l10n.achievementCeroErroresTitle,
    maratonista: (tier) => tier.title(l10n),
    ambidiestro: () => l10n.achievementAmbidiestroTitle,
    categoryMastery: (category, difficulty) =>
        l10n.achievementCategoryMasteryTitle(
          category.label(l10n),
          difficulty.label(l10n),
        ),
    streak: (tier) => tier.title(l10n),
  );

  /// Returns this achievement's localized display description (what it
  /// takes to unlock it).
  String description(AppLocalizations l10n) => when(
    ceroErrores: () => l10n.achievementCeroErroresDescription,
    maratonista: (tier) => tier.description(l10n),
    ambidiestro: () => l10n.achievementAmbidiestroDescription,
    categoryMastery: (_, _) => l10n.achievementCategoryMasteryDescription,
    streak: (tier) => tier.description(l10n),
  );

  /// Returns this achievement's display icon.
  IconData get icon => when(
    ceroErrores: () => Icons.verified_rounded,
    maratonista: (_) => Icons.directions_run_rounded,
    ambidiestro: () => Icons.back_hand_rounded,
    categoryMastery: (_, _) => Icons.workspace_premium_rounded,
    streak: (_) => Icons.local_fire_department_rounded,
  );
}

/// Localized display title/description for a [MaratonistaTier].
extension MaratonistaTierPresentation on MaratonistaTier {
  /// Returns this tier's localized display title.
  String title(AppLocalizations l10n) => switch (this) {
    MaratonistaTier.bronze => l10n.achievementMaratonistaBronzeTitle,
    MaratonistaTier.silver => l10n.achievementMaratonistaSilverTitle,
    MaratonistaTier.gold => l10n.achievementMaratonistaGoldTitle,
  };

  /// Returns this tier's localized display description.
  String description(AppLocalizations l10n) =>
      l10n.achievementMaratonistaDescription(lifetimeCorrectCharsThreshold);
}

/// Localized display title/description for a [StreakTier].
extension StreakTierPresentation on StreakTier {
  /// Returns this tier's localized display title.
  String title(AppLocalizations l10n) =>
      l10n.achievementStreakTitle(requiredConsecutiveDays);

  /// Returns this tier's localized display description.
  String description(AppLocalizations l10n) =>
      l10n.achievementStreakDescription(requiredConsecutiveDays);
}
