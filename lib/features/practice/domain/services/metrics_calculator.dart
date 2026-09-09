import 'dart:math' as math;

import 'package:just_in_time/features/practice/domain/entities/character_stat.dart';
import 'package:just_in_time/features/practice/domain/entities/finger.dart';
import 'package:just_in_time/features/practice/domain/entities/finger_stat.dart';
import 'package:just_in_time/features/practice/domain/entities/hand.dart';
import 'package:just_in_time/features/practice/domain/entities/keystroke.dart';
import 'package:just_in_time/features/practice/domain/entities/keystroke_result.dart';
import 'package:just_in_time/features/practice/domain/entities/ngram_stat.dart';
import 'package:just_in_time/features/practice/domain/entities/session_metrics.dart';
import 'package:just_in_time/features/practice/domain/value_objects/physical_key_id.dart';

const _ngramSizes = [2, 3];

/// Pure, stateless derivation of [SessionMetrics] from a closed keystroke
/// log (SPEC.md §4.2). No clock, no widget, no I/O — every input
/// (keystrokes, expected text, total duration) is supplied by the
/// caller, which is what makes this unit-testable with fully fabricated
/// data.
class MetricsCalculator {
  /// Creates the (stateless) calculator.
  const new();

  /// Derives [SessionMetrics] from [keystrokes] captured while typing
  /// [expectedSnippet] over [totalDuration].
  SessionMetrics calculate({
    required List<Keystroke> keystrokes,
    required String expectedSnippet,
    required Duration totalDuration,
  }) {
    final forward = [
      for (final k in keystrokes)
        if (!k.isCorrection) k,
    ];
    final minutes =
        totalDuration.inMicroseconds / Duration.microsecondsPerMinute;
    final correctCount = forward
        .where((k) => k.result == KeystrokeResult.correct)
        .length;
    final fatigueThirds = _fatigueThirds(forward);

    return SessionMetrics(
      rawSpeedCpm: _perMinute(forward.length, minutes),
      netSpeedCpm: _perMinute(correctCount, minutes),
      accuracyPct: forward.isEmpty ? 0 : correctCount / forward.length * 100,
      consistencyScore: _consistencyScore(forward),
      maxStreak: _maxStreak(forward),
      fatigueFirstThirdCpm: fatigueThirds[0],
      fatigueMiddleThirdCpm: fatigueThirds[1],
      fatigueLastThirdCpm: fatigueThirds[2],
      handBalanceRatio: _handBalanceRatio(forward),
      characterStats: _characterStats(forward),
      fingerStats: _fingerStats(forward),
      ngramStats: _ngramStats(forward),
      keyHeatmap: _keyHeatmap(forward),
    );
  }

  double _perMinute(int count, double minutes) =>
      minutes <= 0 ? 0 : count / minutes;

  double _consistencyScore(List<Keystroke> forward) {
    final flightsMs = [
      for (final k in forward)
        if (k.flight != null) k.flight!.inMicroseconds / 1000,
    ];
    if (flightsMs.length < 2) return 100;
    final mean = flightsMs.reduce((a, b) => a + b) / flightsMs.length;
    if (mean <= 0) return 100;
    final variance =
        flightsMs.map((f) => (f - mean) * (f - mean)).reduce((a, b) => a + b) /
        flightsMs.length;
    final stdDev = math.sqrt(variance);
    return (100 * (1 - stdDev / mean)).clamp(0, 100).toDouble();
  }

  int _maxStreak(List<Keystroke> forward) {
    var current = 0;
    var max = 0;
    for (final k in forward) {
      if (k.result == KeystrokeResult.correct) {
        current += 1;
        if (current > max) max = current;
      } else {
        current = 0;
      }
    }
    return max;
  }

  /// CPM for the first/middle/last third of [forward], split by *count*
  /// into three index ranges. Elapsed time per third is approximated as
  /// the sum of that third's own inter-keystroke `flight` durations —
  /// each `flight` already represents "time since the previous keydown",
  /// so summing them over a range approximates the wall-clock span spent
  /// typing it.
  List<double> _fatigueThirds(List<Keystroke> forward) {
    final n = forward.length;
    if (n == 0) return const [0, 0, 0];
    final thirdSize = n ~/ 3;
    final ranges = [
      (0, thirdSize),
      (thirdSize, thirdSize * 2),
      (thirdSize * 2, n),
    ];
    return [
      for (final (start, end) in ranges) _cpmForRange(forward, start, end),
    ];
  }

