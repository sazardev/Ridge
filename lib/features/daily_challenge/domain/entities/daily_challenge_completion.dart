import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
import 'package:ridge/features/daily_challenge/domain/value_objects/challenge_date.dart';
import 'package:ridge/features/practice/domain/value_objects/typing_session_id.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';

part 'daily_challenge_completion.freezed.dart';

/// The one persisted, immutable fact that [profileId] played the shared
/// snippet of [date] (SPEC.md §5.4) — at most one per (profile, date),
/// enforced by `daily_challenge_completions`' composite primary key.
/// [snippetId]/[snippetRevision] are frozen at the moment of completion:
/// a later catalog change can never retroactively alter an
/// already-played day (SPEC.md §3.2).
@freezed
abstract class DailyChallengeCompletion with _$DailyChallengeCompletion {
  /// Creates a completed Daily Challenge attempt record.
  const factory({
    required ProfileId profileId,
    required ChallengeDate date,
    required SnippetId snippetId,
    required int snippetRevision,
    required TypingSessionId sessionId,
    required int score,
    required bool passed,
    required DateTime completedAtUtc,
  }) = _DailyChallengeCompletion;
}
