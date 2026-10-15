import 'package:ridge/features/practice/domain/entities/typing_session.dart';

/// One week's rolled-up practice report (SPEC.md §4.3/§17's weekly
/// check-in): the rolling window of the last seven local calendar days
/// (today inclusive), with the immediately preceding seven days kept for
/// deltas.
typedef WeeklySummary = ({
  int sessions,
  int previousSessions,
  Duration totalDuration,
  Duration previousTotalDuration,
  int totalXp,
  double averageNetSpeedCpm,
  double previousAverageNetSpeedCpm,
  double averageAccuracyPct,
  int activeDays,
});

/// Pure, stateless weekly roll-up — `nowLocal` injected explicitly so
/// every scenario is deterministic (same contract as `StreakCalculator`,
/// whose local-calendar-day semantics this mirrors).
class WeeklySummaryCalculator {
  /// Creates the (stateless) calculator.
  const new();

  /// How many days the rolling window spans, including today.
  static const windowDays = 7;

  /// Rolls [sessions] (any order, any age) up into a [WeeklySummary].
  /// Sessions dated in the future (clock skew) are ignored rather than
  /// bucketed, so a bad device clock can't inflate the report.
  WeeklySummary compute({
    required List<TypingSession> sessions,
    required DateTime nowLocal,
  }) {
    final today = DateTime(nowLocal.year, nowLocal.month, nowLocal.day);
    final windowStart = today.subtract(const Duration(days: windowDays - 1));
    final previousStart = windowStart.subtract(
      const Duration(days: windowDays),
    );

    final current = <TypingSession>[];
    final previous = <TypingSession>[];
    for (final session in sessions) {
      final local = session.startedAtUtc.toLocal();
      final date = DateTime(local.year, local.month, local.day);
      if (date.isAfter(today)) continue;
      if (date.isBefore(windowStart)) {
        if (!date.isBefore(previousStart)) previous.add(session);
      } else {
        current.add(session);
      }
    }

    return (
      sessions: current.length,
      previousSessions: previous.length,
      totalDuration: _totalDuration(current),
      previousTotalDuration: _totalDuration(previous),
      totalXp: _totalXp(current),
      averageNetSpeedCpm: _averageNetSpeed(current),
      previousAverageNetSpeedCpm: _averageNetSpeed(previous),
      averageAccuracyPct: _averageAccuracy(current),
      activeDays: _distinctLocalDays(current),
    );
  }

  Duration _totalDuration(List<TypingSession> sessions) =>
      sessions.fold(Duration.zero, (sum, session) => sum + session.duration);

  int _totalXp(List<TypingSession> sessions) =>
      sessions.fold(0, (sum, session) => sum + session.xpAwarded);

  double _averageNetSpeed(List<TypingSession> sessions) => sessions.isEmpty
      ? 0
      : sessions.fold<double>(0, (sum, s) => sum + s.netSpeedCpm) /
            sessions.length;

  double _averageAccuracy(List<TypingSession> sessions) => sessions.isEmpty
      ? 0
      : sessions.fold<double>(0, (sum, s) => sum + s.accuracyPct) /
            sessions.length;

  int _distinctLocalDays(List<TypingSession> sessions) {
    final days = <DateTime>{};
    for (final session in sessions) {
      final local = session.startedAtUtc.toLocal();
      days.add(DateTime(local.year, local.month, local.day));
    }
    return days.length;
  }
}
