import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/learning_paths/domain/value_objects/lesson_id.dart';
import 'package:just_in_time/features/profile/domain/value_objects/profile_id.dart';

/// Driven port for destructive, user-initiated local-data cleanup (the
/// Settings screen's "danger zone", SPEC.md-adjacent): resetting one
/// lesson, resetting every lesson, or wiping every table this device
/// holds — including the Guest Profile itself.
///
/// Every method here only touches raw storage; recomputing derived
/// caches (`lesson_progress_cache`, the `progression` snapshot) after a
/// reset is the caller's job, the same composition pattern
/// `practice_session_controller.dart` already uses after finishing a
/// session — this port stays a narrow, honest "delete these rows".
abstract interface class DataResetRepository {
  /// Deletes every one of [profileId]'s `typing_sessions` (and their
  /// `keystroke_events`/processed markers) tagged with [lessonId] —
  /// every attempt at that one lesson, gone.
  Future<Result<void, AppFailure>> resetLesson({
    required ProfileId profileId,
    required LessonId lessonId,
  });

  /// Deletes every one of [profileId]'s `typing_sessions` (and their
  /// `keystroke_events`/processed markers) tagged with any lesson id —
  /// every attempt at every lesson, across every learning path, gone.
  Future<Result<void, AppFailure>> resetAllLessons(ProfileId profileId);

  /// Deletes every row in every table this app owns, across every
  /// profile — sessions, keystrokes, caches, unlocked achievements, and
  /// the Guest Profile row itself. There is no [ProfileId] parameter:
  /// this app only ever has one on-device profile (SPEC.md §7.1), and a
  /// full wipe means starting over as a brand-new guest.
  Future<Result<void, AppFailure>> wipeAllData();
}
