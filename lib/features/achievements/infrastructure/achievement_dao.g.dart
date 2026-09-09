// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement_dao.dart';

// ignore_for_file: type=lint
mixin _$AchievementDaoMixin on DatabaseAccessor<AppDatabase> {
  $TypingSessionsTable get typingSessions => attachedDatabase.typingSessions;
  $KeystrokeEventsTable get keystrokeEvents => attachedDatabase.keystrokeEvents;
  $AchievementsUnlockedTable get achievementsUnlocked =>
      attachedDatabase.achievementsUnlocked;
  AchievementDaoManager get managers => AchievementDaoManager(this);
}

class AchievementDaoManager {
  final _$AchievementDaoMixin _db;
  AchievementDaoManager(this._db);
  $$TypingSessionsTableTableManager get typingSessions =>
      $$TypingSessionsTableTableManager(
        _db.attachedDatabase,
        _db.typingSessions,
      );
  $$KeystrokeEventsTableTableManager get keystrokeEvents =>
      $$KeystrokeEventsTableTableManager(
        _db.attachedDatabase,
        _db.keystrokeEvents,
      );
  $$AchievementsUnlockedTableTableManager get achievementsUnlocked =>
      $$AchievementsUnlockedTableTableManager(
        _db.attachedDatabase,
        _db.achievementsUnlocked,
      );
}
