import 'dart:math' as math;

import 'package:ridge/features/content/domain/entities/difficulty.dart';

/// Pure, stateless XP formula (SPEC.md §6.1):
///
/// `xp = floor(correctFirstTryChars * difficultyMultiplier *
/// accuracyMultiplier) + firstCompletionBonus + streakBonus`
///
/// No clock, no I/O — every input is supplied by the caller
/// (`RecomputeProgressSnapshotUseCase`), which is what makes this
/// unit-testable with fully fabricated data.
class XpCalculator {
  /// Creates the (stateless) calculator.
  const new();

  static const Map<Difficulty, double> _difficultyMultipliers = {
    Difficulty.beginner: 1.0,
    Difficulty.intermediate: 1.3,
    Difficulty.advanced: 1.6,
    Difficulty.expert: 2.0,
  };

  /// Awarded once per `SnippetId` (any revision), the first time it's
  /// ever completed.
  static const firstCompletionBonus = 50;

  /// A streak longer than this many days stops adding more XP bonus.
  static const streakBonusCapDays = 14;

  /// XP granted per day of current streak, up to [streakBonusCapDays].
  static const streakBonusPerDay = 5;

  /// XP never dips below half credit for `correctFirstTryChars`-worth of
  /// typing, however low `accuracyPct` is (SPEC.md §6.1: "no hay
  /// penalización de XP por bajo desempeño, solo menor ganancia").
  static const _minAccuracyMultiplier = 0.5;
  static const _maxAccuracyMultiplier = 1.0;

  /// Computes the XP one finished session grants.
  int calculate({
    required int correctFirstTryChars,
    required Difficulty difficulty,
    required double accuracyPct,
    required bool isFirstCompletion,
    required int currentStreakDays,
  }) {
    final difficultyMultiplier = _difficultyMultipliers[difficulty]!;
    final accuracyMultiplier =
        (_minAccuracyMultiplier + _minAccuracyMultiplier * accuracyPct / 100)
            .clamp(_minAccuracyMultiplier, _maxAccuracyMultiplier);
    final base =
        (correctFirstTryChars * difficultyMultiplier * accuracyMultiplier)
            .floor();
    final streakBonus =
        math.min(currentStreakDays, streakBonusCapDays) * streakBonusPerDay;
    return base + (isFirstCompletion ? firstCompletionBonus : 0) + streakBonus;
  }
}
