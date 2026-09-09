import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:just_in_time/features/achievements/presentation/providers/achievements_providers.dart';
import 'package:just_in_time/features/content/domain/entities/snippet.dart';
import 'package:just_in_time/features/content/domain/value_objects/snippet_id.dart';
import 'package:just_in_time/features/learning_paths/presentation/providers/learning_paths_providers.dart';
import 'package:just_in_time/features/practice/application/usecases/finish_practice_session_usecase.dart';
import 'package:just_in_time/features/practice/domain/entities/keystroke.dart';
import 'package:just_in_time/features/practice/domain/entities/practice_mode.dart';
import 'package:just_in_time/features/practice/domain/entities/practice_session_status.dart';
import 'package:just_in_time/features/practice/domain/services/keystroke_stream_recorder.dart';
import 'package:just_in_time/features/practice/domain/value_objects/physical_key_id.dart';
import 'package:just_in_time/features/practice/domain/value_objects/typing_session_id.dart';
import 'package:just_in_time/features/practice/presentation/providers/practice_providers.dart';
import 'package:just_in_time/features/profile/presentation/providers/profile_providers.dart';
import 'package:just_in_time/features/progression/presentation/providers/progression_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'practice_session_controller.g.dart';
part 'practice_session_state.dart';
part 'practice_lifecycle_observer.dart';

/// How long the app may sit backgrounded mid-session before the in-flight
/// run is discarded rather than resumed (SPEC.md §8.1: only a genuinely
/// finished run is a "closed immutable event").
const _abandonThreshold = Duration(minutes: 5);

/// How often Sprint mode's countdown ticks, for the UI badge and for
/// detecting the deadline (SPEC.md §5.2). Small enough to feel live,
/// large enough not to spam rebuilds.
const _countdownTickInterval = Duration(milliseconds: 200);

/// Drives one practice session for a specific `Snippet` through
/// `idle -> running -> finished -> result` (SPEC.md §5.1-§5.3).
/// Parameterized (a Riverpod family) by the starting snippet and mode so
/// navigating to a new session always gets fresh state.
///
/// - **Zen**: no deadline, no accuracy gate. `running` starts on the
///   first keystroke; the session reaches `finished` the moment the
///   buffer reaches the expected snippet's length.
/// - **Sprint**: a countdown starts alongside `running`. Finishing the
///   current snippet before the countdown reaches zero advances to a new
///   same-difficulty snippet within the *same* session (seamless — no
///   `finished`/`idle` transition in between); the countdown reaching
///   zero force-finishes instead, dropping any character still pending
///   classification at that exact instant from the metrics input.
/// - **Precision**: shaped like Zen, but [FinishPracticeSessionUseCase]
///   evaluates the finished session's accuracy against the mode's
///   threshold. "Retry" ([retry]) is just a fresh `idle -> running` on
///   the same snippet, producing a brand-new immutable session row.
///
/// Backgrounding freezes elapsed-time accounting (and, for Sprint, the
/// countdown); backgrounding for longer than [_abandonThreshold] discards
/// the in-progress buffer entirely (nothing is ever persisted for an
/// abandoned run).
@riverpod
class PracticeSessionController extends _$PracticeSessionController {
  DateTime? _runningSince;
  Duration _totalPaused = Duration.zero;
  DateTime? _backgroundedAt;
  Timer? _countdownTimer;
  final Set<SnippetId> _usedSnippetIds = {};

  /// This mode's Sprint window, or `null` for every other mode.
  Duration? get _sprintWindow =>
      mode.maybeWhen(sprint: (window) => window, orElse: () => null);

