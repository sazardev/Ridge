import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:just_in_time/features/content/domain/entities/content_category.dart';
import 'package:just_in_time/features/content/domain/value_objects/snippet_id.dart';

part 'session_activity_sample.freezed.dart';

/// One raw finished-session observation feeding activity ranking — just
/// the fields `ActivityRankingCalculator` needs to compute "most
/// practiced"/"lowest scoring" per category and per exercise, pulled
/// from `typing_sessions` across a profile's full history.
@freezed
abstract class SessionActivitySample with _$SessionActivitySample {
  /// Creates an immutable activity-sample read view.
  const factory({
    required SnippetId snippetId,
    required ContentCategory category,
    required Duration duration,
    required double netSpeedCpm,
    required double accuracyPct,
    required DateTime occurredAtUtc,
  }) = _SessionActivitySample;
}
