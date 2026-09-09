// Unit tests for `AchievementId.storageKey`/`fromStorageKey` — the
// hand-written string encoding `achievements_unlocked.achievement_id`
// persists, so its round-trip correctness matters for every variant,
// including every (category, difficulty) combination the category-
// mastery badge can be parameterized by.
import 'package:flutter_test/flutter_test.dart';
import 'package:just_in_time/features/achievements/domain/entities/achievement_id.dart';
import 'package:just_in_time/features/achievements/domain/entities/maratonista_tier.dart';
import 'package:just_in_time/features/achievements/domain/entities/streak_tier.dart';
import 'package:just_in_time/features/content/domain/entities/content_category.dart';
import 'package:just_in_time/features/content/domain/entities/difficulty.dart';

void main() {
  test('ceroErrores round-trips through its storage key', () {
    const id = AchievementId.ceroErrores();
    expect(AchievementId.fromStorageKey(id.storageKey), id);
  });

  test('ambidiestro round-trips through its storage key', () {
    const id = AchievementId.ambidiestro();
    expect(AchievementId.fromStorageKey(id.storageKey), id);
  });

  test('every maratonista tier round-trips through its storage key', () {
    for (final tier in MaratonistaTier.values) {
      final id = AchievementId.maratonista(tier);
      expect(AchievementId.fromStorageKey(id.storageKey), id);
    }
  });

  test('every streak tier round-trips through its storage key', () {
    for (final tier in StreakTier.values) {
      final id = AchievementId.streak(tier);
      expect(AchievementId.fromStorageKey(id.storageKey), id);
    }
  });

  test('every (category, difficulty) categoryMastery pair round-trips '
      'through its storage key', () {
    for (final category in ContentCategory.values) {
      for (final difficulty in Difficulty.values) {
        final id = AchievementId.categoryMastery(
          category: category,
          difficulty: difficulty,
        );
        expect(AchievementId.fromStorageKey(id.storageKey), id);
      }
    }
  });

  test('storage keys are unique across the whole catalog', () {
    final ids = [
      const AchievementId.ceroErrores(),
      const AchievementId.ambidiestro(),
      for (final tier in MaratonistaTier.values)
        AchievementId.maratonista(tier),
      for (final tier in StreakTier.values) AchievementId.streak(tier),
      for (final category in ContentCategory.values)
        for (final difficulty in Difficulty.values)
          AchievementId.categoryMastery(
            category: category,
            difficulty: difficulty,
          ),
    ];
    final keys = [for (final id in ids) id.storageKey];
    expect(keys.toSet(), hasLength(keys.length));
  });

  test('an unknown storage key throws ArgumentError', () {
    expect(
      () => AchievementId.fromStorageKey('not_a_real_achievement'),
      throwsArgumentError,
    );
  });
}
