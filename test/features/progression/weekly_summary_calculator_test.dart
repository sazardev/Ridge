// Unit tests for `WeeklySummaryCalculator` — pure, `nowLocal` injected
// explicitly so every scenario is deterministic. Sessions are built from
// local wall-clock times converted to UTC, so the calculator's own
// `toLocal()` bucketing round-trips exactly regardless of the test
// machine's timezone.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
import 'package:ridge/features/practice/domain/entities/practice_mode.dart';
import 'package:ridge/features/practice/domain/entities/typing_session.dart';
import 'package:ridge/features/practice/domain/value_objects/typing_session_id.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';
import 'package:ridge/features/progression/domain/services/weekly_summary_calculator.dart';

TypingSession _session({
  required DateTime startedAtLocal,
  Duration duration = const Duration(minutes: 5),
  int xp = 10,
  double netSpeedCpm = 60,
  double accuracyPct = 98,
}) {
  return TypingSession(
    id: TypingSessionId.generate(),
    profileId: ProfileId.generate(),
    mode: const PracticeMode.zen(),
    snippetId: const SnippetId('go-test-001'),
    snippetRevision: 1,
    category: ContentCategory.variablesAndTypes,
    difficulty: Difficulty.beginner,
    startedAtUtc: startedAtLocal.toUtc(),
    duration: duration,
    rawSpeedCpm: netSpeedCpm + 5,
    netSpeedCpm: netSpeedCpm,
    accuracyPct: accuracyPct,
    consistencyScore: 80,
    maxStreak: 100,
    fatigueFirstThirdCpm: netSpeedCpm,
    fatigueMiddleThirdCpm: netSpeedCpm,
    fatigueLastThirdCpm: netSpeedCpm,
    handBalanceRatio: 1,
    xpAwarded: xp,
  );
}

void main() {
  const calculator = WeeklySummaryCalculator();
  final now = DateTime(2026, 1, 15, 12);

  test('no sessions at all is an empty report', () {
    final summary = calculator.compute(sessions: const [], nowLocal: now);

    expect(summary.sessions, 0);
    expect(summary.previousSessions, 0);
    expect(summary.totalDuration, Duration.zero);
    expect(summary.totalXp, 0);
    expect(summary.averageNetSpeedCpm, 0);
    expect(summary.activeDays, 0);
  });

  test('the window is today plus the six days before it', () {
    final summary = calculator.compute(
      sessions: [
        _session(startedAtLocal: DateTime(2026, 1, 15, 8)), // today
        _session(startedAtLocal: DateTime(2026, 1, 9, 8)), // window start
        _session(startedAtLocal: DateTime(2026, 1, 8, 8)), // previous week
        _session(startedAtLocal: DateTime(2026, 1, 2, 8)), // previous week
        _session(startedAtLocal: DateTime(2026, 1, 1, 8)), // outside both
      ],
      nowLocal: now,
    );

    expect(summary.sessions, 2);
    expect(summary.previousSessions, 2);
  });

  test('aggregates sum time and XP and average speed and accuracy', () {
    final summary = calculator.compute(
      sessions: [
        _session(
          startedAtLocal: DateTime(2026, 1, 15, 8),
          duration: const Duration(minutes: 4),
          accuracyPct: 90,
        ),
        _session(
          startedAtLocal: DateTime(2026, 1, 14, 8),
          duration: const Duration(minutes: 6),
          xp: 20,
          netSpeedCpm: 80,
          accuracyPct: 100,
        ),
      ],
      nowLocal: now,
    );

    expect(summary.totalDuration, const Duration(minutes: 10));
    expect(summary.totalXp, 30);
    expect(summary.averageNetSpeedCpm, 70);
    expect(summary.averageAccuracyPct, 95);
  });

  test('active days count distinct local days, not sessions', () {
    final summary = calculator.compute(
      sessions: [
        _session(startedAtLocal: DateTime(2026, 1, 15, 8)),
        _session(startedAtLocal: DateTime(2026, 1, 15, 20)),
        _session(startedAtLocal: DateTime(2026, 1, 13, 9)),
      ],
      nowLocal: now,
    );

    expect(summary.sessions, 3);
    expect(summary.activeDays, 2);
  });

  test('future-dated sessions (clock skew) are ignored entirely', () {
    final summary = calculator.compute(
      sessions: [_session(startedAtLocal: DateTime(2026, 1, 16, 8))],
      nowLocal: now,
    );

    expect(summary.sessions, 0);
    expect(summary.activeDays, 0);
  });
}
