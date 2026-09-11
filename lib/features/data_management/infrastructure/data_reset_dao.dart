import 'package:drift/drift.dart';

import 'package:ridge/core/persistence/drift/app_database.dart';
import 'package:ridge/features/achievements/infrastructure/tables/achievements_unlocked_table.dart';
import 'package:ridge/features/daily_challenge/infrastructure/tables/daily_challenge_completions_table.dart';
import 'package:ridge/features/learning_paths/infrastructure/tables/lesson_progress_cache_table.dart';
import 'package:ridge/features/practice/infrastructure/tables/keystroke_events_table.dart';
import 'package:ridge/features/practice/infrastructure/tables/typing_sessions_table.dart';
import 'package:ridge/features/profile/infrastructure/tables/guest_profiles_table.dart';
import 'package:ridge/features/progression/infrastructure/tables/mastery_status_cache_table.dart';
import 'package:ridge/features/progression/infrastructure/tables/processed_sessions_table.dart';
import 'package:ridge/features/progression/infrastructure/tables/progress_snapshot_cache_table.dart';

part 'data_reset_dao.g.dart';

/// `data_management`-owned queries issued directly against every other
/// feature's drift tables (an allowed infrastructure-to-infrastructure
/// import — the same pattern `progression`'s `ProgressionDao`/
/// `learning_paths`' `LessonProgressDao`/`achievements`' `AchievementDao`
/// already establish, just broader: this DAO's whole reason to exist is
/// deleting rows across every hexagon at once). Owns no table itself.
@DriftAccessor(
  tables: [
    GuestProfiles,
    TypingSessions,
    KeystrokeEvents,
    ProgressSnapshotCache,
    MasteryStatusCache,
    ProcessedSessions,
    LessonProgressCache,
    AchievementsUnlocked,
    DailyChallengeCompletions,
  ],
)
class DataResetDao extends DatabaseAccessor<AppDatabase>
    with _$DataResetDaoMixin {
  /// Creates the DAO bound to the shared [AppDatabase].
  new(super.attachedDatabase);

  /// Deletes every `typing_sessions` row for [profileId] matching
  /// [lessonIdFilter] (an exact lesson id, or `null` to match every
  /// lesson-tagged session regardless of which lesson), plus every
  /// `keystroke_events`/`processed_sessions` row that references one of
  /// those sessions — one atomic transaction so a reset never leaves
  /// orphaned keystrokes or processed-markers behind.
  Future<void> _deleteLessonSessions({
    required String profileId,
    String? lessonIdFilter,
  }) {
    return transaction(() async {
      final lessonIdCondition = lessonIdFilter == null
          ? typingSessions.lessonId.isNotNull()
          : typingSessions.lessonId.equals(lessonIdFilter);
      final sessionIds =
          await (selectOnly(typingSessions)
                ..addColumns([typingSessions.id])
                ..where(
                  typingSessions.profileId.equals(profileId) &
                      lessonIdCondition,
                ))
              .map((row) => row.read(typingSessions.id)!)
              .get();
      if (sessionIds.isEmpty) return;

      await (delete(
        keystrokeEvents,
      )..where((row) => row.sessionId.isIn(sessionIds))).go();
      await (delete(
        processedSessions,
      )..where((row) => row.sessionId.isIn(sessionIds))).go();
      await (delete(
        typingSessions,
      )..where((row) => row.id.isIn(sessionIds))).go();
    });
  }

  /// Deletes every attempt [profileId] made at [lessonId] specifically.
  Future<void> deleteLessonSessions({
    required String profileId,
    required String lessonId,
  }) => _deleteLessonSessions(profileId: profileId, lessonIdFilter: lessonId);

  /// Deletes every attempt [profileId] made at any lesson.
  Future<void> deleteAllLessonSessions(String profileId) =>
      _deleteLessonSessions(profileId: profileId);

  /// Deletes every row in every table this app owns, across every
  /// profile — one atomic transaction, so the app is never left in a
  /// half-wiped state (e.g. sessions gone but the profile still there)
  /// if something fails partway through.
  Future<void> wipeEverything() {
    return transaction(() async {
      await delete(keystrokeEvents).go();
      await delete(typingSessions).go();
      await delete(processedSessions).go();
      await delete(progressSnapshotCache).go();
      await delete(masteryStatusCache).go();
      await delete(lessonProgressCache).go();
      await delete(achievementsUnlocked).go();
      await delete(dailyChallengeCompletions).go();
      await delete(guestProfiles).go();
    });
  }
}
