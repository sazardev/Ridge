// The concrete de-risking check for the riskiest part of this whole
// project: proves a sequence of *real* physical key events (simulated
// via `tester.sendKeyDownEvent`/`sendKeyUpEvent`, plain flutter_test, no
// integration_test) actually advances the capture engine's buffer and
// produces classified keystrokes with plausible timing.
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/content/domain/entities/snippet_length.dart';
import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
import 'package:ridge/features/practice/domain/entities/keystroke_result.dart';
import 'package:ridge/features/practice/domain/entities/practice_mode.dart';
import 'package:ridge/features/practice/domain/entities/practice_session_status.dart';
import 'package:ridge/features/practice/domain/value_objects/physical_key_id.dart';
import 'package:ridge/features/practice/presentation/providers/practice_providers.dart';
import 'package:ridge/features/practice/presentation/providers/practice_session_controller.dart';
import 'package:ridge/features/practice/presentation/services/keystroke_sound_player.dart';
import 'package:ridge/features/practice/presentation/widgets/keystroke_capture_field.dart';
import 'package:ridge/features/settings/domain/entities/app_sound_pack.dart';

const _snippet = Snippet(
  id: SnippetId('test-snippet-001'),
  revision: 1,
  language: ProgrammingLanguage.go,
  difficulty: Difficulty.beginner,
  category: ContentCategory.variablesAndTypes,
  symbolFocus: {},
  length: SnippetLength.short,
  titleEn: 'Test snippet',
  titleEs: 'Snippet de prueba',
  code: 'abc',
  sourceAttribution: 'hand-authored for test',
  isActive: true,
  tldrEn: 'Test tl;dr.',
  tldrEs: 'Tl;dr de prueba.',
  explanationEn: 'Test explanation.',
  explanationEs: 'Explicación de prueba.',
);
const _mode = PracticeMode.zen();

/// Builds the container the capture field tests run in, with the keystroke
/// sound player overridden by its silent variant — the field reads it on
/// every key event, and these tests must never initialize native audio
/// (sound is not what's under test here).
ProviderContainer _createContainer() => ProviderContainer(
  overrides: [
    keystrokeSoundPlayerProvider.overrideWithValue(
      KeystrokeSoundPlayer.silent(AppSoundPack.mechanical),
    ),
  ],
);

/// Dispatches a raw key event through the exact same `KeyEventManager`
/// path `tester.sendKeyDownEvent` uses, but with a hand-built `KeyData`
/// — the test harness's own simulator lacks a keycode for the ISO
/// `intlBackslash` logical key on every platform map, so its key down/up
/// (and the shift that reaches `>`) have to be synthesized directly.
/// `synthesized: true` makes `KeyEventManager` dispatch the event
/// immediately instead of queueing it for a follow-up raw event.
void _dispatch({
  required PhysicalKeyboardKey physicalKey,
  required LogicalKeyboardKey logicalKey,
  ui.KeyEventType type = ui.KeyEventType.down,
  String? character,
  Duration timeStamp = Duration.zero,
}) {
  // The deprecated `keyEventManager`/`handleKeyData` are the same APIs
  // flutter_test's own `simulateKeyDownEvent` uses internally to convert
  // a `KeyData` into a dispatched `KeyEvent` — there is no replacement
  // path that also routes synthesized events through `FocusManager`, so
  // this mirrors the framework's own test harness.
  // ignore: deprecated_member_use
  ServicesBinding.instance.keyEventManager.handleKeyData(
    ui.KeyData(
      timeStamp: timeStamp,
      type: type,
      physical: physicalKey.usbHidUsage,
      logical: logicalKey.keyId,
      character: character,
      synthesized: true,
    ),
  );
}

/// A snippet whose code needs the ISO key Spanish keyboards print `<`/`>`
/// on — the regression case for the `intlBackslash` capture gap.
const _angleSnippet = Snippet(
  id: SnippetId('test-snippet-angles'),
  revision: 1,
  language: ProgrammingLanguage.go,
  difficulty: Difficulty.beginner,
  category: ContentCategory.variablesAndTypes,
  symbolFocus: {},
  length: SnippetLength.short,
  titleEn: 'Angle brackets',
  titleEs: 'Ángulos',
  code: '<>',
  sourceAttribution: 'hand-authored for test',
  isActive: true,
  tldrEn: 'Test tl;dr.',
  tldrEs: 'Tl;dr de prueba.',
  explanationEn: 'Test explanation.',
  explanationEs: 'Explicación de prueba.',
);

