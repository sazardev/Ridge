// Unit tests for `LevelCalculator` — pure and stateless. Covers the
// level curve's exact values (cross-checked against
// `round(100*n^1.6, nearest 10)`), the level-1-is-free-floor exception,
// boundary behavior at exact thresholds, and the four difficulty-unlock
// levels (SPEC.md §6.2).
import 'package:flutter_test/flutter_test.dart';
import 'package:just_in_time/features/content/domain/entities/difficulty.dart';
import 'package:just_in_time/features/progression/domain/services/level_calculator.dart';

void main() {
  const calculator = LevelCalculator();

  group('xpForLevel', () {
    test('level 1 is a free floor at 0 XP, not the raw formula value', () {
      expect(calculator.xpForLevel(1), 0);
    });

    test('matches round(100*n^1.6, nearest 10) for level 2 and up', () {
      expect(calculator.xpForLevel(2), 300);
      expect(calculator.xpForLevel(3), 580);
      expect(calculator.xpForLevel(5), 1310);
      expect(calculator.xpForLevel(15), 7620);
      expect(calculator.xpForLevel(30), 23090);
    });
  });

  group('levelForXp', () {
    test('0 XP is level 1', () {
      expect(calculator.levelForXp(0), 1);
    });

    test('just below a threshold stays at the lower level', () {
      expect(calculator.levelForXp(299), 1);
    });

    test('exactly at a threshold reaches the new level', () {
      expect(calculator.levelForXp(300), 2);
    });

    test('just above a threshold stays at that level until the next one', () {
      expect(calculator.levelForXp(301), 2);
      expect(calculator.levelForXp(579), 2);
    });

    test('a large XP total reaches a correspondingly high level', () {
      expect(calculator.levelForXp(23090), 30);
      expect(calculator.levelForXp(23089), 29);
    });
  });

  group('isDifficultyUnlocked', () {
    test('Beginner is unlocked from level 1', () {
      expect(calculator.isDifficultyUnlocked(Difficulty.beginner, 1), isTrue);
    });

    test('Intermediate unlocks at level 5, not before', () {
      expect(
        calculator.isDifficultyUnlocked(Difficulty.intermediate, 4),
        isFalse,
      );
      expect(
        calculator.isDifficultyUnlocked(Difficulty.intermediate, 5),
        isTrue,
      );
    });

    test('Advanced unlocks at level 15, not before', () {
      expect(calculator.isDifficultyUnlocked(Difficulty.advanced, 14), isFalse);
      expect(calculator.isDifficultyUnlocked(Difficulty.advanced, 15), isTrue);
    });

    test('Expert unlocks at level 30, not before', () {
      expect(calculator.isDifficultyUnlocked(Difficulty.expert, 29), isFalse);
      expect(calculator.isDifficultyUnlocked(Difficulty.expert, 30), isTrue);
    });
  });
}
