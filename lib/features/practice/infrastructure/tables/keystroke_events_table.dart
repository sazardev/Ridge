import 'package:drift/drift.dart';

/// Drift table for one captured keystroke event — mirrors `Keystroke`
/// column-for-column, plus the session-scoping/partitioning columns from
/// the project plan's schema. Append-only: a row is written once and
/// never updated or deleted (SPEC.md §8.1).
@DataClassName('KeystrokeEventRow')
class KeystrokeEvents extends Table {
  /// The owning session's `TypingSessionId` value.
  TextColumn get sessionId => text()();

  /// Monotonically increasing per-session sequence number.
  IntColumn get seq => integer()();

  /// The owning session's start time, denormalized onto every row purely
  /// as an index/partition key (not a second source of truth) so
  /// window-bounded queries never need to join back to
  /// `typing_sessions` just to filter by recency.
  IntColumn get sessionStartedAtUtcMicros => integer()();

  /// The character expected at this position, or `null` for a pure
  /// insertion (no expected character) or when not applicable.
  TextColumn get expectedChar => text().nullable()();

  /// The character actually typed, or `null` for a correction event
  /// (nothing remains typed at that position after a backspace).
  TextColumn get actualChar => text().nullable()();

  /// `KeystrokeResult`'s enum name.
  TextColumn get result => text()();

  /// Whether this row is a backspace/correction event rather than a
  /// forward-typed character.
  BoolColumn get isCorrection => boolean()();

  /// `PhysicalKeyId`'s enum name.
  TextColumn get physicalKeyId => text()();

  /// `Finger`'s enum name.
  TextColumn get finger => text()();

  /// `KeyboardRow`'s enum name.
  TextColumn get keyboardRow => text()();

  /// Key-down-to-key-up duration for this key, in microseconds, when the
  /// platform allows measuring it.
  IntColumn get dwellMicros => integer().nullable()();

  /// Duration since the previous keydown, in microseconds.
  IntColumn get flightMicros => integer().nullable()();

  /// Which third (0, 1, or 2) of the session this event falls in,
  /// precomputed once at finish time (SPEC.md §4.2's fatigue curve).
  IntColumn get thirdIndex => integer()();

  @override
  Set<Column> get primaryKey => {sessionId, seq};
}
