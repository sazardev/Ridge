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
    this.onShare,
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

  /// Shares a link to this lesson — only ever supplied by
  /// `learning_paths` (`LessonNavigation`), opaque to this screen exactly
  /// like [onContinue]. Shown as a small, muted icon in
  /// `SessionResultPanel`'s own title row once the session passes, same
  /// gating as [onContinue] but independent of whether there's a next
  /// lesson to continue to.
  final VoidCallback? onShare;

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

  /// Holds focus over the result/finishing area once `KeystrokeCaptureField`
  /// (the only other focus claimant on this screen) unmounts — without
  /// this, nothing in that subtree ever holds focus, so `CallbackShortcuts`
  /// below (which only sees a key event by bubbling up from whichever node
  /// is currently focused) would never get a chance to match Enter/R/I/
  /// Home/End/PageUp/PageDown. Same fix `SnippetInfoScreen` already needed
  /// for the same reason — see its class doc.
  final _resultFocusNode = FocusNode(debugLabel: 'PracticeResultFocus');

  /// Whether the result/finishing area was already showing as of the last
  /// build — so focus is (re-)requested exactly once per genuine
  /// idle/running -> finished transition, not on every rebuild while
  /// already showing (which would fight a user tabbing to, or clicking,
  /// a button inside the result panel).
  bool _wasShowingResultArea = false;

  @override
  void initState() {
    super.initState();
    unawaited(_captureUnlockedBaseline());
  }

  @override
  void dispose() {
    _resultScrollController.dispose();
    _resultFocusNode.dispose();
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
    final theme = Theme.of(context);
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
    final onShareAction = passed == true ? widget.onShare : null;
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
    // Whether there's a result area to show at all (finishing spinner,
    // error, or the actual result panel) — while typing (idle/running)
    // there isn't, and the code card is shown full-height instead (see
    // the body's outer `AnimatedSwitcher`, which shows exactly one of
    // the two).
    final showResultArea =
        state.status == PracticeSessionStatus.finished ||
        state.status == PracticeSessionStatus.result;
    if (showResultArea && !_wasShowingResultArea) {
      // Deferred a frame: `KeystrokeCaptureField` needs to actually finish
      // unmounting first — requesting focus here is still safe even before
      // that, since an explicit `requestFocus()` always wins over whatever
      // currently holds it, unlike passive `autofocus`.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _resultFocusNode.requestFocus();
      });
    }
    _wasShowingResultArea = showResultArea;

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
        // Matches the code card's own tonal surface (see
        // `KeystrokeCaptureField`) so the app bar and the card read as one
        // continuous surface — no separate "card floating on the
        // background" seam — letting the code itself be the page.
        backgroundColor: theme.colorScheme.surfaceContainerHigh,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surfaceContainerHigh,
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
          // The code card and the finished/result readout never need to be
          // visible at once — showing both together (each squeezed into
          // half the height) is what used to force scrolling just to read
          // the result. Swapping the whole area instead of stacking both
          // lets the result take the full screen once there's one to show.
          //
          // Only the result branch keeps its own padding — the typing
          // branch is deliberately edge-to-edge (no margin around the code
          // card) so, combined with the Scaffold/AppBar sharing the card's
          // surface color above, the whole screen reads as one continuous
          // card with the code as its sole focus.
          child: AnimatedSwitcher(
            duration: AppMotion.spatialDefault,
            switchInCurve: AppMotion.enter,
            switchOutCurve: AppMotion.exit,
            child: showResultArea
                ? Focus(
                    focusNode: _resultFocusNode,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: AnimatedSwitcher(
                        key: const ValueKey('result-area'),
                        duration: AppMotion.spatialDefault,
                        switchInCurve: AppMotion.enter,
                        switchOutCurve: AppMotion.exit,
                        child: switch (state.status) {
                          PracticeSessionStatus.result
                              when state.error == null =>
                            SingleChildScrollView(
                              key: const ValueKey('result'),
                              controller: _resultScrollController,
                              padding: const EdgeInsets.only(bottom: 16),
                              child: SessionResultPanel(
                                metrics: state.finishedSession!.metrics,
                                passed: passed,
                                survival: survival,
                                onShare: onShareAction,
                              ),
                            ),
                          PracticeSessionStatus.result => Center(
                            key: const ValueKey('error'),
                            child: Text(state.error ?? ''),
                          ),
                          // `showResultArea` already narrows this branch to
                          // `finished`/`result`, so anything else here is
                          // the brief finishing spinner between the two.
                          _ => const Center(
                            key: ValueKey('finishing'),
                            child: CircularProgressIndicator(),
                          ),
                        },
                      ),
                    ),
                  )
                : Column(
                    key: const ValueKey('typing-area'),
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (state.status == PracticeSessionStatus.running &&
                          survival != null)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: _LiveStatsRow(survival: survival),
                        ),
                      Expanded(
                        child: KeystrokeCaptureField(
                          snippet: snippet,
                          mode: mode,
                        ),
                      ),
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

/// Small live readout for Survival (§5.8) only — the run-local score,
/// current combo multiplier, and snippets cleared, since lives/score are
/// the mode's whole point. Every other mode's typing progress is carried
/// entirely by `TypingProgressBar` now, with no numeric chars-typed/
/// accuracy readout competing with it.
class _LiveStatsRow extends StatelessWidget {
  const new({required this.survival});

  final SurvivalRunTracker survival;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final subtleStyle = theme.textTheme.labelMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

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
}