  @override
  PracticeSessionState build(Snippet snippet, PracticeMode mode) {
    final observer = _PracticeLifecycleObserver(_handleLifecycleChange);
    WidgetsBinding.instance.addObserver(observer);
    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(observer);
      _countdownTimer?.cancel();
    });

    _usedSnippetIds
      ..clear()
      ..add(snippet.id);

    return PracticeSessionState(
      status: PracticeSessionStatus.idle,
      recorder: KeystrokeStreamRecorder(expectedSnippet: snippet.code),
      snippet: snippet,
    );
  }

  /// Records a printable keydown, starting the clock (and, for Sprint,
  /// the countdown) on the first character if the session was still
  /// idle. Returns the (possibly provisional) classified keystroke, so
  /// the caller can remember its `sequenceIndex` for a later [patchDwell]
  /// call once the matching keyup arrives.
  Keystroke? ingestChar({
    required PhysicalKeyId physicalKeyId,
    required String char,
    Duration? dwell,
    Duration? flight,
  }) {
    if (state.status != PracticeSessionStatus.idle &&
        state.status != PracticeSessionStatus.running) {
      return null;
    }
    if (state.status == PracticeSessionStatus.idle) {
      _runningSince = DateTime.now();
      _startCountdownIfSprint();
    }
    final keystroke = state.recorder.ingestChar(
      physicalKeyId: physicalKeyId,
      char: char,
      dwell: dwell,
      flight: flight,
    );
    if (state.recorder.isComplete) {
      unawaited(_handleSnippetComplete());
    } else {
      _refresh(status: PracticeSessionStatus.running);
    }
    return keystroke;
  }

  /// Records a Tab keydown — see `KeystrokeStreamRecorder.ingestTabKey`
  /// for why this can commit more than one character (a `gofmt`
  /// alignment-space run) from a single press.
  List<Keystroke> ingestTabKey({
    required PhysicalKeyId physicalKeyId,
    Duration? dwell,
    Duration? flight,
  }) {
    if (state.status != PracticeSessionStatus.idle &&
        state.status != PracticeSessionStatus.running) {
      return const [];
    }
    if (state.status == PracticeSessionStatus.idle) {
      _runningSince = DateTime.now();
      _startCountdownIfSprint();
    }
    final keystrokes = state.recorder.ingestTabKey(
      physicalKeyId: physicalKeyId,
      dwell: dwell,
      flight: flight,
    );
    if (state.recorder.isComplete) {
      unawaited(_handleSnippetComplete());
    } else {
      _refresh(status: PracticeSessionStatus.running);
    }
    return keystrokes;
  }

  /// Records a backspace keydown. Returns the correction keystroke (or
  /// `null` if the buffer was already empty).
  Keystroke? ingestBackspace({
    required PhysicalKeyId physicalKeyId,
    Duration? dwell,
    Duration? flight,
  }) {
    if (state.status != PracticeSessionStatus.running) return null;
    final correction = state.recorder.ingestBackspace(
      physicalKeyId: physicalKeyId,
      dwell: dwell,
      flight: flight,
    );
    _refresh(status: PracticeSessionStatus.running);
    return correction;
  }

  /// Retroactively attaches [dwell] to the keystroke at [sequenceIndex],
  /// once the matching keyup event supplies it (see
  /// `KeystrokeStreamRecorder.patchDwell`).
  void patchDwell({required int sequenceIndex, required Duration dwell}) {
    state.recorder.patchDwell(sequenceIndex: sequenceIndex, dwell: dwell);
  }

  /// Truncates the committed buffer back to wherever the review cursor
  /// (moved via [moveReviewCursorLeft]/[moveReviewCursorRight]) is
  /// currently pointing — a bulk "redo from here." Returns the removed
  /// correction keystrokes (empty if the review cursor is at the live
  /// end, i.e. there's nothing ahead of it to remove).
  List<Keystroke> ingestDelete({
    required PhysicalKeyId physicalKeyId,
    Duration? dwell,
    Duration? flight,
  }) {
    if (state.status != PracticeSessionStatus.running) return const [];
    final removed = state.recorder.ingestDelete(
      physicalKeyId: physicalKeyId,
      dwell: dwell,
      flight: flight,
    );
    if (removed.isNotEmpty) _refresh(status: PracticeSessionStatus.running);
    return removed;
  }

  /// Moves the read-only review cursor left within the already-typed
  /// text, for the capture field to render a distinct "reviewing"
  /// highlight — typing always still commits at the live end regardless.
  void moveReviewCursorLeft() {
    if (state.status != PracticeSessionStatus.running) return;
    state.recorder.moveReviewCursorLeft();
    _refresh(status: PracticeSessionStatus.running);
  }

  /// Moves the review cursor right, back towards the live end.
  void moveReviewCursorRight() {
    if (state.status != PracticeSessionStatus.running) return;
    state.recorder.moveReviewCursorRight();
    _refresh(status: PracticeSessionStatus.running);
  }

  /// Resets back to `idle` on demand — the "Retry" action for a Precision
  /// attempt (SPEC.md §5.3), whether it failed or passed: each attempt is
  /// its own fresh `idle -> running`, producing a brand-new immutable
  /// session row once it finishes, rather than a special retry state of
  /// its own.
  void retry() => _resetToIdle();

  /// Called the instant the buffer reaches the *current* snippet's
  /// expected length. Zen/Precision finish outright; Sprint instead
  /// advances to a new same-difficulty snippet within the same session,
  /// unless the countdown has already run out (finishing outright there
  /// too) — SPEC.md §5.2's continuous stream.
  Future<void> _handleSnippetComplete() async {
    final window = _sprintWindow;
    if (window == null) {
      await _finish();
      return;
    }
    final remaining = window - _elapsedSoFar();
    if (remaining <= Duration.zero) {
      await _finishAtDeadline();
      return;
    }
    await _advanceToNextSprintSnippet(remaining: remaining);
  }

  Future<void> _advanceToNextSprintSnippet({
    required Duration remaining,
  }) async {
    final result = await ref.read(getNextSprintSnippetUseCaseProvider)(
      difficulty: state.snippet.difficulty,
      usedSnippetIds: _usedSnippetIds,
    );
    if (state.status != PracticeSessionStatus.running) {
      // The countdown reached zero (or the session was otherwise reset)
      // while this lookup was in flight — don't resurrect a session that
      // has already moved on to `finished`/`idle` as "running" again.
      return;
    }
    final nextSnippet = result.valueOrNull;
    if (nextSnippet == null) {
      // Nothing to advance to (e.g. an empty catalog) — finish the run
      // instead of leaving Sprint stuck on a filled buffer with nowhere
      // to go.
      await _finish();
      return;
    }
    _usedSnippetIds.add(nextSnippet.id);
    state.recorder.retarget(nextSnippet.code);
    state = PracticeSessionState(
      status: PracticeSessionStatus.running,
      recorder: state.recorder,
      snippet: nextSnippet,
      remaining: remaining,
      finishedSession: state.finishedSession,
      error: state.error,
    );
  }

  void _startCountdownIfSprint() {
    if (_sprintWindow == null) return;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(
      _countdownTickInterval,
      (_) => _onCountdownTick(),
    );
  }

  void _onCountdownTick() {
    if (state.status != PracticeSessionStatus.running) return;
    // Backgrounding freezes the countdown exactly like it freezes the
    // elapsed-time clock (SPEC.md §8.1) — don't let the window run out
    // while nothing is on screen to see it.
    if (_backgroundedAt != null) return;
    final window = _sprintWindow;
    if (window == null) return;
    final remaining = window - _elapsedSoFar();
    if (remaining <= Duration.zero) {
      _countdownTimer?.cancel();
      _countdownTimer = null;
      unawaited(_finishAtDeadline());
    } else {
      _refresh(status: PracticeSessionStatus.running, remaining: remaining);
    }
  }

  /// Elapsed running time so far, excluding every backgrounded interval —
  /// frozen at the instant backgrounding began if currently backgrounded,
  /// so a countdown (or the final persisted duration) never advances
  /// while the app isn't on screen.
  Duration _elapsedSoFar() {
    final runningSince = _runningSince;
    if (runningSince == null) return Duration.zero;
    final referenceNow = _backgroundedAt ?? DateTime.now();
    final elapsed = referenceNow.difference(runningSince) - _totalPaused;
    return elapsed.isNegative ? Duration.zero : elapsed;
  }

  void _refresh({required PracticeSessionStatus status, Duration? remaining}) {
    state = PracticeSessionState(
      status: status,
      recorder: state.recorder,
      snippet: state.snippet,
      remaining: remaining ?? state.remaining,
      finishedSession: state.finishedSession,
      error: state.error,
    );
  }

  /// Normal finish path: the buffer naturally reached the end of all
  /// available text (Zen, Precision, or Sprint when there's genuinely no
  /// next snippet to advance to). Anything still pending is finalized
  /// like any other keystroke, since this isn't a hard external cutoff.
  Future<void> _finish() async {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    _refresh(status: PracticeSessionStatus.finished);
    final keystrokes = state.recorder.finish();
    await _persistFinishedSession(keystrokes);
  }

  /// Sprint's countdown reached zero mid-typing (SPEC.md §5.2): anything
  /// still pending classification at this exact instant is dropped
  /// entirely from the metrics input, never judged right or wrong.
  Future<void> _finishAtDeadline() async {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    _refresh(status: PracticeSessionStatus.finished, remaining: Duration.zero);
    final keystrokes = state.recorder.forceFinishAtDeadline();
    await _persistFinishedSession(keystrokes);
  }

  Future<void> _persistFinishedSession(List<Keystroke> keystrokes) async {
    final profileId = ref.read(activeProfileControllerProvider).value?.id;
    if (profileId == null) {
      state = PracticeSessionState(
        status: PracticeSessionStatus.result,
        recorder: state.recorder,
        snippet: state.snippet,
        remaining: state.remaining,
        error: 'No guest profile found',
      );
      return;
    }

    final duration = _elapsedSoFar();

    final result = await ref.read(finishPracticeSessionUseCaseProvider)(
      id: TypingSessionId.generate(),
      profileId: profileId,
      mode: mode,
      // The *starting* snippet, always — a multi-snippet Sprint run still
      // denormalizes onto it (see the project plan's design decision);
      // `state.snippet` may have already advanced past it.
      snippet: snippet,
      startedAtUtc: (_runningSince ?? DateTime.now()).toUtc(),
      duration: duration,
      keystrokes: keystrokes,
    );

    // Fire-and-forget: never block the finish -> result transition on
    // `progression`'s recompute (SPEC.md §6). Idempotent and cheap, so a
    // failure here is silently caught by the Progress screen's own
    // safety-net recompute on next load.
    if (result.isOk) {
      unawaited(
        ref.read(recomputeProgressSnapshotUseCaseProvider)(
          profileId: profileId,
          now: DateTime.now(),
        ),
      );
      // Fire-and-forget, same rationale as the recompute above: a pass
      // against a `learningRouteLesson`-tagged session should unlock the
      // next lesson as soon as possible, but nothing here needs to block
      // the finish -> result transition on it (SPEC.md §5.7).
      unawaited(ref.read(recomputeLessonProgressUseCaseProvider)(profileId));
      // Fire-and-forget, same rationale again: a just-finished session
      // may have unlocked a SPEC.md §12 achievement. This call is
      // self-sufficient regardless of the two calls above's own
      // ordering/timing — see `EvaluateAchievementsUseCase`'s class doc.
      unawaited(ref.read(evaluateAchievementsUseCaseProvider)(profileId));
    }

    state = result.fold(
      (finished) => PracticeSessionState(
        status: PracticeSessionStatus.result,
        recorder: state.recorder,
        snippet: state.snippet,
        remaining: state.remaining,
        finishedSession: finished,
      ),
      (failure) => PracticeSessionState(
        status: PracticeSessionStatus.result,
        recorder: state.recorder,
        snippet: state.snippet,
        remaining: state.remaining,
        error: failure.message,
      ),
    );
  }

  void _handleLifecycleChange(AppLifecycleState lifecycleState) {
    if (state.status != PracticeSessionStatus.running) return;

    final isBackgrounding =
        lifecycleState == AppLifecycleState.paused ||
        lifecycleState == AppLifecycleState.inactive ||
        lifecycleState == AppLifecycleState.hidden;
    if (isBackgrounding) {
      _backgroundedAt ??= DateTime.now();
      return;
    }

    if (lifecycleState != AppLifecycleState.resumed) return;
    final backgroundedAt = _backgroundedAt;
    if (backgroundedAt == null) return;
    final backgroundedDuration = DateTime.now().difference(backgroundedAt);
    _backgroundedAt = null;
    if (backgroundedDuration > _abandonThreshold) {
      _resetToIdle();
    } else {
      _totalPaused += backgroundedDuration;
    }
  }

  /// Resets this session back to `idle` on the snippet this controller
  /// was created for — used both when a backgrounded run is abandoned
  /// and when the user requests a Precision [retry]. Nothing is ever
  /// persisted for an abandoned or retried run until it's genuinely
  /// finished (SPEC.md §8.1).
  void _resetToIdle() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    _runningSince = null;
    _totalPaused = Duration.zero;
    _backgroundedAt = null;
    _usedSnippetIds
      ..clear()
      ..add(snippet.id);
    state = PracticeSessionState(
      status: PracticeSessionStatus.idle,
      recorder: KeystrokeStreamRecorder(expectedSnippet: snippet.code),
      snippet: snippet,
    );
  }
}
