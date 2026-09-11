import 'package:ridge/features/practice/domain/entities/keystroke.dart';
import 'package:ridge/features/practice/domain/entities/keystroke_result.dart';
import 'package:ridge/features/practice/domain/services/key_layout_map.dart';
import 'package:ridge/features/practice/domain/value_objects/physical_key_id.dart';

/// Pure, stateful domain service that turns a live stream of physical key
/// events into classified [Keystroke]s against an expected snippet
/// (SPEC.md §4.1) — the heart of the capture engine.
///
/// Hard-locked: the committed buffer only ever advances on a character
/// that matches [expectedSnippet] at the current cursor. A mismatch is
/// still logged as its own [KeystrokeResult.substitution] event (finger,
/// timing, everything SPEC.md §4.1 wants) but is rejected — the cursor
/// does not move, and the user must retype the correct character before
/// anything else is accepted. This means the committed buffer is always
/// exactly the correct prefix of [expectedSnippet]; there is nothing to
/// "skip" or "insert ahead of," so omission/insertion/transposition
/// (meaningful only for a free-flowing buffer that can diverge in length
/// from the expected text) cannot occur and aren't modeled.
///
/// Backspace/Delete still let the user step back and redo — the
/// review cursor ([reviewCursor]) moves within the already-committed
/// prefix purely for navigation, and [ingestDelete] truncates the buffer
/// back to wherever it's pointing, but neither ever inserts or edits a
/// character in the middle without redoing everything after it.
class KeystrokeStreamRecorder {
  /// Creates a recorder that will classify typed characters against
  /// [expectedSnippet].
  new({required this.expectedSnippet});

  /// The static target text this session is typing towards.
  ///
  /// Mutable only via [retarget] — Sprint mode (SPEC.md §5.2) swaps this
  /// mid-run when the current snippet is finished before the countdown
  /// reaches zero, while every other mode leaves it untouched for the
  /// recorder's whole lifetime.
  String expectedSnippet;

  /// The committed, correctly-typed prefix — always a true prefix of
  /// [expectedSnippet] (hard lock guarantees this never diverges).
  final List<String> _buffer = [];

  /// Every keystroke ever emitted (forward attempts, rejected or
  /// committed, and corrections), in chronological order, keyed by
  /// [Keystroke.sequenceIndex] — append-only, nothing is ever rewritten
  /// or removed once emitted.
  final List<Keystroke> _allEvents = [];

  /// For each *current* buffer position, the index into [_allEvents]
  /// holding the correct keystroke that committed it — so backspace/
  /// delete can log an accurate correction referencing what's undone.
  final List<int> _committedEventIndexForPosition = [];

  int _seq = 0;

  /// Where arrow-key navigation currently points within the committed
  /// buffer, for review — `null` means "at the live end" (the default,
  /// and where every new keystroke commits regardless of where this last
  /// pointed, since navigation is read-only until [ingestDelete] acts on
  /// it).
  int? _reviewCursor;

  /// Bumped on every rejected (wrong) attempt — the UI keys a shake/flash
  /// animation off any change to this, mirroring how `PinDots.errorTick`
  /// already triggers a shake in this app's lock screen.
  int _rejectedTick = 0;

  KeyLayoutEntry _layoutOf(PhysicalKeyId id) =>
      keyLayoutMap[id] ?? (throw StateError('No KeyLayoutMap entry for $id'));

  /// Whether the full expected snippet has been correctly typed — the
  /// Zen-mode finish condition (no accuracy gate, per SPEC.md §5.1). Hard
  /// lock guarantees the buffer can never overshoot or permanently lag
  /// behind [expectedSnippet]'s length, so this is a plain length check.
  bool get isComplete => _buffer.length >= expectedSnippet.length;

  /// The expected-snippet index the next typed character will be judged
  /// against — always equal to the committed buffer's length.
  int get expectedCursor => _buffer.length;

