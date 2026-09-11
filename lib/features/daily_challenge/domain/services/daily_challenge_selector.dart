import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/daily_challenge/domain/value_objects/challenge_date.dart';

/// Pure, stateless "which snippet is today's Daily Challenge" selection
/// (SPEC.md §5.4) — deterministic from [ChallengeDate] alone, so every
/// device computes the same answer for the same day without ever asking
/// a server.
///
/// Filtering candidates down to the shared pool (Go, beginner/
/// intermediate, active-only) is the caller's job — this service only
/// picks one entry out of whatever pool it's handed.
class DailyChallengeSelector {
  /// Creates the (stateless) selector.
  const new();

  /// Deterministically picks one of [candidates] for [date], or `null`
  /// if [candidates] is empty.
  ///
  /// [candidates] is sorted by [Snippet.id] first so the result never
  /// depends on JSON-asset read order or map-iteration order, then
  /// indexed by a hash of [ChallengeDate.isoKey]. The hash is a
  /// hand-written 32-bit FNV-1a, not `String.hashCode` — Dart doesn't
  /// guarantee `hashCode` is stable across SDK versions or platforms
  /// (native vs. web), and two devices disagreeing on the index would
  /// silently break "the same snippet worldwide." FNV-1a is fully owned
  /// by this file and never changes unless this file does.
  Snippet? selectFor({
    required ChallengeDate date,
    required List<Snippet> candidates,
  }) {
    if (candidates.isEmpty) return null;
    final sorted = [...candidates]
      ..sort((a, b) => a.id.value.compareTo(b.id.value));
    final index = _fnv1a32(date.isoKey) % sorted.length;
    return sorted[index];
  }

  static int _fnv1a32(String input) {
    var hash = 0x811c9dc5;
    for (final codeUnit in input.codeUnits) {
      hash ^= codeUnit;
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }
    return hash;
  }
}
