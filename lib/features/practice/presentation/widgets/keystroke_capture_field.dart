import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ridge/core/theme/app_motion.dart';
import 'package:ridge/core/theme/app_typography.dart';
import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/content/domain/services/syntax_tokenizer.dart';
import 'package:ridge/features/content/presentation/syntax_colors.dart';
import 'package:ridge/features/practice/domain/entities/keystroke_result.dart';
import 'package:ridge/features/practice/domain/entities/practice_mode.dart';
import 'package:ridge/features/practice/domain/entities/practice_session_status.dart';
import 'package:ridge/features/practice/domain/value_objects/physical_key_id.dart';
import 'package:ridge/features/practice/presentation/physical_key_id_mapper.dart';
import 'package:ridge/features/practice/presentation/providers/live_keyboard_providers.dart';
import 'package:ridge/features/practice/presentation/providers/practice_providers.dart';
import 'package:ridge/features/practice/presentation/providers/practice_session_controller.dart';
import 'package:ridge/features/practice/presentation/services/ghost_cursor_controller.dart';
import 'package:ridge/features/practice/presentation/widgets/keystroke_capture_autoscroll.dart';
import 'package:ridge/features/practice/presentation/widgets/keystroke_code_card.dart';
import 'package:ridge/features/practice/presentation/widgets/keystroke_span_builder.dart';
import 'package:ridge/features/practice/presentation/widgets/reject_shake.dart';
import 'package:ridge/features/profile/presentation/providers/profile_providers.dart';

/// The capture engine itself: renders [snippet]'s code with live
/// per-character green/red feedback and turns real physical keyboard
/// events into classified keystrokes via `PracticeSessionController`.
///
/// Hard-locked (see `KeystrokeStreamRecorder`'s doc): a wrong character
/// briefly shakes the field and is rejected rather than committed, and
/// the user must retype the correct one before anything else advances.
/// Left/Right arrows move a read-only review cursor within already-typed
/// text; Delete truncates back to it (a bulk "redo from here").
/// Backspace still undoes one character at a time from the live end.
///
/// Deliberately **not** a `TextField` (STACK.md §2.8) — a plain [Focus]
/// widget wraps a manually painted [RichText], so there's no IME/
/// autocorrect/autocomplete interference with raw keystroke capture.
class KeystrokeCaptureField extends ConsumerStatefulWidget {
  /// Creates the capture field for [snippet] under [mode].
  const new({required this.snippet, required this.mode, super.key});

  /// The snippet being typed.
  final Snippet snippet;

  /// Which practice mode is driving this session.
  final PracticeMode mode;

  @override
  ConsumerState<KeystrokeCaptureField> createState() =>
      _KeystrokeCaptureFieldState();
}

