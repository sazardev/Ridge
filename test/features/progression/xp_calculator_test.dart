// Unit tests for `XpCalculator` — pure and stateless, so every input is
// hand-fabricated. Covers the four difficulty multipliers, the
// never-below-half-credit accuracy floor, the first-completion bonus
// (applied once per call when `isFirstCompletion` is true), and the
// streak bonus cap at 14 days (SPEC.md §6.1).
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/progression/domain/services/xp_calculator.dart';

void main() {
  const calculator = XpCalculator();

  group('difficulty multipliers', () {
    test('beginner uses a 1.0x multiplier', () {
      final xp = calculator.calculate(
        correctFirstTryChars: 100,
        difficulty: Difficulty.beginner,
        accuracyPct: 100,
        isFirstCompletion: false,
        currentStreakDays: 0,
      );
      expect(xp, 100);
    });

    test('intermediate uses a 1.3x multiplier', () {
      final xp = calculator.calculate(
        correctFirstTryChars: 100,
        difficulty: Difficulty.intermediate,
        accuracyPct: 100,
        isFirstCompletion: false,
        currentStreakDays: 0,
      );
      expect(xp, 130);
    });

    test('advanced uses a 1.6x multiplier', () {
      final xp = calculator.calculate(
        correctFirstTryChars: 100,
        difficulty: Difficulty.advanced,
        accuracyPct: 100,
        isFirstCompletion: false,
        currentStreakDays: 0,
      );
      expect(xp, 160);
    });

    test('expert uses a 2.0x multiplier', () {
      final xp = calculator.calculate(
        correctFirstTryChars: 100,
        difficulty: Difficulty.expert,
        accuracyPct: 100,
        isFirstCompletion: false,
        currentStreakDays: 0,
      );
      expect(xp, 200);
    });
  });

  group('accuracy multiplier never drops below half credit', () {
    test('0% accuracy still grants half credit, never zero', () {
      final xp = calculator.calculate(
        correctFirstTryChars: 100,
        difficulty: Difficulty.beginner,
        accuracyPct: 0,
        isFirstCompletion: false,
        currentStreakDays: 0,
      );
      expect(xp, 50);
    });

    test('100% accuracy grants full credit', () {
      final xp = calculator.calculate(
        correctFirstTryChars: 100,
        difficulty: Difficulty.beginner,
        accuracyPct: 100,
        isFirstCompletion: false,
        currentStreakDays: 0,
      );
      expect(xp, 100);
    });

    test('the base XP is floored, not rounded', () {
      // multiplier = 0.5 + 0.5*50/100 = 0.75; 3 * 1.0 * 0.75 = 2.25.
      final xp = calculator.calculate(
        correctFirstTryChars: 3,
        difficulty: Difficulty.beginner,
        accuracyPct: 50,
        isFirstCompletion: false,
        currentStreakDays: 0,
      );
      expect(xp, 2);
    });
  });

  group('first-completion bonus', () {
    test('is added once when isFirstCompletion is true', () {
      final xp = calculator.calculate(
        correctFirstTryChars: 0,
        difficulty: Difficulty.beginner,
        accuracyPct: 100,
        isFirstCompletion: true,
        currentStreakDays: 0,
      );
      expect(xp, XpCalculator.firstCompletionBonus);
    });

    test('is not added when isFirstCompletion is false', () {
      final xp = calculator.calculate(
        correctFirstTryChars: 0,
        difficulty: Difficulty.beginner,
        accuracyPct: 100,
        isFirstCompletion: false,
        currentStreakDays: 0,
      );
      expect(xp, 0);
    });
  });

  group('streak bonus caps at 14 days', () {
    test('0-day streak grants no bonus', () {
      final xp = calculator.calculate(
        correctFirstTryChars: 0,
        difficulty: Difficulty.beginner,
        accuracyPct: 100,
        isFirstCompletion: false,
        currentStreakDays: 0,
      );
      expect(xp, 0);
    });

    test('5-day streak grants 25 bonus XP', () {
      final xp = calculator.calculate(
        correctFirstTryChars: 0,
        difficulty: Difficulty.beginner,
        accuracyPct: 100,
        isFirstCompletion: false,
        currentStreakDays: 5,
      );
      expect(xp, 25);
    });

    test('exactly 14-day streak grants the maximum 70 bonus XP', () {
      final xp = calculator.calculate(
        correctFirstTryChars: 0,
        difficulty: Difficulty.beginner,
        accuracyPct: 100,
        isFirstCompletion: false,
        currentStreakDays: 14,
      );
      expect(xp, 70);
    });

    test('a streak longer than 14 days still caps at 70 bonus XP', () {
      final xp = calculator.calculate(
        correctFirstTryChars: 0,
        difficulty: Difficulty.beginner,
        accuracyPct: 100,
        isFirstCompletion: false,
        currentStreakDays: 100,
      );
      expect(xp, 70);
    });
  });
}
