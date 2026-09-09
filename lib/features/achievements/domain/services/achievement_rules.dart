import 'package:just_in_time/features/achievements/domain/entities/maratonista_tier.dart';
import 'package:just_in_time/features/achievements/domain/entities/streak_tier.dart';

/// Pure, stateless predicates for SPEC.md §12's five locally-computable
/// achievement rules. Each takes only already-computed inputs (session
/// metrics, lifetime totals, mastery/streak read straight off
/// `progression`'s own output) — never raw drift access — so every rule
/// is unit-testable with hand-fabricated inputs alone (mirrors
/// `progression`'s `MasteryEvaluator`/`XpCalculator`).
class AchievementRules {
  /// Creates the (stateless) rules.
  const new();

  /// "Cero Errores" (SPEC.md §12): a single finished session with a
  /// perfect 100% accuracy AND zero backspaces/corrections at all during
  /// that session — not merely corrected-to-clean.
  bool ceroErrores({
    required double accuracyPct,
    required int correctionsCount,
  }) {
    return accuracyPct == 100.0 && correctionsCount == 0;
  }

  /// "Maratonista" (SPEC.md §12): lifetime correct-first-try characters
  /// has crossed [tier]'s threshold.
  bool maratonista({
    required MaratonistaTier tier,
    required int lifetimeCorrectFirstTryChars,
  }) {
    return lifetimeCorrectFirstTryChars >= tier.lifetimeCorrectCharsThreshold;
  }

  /// "Ambidiestro" (SPEC.md §12): a single session with at least 100
  /// (non-correction) characters typed AND near-perfect hand balance.
  bool ambidiestro({required int charCount, required double handBalanceRatio}) {
    return charCount >= 100 && handBalanceRatio >= 0.95;
  }

  /// A category-mastery badge (SPEC.md §12): fires whenever
  /// `progression`'s already-computed [isMastered] is true. This rule
  /// never recomputes mastery itself — it only observes the result
  /// `MasteryEvaluator` already produced; the caller is responsible for
  /// only unlocking once per (category, difficulty) pair (the permanent
  /// ratchet lives in `EvaluateAchievementsUseCase`, not here).
  bool categoryMastery({required bool isMastered}) => isMastered;

  /// A streak badge (SPEC.md §12): [currentStreakDays] — read straight
  /// off `progression`'s cached snapshot, never reimplementing
  /// `StreakCalculator` — has reached [tier]'s consecutive-day
  /// requirement.
  bool streak({required StreakTier tier, required int currentStreakDays}) {
    return currentStreakDays >= tier.requiredConsecutiveDays;
  }
}
