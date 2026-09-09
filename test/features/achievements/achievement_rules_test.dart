// Unit tests for `AchievementRules` — pure and stateless, so every input
// is hand-fabricated. Covers each of SPEC.md §12's five rules at their
// exact boundary (the threshold itself passes; one unit below does not).
import 'package:flutter_test/flutter_test.dart';
import 'package:just_in_time/features/achievements/domain/entities/maratonista_tier.dart';
import 'package:just_in_time/features/achievements/domain/entities/streak_tier.dart';
import 'package:just_in_time/features/achievements/domain/services/achievement_rules.dart';

void main() {
  const rules = AchievementRules();

  group('Cero Errores', () {
    test('100% accuracy with zero corrections unlocks it', () {
      expect(rules.ceroErrores(accuracyPct: 100, correctionsCount: 0), isTrue);
    });

    test('99.9% accuracy (not exactly 100%) does not unlock it', () {
      expect(
        rules.ceroErrores(accuracyPct: 99.9, correctionsCount: 0),
        isFalse,
      );
    });

    test('100% accuracy with even one correction does not unlock it', () {
      expect(rules.ceroErrores(accuracyPct: 100, correctionsCount: 1), isFalse);
    });
  });

  group('Ambidiestro', () {
    test('exactly 100 characters and 0.95 hand balance unlocks it', () {
      expect(rules.ambidiestro(charCount: 100, handBalanceRatio: 0.95), isTrue);
    });

    test('99 characters (one below the floor) does not unlock it', () {
      expect(rules.ambidiestro(charCount: 99, handBalanceRatio: 1), isFalse);
    });

    test('hand balance just below 0.95 (one below the floor) does not '
        'unlock it', () {
      expect(
        rules.ambidiestro(charCount: 200, handBalanceRatio: 0.949),
        isFalse,
      );
    });

    test('a perfect 1.0 hand balance still unlocks it', () {
      expect(rules.ambidiestro(charCount: 500, handBalanceRatio: 1), isTrue);
    });
  });

  group('Maratonista', () {
    test('exactly the bronze threshold unlocks bronze', () {
      expect(
        rules.maratonista(
          tier: MaratonistaTier.bronze,
          lifetimeCorrectFirstTryChars:
              MaratonistaTier.bronze.lifetimeCorrectCharsThreshold,
        ),
        isTrue,
      );
    });

    test('one character below the bronze threshold does not unlock it', () {
      expect(
        rules.maratonista(
          tier: MaratonistaTier.bronze,
          lifetimeCorrectFirstTryChars:
              MaratonistaTier.bronze.lifetimeCorrectCharsThreshold - 1,
        ),
        isFalse,
      );
    });

    test('exactly the silver threshold unlocks silver', () {
      expect(
        rules.maratonista(
          tier: MaratonistaTier.silver,
          lifetimeCorrectFirstTryChars:
              MaratonistaTier.silver.lifetimeCorrectCharsThreshold,
        ),
        isTrue,
      );
    });

    test('one character below the silver threshold does not unlock it', () {
      expect(
        rules.maratonista(
          tier: MaratonistaTier.silver,
          lifetimeCorrectFirstTryChars:
              MaratonistaTier.silver.lifetimeCorrectCharsThreshold - 1,
        ),
        isFalse,
      );
    });

    test('exactly the gold threshold unlocks gold', () {
      expect(
        rules.maratonista(
          tier: MaratonistaTier.gold,
          lifetimeCorrectFirstTryChars:
              MaratonistaTier.gold.lifetimeCorrectCharsThreshold,
        ),
        isTrue,
      );
    });

    test('one character below the gold threshold does not unlock it', () {
      expect(
        rules.maratonista(
          tier: MaratonistaTier.gold,
          lifetimeCorrectFirstTryChars:
              MaratonistaTier.gold.lifetimeCorrectCharsThreshold - 1,
        ),
        isFalse,
      );
    });
  });

  group('category mastery', () {
    test('a mastered status unlocks the badge', () {
      expect(rules.categoryMastery(isMastered: true), isTrue);
    });

    test('a not-yet-mastered status does not unlock the badge', () {
      expect(rules.categoryMastery(isMastered: false), isFalse);
    });
  });

  group('streak', () {
    for (final tier in StreakTier.values) {
      test('exactly the ${tier.name} threshold '
          '(${tier.requiredConsecutiveDays} days) unlocks it', () {
        expect(
          rules.streak(
            tier: tier,
            currentStreakDays: tier.requiredConsecutiveDays,
          ),
          isTrue,
        );
      });

      test('one day below the ${tier.name} threshold does not unlock it', () {
        expect(
          rules.streak(
            tier: tier,
            currentStreakDays: tier.requiredConsecutiveDays - 1,
          ),
          isFalse,
        );
      });
    }
  });
}
