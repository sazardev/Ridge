/// Pure, stateless consecutive-days streak calculation (SPEC.md §6.1/§12): "racha
/// de días activos" — consecutive local-calendar days with at least one
/// finished session, alive through yesterday (today not having played
/// yet doesn't break it, but skipping an entire day does).
///
/// `today` is an explicit parameter (never `DateTime.now()` internally)
/// so this stays deterministic and unit-testable — timezone/local-date
/// conversion is the caller's job; every `DateTime` this receives is
/// expected to already be a local, time-of-day-stripped calendar date.
class StreakCalculator {
  /// Creates the (stateless) calculator.
  const new();

  /// Computes the streak length ending on (or, if nothing happened
  /// today yet, ending yesterday) given [localDates] — the distinct
  /// local-calendar dates a session was finished on, in any order.
  int compute(List<DateTime> localDates, DateTime today) {
    if (localDates.isEmpty) return 0;
    final dateSet = {for (final d in localDates) _dateOnly(d)};
    final todayDate = _dateOnly(today);

    var cursor = todayDate;
    if (!dateSet.contains(cursor)) {
      cursor = cursor.subtract(const Duration(days: 1));
      if (!dateSet.contains(cursor)) {
        // Neither today nor yesterday has a session — the streak is
        // dead, not just paused.
        return 0;
      }
    }

    var streak = 0;
    while (dateSet.contains(cursor)) {
      streak += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
