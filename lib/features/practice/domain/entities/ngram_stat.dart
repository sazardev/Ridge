import 'package:freezed_annotation/freezed_annotation.dart';

part 'ngram_stat.freezed.dart';

/// Derived metrics for one 2- or 3-character sequence observed *within a
/// single session* (SPEC.md §4.2's "encadenamientos"/n-gramas).
///
/// This is intentionally session-scoped, computed in-memory by
/// `MetricsCalculator` from that session's own keystrokes — it is *not*
/// the cross-session weakness-ranking n-gram query described in the
/// project plan (that's a `progression`-phase concern querying persisted
/// `keystroke_events` across many sessions via a SQL self-join).
@freezed
abstract class NgramStat with _$NgramStat {
  /// Creates an immutable per-n-gram stat snapshot.
  const factory({
    required String text,
    required int occurrences,
    required int errorCount,
    required double avgDurationMs,
  }) = _NgramStat;
}
