import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_motion.dart';
import 'package:ridge/features/achievements/domain/entities/achievement.dart';
import 'package:ridge/features/achievements/presentation/providers/achievements_providers.dart';
import 'package:ridge/features/achievements/presentation/widgets/achievement_unlocked_toast.dart';
import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/content/presentation/content_labels.dart';
import 'package:ridge/features/practice/domain/entities/keystroke.dart';
import 'package:ridge/features/practice/domain/entities/keystroke_result.dart';
import 'package:ridge/features/practice/domain/entities/practice_mode.dart';
import 'package:ridge/features/practice/domain/entities/practice_session_status.dart';
import 'package:ridge/features/practice/domain/services/survival_run_tracker.dart';
import 'package:ridge/features/practice/presentation/providers/practice_session_controller.dart';
import 'package:ridge/features/practice/presentation/widgets/keystroke_capture_field.dart';
import 'package:ridge/features/practice/presentation/widgets/session_result_footer.dart';
import 'package:ridge/features/practice/presentation/widgets/session_result_panel.dart';
import 'package:ridge/features/practice/presentation/widgets/sprint_countdown_badge.dart';
import 'package:ridge/features/practice/presentation/widgets/survival_lives_badge.dart';
import 'package:ridge/features/profile/presentation/providers/profile_providers.dart';

/// Hosts one full `idle -> running -> finished -> result` practice run
/// for [snippet] under [mode] as a single screen — no route change
/// mid-flow (the project plan's design: the running session is a pushed
/// non-shell route, and `finished`/`result` are states inside it, not
/// separate routes).
class PracticeSessionScreen extends ConsumerStatefulWidget {
  /// Creates the session screen for [snippet] under [mode].
  const new({
    required this.snippet,
    required this.mode,
    this.onContinue,
    super.key,
  });

  /// The snippet being typed this session.
  final Snippet snippet;

  /// Which practice mode is driving this session.
  final PracticeMode mode;

  /// "Continue" (to the next lesson) — only ever supplied by
  /// `learning_paths` (see `LessonDetailScreen`), and only when there
  /// genuinely is a next lesson to jump to. Shown on the result
  /// screen's fixed footer alongside Retry once
  /// [PracticeSessionState.finishedSession]'s session passes.
  final VoidCallback? onContinue;

  @override
  ConsumerState<PracticeSessionScreen> createState() =>
      _PracticeSessionScreenState();
}

class _PracticeSessionScreenState extends ConsumerState<PracticeSessionScreen> {
  /// The unlocked-achievement ids this profile already had *before* this
  /// session could possibly affect them — captured once, at the very
  /// start (still `idle`), so the post-finish diff below only ever
  /// reports what's genuinely new from this run. `null` until that
  /// one-shot read completes, or if there's no active profile at all.
  Set<String>? _unlockedBeforeSession;
  bool _achievementsChecked = false;