  double _cpmForRange(List<Keystroke> forward, int start, int end) {
    if (end <= start) return 0;
    final slice = forward.sublist(start, end);
    final elapsedMinutes =
        slice
            .map((k) => k.flight?.inMicroseconds ?? 0)
            .reduce((a, b) => a + b) /
        Duration.microsecondsPerMinute;
    return elapsedMinutes <= 0 ? 0 : slice.length / elapsedMinutes;
  }

  /// Ratio of the less-used hand to the more-used hand, thumb excluded
  /// from both counts (space doesn't inform left/right balance). `1.0`
  /// is perfectly balanced; `0.0` is fully one-sided. Defaults to `1.0`
  /// when there's no hand-attributable data at all.
  double _handBalanceRatio(List<Keystroke> forward) {
    var left = 0;
    var right = 0;
    for (final k in forward) {
      switch (k.finger.hand) {
        case Hand.left:
          left += 1;
        case Hand.right:
          right += 1;
        case Hand.neutral:
          break;
      }
    }
    final maxCount = math.max(left, right);
    if (maxCount == 0) return 1;
    return math.min(left, right) / maxCount;
  }

  Map<String, CharacterStat> _characterStats(List<Keystroke> forward) {
    final byChar = <String, List<Keystroke>>{};
    for (final k in forward) {
      final key = k.expectedChar ?? k.actualChar;
      if (key == null) continue;
      byChar.putIfAbsent(key, () => []).add(k);
    }
    return {
      for (final entry in byChar.entries)
        entry.key: CharacterStat(
          character: entry.key,
          attempts: entry.value.length,
          errors: entry.value
              .where((k) => k.result != KeystrokeResult.correct)
              .length,
          avgFlightMs: _avgFlightMs(entry.value),
        ),
    };
  }

  Map<Finger, FingerStat> _fingerStats(List<Keystroke> forward) {
    final byFinger = <Finger, List<Keystroke>>{};
    for (final k in forward) {
      byFinger.putIfAbsent(k.finger, () => []).add(k);
    }
    return {
      for (final entry in byFinger.entries)
        entry.key: FingerStat(
          finger: entry.key,
          attempts: entry.value.length,
          errors: entry.value
              .where((k) => k.result != KeystrokeResult.correct)
              .length,
          avgFlightMs: _avgFlightMs(entry.value),
        ),
    };
  }

  double _avgFlightMs(List<Keystroke> group) {
    final flights = [
      for (final k in group)
        if (k.flight != null) k.flight!.inMicroseconds / 1000,
    ];
    if (flights.isEmpty) return 0;
    return flights.reduce((a, b) => a + b) / flights.length;
  }

  /// 2- and 3-character n-gram stats derived from *this session's own*
  /// actually-typed character sequence (SPEC.md §4.2). This is distinct
  /// from the cross-session weakness-ranking n-gram query the project
  /// plan describes for `progression` — that queries persisted
  /// `keystroke_events` across many sessions via SQL; this is an
  /// in-memory, single-session value.
  List<NgramStat> _ngramStats(List<Keystroke> forward) {
    final byText = <String, List<(bool, double)>>{};
    for (final size in _ngramSizes) {
      for (var start = 0; start + size <= forward.length; start++) {
        final window = forward.sublist(start, start + size);
        final text = window.map((k) => k.actualChar ?? '').join();
        final hasError = window.any((k) => k.result != KeystrokeResult.correct);
        final durationMs =
            window
                .map((k) => k.flight?.inMicroseconds ?? 0)
                .reduce((a, b) => a + b) /
            1000;
        byText.putIfAbsent(text, () => []).add((hasError, durationMs));
      }
    }
    return [
      for (final entry in byText.entries)
        NgramStat(
          text: entry.key,
          occurrences: entry.value.length,
          errorCount: entry.value.where((o) => o.$1).length,
          avgDurationMs:
              entry.value.map((o) => o.$2).reduce((a, b) => a + b) /
              entry.value.length,
        ),
    ];
  }

  Map<PhysicalKeyId, KeyHeatmapEntry> _keyHeatmap(List<Keystroke> forward) {
    final usage = <PhysicalKeyId, int>{};
    final errors = <PhysicalKeyId, int>{};
    for (final k in forward) {
      usage[k.physicalKeyId] = (usage[k.physicalKeyId] ?? 0) + 1;
      if (k.result != KeystrokeResult.correct) {
        errors[k.physicalKeyId] = (errors[k.physicalKeyId] ?? 0) + 1;
      }
    }
    return {
      for (final key in usage.keys)
        key: (usageCount: usage[key]!, errorCount: errors[key] ?? 0),
    };
  }
}
