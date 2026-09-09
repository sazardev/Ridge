// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_progress_dao.dart';

// ignore_for_file: type=lint
mixin _$LessonProgressDaoMixin on DatabaseAccessor<AppDatabase> {
  $TypingSessionsTable get typingSessions => attachedDatabase.typingSessions;
  $LessonProgressCacheTable get lessonProgressCache =>
      attachedDatabase.lessonProgressCache;
  LessonProgressDaoManager get managers => LessonProgressDaoManager(this);
}

class LessonProgressDaoManager {
  final _$LessonProgressDaoMixin _db;
  LessonProgressDaoManager(this._db);
  $$TypingSessionsTableTableManager get typingSessions =>
      $$TypingSessionsTableTableManager(
        _db.attachedDatabase,
        _db.typingSessions,
      );
  $$LessonProgressCacheTableTableManager get lessonProgressCache =>
      $$LessonProgressCacheTableTableManager(
        _db.attachedDatabase,
        _db.lessonProgressCache,
      );
}
