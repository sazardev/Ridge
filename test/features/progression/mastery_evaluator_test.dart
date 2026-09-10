// Unit tests for `MasteryEvaluator` — pure and stateless. Covers
// certifying on a clean 5/5, decaying only below 4/5 trailing passes
// (the hysteresis that lets "mastered" survive a single off day), the
// not-enough-history case (fewer than 5 results), and the exact
// accuracy/speed threshold boundaries (SPEC.md §6.4).
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/progression/domain/entities/precision_result.dart';
import 'package:ridge/features/progression/domain/services/mastery_evaluator.dart';

void main() {
  const evaluator = MasteryEvaluator();
  final evaluatedAt = DateTime.utc(2026);
  const category = ContentCategory.errorHandling;
  const difficulty = Difficulty.beginner; // speed floor: 150 cpm.

  PrecisionResult passing() =>
      const PrecisionResult(accuracyPct: 99, netSpeedCpm: 160);
  PrecisionResult failing() =>
      const PrecisionResult(accuracyPct: 90, netSpeedCpm: 160);

  test('fewer than 5 results is not enough history to certify or decay', () {
    final status = evaluator.evaluate(
      category: category,
      difficulty: difficulty,
      wasMastered: false,
      lastFiveNewestFirst: [passing(), passing(), passing()],
      evaluatedAt: evaluatedAt,
    );
    expect(status.isMastered, isFalse);
    expect(status.passCountInLastFive, isNull);
  });

  test('fewer than 5 results leaves an already-mastered pair mastered '
      '(still not enough history to decay it)', () {
    final status = evaluator.evaluate(
      category: category,
      difficulty: difficulty,
      wasMastered: true,
      lastFiveNewestFirst: [failing(), failing()],
      evaluatedAt: evaluatedAt,
    );
    expect(status.isMastered, isTrue);
    expect(status.passCountInLastFive, isNull);
  });

  test('a clean 5/5 newly certifies mastery', () {
    final status = evaluator.evaluate(
      category: category,
      difficulty: difficulty,
      wasMastered: false,
      lastFiveNewestFirst: List.generate(5, (_) => passing()),
      evaluatedAt: evaluatedAt,
    );
    expect(status.isMastered, isTrue);
    expect(status.passCountInLastFive, 5);
  });

  test('4/5 does not newly certify mastery', () {
    final status = evaluator.evaluate(
      category: category,
      difficulty: difficulty,
      wasMastered: false,
      lastFiveNewestFirst: [
        passing(),
        passing(),
        passing(),
        passing(),
        failing(),
      ],
      evaluatedAt: evaluatedAt,
    );
    expect(status.isMastered, isFalse);
    expect(status.passCountInLastFive, 4);
  });

  test('4/5 trailing passes keeps an already-mastered pair mastered', () {
    final status = evaluator.evaluate(
      category: category,
      difficulty: difficulty,
      wasMastered: true,
      lastFiveNewestFirst: [
        passing(),
        passing(),
        passing(),
        passing(),
        failing(),
      ],
      evaluatedAt: evaluatedAt,
    );
    expect(status.isMastered, isTrue);
    expect(status.passCountInLastFive, 4);
  });

  test('3/5 trailing passes decays an already-mastered pair', () {
    final status = evaluator.evaluate(
      category: category,
      difficulty: difficulty,
      wasMastered: true,
      lastFiveNewestFirst: [
        passing(),
        passing(),
        passing(),
        failing(),
        failing(),
      ],
      evaluatedAt: evaluatedAt,
    );
    expect(status.isMastered, isFalse);
    expect(status.passCountInLastFive, 3);
  });

  group('exact threshold boundaries', () {
    test('accuracy exactly at 98% and speed exactly at the floor passes', () {
      const result = PrecisionResult(accuracyPct: 98, netSpeedCpm: 150);
      expect(evaluator.passes(result, Difficulty.beginner), isTrue);
    });

    test('accuracy just below 98% fails', () {
      const result = PrecisionResult(accuracyPct: 97.99, netSpeedCpm: 150);
      expect(evaluator.passes(result, Difficulty.beginner), isFalse);
    });

    test('speed just below the floor fails', () {
      const result = PrecisionResult(accuracyPct: 98, netSpeedCpm: 149.99);
      expect(evaluator.passes(result, Difficulty.beginner), isFalse);
    });

    test('each difficulty has its own speed floor', () {
      const atBeginnerFloor = PrecisionResult(
        accuracyPct: 98,
        netSpeedCpm: 180,
      );
      expect(
        evaluator.passes(atBeginnerFloor, Difficulty.intermediate),
        isTrue,
      );
      expect(evaluator.passes(atBeginnerFloor, Difficulty.advanced), isFalse);
    });
  });
}
