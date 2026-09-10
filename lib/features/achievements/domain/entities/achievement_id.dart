import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ridge/features/achievements/domain/entities/maratonista_tier.dart';
import 'package:ridge/features/achievements/domain/entities/streak_tier.dart';
import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';

part 'achievement_id.freezed.dart';

/// Which concrete SPEC.md §12 achievement this is. Modeled as one sealed
/// type (rather than a flat enum) because [AchievementId.categoryMastery]
/// is parameterized by a (category, difficulty) pair — there's one such
/// badge per pair, not a fixed enum case (mirrors `practice`'s
/// `PracticeMode`).
@freezed
sealed class AchievementId with _$AchievementId {
  /// "Cero Errores": a single finished session with 100% accuracy and
  /// zero corrections at all during that session.
  const factory ceroErrores() = _CeroErrores;

  /// "Maratonista": lifetime correct-first-try characters crosses
  /// [tier]'s threshold — one badge per tier.
  const factory maratonista(MaratonistaTier tier) = _Maratonista;

  /// "Ambidiestro": a single session with at least 100 characters typed
  /// and near-perfect hand balance.
  const factory ambidiestro() = _Ambidiestro;

  /// A (category, difficulty) pair certified as mastered by
  /// `progression`'s `MasteryEvaluator` — one badge per pair, unlocked
  /// the first time it's observed certified.
  const factory categoryMastery({
    required ContentCategory category,
    required Difficulty difficulty,
  }) = _CategoryMastery;

  /// A consecutive-day streak crosses [tier]'s threshold — one badge per
  /// tier.
  const factory streak(StreakTier tier) = _Streak;

  // The project-wide "elide the type name in a constructor" convention
  // only has a valid spelling for the unnamed constructor and named
  // *factory* constructors (see `Snippet._()`'s class doc) — this
  // private non-factory constructor must spell out the class name.
  // ignore: unnecessary_type_name_in_constructor
  const AchievementId._();

  /// Stable, storage-safe key this id round-trips through via
  /// [fromStorageKey] — persisted as `achievements_unlocked
  /// .achievement_id`. Never change an existing variant's encoding once
  /// shipped; already-persisted rows reference it directly.
  String get storageKey => when(
    ceroErrores: () => 'cero_errores',
    maratonista: (tier) => 'maratonista_${tier.name}',
    ambidiestro: () => 'ambidiestro',
    categoryMastery: (category, difficulty) =>
        'category_mastery_${category.name}_${difficulty.name}',
    streak: (tier) => 'streak_${tier.name}',
  );

  /// The inverse of [storageKey] — reconstructs the [AchievementId] a
  /// persisted `achievements_unlocked` row refers to. Throws
  /// [ArgumentError] if [key] doesn't match any known encoding.
  static AchievementId fromStorageKey(String key) {
    if (key == 'cero_errores') return const AchievementId.ceroErrores();
    if (key == 'ambidiestro') return const AchievementId.ambidiestro();

    for (final tier in MaratonistaTier.values) {
      if (key == 'maratonista_${tier.name}') {
        return AchievementId.maratonista(tier);
      }
    }
    for (final tier in StreakTier.values) {
      if (key == 'streak_${tier.name}') return AchievementId.streak(tier);
    }

    const categoryMasteryPrefix = 'category_mastery_';
    if (key.startsWith(categoryMasteryPrefix)) {
      final rest = key.substring(categoryMasteryPrefix.length);
      for (final category in ContentCategory.values) {
        final categoryPrefix = '${category.name}_';
        if (rest.startsWith(categoryPrefix)) {
          final difficulty = Difficulty.values.byName(
            rest.substring(categoryPrefix.length),
          );
          return AchievementId.categoryMastery(
            category: category,
            difficulty: difficulty,
          );
        }
      }
    }

    throw ArgumentError.value(key, 'key', 'Unknown achievement storage key');
  }
}
