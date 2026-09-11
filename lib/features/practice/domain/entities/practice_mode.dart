import 'package:freezed_annotation/freezed_annotation.dart';

part 'practice_mode.freezed.dart';

/// Which of SPEC.md §5's offline game modes a practice session is
/// running under. Modeled as one sealed type (rather than a separate
/// session-runner per mode) because every mode shares the same capture
/// engine and metrics pipeline (§4) — only the start/finish rules differ.
///
/// All four variants share the same playable `PracticeSessionController`
/// state machine. A pass against a `learningRouteLesson`-tagged session
/// additionally triggers `learning_paths`' unlock recompute, but that
/// coordination lives in the application layer (`PracticeSessionController`
/// fire-and-forgets `RecomputeLessonProgressUseCase` after a finish), not
/// as a dependency of this domain type on `learning_paths`.
@freezed
sealed class PracticeMode with _$PracticeMode {
  /// Free practice: no deadline, no accuracy gate (SPEC.md §5.1).
  const factory zen() = _Zen;

  /// A fixed time window; the goal is to maximize net correct characters
  /// before it elapses (SPEC.md §5.2). Finishing the current snippet
  /// before [window] elapses advances to a new same-difficulty snippet
  /// within the same session rather than ending it — a continuous
  /// stream, not one attempt per snippet.
  const factory sprint({required Duration window}) = _Sprint;

  /// A fixed snippet, scored 1-10 on accuracy via
  /// `PrecisionScoreCalculator` to decide pass/fail (SPEC.md §5.3) —
  /// deliberately not a flat "98% or nothing" bar, which read as
  /// punishing for anything short of a flawless run; a score over 7
  /// (80% accuracy or better) passes, and retrying for a higher score is
  /// always available (every attempt is its own fresh session).
  const factory precision() = _Precision;

  /// A Precision-shaped run tagged with the `learning_paths` lesson it
  /// belongs to, scored the same way via `PrecisionScoreCalculator`.
  /// [lessonId] is a plain `String`, not `learning_paths`' own `LessonId`
  /// value object, because of this project's one-directional dependency
  /// graph (`practice` sits before `learning_paths`) — this domain type
  /// must not import from a feature that depends on it. `LessonDetailScreen`
  /// passes the lesson's raw id string when starting the run.
  const factory learningRouteLesson({required String lessonId}) =
      _LearningRouteLesson;

  /// An arcade run (SPEC.md §5.8): a continuous same-difficulty stream of
  /// snippets with a small pool of lives instead of a clock. Every
  /// rejected (wrong) keystroke costs one life; reaching zero ends the
  /// run. A combo multiplier scales the run-local score, and finishing a
  /// snippet seamlessly advances to the next one — the same stream queue
  /// Sprint uses.
  const factory survival() = _Survival;

  /// The shared, date-locked snippet every profile in the world gets on
  /// [challengeDate] (SPEC.md §5.4), scored the same way as
  /// [PracticeMode.precision] via `PrecisionScoreCalculator`.
  /// [challengeDate] is a plain `DateTime`, not `daily_challenge`'s own
  /// `ChallengeDate` value object, for the same one-directional-
  /// dependency reason [PracticeMode.learningRouteLesson] carries a raw
  /// `String lessonId`: this domain type must not import from a feature
  /// built on top of it.
  const factory dailyChallenge({required DateTime challengeDate}) =
      _DailyChallenge;
}
