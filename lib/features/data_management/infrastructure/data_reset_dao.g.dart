// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_reset_dao.dart';

// ignore_for_file: type=lint
mixin _$DataResetDaoMixin on DatabaseAccessor<AppDatabase> {
  $GuestProfilesTable get guestProfiles => attachedDatabase.guestProfiles;
  $TypingSessionsTable get typingSessions => attachedDatabase.typingSessions;
  $KeystrokeEventsTable get keystrokeEvents => attachedDatabase.keystrokeEvents;
  $ProgressSnapshotCacheTable get progressSnapshotCache =>
      attachedDatabase.progressSnapshotCache;
  $MasteryStatusCacheTable get masteryStatusCache =>
      attachedDatabase.masteryStatusCache;
  $ProcessedSessionsTable get processedSessions =>
      attachedDatabase.processedSessions;
  $LessonProgressCacheTable get lessonProgressCache =>
      attachedDatabase.lessonProgressCache;
  $AchievementsUnlockedTable get achievementsUnlocked =>
      attachedDatabase.achievementsUnlocked;
  $DailyChallengeCompletionsTable get dailyChallengeCompletions =>
      attachedDatabase.dailyChallengeCompletions;
  DataResetDaoManager get managers => DataResetDaoManager(this);
}

class DataResetDaoManager {
  final _$DataResetDaoMixin _db;
  DataResetDaoManager(this._db);
  $$GuestProfilesTableTableManager get guestProfiles =>
      $$GuestProfilesTableTableManager(_db.attachedDatabase, _db.guestProfiles);
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
  $$ProgressSnapshotCacheTableTableManager get progressSnapshotCache =>
      $$ProgressSnapshotCacheTableTableManager(
        _db.attachedDatabase,
        _db.progressSnapshotCache,
      );
  $$MasteryStatusCacheTableTableManager get masteryStatusCache =>
      $$MasteryStatusCacheTableTableManager(
        _db.attachedDatabase,
        _db.masteryStatusCache,
      );
  $$ProcessedSessionsTableTableManager get processedSessions =>
      $$ProcessedSessionsTableTableManager(
        _db.attachedDatabase,
        _db.processedSessions,
      );
  $$LessonProgressCacheTableTableManager get lessonProgressCache =>
      $$LessonProgressCacheTableTableManager(
        _db.attachedDatabase,
        _db.lessonProgressCache,
      );
  $$AchievementsUnlockedTableTableManager get achievementsUnlocked =>
      $$AchievementsUnlockedTableTableManager(
        _db.attachedDatabase,
        _db.achievementsUnlocked,
      );
  $$DailyChallengeCompletionsTableTableManager get dailyChallengeCompletions =>
      $$DailyChallengeCompletionsTableTableManager(
        _db.attachedDatabase,
        _db.dailyChallengeCompletions,
      );
}