  /// Where arrow-key review navigation currently points, or `null` for
  /// "at the live end" (the default state).
  int? get reviewCursor => _reviewCursor;

  /// Bumped on every rejected attempt — see the field doc for how the UI
  /// should use it.
  int get rejectedTick => _rejectedTick;

  /// For each index into [expectedSnippet]: `true` once correctly typed,
  /// `null` if not reached yet. Never `false` — a position that's been
  /// attempted but not yet solved simply stays `null` until it is,
  /// exactly reflecting hard lock's guarantee that nothing wrong is ever
  /// committed.
  List<bool?> get expectedCharStatuses => [
    for (var i = 0; i < expectedSnippet.length; i++)
      if (i < _buffer.length) true else null,
  ];

  /// Every keystroke emitted so far, including rejected attempts.
  List<Keystroke> get keystrokes => List.unmodifiable(_allEvents);

  /// Records a printable keydown that produced [char], typed via
  /// [physicalKeyId]. Always anchored at the live end (typing resets any
  /// active [reviewCursor] navigation back to `null`). Returns the
  /// classified [Keystroke] — [KeystrokeResult.correct] and committed if
  /// [char] matches the expected character, [KeystrokeResult.substitution]
  /// and rejected (buffer unchanged) otherwise. Returns `null` if
  /// [isComplete] already (nothing left to type).
  Keystroke? ingestChar({
    required PhysicalKeyId physicalKeyId,
    required String char,
    Duration? dwell,
    Duration? flight,
  }) {
    _reviewCursor = null;
    final expectedChar = _expectedCharAt(_buffer.length);
    if (expectedChar == null) return null;

    final layout = _layoutOf(physicalKeyId);
    final matches = char == expectedChar;
    final keystroke = Keystroke(
      physicalKeyId: physicalKeyId,
      expectedChar: expectedChar,
      actualChar: char,
      result: matches ? KeystrokeResult.correct : KeystrokeResult.substitution,
      isCorrection: false,
      finger: layout.finger,
      keyboardRow: layout.row,
      dwell: dwell,
      flight: flight,
      sequenceIndex: _seq++,
    );
    _allEvents.add(keystroke);
    if (matches) {
      _buffer.add(char);
      _committedEventIndexForPosition.add(_allEvents.length - 1);
    } else {
      _rejectedTick++;
    }
    return keystroke;
  }

  /// Records a Tab keydown, with one comfort accommodation on top of
  /// plain [ingestChar]: `gofmt` pads struct/const/var blocks with a
  /// *run* of literal spaces to align a later column (e.g. `Msg   string`
  /// next to `Field string`) — nobody actually retypes each of those
  /// alignment spaces by hand in real Go, so requiring exactly that here
  /// would be the opposite of "real code, not filler". If the next
  /// expected character is a space, this consumes the *entire* run of
  /// consecutive expected spaces from here in one press (each still its
  /// own committed [Keystroke], only the first carrying real dwell/
  /// flight — mirrors [ingestDelete]'s batched-corrections pattern);
  /// real leading-indentation tabs (`expectedSnippet` uses `'\t'` for
  /// those, never a space) are untouched and still need a real Tab per
  /// level, exactly as before. Anywhere else, this is just [ingestChar]
  /// with `'\t'` — rejected like any other wrong key if it doesn't
  /// match.
  List<Keystroke> ingestTabKey({
    required PhysicalKeyId physicalKeyId,
    Duration? dwell,
    Duration? flight,
  }) {
    if (_expectedCharAt(_buffer.length) != ' ') {
      final keystroke = ingestChar(
        physicalKeyId: physicalKeyId,
        char: '\t',
        dwell: dwell,
        flight: flight,
      );
      return keystroke == null ? const [] : [keystroke];
    }

    final committed = <Keystroke>[];
    while (_expectedCharAt(_buffer.length) == ' ') {
      final keystroke = ingestChar(
        physicalKeyId: physicalKeyId,
        char: ' ',
        dwell: committed.isEmpty ? dwell : null,
        flight: committed.isEmpty ? flight : null,
      );
      if (keystroke == null) break;
      committed.add(keystroke);
    }
    return committed;
  }