void main() {
  testWidgets(
    'real key down/up events advance the buffer and produce classified '
    'keystrokes with plausible dwell/flight timing',
    (tester) async {
      final container = _createContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: KeystrokeCaptureField(snippet: _snippet, mode: _mode),
            ),
          ),
        ),
      );
      await tester.pump();

      // Idle before anything is typed.
      var state = container.read(
        practiceSessionControllerProvider(_snippet, _mode),
      );
      expect(state.status, PracticeSessionStatus.idle);
      expect(state.recorder.expectedCharStatuses, [null, null, null]);

      // First real key event: 'a', correct (matches "abc"[0]).
      await tester.sendKeyDownEvent(LogicalKeyboardKey.keyA);
      await tester.pump(const Duration(milliseconds: 40));
      await tester.sendKeyUpEvent(LogicalKeyboardKey.keyA);
      await tester.pump();

      state = container.read(
        practiceSessionControllerProvider(_snippet, _mode),
      );
      expect(state.status, PracticeSessionStatus.running);
      expect(state.recorder.expectedCharStatuses, [true, null, null]);

      final first = state.recorder.keystrokes.single;
      expect(first.actualChar, 'a');
      expect(first.result, KeystrokeResult.correct);
      // Dwell is only known once the matching keyup arrives — by now it
      // should be patched in, and be a real, small, non-negative
      // duration (roughly the ~40ms the key was held).
      expect(first.dwell, isNotNull);
      expect(first.dwell!.inMilliseconds, greaterThanOrEqualTo(0));

      // Second real key event: a deliberate mistake ('x' where 'b' is
      // expected) — rejected under hard lock, the buffer does not
      // advance and nothing needs correcting.
      await tester.pump(const Duration(milliseconds: 60));
      await tester.sendKeyDownEvent(LogicalKeyboardKey.keyX);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.keyX);
      await tester.pump();

      state = container.read(
        practiceSessionControllerProvider(_snippet, _mode),
      );
      expect(state.recorder.expectedCharStatuses, [true, null, null]);
      expect(state.recorder.rejectedTick, 1);
      final second = state.recorder.keystrokes[1];
      expect(second.actualChar, 'x');
      expect(second.result, isNot(KeystrokeResult.correct));
      // Flight is the gap since the previous keydown, threaded through
      // from `KeyEvent.timeStamp`. flutter_test's synthetic key events
      // always stamp `Duration.zero` regardless of real elapsed time
      // (a test-harness limitation, not an app bug — verified against
      // `KeyEventSimulator` in the Flutter SDK), so this can only assert
      // the field is wired through and non-negative here; the actual
      // *math* over real non-zero durations is covered by
      // `keystroke_stream_recorder_test.dart`'s fabricated-timestamp
      // tests.
      expect(second.flight, isNotNull);
      expect(second.flight!.inMicroseconds, greaterThanOrEqualTo(0));

      // Retype the correct character directly — no backspace needed,
      // since the rejected 'x' was never committed.
      await tester.sendKeyDownEvent(LogicalKeyboardKey.keyB);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.keyB);
      await tester.pump();

      state = container.read(
        practiceSessionControllerProvider(_snippet, _mode),
      );
      expect(state.recorder.expectedCharStatuses, [true, true, null]);

      // Left arrow reviews the already-typed text without touching the
      // live cursor; Delete then truncates back to it. Buffer is "ab"
      // (expectedCursor 2) — one left arrow points the review cursor at
      // position 1 ('b').
      await tester.sendKeyDownEvent(LogicalKeyboardKey.arrowLeft);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pump();
      state = container.read(
        practiceSessionControllerProvider(_snippet, _mode),
      );
      expect(state.recorder.reviewCursor, 1);
      expect(state.recorder.expectedCursor, 2, reason: 'live cursor unmoved');

      await tester.sendKeyDownEvent(LogicalKeyboardKey.delete);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.delete);
      await tester.pump();
      state = container.read(
        practiceSessionControllerProvider(_snippet, _mode),
      );
      expect(state.recorder.reviewCursor, isNull);
      expect(state.recorder.expectedCursor, 1, reason: 'only "b" was undone');
      expect(
        state.recorder.keystrokes.where((k) => k.isCorrection),
        hasLength(1),
      );

      // Retype "bc" to finish the whole snippet ("a" is still committed).
      await tester.sendKeyDownEvent(LogicalKeyboardKey.keyB);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.keyB);
      await tester.pump();
      await tester.sendKeyDownEvent(LogicalKeyboardKey.keyC);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.keyC);
      await tester.pumpAndSettle();

      state = container.read(
        practiceSessionControllerProvider(_snippet, _mode),
      );
      expect(state.status, PracticeSessionStatus.result);
      expect(state.recorder.isComplete, isTrue);
    },
  );

  testWidgets('OS auto-repeat does not advance the buffer', (tester) async {
    final container = _createContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(
            body: KeystrokeCaptureField(snippet: _snippet, mode: _mode),
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.sendKeyDownEvent(LogicalKeyboardKey.keyA);
    await tester.sendKeyRepeatEvent(LogicalKeyboardKey.keyA);
    await tester.sendKeyRepeatEvent(LogicalKeyboardKey.keyA);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.keyA);
    await tester.pump();

    final state = container.read(
      practiceSessionControllerProvider(_snippet, _mode),
    );
    // Only one real keystroke should have been recorded, despite three
    // "a" key-down-shaped events reaching the engine.
    expect(state.recorder.keystrokes, hasLength(1));
  });

  testWidgets(
    'the ISO intlBackslash key types < > (the Spanish-layout path, where '
    'those characters live between Left Shift and Z, not on ,/. keys)',
    (tester) async {
      final container = _createContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: KeystrokeCaptureField(snippet: _angleSnippet, mode: _mode),
            ),
          ),
        ),
      );
      await tester.pump();

      // Unshifted: '<' — the ISO key, exactly where a Spanish keyboard
      // prints it. `character:` stands in for the layout-aware
      // `KeyEvent.character` Linux/GTK populates for this key, and the
      // explicit `physicalKey` bypasses the test harness's incomplete
      // Android physical-key map (which lacks the ISO key).
      // Unshifted: '<' — the ISO key, exactly where a Spanish keyboard
      // prints it. `character:` stands in for the layout-aware
      // `KeyEvent.character` Linux/GTK populates for this key.
      _dispatch(
        physicalKey: PhysicalKeyboardKey.intlBackslash,
        logicalKey: LogicalKeyboardKey.intlBackslash,
        character: '<',
      );
      _dispatch(
        physicalKey: PhysicalKeyboardKey.intlBackslash,
        logicalKey: LogicalKeyboardKey.intlBackslash,
        type: ui.KeyEventType.up,
        timeStamp: const Duration(milliseconds: 40),
      );
      await tester.pump();

      var state = container.read(
        practiceSessionControllerProvider(_angleSnippet, _mode),
      );
      expect(state.recorder.expectedCharStatuses, [true, null]);
      expect(state.recorder.keystrokes.single.actualChar, '<');
      expect(
        state.recorder.keystrokes.single.physicalKeyId,
        PhysicalKeyId.intlBackslash,
        reason:
            'metrics must record the real ISO physical position, '
            'not a US-QWERTY stand-in',
      );

      // Shifted: '>'.
      _dispatch(
        physicalKey: PhysicalKeyboardKey.shiftLeft,
        logicalKey: LogicalKeyboardKey.shiftLeft,
      );
      _dispatch(
        physicalKey: PhysicalKeyboardKey.intlBackslash,
        logicalKey: LogicalKeyboardKey.intlBackslash,
        character: '>',
        timeStamp: const Duration(milliseconds: 40),
      );
      _dispatch(
        physicalKey: PhysicalKeyboardKey.intlBackslash,
        logicalKey: LogicalKeyboardKey.intlBackslash,
        type: ui.KeyEventType.up,
        timeStamp: const Duration(milliseconds: 80),
      );
      _dispatch(
        physicalKey: PhysicalKeyboardKey.shiftLeft,
        logicalKey: LogicalKeyboardKey.shiftLeft,
        type: ui.KeyEventType.up,
        timeStamp: const Duration(milliseconds: 80),
      );
      await tester.pumpAndSettle();

      state = container.read(
        practiceSessionControllerProvider(_angleSnippet, _mode),
      );
      expect(state.recorder.expectedCharStatuses, [true, true]);
      expect(state.status, PracticeSessionStatus.result);
      expect(state.recorder.isComplete, isTrue);
    },
  );
}