class _KeystrokeCaptureFieldState extends ConsumerState<KeystrokeCaptureField>
    with TickerProviderStateMixin {
  late final FocusNode _focusNode;

  /// Drives the reject-shake manually (never via a `flutter_animate`
  /// widget-key change) — replaying an animation by changing a widget's
  /// key tears down and remounts its whole subtree, which previously
  /// reset `_scrollController` back to the top on every single wrong
  /// keystroke (then immediately jumped back down as the next
  /// auto-scroll ran), a jarring, nausea-inducing double-jump. Driving
  /// the same controller repeatedly keeps the scrollable subtree —
  /// and its scroll position — mounted throughout.
  late final AnimationController _shakeController;

  /// The `rejectedTick` the shake last played for, so a rebuild for an
  /// unrelated reason (e.g. a correct keystroke) never replays it.
  int _lastRejectedTick = 0;

  /// Backs the field's own internal scroll — a snippet long enough to
  /// exceed the `Flexible` share `PracticeSessionScreen` gives this
  /// widget scrolls in here instead of overflowing the column (SPEC.md's
  /// longer DDD/hexagonal-architecture content routinely exceeds what
  /// the earlier, syntax-fundamentals-only catalog ever needed).
  final _scrollController = ScrollController();

  /// The cursor index the last auto-scroll ran for — re-running it every
  /// build (not just when this changes) would fight a user manually
  /// scrolling to re-read earlier code while stopped, but a genuinely new
  /// cursor position (the user typed or corrected something) should
  /// always keep typing comfortably in view.
  int? _lastAutoScrolledCursor;

  /// The snippet id the field's scroll position was last settled for —
  /// a Sprint mid-session advance (SPEC.md §5.2) swaps `state.snippet`
  /// without recreating this widget (the provider key is the *original*
  /// snippet/mode pair), so a plain "did the widget change" check
  /// wouldn't catch it; this is checked by value every build instead.
  String? _lastSnippetId;

  /// Keydown timestamp per currently-held physical key, for dwell.
  final Map<PhysicalKeyboardKey, Duration> _keyDownAt = {};

  /// The `sequenceIndex` of the keystroke a given physical key's keydown
  /// produced, so the matching keyup can retroactively attach dwell.
  final Map<PhysicalKeyboardKey, int> _sequenceIndexForKeyDown = {};

  /// The most recent keydown's timestamp, for flight (inter-onset
  /// interval) — deliberately excludes bare Shift/arrow presses, which
  /// aren't classified keystrokes of their own.
  Duration? _lastKeyDownAt;

  /// The live-keyboard notifier, grabbed once here so `dispose` can
  /// clear it without an unsafe `ref` use while unmounting.
  late final ValueNotifier<Set<String>> _pressedKeys;

  /// Drives the ghost-race cursor (see `GhostCursorController`) — its
  /// clock starts with the session's first classified keystroke, so the
  /// race is relative to typing time, not to idle screen time.
  late final GhostCursorController _ghostCursor;

  @override
  void initState() {
    super.initState();
    _pressedKeys = ref.read(pressedSessionKeysProvider);
    _ghostCursor = GhostCursorController(
      vsync: this,
      onAdvance: () {
        if (mounted) setState(() {});
      },
    );
    _focusNode = FocusNode(debugLabel: 'KeystrokeCaptureField')
      ..addListener(_onFocusChange);
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
  }

  @override
  void dispose() {
    // A key still held when the session screen goes away must not stay
    // lit on the shared live-keyboard notifier.
    _pressedKeys.value = const {};
    _ghostCursor.dispose();
    _focusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    _scrollController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  /// Mirrors a real key's down/up state into the live-keyboard notifier —
  /// the strip's input. Position-based on purpose: a functional remap
  /// changes what a key types, never which cap is under the finger.
  void _setPressedKey(PhysicalKeyId id, {required bool pressed}) {
    final next = {..._pressedKeys.value};
    final changed = pressed ? next.add(id.name) : next.remove(id.name);
    if (changed) _pressedKeys.value = next;
  }

  /// Scrolls just enough to keep [cursorIndex] comfortably in view (a
  /// couple of lines of margin above/below), never more than needed —
  /// unlike centering on every keystroke, this only moves the viewport
  /// when typing has actually reached its edge, which reads as "the code
  /// follows me" rather than a constant jitter.
  void _ensureCursorVisible(
    int cursorIndex,
    TextSpan textSpan,
    double innerWidth,
  ) {
    if (!_scrollController.hasClients) return;
    if (cursorIndex == _lastAutoScrolledCursor) return;
    _lastAutoScrolledCursor = cursorIndex;

    final target = cursorScrollTarget(
      textSpan: textSpan,
      cursorIndex: cursorIndex,
      innerWidth: innerWidth,
      position: _scrollController.position,
    );
    if (target == null) return;

    _scrollController.animateTo(
      target,
      duration: AppMotion.spatialFast,
      curve: AppMotion.spatial,
    );
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) return;
    final status = ref
        .read(practiceSessionControllerProvider(widget.snippet, widget.mode))
        .status;
    if (status != PracticeSessionStatus.running) return;
    // Re-request focus once the frame settles, so the running session
    // never silently stops capturing keystrokes.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    final status = ref
        .read(practiceSessionControllerProvider(widget.snippet, widget.mode))
        .status;
    final notifier = ref.read(
      practiceSessionControllerProvider(widget.snippet, widget.mode).notifier,
    );

    // Keyups are still owed to already-classified keystrokes after the
    // session leaves `running`: a session finishes on the completing
    // key's *keydown*, so that key's own keyup — and the keyup of any key
    // still held at that instant — only arrives while the status is
    // `finished`. Let those patch their dwell, and once nothing is held
    // anymore, tell the controller no more dwell patches are coming so it
    // can persist without waiting out its settle timeout.
    if (event is KeyUpEvent) {
      final releasedKeyId = physicalKeyIdFor(event.physicalKey);
      if (releasedKeyId != null) {
        _setPressedKey(releasedKeyId, pressed: false);
      }
      if (status != PracticeSessionStatus.running &&
          status != PracticeSessionStatus.finished) {
        return KeyEventResult.ignored;
      }
      final keyDownAt = _keyDownAt.remove(event.physicalKey);
      final sequenceIndex = _sequenceIndexForKeyDown.remove(event.physicalKey);
      if (keyDownAt != null && sequenceIndex != null) {
        notifier.patchDwell(
          sequenceIndex: sequenceIndex,
          dwell: event.timeStamp - keyDownAt,
        );
      }
      if (status == PracticeSessionStatus.finished && _keyDownAt.isEmpty) {
        notifier.concludePendingDwell();
      }
      return KeyEventResult.handled;
    }

    // Once a session is finished/showing its result, there's nothing
    // left to capture — ignore every key so it bubbles up to the result
    // screen's own keyboard shortcuts (Enter/R/Escape) instead of being
    // silently swallowed here.
    if (status != PracticeSessionStatus.idle &&
        status != PracticeSessionStatus.running) {
      return KeyEventResult.ignored;
    }

    // OS auto-repeat from a held key isn't a deliberate keystroke — it
    // would pollute dwell/flight stats and double-advance the buffer.
    if (event is KeyRepeatEvent) return KeyEventResult.handled;

    final physicalKeyId = physicalKeyIdFor(event.physicalKey);
    if (physicalKeyId == null) return KeyEventResult.ignored;

    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    _setPressedKey(physicalKeyId, pressed: true);

    // Shift is a modifier: it never produces its own classified
    // keystroke, and (being usually held slightly before the key it
    // modifies) shouldn't count as "the previous keydown" for flight.
    if (physicalKeyId == PhysicalKeyId.shiftLeft ||
        physicalKeyId == PhysicalKeyId.shiftRight) {
      return KeyEventResult.handled;
    }

    // Arrow-key review navigation never produces a classified keystroke
    // (it doesn't touch the typed buffer), so it's excluded from flight
    // bookkeeping too — same treatment as Shift.
    if (physicalKeyId == PhysicalKeyId.arrowLeft) {
      notifier.moveReviewCursorLeft();
      return KeyEventResult.handled;
    }
    if (physicalKeyId == PhysicalKeyId.arrowRight) {
      notifier.moveReviewCursorRight();
      return KeyEventResult.handled;
    }

    // From here on this is a classified keystroke — the same moment the
    // session's own clock starts, so the ghost race starts with it.
    _ghostCursor.start();

    final now = event.timeStamp;
    final flight = _lastKeyDownAt == null ? null : now - _lastKeyDownAt!;
    _lastKeyDownAt = now;
    _keyDownAt[event.physicalKey] = now;

    final soundPlayer = ref.read(keystrokeSoundPlayerProvider);

    if (physicalKeyId == PhysicalKeyId.backspace) {
      final correction = notifier.ingestBackspace(
        physicalKeyId: physicalKeyId,
        flight: flight,
      );
      if (correction != null) {
        _sequenceIndexForKeyDown[event.physicalKey] = correction.sequenceIndex;
        unawaited(soundPlayer.playClick());
      }
      return KeyEventResult.handled;
    }

    if (physicalKeyId == PhysicalKeyId.delete) {
      final removed = notifier.ingestDelete(
        physicalKeyId: physicalKeyId,
        flight: flight,
      );
      if (removed.isNotEmpty) {
        _sequenceIndexForKeyDown[event.physicalKey] =
            removed.first.sequenceIndex;
        unawaited(soundPlayer.playClick());
      }
      return KeyEventResult.handled;
    }

    if (physicalKeyId == PhysicalKeyId.tab) {
      final keystrokes = notifier.ingestTabKey(
        physicalKeyId: physicalKeyId,
        flight: flight,
      );
      if (keystrokes.isNotEmpty) {
        _sequenceIndexForKeyDown[event.physicalKey] =
            keystrokes.first.sequenceIndex;
        unawaited(
          keystrokes.first.result == KeystrokeResult.correct
              ? soundPlayer.playClick()
              : soundPlayer.playReject(),
        );
      }
      return KeyEventResult.handled;
    }

    if (physicalKeyId == PhysicalKeyId.enter) {
      final keystrokes = notifier.ingestEnterKey(
        physicalKeyId: physicalKeyId,
        flight: flight,
      );
      if (keystrokes.isNotEmpty) {
        _sequenceIndexForKeyDown[event.physicalKey] =
            keystrokes.first.sequenceIndex;
        unawaited(
          keystrokes.first.result == KeystrokeResult.correct
              ? soundPlayer.playClick()
              : soundPlayer.playReject(),
        );
      }
      return KeyEventResult.handled;
    }

    final char = resolveTypedCharacter(
      event: event,
      physicalKeyId: physicalKeyId,
      remaps: ref.read(keyboardRemapsByNameProvider),
      shiftPressed: HardwareKeyboard.instance.isShiftPressed,
    );
    if (char == null) return KeyEventResult.ignored;
    final keystroke = notifier.ingestChar(
      physicalKeyId: physicalKeyId,
      char: char,
      flight: flight,
    );
    if (keystroke != null) {
      _sequenceIndexForKeyDown[event.physicalKey] = keystroke.sequenceIndex;
      unawaited(
        keystroke.result == KeystrokeResult.correct
            ? soundPlayer.playClick()
            : soundPlayer.playReject(),
      );
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(
      practiceSessionControllerProvider(widget.snippet, widget.mode),
    );
    final baseStyle = (theme.textTheme.bodyLarge ?? const TextStyle()).copyWith(
      fontFamily: AppFonts.mono,
      height: 1.6,
      fontSize: 18,
    );
    final syntaxColors = SyntaxColors.fromScheme(theme.colorScheme);
    final tokenTypes = SyntaxTokenizers.forLanguage(state.snippet.language)
        .classify(state.snippet.code);
    final rejectedTick = state.recorder.rejectedTick;

    // The ghost race: mirror the provider into the cursor controller,
    // which resets it on a retry and late-starts it in the rare case the
    // provider resolved only after typing had already begun.
    final ghost = ref
        .watch(ghostRunProvider(widget.snippet, widget.mode))
        .value;
    _ghostCursor
      ..ghost = ghost
      ..reconcile(
        sessionIdle: state.status == PracticeSessionStatus.idle,
        sessionRunning: state.status == PracticeSessionStatus.running,
      );
    final ghostActive =
        ghost != null && state.status == PracticeSessionStatus.running;

    final codeLength = state.snippet.code.length;
    final ghostCursorIndex = ghost == null || codeLength == 0
        ? null
        : math.min(_ghostCursor.cursorIndex, codeLength - 1);
    final ghostPercent = !ghostActive || ghost.steps.isEmpty
        ? null
        : (_ghostCursor.committed / ghost.steps.length * 100).round();

    const containerPadding = KeystrokeCodeCard.padding;
    final textSpan = TextSpan(
      style: baseStyle,
      children: buildKeystrokeSpans(
        colors: theme.colorScheme,
        syntaxColors: syntaxColors,
        tokenTypes: tokenTypes,
        base: baseStyle,
        code: state.snippet.code,
        statuses: state.recorder.expectedCharStatuses,
        liveCursorIndex: state.recorder.expectedCursor,
        reviewCursorIndex: state.recorder.reviewCursor,
        ghostCursorIndex: ghostCursorIndex,
      ),
    );

    // Raw advance through the snippet, not accuracy — a rejected
    // keystroke never moves `expectedCursor` (this field is hard-locked),
    // so this is simply "how far in" the user has gotten.
    final progress = codeLength == 0
        ? 0.0
        : (state.recorder.expectedCursor / codeLength).clamp(0.0, 1.0);

    final field = Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      // A snippet tall enough to exceed the space `PracticeSessionScreen`
      // gives this field (SPEC.md's longer DDD/hexagonal-architecture
      // content routinely does) scrolls here instead of overflowing —
      // `LayoutBuilder` supplies the exact inner width the auto-scroll
      // calculation below needs to match the `RichText`'s real layout.
      child: LayoutBuilder(
        builder: (context, constraints) {
          final innerWidth = constraints.maxWidth - containerPadding.horizontal;
          final snippetChanged = state.snippet.id.value != _lastSnippetId;
          _lastSnippetId = state.snippet.id.value;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted || !_scrollController.hasClients) return;
            if (snippetChanged) {
              _lastAutoScrolledCursor = null;
              _scrollController.jumpTo(0);
              return;
            }
            _ensureCursorVisible(
              state.recorder.expectedCursor,
              textSpan,
              innerWidth,
            );
          });

          return SingleChildScrollView(
            controller: _scrollController,
            child: ConstrainedBox(
              // Floors the card at the full height `Expanded` gives it in
              // `PracticeSessionScreen`'s column, so a short snippet still
              // fills the available space instead of shrink-wrapping to
              // its text (jarring size jumps between snippets); a snippet
              // taller than this still grows past it and scrolls above.
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              // No rounded shape/clip here — `PracticeSessionScreen` makes
              // the app bar and Scaffold share this exact surface color and
              // runs this field edge-to-edge, so the card *is* the screen
              // rather than a distinct shape floating on it.
              child: KeystrokeCodeCard(
                textSpan: textSpan,
                snippetKey: ValueKey(state.snippet.id),
                progress: progress,
                ghostPercent: ghostPercent,
                ghostSpeedCpm: ghostActive ? ghost.netSpeedCpm : null,
              ),
            ),
          );
        },
      ),
    );

    // A restrained shake on every rejected attempt — the hard-lock
    // equivalent of `PinDots`' wrong-PIN shake, so being rejected reads
    // as a clear physical "no" rather than a silent no-op.
    if (rejectedTick != _lastRejectedTick) {
      _lastRejectedTick = rejectedTick;
      if (rejectedTick != 0) _shakeController.forward(from: 0);
    }

    return RejectShake(controller: _shakeController, child: field);
  }
}
