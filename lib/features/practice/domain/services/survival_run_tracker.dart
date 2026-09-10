import 'package:just_in_time/features/practice/domain/entities/keystroke_result.dart';

/// Pure, mutable state for one Survival-mode run (SPEC.md §5.8): remaining
/// lives, the current combo, its score multiplier, and how many snippets
/// have been cleared. Mirrors `KeystrokeStreamRecorder`'s shape — a
/// long-lived mutable engine the controller owns per run and the UI reads
/// fresh on every rebuild — but has no keystroke-log duties of its own.
///
/// Lives are lost on rejected (wrong) keystrokes only, which the capture
/// engine's hard lock already refuses to commit — so backspacing can
/// never "erase" a mistake's cost, and there is no way to game a life
/// back. The score is run-local flavor, deliberately not persisted: XP
/// keeps deriving from correct characters/difficulty/accuracy per
/// SPEC.md §6.1, with no `progression` changes.
class SurvivalRunTracker {
  /// Creates a tracker for a fresh run.
  new({this.startingLives = defaultStartingLives})
    : _livesRemaining = startingLives;

  /// Lives a run starts with.
  static const defaultStartingLives = 5;

  /// Correct characters in a row needed to climb one multiplier step.
  static const streakPerMultiplierStep = 25;

  /// Ceiling for the combo multiplier.
  static const maxMultiplier = 4;

  /// Lives this run started with, for a fixed-size lives display.
  final int startingLives;

  int _livesRemaining;
  int _currentStreak = 0;
  int _score = 0;
  int _snippetsCleared = 0;
  int _bestMultiplier = 1;

  /// Lives still in hand. Zero means the run is over.
  int get livesRemaining => _livesRemaining;

  /// Consecutive correct characters committed since the last rejected
  /// keystroke — the combo that feeds [multiplier].
  int get currentStreak => _currentStreak;

  /// The score multiplier every correct character currently earns.
  int get multiplier => _multiplierFor(_currentStreak);

  /// Accumulated run score: one point per correct character, times the
  /// multiplier in effect at that moment.
  int get score => _score;

  /// Snippets fully typed during this run.
  int get snippetsCleared => _snippetsCleared;

  /// The highest [multiplier] reached this run, for the result screen.
  int get bestMultiplier => _bestMultiplier;

  /// Whether the run has no lives left.
  bool get isOver => _livesRemaining <= 0;

  /// Records one correctly committed character: earns the multiplier in
  /// effect *before* this character's combo step (so a run's first 25
  /// characters all earn 1× rather than the 25th jumping a step early),
  /// then extends the combo and remembers the peak multiplier reached.
  void recordCorrect() {
    _score += multiplier;
    _currentStreak++;
    final reached = multiplier;
    if (reached > _bestMultiplier) _bestMultiplier = reached;
  }

  /// Records one classified forward keystroke — a correct character grows
  /// the combo and score, a rejected substitution costs a life and resets
  /// the combo. Returns `true` when the run is over (the last life was
  /// just lost), which the caller must turn into an actual finish.
  bool recordKeystroke(KeystrokeResult result) {
    if (result != KeystrokeResult.substitution) {
      recordCorrect();
      return false;
    }
    return recordMistake();
  }

  /// Records one rejected (wrong) keystroke: costs a life and resets the
  /// combo. Returns `true` when that was the last life — the caller must
  /// then end the run.
  bool recordMistake() {
    if (isOver) return true;
    _livesRemaining--;
    _currentStreak = 0;
    return isOver;
  }

  /// Records the current snippet being completed, with the run moving on
  /// to the next one.
  void recordSnippetCleared() => _snippetsCleared++;

  int _multiplierFor(int streak) =>
      (1 + streak ~/ streakPerMultiplierStep).clamp(1, maxMultiplier);
}
