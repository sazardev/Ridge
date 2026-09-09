// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'practice_dao.dart';

// ignore_for_file: type=lint
mixin _$PracticeDaoMixin on DatabaseAccessor<AppDatabase> {
  $TypingSessionsTable get typingSessions => attachedDatabase.typingSessions;
  $KeystrokeEventsTable get keystrokeEvents => attachedDatabase.keystrokeEvents;
  PracticeDaoManager get managers => PracticeDaoManager(this);
}

class PracticeDaoManager {
  final _$PracticeDaoMixin _db;
  PracticeDaoManager(this._db);
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
}
