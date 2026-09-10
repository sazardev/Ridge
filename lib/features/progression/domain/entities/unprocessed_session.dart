import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
import 'package:ridge/features/practice/domain/value_objects/typing_session_id.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';

part 'unprocessed_session.freezed.dart';

/// A finished `practice` session that hasn't yet been annotated with real
/// `xp_awarded`/`is_first_completion` values — exactly the fields
/// `RecomputeProgressSnapshotUseCase` needs to compute both, without
/// pulling in the rest of `TypingSession` (which `progression` has no
/// business depending on wholesale).
@freezed
abstract class UnprocessedSession with _$UnprocessedSession {
  /// Creates an immutable unprocessed-session read view.
  const factory({
    required TypingSessionId id,
    required ProfileId profileId,
    required SnippetId snippetId,
    required ContentCategory category,
    required Difficulty difficulty,
    // `PracticeMode`'s discriminator name — only ever compared against
    // `'precision'` here, so a plain string avoids reconstructing the
    // full sealed `PracticeMode` (which also carries a threshold this
    // use case doesn't need) from its persisted column.
    required String mode,
    required double accuracyPct,
    required int correctFirstTryChars,
    required DateTime startedAtUtc,
  }) = _UnprocessedSession;
}
