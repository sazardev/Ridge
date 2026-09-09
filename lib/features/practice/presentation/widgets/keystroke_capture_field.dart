import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:just_in_time/core/theme/app_motion.dart';
import 'package:just_in_time/core/theme/app_shapes.dart';
import 'package:just_in_time/core/theme/app_typography.dart';
import 'package:just_in_time/features/content/domain/entities/snippet.dart';
import 'package:just_in_time/features/content/domain/entities/syntax_token_type.dart';
import 'package:just_in_time/features/content/domain/services/syntax_tokenizer.dart';
import 'package:just_in_time/features/content/presentation/syntax_colors.dart';
import 'package:just_in_time/features/practice/domain/entities/keystroke_result.dart';
import 'package:just_in_time/features/practice/domain/entities/practice_mode.dart';
import 'package:just_in_time/features/practice/domain/entities/practice_session_status.dart';
import 'package:just_in_time/features/practice/domain/value_objects/physical_key_id.dart';
import 'package:just_in_time/features/practice/presentation/physical_key_id_mapper.dart';
import 'package:just_in_time/features/practice/presentation/providers/practice_providers.dart';
import 'package:just_in_time/features/practice/presentation/providers/practice_session_controller.dart';

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

class _KeystrokeCaptureFieldState extends ConsumerState<KeystrokeCaptureField> {
  late final FocusNode _focusNode;

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
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    super.dispose();
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
    if (physicalKeyId == PhysicalKeyId.enter) return '\n';
    // Tab is handled separately, before this is ever called — see
    // `_handleKeyEvent`'s dedicated branch calling `ingestTabKey`.
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

  /// A char not yet reached is rendered in its real syntax color, just
  /// dimmed — real syntax highlighting *and* an unambiguous "haven't
  /// typed this yet" signal at once, without a second, competing color
  /// scheme fighting the theme's own (SPEC.md §4.1's live feedback,
  /// reworked to sit underneath syntax highlighting rather than replace
  /// it). A char already committed (always correct — see this class's
  /// hard-lock doc) renders at full strength.
  static const _untypedOpacity = 0.38;

  List<TextSpan> _buildSpans(
    ColorScheme colors,
    SyntaxColors syntaxColors,
    List<SyntaxTokenType> tokenTypes,
    TextStyle base,
    String code,
    List<bool?> statuses,
    int liveCursorIndex,
    int? reviewCursorIndex,
  ) {
    return [
      for (var i = 0; i < code.length; i++)
        TextSpan(
          text: code[i],
          style: base.copyWith(
            color: syntaxColors
                .forType(tokenTypes[i])
                .withValues(alpha: statuses[i] == true ? 1 : _untypedOpacity),
            backgroundColor: i == reviewCursorIndex
                ? colors.secondaryContainer
                : (i == liveCursorIndex ? colors.primaryContainer : null),
          ),
        ),
    ];
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

    final field = Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: ShapeDecoration(
          shape: AppShapes.of(context).largeShape,
          color: theme.colorScheme.surfaceContainerHigh,
        ),
        // Keyed by the current snippet's id so a Sprint mid-session swap
        // (SPEC.md §5.2) cross-fades instead of an abrupt cut; ordinary
        // per-keystroke recoloring keeps the same key, so it never
        // retriggers this transition.
        child: AnimatedSwitcher(
          duration: AppMotion.effectsDefault,
          switchInCurve: AppMotion.enter,
          switchOutCurve: AppMotion.exit,
          child: RichText(
            key: ValueKey(state.snippet.id),
            text: TextSpan(
              style: baseStyle,
              children: _buildSpans(
                theme.colorScheme,
                syntaxColors,
                tokenTypes,
                baseStyle,
                state.snippet.code,
                state.recorder.expectedCharStatuses,
                state.recorder.expectedCursor,
                state.recorder.reviewCursor,
              ),
            ),
          ),
        ),
      ),
    );

    // A restrained shake on every rejected attempt — the hard-lock
    // equivalent of `PinDots`' wrong-PIN shake, so being rejected reads
    // as a clear physical "no" rather than a silent no-op.
    if (rejectedTick == 0) return field;
    return field
        .animate(key: ValueKey('capture-reject-$rejectedTick'))
        .shakeX(amount: 6, hz: 8, duration: 260.ms);
  }
}
