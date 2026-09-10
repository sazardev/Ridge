import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';

part 'mastery_status.freezed.dart';

/// Dominance certification for one (category, difficulty) pair (SPEC.md
/// §6.4) — computed by `MasteryEvaluator` from the last 5 Precision-mode
/// sessions for that pair.
@freezed
abstract class MasteryStatus with _$MasteryStatus {
  /// Creates an immutable mastery snapshot.
  const factory({
    required ContentCategory category,
    required Difficulty difficulty,
    required bool isMastered,
    required DateTime evaluatedAt,
    // `null` when fewer than 5 Precision sessions have ever been played
    // for this pair — there isn't enough history to certify or decay
    // yet, distinct from "certified but currently passing 0/5".
    int? passCountInLastFive,
  }) = _MasteryStatus;
}