  /// Records an Enter keydown, with the same kind of comfort accommodation
  /// as [ingestTabKey]: a blank or whitespace-only line is pure vertical
  /// spacing, not real code anyone deliberately retypes — after the real
  /// `\n` itself is correctly typed (still its own hard-locked keystroke,
  /// rejected like any other if this isn't actually where a newline is
  /// expected), this auto-consumes every immediately following line that
  /// has no non-whitespace character before its own `\n` (or the
  /// snippet's end), landing on the first real character of the next
  /// non-blank line in one press. Each auto-consumed character is still
  /// its own committed [Keystroke] (only the first carries real dwell/
  /// flight, exactly like [ingestTabKey]'s space-run). A line that
  /// *starts* with whitespace but then has real code (ordinary leading
  /// indentation) is left untouched — that's still typed one key at a
  /// time (or via [ingestTabKey]), same as before.
  List<Keystroke> ingestEnterKey({
    required PhysicalKeyId physicalKeyId,
    Duration? dwell,
    Duration? flight,
  }) {
    final first = ingestChar(
      physicalKeyId: physicalKeyId,
      char: '\n',
      dwell: dwell,
      flight: flight,
    );
    if (first == null) return const [];
    if (first.result != KeystrokeResult.correct) return [first];

    final committed = [first];
    while (_isAtBlankLine()) {
      final expected = _expectedCharAt(_buffer.length);
      if (expected == null) break;
      final keystroke = ingestChar(
        physicalKeyId: physicalKeyId,
        char: expected,
      );
      if (keystroke == null) break;
      committed.add(keystroke);
    }
    return committed;
  }

  /// Records a backspace keydown, undoing the newest committed position.
  /// Returns the correction [Keystroke] (its own event, distinct from the
  /// keystroke it undoes — SPEC.md §4.1), or `null` if the buffer was
  /// already empty.
  Keystroke? ingestBackspace({
    required PhysicalKeyId physicalKeyId,
    Duration? dwell,
    Duration? flight,
  }) {
    _reviewCursor = null;
    return _removeLastCommitted(
      physicalKeyId: physicalKeyId,
      dwell: dwell,
      flight: flight,
    );
  }

  /// Truncates the committed buffer back to wherever [reviewCursor] is
  /// currently pointing — a bulk "redo from here" rather than repeated
  /// backspacing. A no-op (returns an empty list) if [reviewCursor] is
  /// `null` (at the live end — nothing ahead of it to remove) or already
  /// at the very start.
  List<Keystroke> ingestDelete({
    required PhysicalKeyId physicalKeyId,
    Duration? dwell,
    Duration? flight,
  }) {
    final from = _reviewCursor;
    if (from == null || from >= _buffer.length) return const [];

    final removed = <Keystroke>[];
    while (_buffer.length > from) {
      final correction = _removeLastCommitted(
        physicalKeyId: physicalKeyId,
        // Only the first removal in the batch carries the real physical
        // keydown's timing; the rest are synthetic follow-on corrections
        // triggered by the same single keypress.
        dwell: removed.isEmpty ? dwell : null,
        flight: removed.isEmpty ? flight : null,
      );
      if (correction != null) removed.add(correction);
    }
    _reviewCursor = null;
    return removed;
  }

  /// Moves the review cursor one position left within the committed
  /// buffer (towards the start), for read-only navigation — typing
  /// always still commits at the live end regardless of where this
  /// points. A no-op if the buffer is empty.
  void moveReviewCursorLeft() {
    if (_buffer.isEmpty) return;
    final current = _reviewCursor ?? _buffer.length;
    _reviewCursor = (current - 1).clamp(0, _buffer.length);
  }

