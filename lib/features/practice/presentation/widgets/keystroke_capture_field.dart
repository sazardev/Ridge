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
import 'package:ridge/features/practice/presentation/providers/practice_providers.dart';
import 'package:ridge/features/practice/presentation/providers/practice_session_controller.dart';
import 'package:ridge/features/practice/presentation/widgets/keystroke_span_builder.dart';
import 'package:ridge/features/practice/presentation/widgets/typing_progress_bar.dart';

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
    with SingleTickerProviderStateMixin {
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

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(debugLabel: 'KeystrokeCaptureField')
      ..addListener(_onFocusChange);
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    _scrollController.dispose();
    _shakeController.dispose();
    super.dispose();
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

    final painter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: innerWidth);
    final caretOffset = painter.getOffsetForCaret(
      TextPosition(offset: cursorIndex),
      Rect.zero,
    );
    final lineHeight = painter.preferredLineHeight;

    final position = _scrollController.position;
    final viewportTop = position.pixels;
    final viewportBottom = viewportTop + position.viewportDimension;
    // 6 lines of context above/below the cursor — clamped to a fraction
    // of the viewport so a short viewport (a small window, or a result
    // area sharing the screen) can't make the margin exceed the space
    // there is to scroll within.
    final margin = math.min(lineHeight * 6, position.viewportDimension * 0.35);

    double? target;
    if (caretOffset.dy < viewportTop + margin) {
      target = caretOffset.dy - margin;
    } else if (caretOffset.dy + lineHeight > viewportBottom - margin) {
      target =
          caretOffset.dy + lineHeight - position.viewportDimension + margin;
    }
    if (target == null) return;

    final clamped = target.clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    _scrollController.animateTo(
      clamped,
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

  String? _resolveChar(KeyEvent event, PhysicalKeyId physicalKeyId) {
    // Tab and Enter are handled separately, before this is ever called —
    // see `_handleKeyEvent`'s dedicated branches calling `ingestTabKey`/
    // `ingestEnterKey`.
    final character = event.character;
    if (character != null && character.isNotEmpty) return character;
    return fallbackCharFor(
      physicalKeyId,
      shiftPressed: HardwareKeyboard.instance.isShiftPressed,
    );
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    // Once a session is finished/showing its result, there's nothing
    // left to capture — ignore every key so it bubbles up to the result
    // screen's own keyboard shortcuts (Enter/R/Escape) instead of being
    // silently swallowed here.
    final status = ref
        .read(practiceSessionControllerProvider(widget.snippet, widget.mode))
        .status;
    if (status != PracticeSessionStatus.idle &&
        status != PracticeSessionStatus.running) {
      return KeyEventResult.ignored;
    }

    // OS auto-repeat from a held key isn't a deliberate keystroke — it
    // would pollute dwell/flight stats and double-advance the buffer.
    if (event is KeyRepeatEvent) return KeyEventResult.handled;

    final physicalKeyId = physicalKeyIdFor(event.physicalKey);
    if (physicalKeyId == null) return KeyEventResult.ignored;

    final notifier = ref.read(
      practiceSessionControllerProvider(widget.snippet, widget.mode).notifier,
    );

    if (event is KeyUpEvent) {
      final keyDownAt = _keyDownAt.remove(event.physicalKey);
      final sequenceIndex = _sequenceIndexForKeyDown.remove(event.physicalKey);
      if (keyDownAt != null && sequenceIndex != null) {
        notifier.patchDwell(
          sequenceIndex: sequenceIndex,
          dwell: event.timeStamp - keyDownAt,
        );
      }
      return KeyEventResult.handled;
    }

    if (event is! KeyDownEvent) return KeyEventResult.ignored;

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

    final char = _resolveChar(event, physicalKeyId);
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

    const containerPadding = EdgeInsets.all(20);
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
      ),
    );

    final codeLength = state.snippet.code.length;
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
              child: Stack(
                // `loose` (the default) would hand the `Container` below
                // loosened constraints, discarding the minHeight floor
                // this `ConstrainedBox` just set — `passthrough` forwards
                // the incoming constraints unchanged so the card still
                // fills the available space instead of shrinking back to
                // its text, with the progress bar still free to position
                // itself via `Positioned`.
                fit: StackFit.passthrough,
                children: [
                  Container(
                    width: double.infinity,
                    padding: containerPadding,
                    color: theme.colorScheme.surfaceContainerHigh,
                    // Keyed by the current snippet's id so a Sprint
                    // mid-session swap (SPEC.md §5.2) cross-fades instead
                    // of an abrupt cut; ordinary per-keystroke recoloring
                    // keeps the same key, so it never retriggers this
                    // transition.
                    child: AnimatedSwitcher(
                      duration: AppMotion.effectsDefault,
                      switchInCurve: AppMotion.enter,
                      switchOutCurve: AppMotion.exit,
                      child: RichText(
                        key: ValueKey(state.snippet.id),
                        text: textSpan,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: TypingProgressBar(progress: progress),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    // A restrained shake on every rejected attempt — the hard-lock
    // equivalent of `PinDots`' wrong-PIN shake, so being rejected reads
    // as a clear physical "no" rather than a silent no-op. Replayed by
    // driving `_shakeController` again, never by changing a widget key
    // (see its field doc for why that broke scrolling).
    if (rejectedTick != _lastRejectedTick) {
      _lastRejectedTick = rejectedTick;
      if (rejectedTick != 0) _shakeController.forward(from: 0);
    }

    return AnimatedBuilder(
      animation: _shakeController,
      // `field`'s whole scrollable subtree is passed as `child` — an
      // `AnimatedBuilder` never rebuilds `child` on its own animation
      // ticks, only `builder`, so the shake repositions the field
      // without ever remounting it.
      child: field,
      builder: (context, child) {
        final t = _shakeController.value;
        final decay = 1 - t;
        final dx = 6.0 * math.sin(t * 4 * math.pi) * decay;
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
    );
  }
}
