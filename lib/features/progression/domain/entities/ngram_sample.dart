import 'package:freezed_annotation/freezed_annotation.dart';

part 'ngram_sample.freezed.dart';

/// One raw 2-character n-gram observation feeding weakness ranking — two
/// adjacent forward keystrokes within the same session (`k2.seq =
/// k1.seq + 1`), across many sessions within the recency window.
@freezed
abstract class NgramSample with _$NgramSample {
  /// Creates an immutable n-gram-sample read view.
  const factory({
    required String text,
    required bool isError,
    required double flightMs,
    required DateTime occurredAtUtc,
  }) = _NgramSample;
}
