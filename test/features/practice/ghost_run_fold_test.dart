// Unit tests for `foldGhostSteps` — the pure inverse of a live session's
// commit stream: flights accumulate into offsets, only committed
// keystrokes advance the position, rejections consume time without
// moving it, and corrections step it back.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/practice/domain/entities/finger.dart';
import 'package:ridge/features/practice/domain/entities/keyboard_row.dart';
import 'package:ridge/features/practice/domain/entities/keystroke.dart';
import 'package:ridge/features/practice/domain/entities/keystroke_result.dart';
import 'package:ridge/features/practice/domain/services/ghost_run_fold.dart';
import 'package:ridge/features/practice/domain/value_objects/physical_key_id.dart';

Keystroke _keystroke({
  required int seq,
  String expectedChar = '',
  String actualChar = '',
  KeystrokeResult result = KeystrokeResult.correct,
  bool isCorrection = false,
  Duration? flight,
  Duration? dwell,
}) {
  return Keystroke(
    physicalKeyId: PhysicalKeyId.keyA,
    expectedChar: isCorrection ? null : expectedChar,
    actualChar: isCorrection ? null : actualChar,
    result: result,
    isCorrection: isCorrection,
    finger: Finger.leftPinky,
    keyboardRow: KeyboardRow.homeRow,
    dwell: dwell,
    flight: flight,
    sequenceIndex: seq,
  );
}

void main() {
  test('an empty session folds to no steps', () {
    expect(foldGhostSteps(const []), isEmpty);
  });

  test('correct keystrokes commit consecutive positions with cumulative '
      'offsets', () {
    final steps = foldGhostSteps([
      _keystroke(seq: 0, expectedChar: 'a', actualChar: 'a'),
      _keystroke(
        seq: 1,
        expectedChar: 'b',
        actualChar: 'b',
        flight: const Duration(milliseconds: 120),
      ),
      _keystroke(
        seq: 2,
        expectedChar: 'c',
        actualChar: 'c',
        flight: const Duration(milliseconds: 80),
      ),
    ]);

    expect(steps, [
      (position: 0, at: Duration.zero),
      (position: 1, at: const Duration(milliseconds: 120)),
      (position: 2, at: const Duration(milliseconds: 200)),
    ]);
  });

  test('a rejected substitution consumes time but commits no position', () {
    final steps = foldGhostSteps([
      _keystroke(seq: 0, expectedChar: 'a', actualChar: 'a'),
      _keystroke(
        seq: 1,
        expectedChar: 'b',
        actualChar: 'x',
        result: KeystrokeResult.substitution,
        flight: const Duration(milliseconds: 50),
      ),
      _keystroke(
        seq: 2,
        expectedChar: 'b',
        actualChar: 'b',
        flight: const Duration(milliseconds: 70),
      ),
    ]);

    expect(steps, [
      (position: 0, at: Duration.zero),
      (position: 1, at: const Duration(milliseconds: 120)),
    ]);
  });

  test('a correction steps the position back so the retype appears again', () {
    final steps = foldGhostSteps([
      _keystroke(seq: 0, expectedChar: 'a', actualChar: 'a'),
      _keystroke(
        seq: 1,
        expectedChar: 'b',
        actualChar: 'b',
        flight: const Duration(milliseconds: 40),
      ),
      _keystroke(
        seq: 2,
        isCorrection: true,
        flight: const Duration(milliseconds: 30),
      ),
      _keystroke(
        seq: 3,
        expectedChar: 'b',
        actualChar: 'b',
        flight: const Duration(milliseconds: 60),
      ),
    ]);

    expect(steps, [
      (position: 0, at: Duration.zero),
      (position: 1, at: const Duration(milliseconds: 40)),
      (position: 1, at: const Duration(milliseconds: 130)),
    ]);
  });

  test('a correction at position zero never underflows', () {
    final steps = foldGhostSteps([
      _keystroke(seq: 0, isCorrection: true),
      _keystroke(
        seq: 1,
        expectedChar: 'a',
        actualChar: 'a',
        flight: const Duration(milliseconds: 20),
      ),
    ]);

    expect(steps, [(position: 0, at: const Duration(milliseconds: 20))]);
  });
}