  /// Moves the review cursor one position right, back towards the live
  /// end — snapping to `null` (live end) once it gets there. A no-op if
  /// already at the live end.
  void moveReviewCursorRight() {
    final current = _reviewCursor;
    if (current == null) return;
    final next = current + 1;
    _reviewCursor = next >= _buffer.length ? null : next;
  }

  /// Returns the final, closed keystroke log — call this once, when the
  /// session ends. Hard lock means there's never anything left ambiguous
  /// or "in flight" to resolve (every keystroke is final the instant it's
  /// typed), so this is simply the full log.
  List<Keystroke> finish() => keystrokes;

  /// Ends the session at a hard external deadline (SPEC.md §5.2's Sprint
  /// countdown reaching zero) rather than because the buffer naturally
  /// ran out of text. Identical to [finish] under hard lock — there is
  /// no longer a notion of a still-ambiguous trailing keystroke to drop,
  /// since every keydown is classified conclusively the instant it
  /// arrives.
  List<Keystroke> forceFinishAtDeadline() => keystrokes;

  /// Swaps the target text mid-run (SPEC.md §5.2's Sprint queue): resets
  /// per-position tracking for [newExpectedSnippet] while preserving the
  /// full keystroke log ([_allEvents]/[_seq]) — so a finished Sprint
  /// run's keystrokes span every snippet typed, contiguously numbered in
  /// one sequence, exactly as if they'd all been typed against a single,
  /// longer snippet.
  void retarget(String newExpectedSnippet) {
    expectedSnippet = newExpectedSnippet;
    _buffer.clear();
    _committedEventIndexForPosition.clear();
    _reviewCursor = null;
  }

  /// Retroactively attaches [dwell] to the keystroke at [sequenceIndex].
  ///
  /// Dwell (keyup minus keydown) can only be known once the matching
  /// keyup event arrives, which is necessarily *after* the keystroke was
  /// already classified on keydown — the capture widget calls this once
  /// that keyup arrives. Safe because every emitted keystroke's list
  /// position always equals its own [Keystroke.sequenceIndex] (entries
  /// are only ever appended, never reordered or removed).
  void patchDwell({required int sequenceIndex, required Duration dwell}) {
    if (sequenceIndex < 0 || sequenceIndex >= _allEvents.length) return;
    _allEvents[sequenceIndex] = _allEvents[sequenceIndex].copyWith(
      dwell: dwell,
    );
  }

  String? _expectedCharAt(int index) =>
      index >= 0 && index < expectedSnippet.length
      ? expectedSnippet[index]
      : null;

  /// Whether the cursor sits at the start of a line that has nothing but
  /// spaces/tabs before its terminating `\n` (or the snippet's end) —
  /// i.e. a blank line with no real code in it, for [ingestEnterKey].
  bool _isAtBlankLine() {
    var i = _buffer.length;
    if (i >= expectedSnippet.length) return false;
    while (i < expectedSnippet.length && expectedSnippet[i] != '\n') {
      if (expectedSnippet[i] != ' ' && expectedSnippet[i] != '\t') {
        return false;
      }
      i++;
    }
    return true;
  }

  Keystroke? _removeLastCommitted({
    required PhysicalKeyId physicalKeyId,
    Duration? dwell,
    Duration? flight,
  }) {
    if (_buffer.isEmpty) return null;
    final undone = _allEvents[_committedEventIndexForPosition.removeLast()];
    _buffer.removeLast();

    final layout = _layoutOf(physicalKeyId);
    final correction = Keystroke(
      physicalKeyId: physicalKeyId,
      expectedChar: undone.expectedChar,
      result: undone.result,
      isCorrection: true,
      finger: layout.finger,
      keyboardRow: layout.row,
      dwell: dwell,
      flight: flight,
      sequenceIndex: _seq++,
    );
    _allEvents.add(correction);
    return correction;
  }
}
