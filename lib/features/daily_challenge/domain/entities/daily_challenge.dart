import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
import 'package:ridge/features/daily_challenge/domain/value_objects/challenge_date.dart';

part 'daily_challenge.freezed.dart';

/// The shared snippet assigned to a given [date] (SPEC.md §5.4) — every
/// profile in the world gets the same [snippetId]/[snippetRevision] for
/// the same [date], computed deterministically rather than fetched from
/// a server. Never persisted on its own: it's the pure output of the
/// daily-snippet selector, recomputed on demand from the still-active
/// catalog.
@freezed
abstract class DailyChallenge with _$DailyChallenge {
  /// Creates the day's computed snippet assignment.
  const factory({
    required ChallengeDate date,
    required SnippetId snippetId,
    required int snippetRevision,
  }) = _DailyChallenge;
}
