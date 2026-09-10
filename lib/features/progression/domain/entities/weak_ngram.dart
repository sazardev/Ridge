import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ridge/features/progression/domain/entities/trend.dart';

part 'weak_ngram.freezed.dart';

/// One entry in the "weakest n-grams" ranked list (SPEC.md §4.2's
/// "encadenamientos" turned into a diagnostic top-N) — cross-session,
/// unlike `practice`'s own single-session `NgramStat`.
@freezed
abstract class WeakNgram with _$WeakNgram {
  /// Creates an immutable ranked-entry snapshot.
  const factory({
    required String text,
    required double score,
    required Trend trend,
  }) = _WeakNgram;
}
