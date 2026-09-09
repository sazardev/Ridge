// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progression_dao.dart';

// ignore_for_file: type=lint
mixin _$ProgressionDaoMixin on DatabaseAccessor<AppDatabase> {
  $TypingSessionsTable get typingSessions => attachedDatabase.typingSessions;
  $KeystrokeEventsTable get keystrokeEvents => attachedDatabase.keystrokeEvents;
  $ProgressSnapshotCacheTable get progressSnapshotCache =>
      attachedDatabase.progressSnapshotCache;
  $MasteryStatusCacheTable get masteryStatusCache =>
      attachedDatabase.masteryStatusCache;
  $ProcessedSessionsTable get processedSessions =>
      attachedDatabase.processedSessions;
  ProgressionDaoManager get managers => ProgressionDaoManager(this);
}

class ProgressionDaoManager {
  final _$ProgressionDaoMixin _db;
  ProgressionDaoManager(this._db);
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
}
