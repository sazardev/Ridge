// Unit tests for `KeystrokeStreamRecorder` — the riskiest piece of pure
// domain logic in this build phase. Covers the hard-lock capture model
// (a wrong character is rejected and logged, never committed), corrections
// (backspace, and Delete-to-truncate via review-cursor navigation), and
// the live green/red classification of a clean run.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/practice/domain/entities/keystroke_result.dart';
import 'package:ridge/features/practice/domain/services/keystroke_stream_recorder.dart';
import 'package:ridge/features/practice/domain/value_objects/physical_key_id.dart';

void main() {
  group('clean run (live feedback, hard lock)', () {
    test('every correct character is classified immediately and commits', () {
      final recorder = KeystrokeStreamRecorder(expectedSnippet: 'abc');

      final k1 = recorder.ingestChar(
        physicalKeyId: PhysicalKeyId.keyA,
        char: 'a',
      );
      expect(k1!.result, KeystrokeResult.correct);
      expect(recorder.expectedCharStatuses, [true, null, null]);
      expect(recorder.expectedCursor, 1);

      recorder.ingestChar(physicalKeyId: PhysicalKeyId.keyB, char: 'b');
      expect(recorder.expectedCharStatuses, [true, true, null]);

      final k3 = recorder.ingestChar(
        physicalKeyId: PhysicalKeyId.keyC,
        char: 'c',
      );
      expect(k3!.result, KeystrokeResult.correct);
      expect(recorder.isComplete, isTrue);
      expect(recorder.keystrokes, hasLength(3));
      expect(recorder.keystrokes.map((k) => k.sequenceIndex), [0, 1, 2]);
      expect(recorder.rejectedTick, 0);
    });

    test(
      'a wrong character is rejected — logged as substitution, buffer does '
      'not advance, and the position stays not-yet-typed until corrected',
      () {
        final recorder = KeystrokeStreamRecorder(expectedSnippet: 'abc')
          ..ingestChar(physicalKeyId: PhysicalKeyId.keyA, char: 'a');
        final wrong = recorder.ingestChar(
          physicalKeyId: PhysicalKeyId.keyX,
          char: 'x',
        );

        expect(wrong!.result, KeystrokeResult.substitution);
        expect(wrong.expectedChar, 'b');
        expect(wrong.actualChar, 'x');
        expect(
          recorder.expectedCursor,
          1,
          reason: 'rejected — did not advance',
        );
        expect(recorder.expectedCharStatuses, [true, null, null]);
        expect(recorder.rejectedTick, 1);
        expect(recorder.isComplete, isFalse);
      },
    );

    test('several wrong attempts at the same position are all logged, and '
        'only the eventual correct one commits and advances the cursor', () {
      final recorder = KeystrokeStreamRecorder(expectedSnippet: 'ab')
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyX, char: 'x')
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyY, char: 'y');
      expect(recorder.rejectedTick, 2);
      expect(recorder.expectedCursor, 0);

      final finallyCorrect = recorder.ingestChar(
        physicalKeyId: PhysicalKeyId.keyA,
        char: 'a',
      );
      expect(finallyCorrect!.result, KeystrokeResult.correct);
      expect(recorder.expectedCursor, 1);

      final keystrokes = recorder.finish();
      expect(keystrokes.map((k) => k.result), [
        KeystrokeResult.substitution,
        KeystrokeResult.substitution,
        KeystrokeResult.correct,
      ]);
      expect(keystrokes.map((k) => k.sequenceIndex), [0, 1, 2]);
    });

    test('typing past the end of the snippet is a no-op', () {
      final recorder = KeystrokeStreamRecorder(expectedSnippet: 'a')
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyA, char: 'a');
      expect(recorder.isComplete, isTrue);

      final result = recorder.ingestChar(
        physicalKeyId: PhysicalKeyId.keyB,
        char: 'b',
      );
      expect(result, isNull);
      expect(recorder.keystrokes, hasLength(1));
    });
  });

  group('corrections (backspace)', () {
    test('undoing an already-committed correct character', () {
      final recorder = KeystrokeStreamRecorder(expectedSnippet: 'ab')
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyA, char: 'a');
      final correction = recorder.ingestBackspace(
        physicalKeyId: PhysicalKeyId.backspace,
      );

      expect(correction, isNotNull);
      expect(correction!.isCorrection, isTrue);
      expect(correction.result, KeystrokeResult.correct);
      expect(correction.actualChar, isNull);
      expect(correction.expectedChar, 'a');
      expect(recorder.expectedCursor, 0);
      expect(recorder.expectedCharStatuses, [null, null]);

      // Cursor rolled back: retyping 'a' correctly should work again.
      final retyped = recorder.ingestChar(
        physicalKeyId: PhysicalKeyId.keyA,
        char: 'a',
      );
      expect(retyped!.result, KeystrokeResult.correct);
    });

    test('backspacing an empty buffer is a no-op', () {
      final recorder = KeystrokeStreamRecorder(expectedSnippet: 'ab');
      final correction = recorder.ingestBackspace(
        physicalKeyId: PhysicalKeyId.backspace,
      );
      expect(correction, isNull);
      expect(recorder.keystrokes, isEmpty);
    });

    test('every keystroke, including a rejected attempt and a correction, '
        'keeps a monotonic sequenceIndex and is never removed from the '
        'log', () {
      final recorder = KeystrokeStreamRecorder(expectedSnippet: 'ab')
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyA, char: 'a')
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyX, char: 'x')
        ..ingestBackspace(physicalKeyId: PhysicalKeyId.backspace)
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyA, char: 'a')
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyB, char: 'b');

      final keystrokes = recorder.finish();
      expect(keystrokes, hasLength(5));
      expect(keystrokes.map((k) => k.sequenceIndex), [0, 1, 2, 3, 4]);
      expect(keystrokes.where((k) => k.isCorrection), hasLength(1));
      expect(recorder.isComplete, isTrue);
    });
  });

  group('review-cursor navigation and Delete-to-truncate', () {
    test('arrows move the review cursor within already-typed text without '
        'affecting the live typing position', () {
      final recorder = KeystrokeStreamRecorder(expectedSnippet: 'abcd')
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyA, char: 'a')
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyB, char: 'b')
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyC, char: 'c');
      expect(recorder.reviewCursor, isNull);

      recorder.moveReviewCursorLeft();
      expect(recorder.reviewCursor, 2);
      recorder.moveReviewCursorLeft();
      expect(recorder.reviewCursor, 1);

      // Live typing position is untouched by navigation.
      expect(recorder.expectedCursor, 3);

      recorder.moveReviewCursorRight();
      expect(recorder.reviewCursor, 2);
      recorder.moveReviewCursorRight();
      expect(recorder.reviewCursor, isNull, reason: 'back at the live end');
    });

    test('moving left is clamped at the start, moving right is a no-op '
        'once already at the live end', () {
      final recorder = KeystrokeStreamRecorder(expectedSnippet: 'ab')
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyA, char: 'a')
        ..moveReviewCursorRight(); // already at live end
      expect(recorder.reviewCursor, isNull);

      recorder.moveReviewCursorLeft();
      expect(recorder.reviewCursor, 0);
      recorder.moveReviewCursorLeft();
      expect(recorder.reviewCursor, 0, reason: 'clamped at the start');
    });

    test('arrows are a no-op on an empty buffer', () {
      final recorder = KeystrokeStreamRecorder(expectedSnippet: 'ab')
        ..moveReviewCursorLeft();
      expect(recorder.reviewCursor, isNull);
    });

    test('typing after navigating resets the review cursor back to the '
        'live end (typing always commits at the end, never mid-buffer)', () {
      final recorder = KeystrokeStreamRecorder(expectedSnippet: 'abc')
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyA, char: 'a')
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyB, char: 'b')
        ..moveReviewCursorLeft();
      expect(recorder.reviewCursor, 1);

      recorder.ingestChar(physicalKeyId: PhysicalKeyId.keyC, char: 'c');
      expect(recorder.reviewCursor, isNull);
      expect(recorder.expectedCursor, 3);
    });

    test('Delete truncates the buffer back to the review cursor, as a '
        'batch of individual correction events', () {
      final recorder = KeystrokeStreamRecorder(expectedSnippet: 'abcd')
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyA, char: 'a')
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyB, char: 'b')
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyC, char: 'c')
        ..moveReviewCursorLeft()
        ..moveReviewCursorLeft();
      expect(recorder.reviewCursor, 1);

      final removed = recorder.ingestDelete(
        physicalKeyId: PhysicalKeyId.delete,
      );
      expect(removed, hasLength(2), reason: 'truncates positions 1 and 2');
      expect(removed.every((k) => k.isCorrection), isTrue);
      expect(recorder.expectedCursor, 1);
      expect(recorder.reviewCursor, isNull);
      expect(recorder.expectedCharStatuses, [true, null, null, null]);

      // Retyping from position 1 works normally.
      final retyped = recorder.ingestChar(
        physicalKeyId: PhysicalKeyId.keyB,
        char: 'b',
      );
      expect(retyped!.result, KeystrokeResult.correct);
    });

    test('Delete is a no-op at the live end — nothing ahead of it to '
        'remove', () {
      final recorder = KeystrokeStreamRecorder(expectedSnippet: 'ab')
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyA, char: 'a');

      final removed = recorder.ingestDelete(
        physicalKeyId: PhysicalKeyId.delete,
      );
      expect(removed, isEmpty);
      expect(recorder.expectedCursor, 1);
    });
  });

  group('patchDwell', () {
    test('retroactively attaches dwell to the keystroke at sequenceIndex', () {
      final recorder = KeystrokeStreamRecorder(expectedSnippet: 'a');
      final keystroke = recorder.ingestChar(
        physicalKeyId: PhysicalKeyId.keyA,
        char: 'a',
      );
      expect(keystroke!.dwell, isNull);

      recorder.patchDwell(
        sequenceIndex: keystroke.sequenceIndex,
        dwell: const Duration(milliseconds: 80),
      );

      expect(
        recorder.keystrokes.single.dwell,
        const Duration(milliseconds: 80),
      );
    });

    test('patching an out-of-range sequenceIndex is a safe no-op', () {
      final recorder = KeystrokeStreamRecorder(
        expectedSnippet: 'a',
      )..patchDwell(sequenceIndex: 99, dwell: const Duration(milliseconds: 80));
      expect(recorder.keystrokes, isEmpty);
    });
  });

  group('retarget (Sprint mid-session snippet swap)', () {
    test('a finished old snippet followed by a fresh new one keeps one '
        'contiguous, monotonically-sequenced keystroke log', () {
      final recorder = KeystrokeStreamRecorder(expectedSnippet: 'ab')
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyA, char: 'a')
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyB, char: 'b');
      expect(recorder.isComplete, isTrue);

      recorder.retarget('cd');
      expect(recorder.isComplete, isFalse);
      expect(recorder.expectedCursor, 0);
      expect(recorder.reviewCursor, isNull);

      recorder
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyC, char: 'c')
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyD, char: 'd');
      expect(recorder.isComplete, isTrue);

      final keystrokes = recorder.finish();
      expect(keystrokes, hasLength(4));
      expect(keystrokes.map((k) => k.sequenceIndex), [0, 1, 2, 3]);
      expect(keystrokes.map((k) => k.actualChar), ['a', 'b', 'c', 'd']);
      expect(
        keystrokes.every((k) => k.result == KeystrokeResult.correct),
        isTrue,
      );
    });

    test('a rejected attempt against the old snippet stays in the log '
        'untouched after retargeting', () {
      final recorder = KeystrokeStreamRecorder(expectedSnippet: 'a')
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyX, char: 'x')
        ..retarget('b')
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyB, char: 'b');

      final keystrokes = recorder.finish();
      expect(keystrokes, hasLength(2));
      expect(keystrokes[0].result, KeystrokeResult.substitution);
      expect(keystrokes[0].actualChar, 'x');
      expect(keystrokes[1].result, KeystrokeResult.correct);
    });
  });

  group(
    'ingestTabKey (gofmt alignment-space / nested-indentation comfort)',
    () {
      test('a single leading-indentation tab still just satisfies one '
          'position, exactly like ingestChar would', () {
        final recorder = KeystrokeStreamRecorder(expectedSnippet: '\tx');
        final committed = recorder.ingestTabKey(
          physicalKeyId: PhysicalKeyId.tab,
        );

        expect(committed, hasLength(1));
        expect(committed.single.result, KeystrokeResult.correct);
        expect(committed.single.actualChar, '\t');
        expect(recorder.expectedCursor, 1);
      });

      test('one Tab press consumes an entire run of consecutive expected '
          'leading-indentation tabs, landing straight on a deeply nested '
          "line's real code in one press", () {
        // Mirrors a chain of nested `if`s three levels deep.
        final recorder = KeystrokeStreamRecorder(expectedSnippet: '\t\t\tx');
        final committed = recorder.ingestTabKey(
          physicalKeyId: PhysicalKeyId.tab,
        );

        expect(committed, hasLength(3));
        expect(
          committed.every((k) => k.result == KeystrokeResult.correct),
          isTrue,
        );
        expect(committed.every((k) => k.actualChar == '\t'), isTrue);
        expect(recorder.expectedCursor, 3);
        expect(recorder.expectedCharStatuses, [true, true, true, null]);
      });

      test('a run of leading tabs stops consuming at the first non-tab '
          'character, without spilling into the real code that follows', () {
        final recorder = KeystrokeStreamRecorder(expectedSnippet: '\t\tif x {');
        final committed = recorder.ingestTabKey(
          physicalKeyId: PhysicalKeyId.tab,
        );

        expect(committed, hasLength(2));
        expect(recorder.expectedCursor, 2);
      });

      test('one Tab press consumes an entire run of consecutive expected '
          'alignment spaces, each as its own committed keystroke', () {
        // Mirrors `Msg   string` gofmt-aligned next to `Field string`.
        final recorder = KeystrokeStreamRecorder(expectedSnippet: '   x');
        final committed = recorder.ingestTabKey(
          physicalKeyId: PhysicalKeyId.tab,
        );

        expect(committed, hasLength(3));
        expect(
          committed.every((k) => k.result == KeystrokeResult.correct),
          isTrue,
        );
        expect(committed.every((k) => k.actualChar == ' '), isTrue);
        expect(recorder.expectedCursor, 3);
        expect(recorder.expectedCharStatuses, [true, true, true, null]);
      });

      test('only the first keystroke in a consumed space-run carries the real '
          'dwell/flight; the rest are synthetic follow-ons', () {
        final recorder = KeystrokeStreamRecorder(expectedSnippet: '  x');
        final committed = recorder.ingestTabKey(
          physicalKeyId: PhysicalKeyId.tab,
          dwell: const Duration(milliseconds: 40),
          flight: const Duration(milliseconds: 120),
        );

        expect(committed[0].dwell, const Duration(milliseconds: 40));
        expect(committed[0].flight, const Duration(milliseconds: 120));
        expect(committed[1].dwell, isNull);
        expect(committed[1].flight, isNull);
      });

      test('a Tab pressed where neither a space nor a tab is expected is '
          'rejected as a substitution, exactly like any other wrong key', () {
        final recorder = KeystrokeStreamRecorder(expectedSnippet: 'x');
        final committed = recorder.ingestTabKey(
          physicalKeyId: PhysicalKeyId.tab,
        );

        expect(committed, hasLength(1));
        expect(committed.single.result, KeystrokeResult.substitution);
        expect(recorder.expectedCursor, 0);
        expect(recorder.rejectedTick, 1);
      });

      test('stops consuming spaces at the end of the snippet, without '
          'overrunning', () {
        final recorder = KeystrokeStreamRecorder(expectedSnippet: '  ');
        final committed = recorder.ingestTabKey(
          physicalKeyId: PhysicalKeyId.tab,
        );

        expect(committed, hasLength(2));
        expect(recorder.isComplete, isTrue);
      });
    },
  );

  group('ingestEnterKey (blank-line skip / auto-indent comfort)', () {
    test('a plain newline into a real code line just satisfies one '
        'position, exactly like ingestChar would', () {
      final recorder = KeystrokeStreamRecorder(expectedSnippet: 'a\nb')
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyA, char: 'a');
      final committed = recorder.ingestEnterKey(
        physicalKeyId: PhysicalKeyId.enter,
      );

      expect(committed, hasLength(1));
      expect(committed.single.result, KeystrokeResult.correct);
      expect(committed.single.actualChar, '\n');
      expect(recorder.expectedCursor, 2);
    });

    test('one Enter press skips a run of several empty blank lines, '
        'landing straight on the next real code line', () {
      final recorder = KeystrokeStreamRecorder(expectedSnippet: 'foo\n\n\nbar')
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyF, char: 'f')
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyO, char: 'o')
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyO, char: 'o');

      final committed = recorder.ingestEnterKey(
        physicalKeyId: PhysicalKeyId.enter,
      );

      expect(committed, hasLength(3), reason: 'the 3 skipped newlines');
      expect(
        committed.every(
          (k) => k.result == KeystrokeResult.correct && k.actualChar == '\n',
        ),
        isTrue,
      );
      expect(recorder.expectedCursor, 6, reason: 'right at "bar"');
    });

    test('one Enter press also skips a blank line that has leftover '
        'indentation whitespace before its newline', () {
      final recorder = KeystrokeStreamRecorder(expectedSnippet: 'a\n    \nb')
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyA, char: 'a');

      final committed = recorder.ingestEnterKey(
        physicalKeyId: PhysicalKeyId.enter,
      );

      expect(committed, hasLength(6), reason: '2 newlines + 4 spaces');
      expect(recorder.expectedCursor, 7, reason: 'right at "b"');
      expect(recorder.expectedCharStatuses, [
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        null,
      ]);
    });

    test("one Enter press also auto-indents past a real code line's "
        'leading tab run, landing straight on its first real character', () {
      final recorder = KeystrokeStreamRecorder(expectedSnippet: 'a\n\tb')
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyA, char: 'a');

      final committed = recorder.ingestEnterKey(
        physicalKeyId: PhysicalKeyId.enter,
      );

      expect(committed, hasLength(2), reason: r'the "\n" plus the "\t"');
      expect(recorder.expectedCursor, 3, reason: 'right at "b"');
    });

    test('one Enter press auto-indents past several levels of nested '
        'leading tabs in one go', () {
      final recorder = KeystrokeStreamRecorder(expectedSnippet: 'a\n\t\t\tb')
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyA, char: 'a');

      final committed = recorder.ingestEnterKey(
        physicalKeyId: PhysicalKeyId.enter,
      );

      expect(committed, hasLength(4), reason: r'the "\n" plus 3 tabs');
      expect(recorder.expectedCursor, 5, reason: 'right at "b"');
    });

    test("one Enter press also auto-indents past a real code line's "
        'leading space run, landing straight on its first real character '
        '(every non-Go catalog indents with spaces, not tabs)', () {
      final recorder = KeystrokeStreamRecorder(expectedSnippet: 'a\n    b')
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyA, char: 'a');

      final committed = recorder.ingestEnterKey(
        physicalKeyId: PhysicalKeyId.enter,
      );

      expect(committed, hasLength(5), reason: r'the "\n" plus 4 spaces');
      expect(recorder.expectedCursor, 6, reason: 'right at "b"');
    });

    test('only the first keystroke in a skipped run carries real dwell/flight; '
        'the rest are synthetic follow-ons', () {
      final recorder = KeystrokeStreamRecorder(expectedSnippet: 'a\n\nb')
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyA, char: 'a');

      final committed = recorder.ingestEnterKey(
        physicalKeyId: PhysicalKeyId.enter,
        dwell: const Duration(milliseconds: 40),
        flight: const Duration(milliseconds: 120),
      );

      expect(committed[0].dwell, const Duration(milliseconds: 40));
      expect(committed[0].flight, const Duration(milliseconds: 120));
      expect(committed[1].dwell, isNull);
      expect(committed[1].flight, isNull);
    });

    test('an Enter pressed where no newline is expected is rejected as a '
        'substitution, exactly like any other wrong key', () {
      final recorder = KeystrokeStreamRecorder(expectedSnippet: 'ab');
      final committed = recorder.ingestEnterKey(
        physicalKeyId: PhysicalKeyId.enter,
      );

      expect(committed, hasLength(1));
      expect(committed.single.result, KeystrokeResult.substitution);
      expect(recorder.expectedCursor, 0);
      expect(recorder.rejectedTick, 1);
    });

    test('stops at the end of the snippet without overrunning when the '
        'snippet ends in blank lines', () {
      final recorder = KeystrokeStreamRecorder(expectedSnippet: 'a\n\n')
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyA, char: 'a');

      final committed = recorder.ingestEnterKey(
        physicalKeyId: PhysicalKeyId.enter,
      );

      expect(committed, hasLength(2));
      expect(recorder.isComplete, isTrue);
    });
  });

  group('finish / forceFinishAtDeadline', () {
    test('both simply return the full log — hard lock leaves nothing '
        'ambiguous or in-flight to resolve', () {
      final recorder = KeystrokeStreamRecorder(expectedSnippet: 'ab')
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyA, char: 'a')
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyX, char: 'x');

      expect(recorder.finish(), hasLength(2));
      expect(recorder.forceFinishAtDeadline(), hasLength(2));
    });
  });
}
