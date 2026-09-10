// Unit tests for `PrecisionScoreCalculator` — the 1-10 scoring that
// replaced a flat "98% or nothing" Precision pass bar with something
// more forgiving of a strong-but-imperfect run (SPEC.md §5.3).
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/practice/domain/services/precision_score_calculator.dart';

void main() {
  const calculator = PrecisionScoreCalculator();

  group('scoreFor', () {
    test('a flawless 100% run scores 10', () {
      expect(calculator.scoreFor(100), 10);
    });

    test('just under 100% still scores 9, not 10', () {
      expect(calculator.scoreFor(99.9), 9);
    });

    test('scores one point per 10-percentage-point band', () {
      expect(calculator.scoreFor(90), 9);
      expect(calculator.scoreFor(89.9), 8);
      expect(calculator.scoreFor(80), 8);
      expect(calculator.scoreFor(79.9), 7);
      expect(calculator.scoreFor(70), 7);
      expect(calculator.scoreFor(10), 1);
    });

    test('never reads as literally zero, even at 0% accuracy', () {
      expect(calculator.scoreFor(0), 1);
      expect(calculator.scoreFor(5), 1);
    });
  });

  group('passes', () {
    test('exactly 80% accuracy (score 8) passes', () {
      expect(calculator.passes(80), isTrue);
    });

    test('just below 80% accuracy (score 7) fails', () {
      expect(calculator.passes(79.9), isFalse);
    });

    test('a flawless run passes', () {
      expect(calculator.passes(100), isTrue);
    });

    test('a poor run fails', () {
      expect(calculator.passes(20), isFalse);
    });
  });
}
