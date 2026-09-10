import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/practice/domain/entities/keystroke.dart';
import 'package:ridge/features/practice/domain/entities/typing_session.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';

/// Driven port: the application core depends on this abstraction only.
/// Infrastructure provides the adapter (a local drift table pair —
/// `typing_sessions`/`keystroke_events`, see the project plan).
///
/// This is deliberately the *minimal* read surface `practice`'s own
/// presentation layer needs (a session-result/history view) — it is not
/// the full weakness/mastery/streak query surface `progression` will
/// need. A later `progression` phase queries the same tables directly
/// through its own DAO rather than through this port, so this interface
/// never has to grow to serve concerns outside `practice`.
abstract interface class SessionRepository {
  /// Persists [session] and every one of its [keystrokes] in a single
  /// transaction — a finished session and its capture data are one
  /// atomic, immutable unit (SPEC.md §8.1).
  Future<Result<void, AppFailure>> persistSession({
    required TypingSession session,
    required List<Keystroke> keystrokes,
  });

  /// Emits every finished session belonging to [profileId], most recent
  /// first, and every subsequent change — powers a personal session
  /// history/result view.
  Stream<List<TypingSession>> watchSessionsForProfile(ProfileId profileId);
}
