import 'package:drift/drift.dart';

/// Drift table recording one unlocked SPEC.md §12 achievement — the one
/// *primary* (not cache) table this feature owns: an unlock, once
/// recorded, is a permanent fact never rebuilt from anything else (see
/// `Achievement`'s class doc on the monotonic-ratchet design). Append-
/// mostly: a row is inserted once (`INSERT OR IGNORE`, per
/// `AchievementDao.insertUnlockIfAbsent`) and never updated or deleted.
@DataClassName('AchievementUnlockedRow')
class AchievementsUnlocked extends Table {
  /// The `ProfileId` this unlock belongs to.
  TextColumn get profileId => text()();

  /// `AchievementId.storageKey` — see that getter's class doc for the
  /// encoding.
  TextColumn get achievementId => text()();

  /// When this achievement was first unlocked, as UTC microseconds since
  /// epoch — never updated after the row is first inserted.
  IntColumn get unlockedAtUtcMicros => integer()();

  /// The `TypingSessionId` that triggered this unlock, when the
  /// achievement is tied to one specific session ("Cero Errores"/
  /// "Ambidiestro") — `null` for streak/mastery/marathon badges.
  TextColumn get triggerSessionId => text().nullable()();

  @override
  Set<Column> get primaryKey => {profileId, achievementId};
}
