// Unit tests for `MetricsCalculator` — pure and stateless, so every
// input here is hand-fabricated: no clock, no widget, no drift. Covers
// raw/net speed, accuracy, per-char/finger aggregation + hand-balance
// ratio (thumb excluded), n-gram stats, consistency scoring,
// fatigue-by-thirds, max streak, and the zero-keystroke/only-corrections
// edge cases.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/practice/domain/entities/finger.dart';
import 'package:ridge/features/practice/domain/entities/keyboard_row.dart';
import 'package:ridge/features/practice/domain/entities/keystroke.dart';
import 'package:ridge/features/practice/domain/entities/keystroke_result.dart';
import 'package:ridge/features/practice/domain/services/metrics_calculator.dart';
import 'package:ridge/features/practice/domain/value_objects/physical_key_id.dart';

Keystroke _keystroke({
  required int seq,
  String? expected,
  String? actual,
  KeystrokeResult result = KeystrokeResult.correct,
  Finger finger = Finger.leftIndex,
  KeyboardRow row = KeyboardRow.homeRow,
  PhysicalKeyId key = PhysicalKeyId.keyA,
  bool isCorrection = false,
  Duration? flight,
}) {
  return Keystroke(
    physicalKeyId: key,
    expectedChar: expected ?? actual,
    actualChar: isCorrection ? null : actual,
    result: result,
    isCorrection: isCorrection,
    finger: finger,
    keyboardRow: row,
    flight: flight,
    sequenceIndex: seq,
  );
}

