// Unit tests for `SurvivalRunTracker` (SPEC.md §5.8) — the pure arcade
// rules behind Survival mode: lives, combo, multiplier, score and
// cleared-snippet count. No widgets, clock or storage needed.
import 'package:flutter_test/flutter_test.dart';
import 'package:just_in_time/features/practice/domain/services/survival_run_tracker.dart';

void main() {
  test('a fresh run starts with 5 lives, 1× multiplier and no score', () {
    final tracker = SurvivalRunTracker();
    expect(tracker.startingLives, 5);
    expect(tracker.livesRemaining, 5);
    expect(tracker.currentStreak, 0);
    expect(tracker.multiplier, 1);
    expect(tracker.score, 0);
    expect(tracker.snippetsCleared, 0);
    expect(tracker.bestMultiplier, 1);
    expect(tracker.isOver, isFalse);
  });

  test('a mistake costs one life and resets the combo', () {
    final tracker = SurvivalRunTracker()
      ..recordCorrect()
      ..recordCorrect();

    expect(tracker.isOver, isFalse);
    expect(tracker.currentStreak, 2);

    expect(tracker.recordMistake(), isFalse);
    expect(tracker.livesRemaining, 4);
    expect(tracker.currentStreak, 0);
    expect(tracker.multiplier, 1);
    expect(tracker.isOver, isFalse);
  });

  test('the fifth mistake reports the run over and later ones stay over', () {
    final tracker = SurvivalRunTracker();
    for (var i = 0; i < 4; i++) {
      expect(tracker.recordMistake(), isFalse);
    }
    expect(tracker.livesRemaining, 1);

    expect(tracker.recordMistake(), isTrue);
    expect(tracker.livesRemaining, 0);
    expect(tracker.isOver, isTrue);
    expect(tracker.recordMistake(), isTrue);
    expect(tracker.livesRemaining, 0);
  });

  test('correct characters earn the pre-combo-step multiplier', () {
    final tracker = SurvivalRunTracker();
    for (var i = 0; i < 25; i++) {
      tracker.recordCorrect();
    }
    expect(tracker.score, 25);
    expect(tracker.currentStreak, 25);
    expect(tracker.multiplier, 2);
    expect(tracker.bestMultiplier, 2);

    tracker.recordCorrect();
    expect(tracker.score, 27, reason: 'the 26th character earns 2×');
  });

  test('the multiplier caps at 4× no matter how long the combo runs', () {
    final tracker = SurvivalRunTracker();
    for (var i = 0; i < 100; i++) {
      tracker.recordCorrect();
    }
    expect(tracker.multiplier, 4);
    expect(tracker.bestMultiplier, 4);
    // 25 at 1× + 25 at 2× + 25 at 3× + 25 at 4×.
    expect(tracker.score, 25 + 50 + 75 + 100);
  });

  test('a mistake keeps the score but drops the multiplier back to 1×', () {
    final tracker = SurvivalRunTracker();
    for (var i = 0; i < 60; i++) {
      tracker.recordCorrect();
    }
    final scoreBefore = tracker.score;
    expect(tracker.multiplier, 3);

    tracker
      ..recordMistake()
      ..recordCorrect();
    expect(tracker.score, scoreBefore + 1);
    expect(tracker.multiplier, 1);
    expect(tracker.bestMultiplier, 3, reason: 'the peak is remembered');
  });

  test('cleared snippets are counted independently of the combo', () {
    final tracker = SurvivalRunTracker()
      ..recordSnippetCleared()
      ..recordSnippetCleared()
      ..recordMistake();
    expect(tracker.snippetsCleared, 2);
    expect(tracker.isOver, isFalse);
  });

  test('a custom life count is honored', () {
    final tracker = SurvivalRunTracker(startingLives: 1);
    expect(tracker.recordMistake(), isTrue);
    expect(tracker.isOver, isTrue);
  });
}