  /// Backs the result panel's `SingleChildScrollView` so Home/End/
  /// PageUp/PageDown (bound below, alongside Enter/R/I) can jump it —
  /// only ever attached while `state.status == result`, but kept for
  /// the screen's lifetime since `CallbackShortcuts`' bindings map is
  /// rebuilt on every build anyway.
  final _resultScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    unawaited(_captureUnlockedBaseline());
  }

  @override
  void dispose() {
    _resultScrollController.dispose();
    super.dispose();
  }

  void _animateResultScrollTo(double offset) {
    if (!_resultScrollController.hasClients) return;
    final position = _resultScrollController.position;
    _resultScrollController.animateTo(
      offset.clamp(position.minScrollExtent, position.maxScrollExtent),
      duration: AppMotion.spatialFast,
      curve: AppMotion.spatial,
    );
  }

  void _pageResultScroll({required bool forward}) {
    if (!_resultScrollController.hasClients) return;
    final position = _resultScrollController.position;
    final increment = position.viewportDimension * 0.8;
    _animateResultScrollTo(
      position.pixels + (forward ? increment : -increment),
    );
  }

  Future<void> _captureUnlockedBaseline() async {
    final profileId = ref.read(activeProfileControllerProvider).value?.id;
    if (profileId == null) return;
    final result = await ref
        .read(achievementRepositoryProvider)
        .getUnlocked(profileId);
    if (!mounted) return;
    _unlockedBeforeSession = {
      for (final a in result.valueOrNull ?? const <Achievement>[])
        a.id.storageKey,
    };
  }

  /// Diffs the unlocked-achievement set against [_unlockedBeforeSession]
  /// and shows a toast for whatever is new — called once per finish.
  ///
  /// `practice`'s controller already fires its own fire-and-forget
  /// `EvaluateAchievementsUseCase` call after persisting this session
  /// (concurrently with this one), so this call may find everything
  /// already unlocked by the time it runs, or may do the unlocking
  /// itself — either way, `EvaluateAchievementsUseCase` is idempotent
  /// (see its class doc), and awaiting it here guarantees the DB
  /// reflects the current truth by the time the "after" set below is
  /// read, regardless of which of the two concurrent calls got there
  /// first.
  Future<void> _checkForNewAchievements() async {
    if (_achievementsChecked) return;
    final before = _unlockedBeforeSession;
    if (before == null) return;
    _achievementsChecked = true;

    final profileId = ref.read(activeProfileControllerProvider).value?.id;
    if (profileId == null) return;

    await ref.read(evaluateAchievementsUseCaseProvider)(profileId);
    if (!mounted) return;
    final afterResult = await ref
        .read(achievementRepositoryProvider)
        .getUnlocked(profileId);
    if (!mounted) return;

    final newlyUnlocked = [
      for (final achievement
          in afterResult.valueOrNull ?? const <Achievement>[])
        if (!before.contains(achievement.id.storageKey)) achievement,
    ];
    if (newlyUnlocked.isEmpty) return;
    showAchievementUnlockedToast(context, achievements: newlyUnlocked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final snippet = widget.snippet;
    final mode = widget.mode;

    ref.listen(practiceSessionControllerProvider(snippet, mode), (
      previous,
      next,
    ) {
      final justFinished =
          next.status == PracticeSessionStatus.result &&
          next.error == null &&
          previous?.status != PracticeSessionStatus.result;
      if (justFinished) unawaited(_checkForNewAchievements());
    });

    final state = ref.watch(practiceSessionControllerProvider(snippet, mode));
    final sprintWindow = mode.maybeWhen(
      sprint: (window) => window,
      orElse: () => null,
    );
    final countdown = state.remaining ?? sprintWindow;
    final passed = state.finishedSession?.session.passed;
    final survival = state.survival;

    final controllerNotifier = ref.read(
      practiceSessionControllerProvider(snippet, mode).notifier,
    );
    // Retry applies to modes with a pass/fail gate (Precision/
    // learning-route lessons) and to Survival (a run always worth
    // replaying); Zen and Sprint never set `passed` and have no gate to
    // retry against (SPEC.md §5.1/§5.2). Continue is only ever offered on
    // an actual pass — a failed lesson attempt should retry the same one,
    // never skip ahead. Never while a persist failure is showing:
    // `survival`/`passed` stay set on state independent of `error`, and a
    // stray Enter/R press would otherwise silently restart typing and
    // discard a session that's still recoverable via retryPersist below.
    final onRetryAction =
        state.error == null && (passed != null || survival != null)
        ? controllerNotifier.retry
        : null;
    // Offered only once a persist attempt has actually failed and there's
    // something queued to resubmit — not the separate, rarer "no guest
    // profile" edge case, which has nothing to retry.
    final onRetryPersistAction =
        state.error != null && controllerNotifier.canRetryPersist
        ? () => unawaited(controllerNotifier.retryPersist())
        : null;
    final onContinueAction = passed == true ? widget.onContinue : null;
    // Enter presses whichever action is primary (Continue when offered,
    // else typing-retry, else persist-retry); Escape always backs out, in
    // every session state, not just at the result — mirrors the AppBar's
    // own back button.
    final onPrimaryAction =
        onContinueAction ?? onRetryAction ?? onRetryPersistAction;
    final explanation = state.snippet.explanationFor(context);
    final onShowInfoAction = explanation.isEmpty
        ? null
        : () => context.push('/practice/session/info', extra: state.snippet);
    // Whether the result area below the code field has anything to show
    // at all (finishing spinner, error, or the actual result panel) —
    // while typing (idle/running) it doesn't, so the code field gets the
    // full height instead of splitting it with reserved blank space.
    final showResultArea =
        state.status == PracticeSessionStatus.finished ||
        state.status == PracticeSessionStatus.result;

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            Navigator.of(context).maybePop(),
        if (state.status == PracticeSessionStatus.result) ...{
          const SingleActivator(LogicalKeyboardKey.enter): ?onPrimaryAction,
          const SingleActivator(LogicalKeyboardKey.numpadEnter):
              ?onPrimaryAction,
          const SingleActivator(LogicalKeyboardKey.keyR):
              ?(onRetryAction ?? onRetryPersistAction),
          const SingleActivator(LogicalKeyboardKey.keyI): ?onShowInfoAction,
          const SingleActivator(LogicalKeyboardKey.home): () =>
              _animateResultScrollTo(double.negativeInfinity),
          const SingleActivator(LogicalKeyboardKey.end): () =>
              _animateResultScrollTo(double.infinity),
          const SingleActivator(LogicalKeyboardKey.pageUp): () =>
              _pageResultScroll(forward: false),
          const SingleActivator(LogicalKeyboardKey.pageDown): () =>
              _pageResultScroll(forward: true),
        },
      },
      child: Scaffold(
        appBar: AppBar(
          // The current snippet — for Sprint this may have already
          // advanced past the one this route was pushed with (SPEC.md
          // §5.2's seamless mid-session queue).
          title: Text(state.snippet.titleFor(context)),
          actions: [
            if (countdown != null)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: SprintCountdownBadge(remaining: countdown),
                ),
              ),
            if (survival != null &&
                (state.status == PracticeSessionStatus.idle ||
                    state.status == PracticeSessionStatus.running))
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(child: SurvivalLivesBadge(tracker: survival)),
              ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (state.status == PracticeSessionStatus.idle) ...[
                  Text(
                    l10n.practiceStartHint,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                ],
                if (state.status == PracticeSessionStatus.running) ...[
                  _LiveStatsRow(
                    keystrokes: state.recorder.keystrokes,
                    survival: survival,
                  ),
                  const SizedBox(height: 8),
                ],
                // While typing (idle/running), the result area below has
                // nothing to show yet — omitting it from the column
                // entirely (rather than reserving its flex share for an
                // empty `SizedBox.shrink`) lets the code field's
                // `Flexible` claim the *whole* remaining height instead
                // of splitting it with blank space, which is what makes
                // this a comfortable full-height editor rather than a
                // cramped one (SPEC.md's longer DDD/hexagonal-
                // architecture content needs every pixel it can get).
                // Once a result actually exists, the field gives room
                // back to it below.
                Flexible(
                  child: KeystrokeCaptureField(snippet: snippet, mode: mode),
                ),
                if (showResultArea) ...[
                  const SizedBox(height: 16),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: AppMotion.spatialDefault,
                      switchInCurve: AppMotion.enter,
                      switchOutCurve: AppMotion.exit,
                      child: switch (state.status) {
                        PracticeSessionStatus.result when state.error == null =>
                          SingleChildScrollView(
                            key: const ValueKey('result'),
                            controller: _resultScrollController,
                            padding: const EdgeInsets.only(bottom: 16),
                            child: SessionResultPanel(
                              metrics: state.finishedSession!.metrics,
                              passed: passed,
                              survival: survival,
                            ),
                          ),
                        PracticeSessionStatus.result => Center(
                          key: const ValueKey('error'),
                          child: Text(state.error ?? ''),
                        ),
                        PracticeSessionStatus.finished => const Center(
                          key: ValueKey('finishing'),
                          child: CircularProgressIndicator(),
                        ),
                        _ => const SizedBox.shrink(key: ValueKey('typing')),
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        // Pinned outside the scrollable result panel above so Retry/
        // Continue/info are always reachable without scrolling, even on
        // a long result (many weak characters, a tall snippet).
        bottomNavigationBar: switch (state.status) {
          PracticeSessionStatus.result when state.error == null =>
            SessionResultFooter(
              onRetry: onRetryAction,
              onContinue: onContinueAction,
              onShowInfo: onShowInfoAction,
            ),
          PracticeSessionStatus.result when onRetryPersistAction != null =>
            SessionResultFooter(
              onRetry: onRetryPersistAction,
              retryLabel: l10n.practiceResultRetrySave,
            ),
          _ => null,
        },
      ),
    );
  }
}

/// Small live readout updated on every keystroke — shown only while a
/// session is actually `running` (the screen already rebuilds then).
///
/// For most modes: characters typed and running accuracy, a cheap,
/// deliberately simple companion to the capture field's live
/// per-character coloring: a continuously-moving number is its own kind
/// of feedback that "yes, this is working," distinct from (and
/// complementary to) knowing whether any one character was right or
/// wrong.
///
/// For Survival (§5.8): the run-local score, current combo multiplier,
/// and snippets cleared, since lives/score are the mode's whole point and
/// accuracy is already reflected in the capture field and result panel.
class _LiveStatsRow extends StatelessWidget {
  const new({required this.keystrokes, this.survival});

  final List<Keystroke> keystrokes;

  /// The live Survival run state, or `null` for every other mode.
  final SurvivalRunTracker? survival;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final subtleStyle = theme.textTheme.labelMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    final survival = this.survival;
    if (survival != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(l10n.practiceLiveScore(survival.score), style: subtleStyle),
          Text(
            l10n.practiceLiveMultiplier(survival.multiplier),
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            l10n.practiceLiveSnippets(survival.snippetsCleared),
            style: subtleStyle,
          ),
        ],
      );
    }

    var typed = 0;
    var correct = 0;
    for (final k in keystrokes) {
      if (k.isCorrection) continue;
      typed++;
      if (k.result == KeystrokeResult.correct) correct++;
    }
    final accuracy = typed == 0 ? 100.0 : (correct / typed) * 100;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(l10n.practiceLiveCharsTyped(typed), style: subtleStyle),
        Text(
          l10n.practiceLiveAccuracy(accuracy.toStringAsFixed(0)),
          style: subtleStyle,
        ),
      ],
    );
  }
}