void main() {
  const calculator = MetricsCalculator();

  test('raw speed counts everything typed; net speed counts only correct '
      'first-try characters; accuracy is correct/total * 100', () {
    final keystrokes = [
      _keystroke(seq: 0, actual: 'a'),
      _keystroke(seq: 1, actual: 'b'),
      _keystroke(seq: 2, actual: 'c'),
      _keystroke(
        seq: 3,
        actual: 'x',
        expected: 'd',
        result: KeystrokeResult.substitution,
      ),
    ];

    final metrics = calculator.calculate(
      keystrokes: keystrokes,
      expectedSnippet: 'abcd',
      totalDuration: const Duration(minutes: 1),
    );

    expect(metrics.rawSpeedCpm, 4);
    expect(metrics.netSpeedCpm, 3);
    expect(metrics.accuracyPct, 75);
  });

  test('correction (backspace) rows are excluded from raw/net speed and '
      'accuracy — only forward keystrokes count', () {
    final keystrokes = [
      _keystroke(seq: 0, actual: 'a'),
      _keystroke(
        seq: 1,
        actual: 'x',
        expected: 'b',
        result: KeystrokeResult.substitution,
      ),
      _keystroke(
        seq: 2,
        isCorrection: true,
        expected: 'b',
        result: KeystrokeResult.substitution,
      ),
      _keystroke(seq: 3, actual: 'b'),
    ];

    final metrics = calculator.calculate(
      keystrokes: keystrokes,
      expectedSnippet: 'ab',
      totalDuration: const Duration(minutes: 1),
    );

    // 3 forward keystrokes (a, x, b), 2 correct.
    expect(metrics.rawSpeedCpm, 3);
    expect(metrics.netSpeedCpm, 2);
    expect(metrics.accuracyPct, closeTo(66.666, 0.01));
  });

  test('hand-balance ratio excludes the thumb and is the smaller-over-larger '
      'hand count', () {
    final keystrokes = [
      _keystroke(seq: 0, actual: 'a'),
      _keystroke(seq: 1, actual: 'b', finger: Finger.leftRing),
      _keystroke(seq: 2, actual: 'c', finger: Finger.leftMiddle),
      _keystroke(seq: 3, actual: 'd', finger: Finger.rightIndex),
      _keystroke(seq: 4, actual: ' ', finger: Finger.thumb),
      _keystroke(seq: 5, actual: ' ', finger: Finger.thumb),
    ];

    final metrics = calculator.calculate(
      keystrokes: keystrokes,
      expectedSnippet: 'abcd  ',
      totalDuration: const Duration(minutes: 1),
    );

    // left=3, right=1, thumb excluded -> 1/3.
    expect(metrics.handBalanceRatio, closeTo(1 / 3, 0.0001));
  });

  test('a perfectly hand-balanced session has a ratio of 1.0, and an '
      'empty session defaults to 1.0 (no data)', () {
    final balanced = calculator.calculate(
      keystrokes: [
        _keystroke(seq: 0, actual: 'a'),
        _keystroke(seq: 1, actual: 'b', finger: Finger.rightIndex),
      ],
      expectedSnippet: 'ab',
      totalDuration: const Duration(minutes: 1),
    );
    expect(balanced.handBalanceRatio, 1.0);

    final empty = calculator.calculate(
      keystrokes: const [],
      expectedSnippet: '',
      totalDuration: Duration.zero,
    );
    expect(empty.handBalanceRatio, 1.0);
  });

  test('per-character stats aggregate attempts/errors/avg flight, keyed by '
      'expected character', () {
    final keystrokes = [
      _keystroke(
        seq: 0,
        actual: 'a',
        flight: const Duration(milliseconds: 100),
      ),
      _keystroke(
        seq: 1,
        actual: 'x',
        expected: 'a',
        result: KeystrokeResult.substitution,
        flight: const Duration(milliseconds: 300),
      ),
    ];

    final metrics = calculator.calculate(
      keystrokes: keystrokes,
      expectedSnippet: 'aa',
      totalDuration: const Duration(minutes: 1),
    );

    final stat = metrics.characterStats['a']!;
    expect(stat.attempts, 2);
    expect(stat.errors, 1);
    expect(stat.avgFlightMs, closeTo(200, 0.01));
  });

  test('per-finger stats aggregate attempts/errors the same way', () {
    final keystrokes = [
      _keystroke(seq: 0, actual: 'a', finger: Finger.leftPinky),
      _keystroke(
        seq: 1,
        actual: 'x',
        expected: 'q',
        result: KeystrokeResult.substitution,
        finger: Finger.leftPinky,
      ),
    ];

    final metrics = calculator.calculate(
      keystrokes: keystrokes,
      expectedSnippet: 'aq',
      totalDuration: const Duration(minutes: 1),
    );

    final stat = metrics.fingerStats[Finger.leftPinky]!;
    expect(stat.attempts, 2);
    expect(stat.errors, 1);
  });

  test('n-gram stats derive 2- and 3-char sequences from the actually '
      'typed characters', () {
    final keystrokes = [
      _keystroke(seq: 0, actual: 'a'),
      _keystroke(seq: 1, actual: 'b'),
      _keystroke(seq: 2, actual: 'c'),
    ];

    final metrics = calculator.calculate(
      keystrokes: keystrokes,
      expectedSnippet: 'abc',
      totalDuration: const Duration(minutes: 1),
    );

    final texts = metrics.ngramStats.map((n) => n.text).toSet();
    // Two 2-grams ("ab", "bc") and one 3-gram ("abc").
    expect(texts, {'ab', 'bc', 'abc'});
    for (final ngram in metrics.ngramStats) {
      expect(ngram.occurrences, 1);
      expect(ngram.errorCount, 0);
    }
  });

  test('an n-gram containing an error is flagged via errorCount', () {
    final keystrokes = [
      _keystroke(seq: 0, actual: 'a'),
      _keystroke(
        seq: 1,
        actual: 'x',
        expected: 'b',
        result: KeystrokeResult.substitution,
      ),
    ];

    final metrics = calculator.calculate(
      keystrokes: keystrokes,
      expectedSnippet: 'ab',
      totalDuration: const Duration(minutes: 1),
    );

    final ab = metrics.ngramStats.firstWhere((n) => n.text == 'ax');
    expect(ab.errorCount, 1);
  });

  test('consistency score is 100 for perfectly uniform flight and drops '
      'for erratic flight', () {
    final uniform = calculator.calculate(
      keystrokes: [
        _keystroke(
          seq: 0,
          actual: 'a',
          flight: const Duration(milliseconds: 100),
        ),
        _keystroke(
          seq: 1,
          actual: 'b',
          flight: const Duration(milliseconds: 100),
        ),
        _keystroke(
          seq: 2,
          actual: 'c',
          flight: const Duration(milliseconds: 100),
        ),
      ],
      expectedSnippet: 'abc',
      totalDuration: const Duration(minutes: 1),
    );
    expect(uniform.consistencyScore, 100);

    final erratic = calculator.calculate(
      keystrokes: [
        _keystroke(
          seq: 0,
          actual: 'a',
          flight: const Duration(milliseconds: 20),
        ),
        _keystroke(
          seq: 1,
          actual: 'b',
          flight: const Duration(milliseconds: 900),
        ),
        _keystroke(
          seq: 2,
          actual: 'c',
          flight: const Duration(milliseconds: 40),
        ),
      ],
      expectedSnippet: 'abc',
      totalDuration: const Duration(minutes: 1),
    );
    expect(erratic.consistencyScore, lessThan(100));
    expect(erratic.consistencyScore, greaterThanOrEqualTo(0));
  });

  test('fatigue-by-thirds shows a faster first third than a slower last '
      'third', () {
    Keystroke fast(int seq) => _keystroke(
      seq: seq,
      actual: 'a',
      flight: const Duration(milliseconds: 100),
    );
    Keystroke slow(int seq) => _keystroke(
      seq: seq,
      actual: 'a',
      flight: const Duration(milliseconds: 1000),
    );

    final keystrokes = [
      fast(0),
      fast(1),
      fast(2),
      fast(3),
      fast(4),
      fast(5),
      slow(6),
      slow(7),
      slow(8),
    ];

    final metrics = calculator.calculate(
      keystrokes: keystrokes,
      expectedSnippet: 'a' * 9,
      totalDuration: const Duration(minutes: 1),
    );

    expect(
      metrics.fatigueFirstThirdCpm,
      greaterThan(metrics.fatigueLastThirdCpm),
    );
  });

  test('max streak is the longest run of consecutive correct-first-try '
      'characters, resetting on any non-correct result', () {
    final keystrokes = [
      _keystroke(seq: 0, actual: 'a'),
      _keystroke(seq: 1, actual: 'b'),
      _keystroke(
        seq: 2,
        actual: 'x',
        expected: 'c',
        result: KeystrokeResult.substitution,
      ),
      _keystroke(seq: 3, actual: 'd'),
      _keystroke(seq: 4, actual: 'e'),
      _keystroke(seq: 5, actual: 'f'),
    ];

    final metrics = calculator.calculate(
      keystrokes: keystrokes,
      expectedSnippet: 'abcdef',
      totalDuration: const Duration(minutes: 1),
    );

    expect(metrics.maxStreak, 3);
  });

  test('keyHeatmap tallies usage/error counts per physical key', () {
    final keystrokes = [
      _keystroke(seq: 0, actual: 'a'),
      _keystroke(seq: 1, actual: 'a'),
      _keystroke(
        seq: 2,
        actual: 'x',
        expected: 'b',
        key: PhysicalKeyId.keyX,
        result: KeystrokeResult.substitution,
      ),
    ];

    final metrics = calculator.calculate(
      keystrokes: keystrokes,
      expectedSnippet: 'aab',
      totalDuration: const Duration(minutes: 1),
    );

    expect(metrics.keyHeatmap[PhysicalKeyId.keyA]!.usageCount, 2);
    expect(metrics.keyHeatmap[PhysicalKeyId.keyA]!.errorCount, 0);
    expect(metrics.keyHeatmap[PhysicalKeyId.keyX]!.usageCount, 1);
    expect(metrics.keyHeatmap[PhysicalKeyId.keyX]!.errorCount, 1);
  });

  test('zero keystrokes yields sensible, non-crashing defaults', () {
    final metrics = calculator.calculate(
      keystrokes: const [],
      expectedSnippet: '',
      totalDuration: Duration.zero,
    );

    expect(metrics.rawSpeedCpm, 0);
    expect(metrics.netSpeedCpm, 0);
    expect(metrics.accuracyPct, 0);
    expect(metrics.consistencyScore, 100);
    expect(metrics.maxStreak, 0);
    expect(metrics.fatigueFirstThirdCpm, 0);
    expect(metrics.fatigueMiddleThirdCpm, 0);
    expect(metrics.fatigueLastThirdCpm, 0);
    expect(metrics.handBalanceRatio, 1.0);
    expect(metrics.characterStats, isEmpty);
    expect(metrics.fingerStats, isEmpty);
    expect(metrics.ngramStats, isEmpty);
    expect(metrics.keyHeatmap, isEmpty);
  });

  test('a session with only correction rows (no forward keystrokes) is '
      'treated the same as an empty session', () {
    final metrics = calculator.calculate(
      keystrokes: [_keystroke(seq: 0, isCorrection: true, expected: 'a')],
      expectedSnippet: 'a',
      totalDuration: const Duration(seconds: 5),
    );

    expect(metrics.rawSpeedCpm, 0);
    expect(metrics.netSpeedCpm, 0);
    expect(metrics.accuracyPct, 0);
    expect(metrics.maxStreak, 0);
    expect(metrics.characterStats, isEmpty);
  });
}
