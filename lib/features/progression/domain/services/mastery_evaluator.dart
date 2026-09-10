import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/progression/domain/entities/mastery_status.dart';
import 'package:ridge/features/progression/domain/entities/precision_result.dart';

/// Pure, stateless dominance certification (SPEC.md §6.4): the last 5
/// Precision-mode sessions for a (category, difficulty) pair, each
/// judged against an accuracy floor and a per-difficulty speed floor.
///
/// One formula serves both certifying and decaying, by hysteresis:
/// newly certifying requires a clean 5/5, but an already-mastered pair
/// only decays once fewer than 4 of the trailing 5 still pass — so
/// "mastered" doesn't flicker off after a single off day, but also
/// doesn't stay true forever once real performance has dropped
/// (SPEC.md §6.4: "puede degradarse ... si el desempeño posterior cae de
/// forma sostenida").
class MasteryEvaluator {
  /// Creates the (stateless) evaluator.
  const new();

  /// Minimum accuracy (inclusive) a Precision session needs to count as
  /// passing for mastery purposes.
  static const accuracyFloor = 98.0;

  /// Minimum net speed (inclusive), in cpm, per [Difficulty].
  static const Map<Difficulty, double> speedFloors = {
    Difficulty.beginner: 150.0,
    Difficulty.intermediate: 180.0,
    Difficulty.advanced: 210.0,
    Difficulty.expert: 240.0,
  };

  /// How many of the trailing 5 results may still pass while a
  /// previously-mastered pair keeps its certification.
  static const _decayFloorPassCount = 4;

  /// Whether one Precision result passes the mastery bar for
  /// [difficulty].
  bool passes(PrecisionResult result, Difficulty difficulty) {
    return result.accuracyPct >= accuracyFloor &&
        result.netSpeedCpm >= speedFloors[difficulty]!;
  }

  /// Evaluates mastery for [category]/[difficulty] from its
  /// [lastFiveNewestFirst] Precision results (newest first, at most 5 —
  /// fewer than 5 means not enough history to certify or decay yet) and
  /// [wasMastered] (the previously cached status, for the decay
  /// hysteresis).
  MasteryStatus evaluate({
    required ContentCategory category,
    required Difficulty difficulty,
    required bool wasMastered,
    required List<PrecisionResult> lastFiveNewestFirst,
    required DateTime evaluatedAt,
  }) {
    if (lastFiveNewestFirst.length < 5) {
      return MasteryStatus(
        category: category,
        difficulty: difficulty,
        isMastered: wasMastered,
        evaluatedAt: evaluatedAt,
      );
    }
    final passCount = lastFiveNewestFirst
        .where((result) => passes(result, difficulty))
        .length;
    final isMastered = wasMastered
        ? passCount >= _decayFloorPassCount
        : passCount == lastFiveNewestFirst.length;
    return MasteryStatus(
      category: category,
      difficulty: difficulty,
      isMastered: isMastered,
      passCountInLastFive: passCount,
      evaluatedAt: evaluatedAt,
    );
  }
}
