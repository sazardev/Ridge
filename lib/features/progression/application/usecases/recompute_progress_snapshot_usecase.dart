import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/practice/domain/entities/finger.dart';
import 'package:ridge/features/practice/domain/value_objects/physical_key_id.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';
import 'package:ridge/features/progression/domain/entities/activity_report.dart';
import 'package:ridge/features/progression/domain/entities/mastery_status.dart';
import 'package:ridge/features/progression/domain/entities/progress_snapshot.dart';
import 'package:ridge/features/progression/domain/entities/weak_character.dart';
import 'package:ridge/features/progression/domain/entities/weak_finger.dart';
import 'package:ridge/features/progression/domain/entities/weak_key_transition.dart';
import 'package:ridge/features/progression/domain/entities/weak_ngram.dart';
import 'package:ridge/features/progression/domain/entities/weakness_report.dart';
import 'package:ridge/features/progression/domain/entities/xp_summary.dart';
import 'package:ridge/features/progression/domain/repositories/progression_repository.dart';
import 'package:ridge/features/progression/domain/services/activity_ranking_calculator.dart';
import 'package:ridge/features/progression/domain/services/level_calculator.dart';
import 'package:ridge/features/progression/domain/services/mastery_evaluator.dart';
import 'package:ridge/features/progression/domain/services/streak_calculator.dart';
import 'package:ridge/features/progression/domain/services/weakness_ranking_calculator.dart';
import 'package:ridge/features/progression/domain/services/xp_calculator.dart';

/// Recomputes and persists the full [ProgressSnapshot] for one profile
/// (SPEC.md §4.3/§6) — idempotent, safe to call any number of times.
/// Fired right after every finished `practice` session, and again as a
/// safety net when the Progress screen first loads.
///
/// Orchestration (see the project plan's "progression" section for the
/// exact design decision this implements):
/// 1. Backfill `xp_awarded`/`is_first_completion` onto every session that
///    hasn't been processed yet, oldest first, so first-completion and
///    streak-bonus context accumulate in true chronological order.
/// 2. Recompute the XP/level/streak/weakness snapshot from the
///    now-complete history.
/// 3. Recompute mastery for every (category, difficulty) pair a
///    newly-processed Precision session touched.
class RecomputeProgressSnapshotUseCase {
  /// Creates the use case over the given [ProgressionRepository] port and
  /// optional injected (pure, stateless) calculators — tests can supply
  /// fakes, though every default is already cheap enough that most
  /// callers just use it.
  const new(
    this._repository, {
    this.xpCalculator = const XpCalculator(),
    this.levelCalculator = const LevelCalculator(),
    this.streakCalculator = const StreakCalculator(),
    this.weaknessRankingCalculator = const WeaknessRankingCalculator(),
    this.activityRankingCalculator = const ActivityRankingCalculator(),
    this.masteryEvaluator = const MasteryEvaluator(),
  });

  final ProgressionRepository _repository;

  /// The (pure, stateless) calculator used to derive session XP.
  final XpCalculator xpCalculator;

  /// The (pure, stateless) calculator used to derive account level.
  final LevelCalculator levelCalculator;

  /// The (pure, stateless) calculator used to derive the current streak.
  final StreakCalculator streakCalculator;

  /// The (pure, stateless) calculator used to rank weaknesses.
  final WeaknessRankingCalculator weaknessRankingCalculator;

  /// The (pure, stateless) calculator used to rank activity (most
  /// practiced/lowest scoring, per category and per exercise).
  final ActivityRankingCalculator activityRankingCalculator;

  /// The (pure, stateless) evaluator used to certify/decay mastery.
  final MasteryEvaluator masteryEvaluator;

  /// How far back weakness ranking looks — bounds scan cost and keeps
  /// the report reflecting *current* skill, not lifetime-diluted history
  /// (SPEC.md §4.2's "trend"/§6.4's mastery wanting current performance).
  static const _weaknessWindow = Duration(days: 60);

  /// Runs the full recompute for [profileId]. [now] is injected (rather
  /// than read internally) for deterministic testing — this is wall-clock
  /// "how long ago"/"what day is it" reporting, not a monotonic
  /// measurement (SPEC.md's keystroke timing stays monotonic elsewhere).
  Future<Result<ProgressSnapshot, AppFailure>> call({
    required ProfileId profileId,
    required DateTime now,
  }) async {
    final nowUtc = now.toUtc();
    final todayLocal = _localDateOf(now);

    final unprocessedResult = await _repository.getUnprocessedSessions(
      profileId,
    );
    if (unprocessedResult.isErr) {
      return Result.err(unprocessedResult.failureOrNull!);
    }
    final unprocessed = unprocessedResult.valueOrNull!;

    final timestampsResult = await _repository.getSessionStartTimestamps(
      profileId,
    );
    if (timestampsResult.isErr) {
      return Result.err(timestampsResult.failureOrNull!);
    }
    final localDatesAll = [
      for (final t in timestampsResult.valueOrNull!) _localDateOf(t),
    ];

    final touchedPairs = <(ContentCategory, Difficulty)>{};
    for (final session in unprocessed) {
      final hasCompletedBeforeResult = await _repository
          .hasCompletedSnippetBefore(
            profileId: profileId,
            snippetId: session.snippetId,
          );
      if (hasCompletedBeforeResult.isErr) {
        return Result.err(hasCompletedBeforeResult.failureOrNull!);
      }
      final isFirstCompletion = !hasCompletedBeforeResult.valueOrNull!;

      final sessionLocalDate = _localDateOf(session.startedAtUtc);
      final datesUpToSession = [
        for (final d in localDatesAll)
          if (!d.isAfter(sessionLocalDate)) d,
      ];
      final streakAsOfSession = streakCalculator.compute(
        datesUpToSession,
        sessionLocalDate,
      );

      final xp = xpCalculator.calculate(
        correctFirstTryChars: session.correctFirstTryChars,
        difficulty: session.difficulty,
        accuracyPct: session.accuracyPct,
        isFirstCompletion: isFirstCompletion,
        currentStreakDays: streakAsOfSession,
      );

      final markResult = await _repository.markSessionProcessed(
        profileId: profileId,
        sessionId: session.id,
        xpAwarded: xp,
        isFirstCompletion: isFirstCompletion,
      );
      if (markResult.isErr) return Result.err(markResult.failureOrNull!);

      if (session.mode == 'precision') {
        touchedPairs.add((session.category, session.difficulty));
      }
    }

    final totalXpResult = await _repository.getTotalXpAwarded(profileId);
    if (totalXpResult.isErr) return Result.err(totalXpResult.failureOrNull!);
    final totalXp = totalXpResult.valueOrNull!;

    final level = levelCalculator.levelForXp(totalXp);
    final xpSummary = XpSummary(
      totalXp: totalXp,
      level: level,
      xpAtCurrentLevel: levelCalculator.xpForLevel(level),
      xpForNextLevel: levelCalculator.xpForLevel(level + 1),
    );

    final currentStreakDays = streakCalculator.compute(
      localDatesAll,
      todayLocal,
    );

    final weaknessReportResult = await _buildWeaknessReport(
      profileId: profileId,
      nowUtc: nowUtc,
    );
    if (weaknessReportResult.isErr) {
      return Result.err(weaknessReportResult.failureOrNull!);
    }

    final activityReportResult = await _buildActivityReport(
      profileId: profileId,
      nowUtc: nowUtc,
    );
    if (activityReportResult.isErr) {
      return Result.err(activityReportResult.failureOrNull!);
    }

    final masteryStatuses = <MasteryStatus>[];
    for (final (category, difficulty) in touchedPairs) {
      final status = await _reevaluateMastery(
        profileId: profileId,
        category: category,
        difficulty: difficulty,
        evaluatedAt: nowUtc,
      );
      if (status.isErr) return Result.err(status.failureOrNull!);
      masteryStatuses.add(status.valueOrNull!);
    }
    final untouchedStatusesResult = await _repository.getAllMasteryStatuses(
      profileId,
    );
    if (untouchedStatusesResult.isErr) {
      return Result.err(untouchedStatusesResult.failureOrNull!);
    }
    for (final cached in untouchedStatusesResult.valueOrNull!) {
      final alreadyIncluded = masteryStatuses.any(
        (s) =>
            s.category == cached.category && s.difficulty == cached.difficulty,
      );
      if (!alreadyIncluded) masteryStatuses.add(cached);
    }

    final snapshot = ProgressSnapshot(
      profileId: profileId,
      xpSummary: xpSummary,
      currentStreakDays: currentStreakDays,
      weaknessReport: weaknessReportResult.valueOrNull!,
      activityReport: activityReportResult.valueOrNull!,
      masteryStatuses: masteryStatuses,
      computedAt: nowUtc,
    );

    final persistResult = await _repository.persistSnapshot(snapshot);
    if (persistResult.isErr) return Result.err(persistResult.failureOrNull!);

    return Result.ok(snapshot);
  }

  Future<Result<WeaknessReport, AppFailure>> _buildWeaknessReport({
    required ProfileId profileId,
    required DateTime nowUtc,
  }) async {
    final since = nowUtc.subtract(_weaknessWindow);

    final keystrokeSamplesResult = await _repository.getKeystrokeSamples(
      profileId: profileId,
      since: since,
    );
    if (keystrokeSamplesResult.isErr) {
      return Result.err(keystrokeSamplesResult.failureOrNull!);
    }
    final ngramSamplesResult = await _repository.getNgramSamples(
      profileId: profileId,
      since: since,
    );
    if (ngramSamplesResult.isErr) {
      return Result.err(ngramSamplesResult.failureOrNull!);
    }
    final keyTransitionSamplesResult = await _repository
        .getKeyTransitionSamples(profileId: profileId, since: since);
    if (keyTransitionSamplesResult.isErr) {
      return Result.err(keyTransitionSamplesResult.failureOrNull!);
    }

    final charSamples = <String, List<WeaknessSample>>{};
    final fingerSamples = <Finger, List<WeaknessSample>>{};
    for (final ks in keystrokeSamplesResult.valueOrNull!) {
      final sample = WeaknessSample(
        ageInDays: _ageInDays(nowUtc, ks.occurredAtUtc),
        isError: ks.isError,
        flightMs: ks.flightMs,
      );
      charSamples.putIfAbsent(ks.character, () => []).add(sample);
      fingerSamples.putIfAbsent(ks.finger, () => []).add(sample);
    }

    final ngramSamples = <String, List<WeaknessSample>>{};
    for (final ns in ngramSamplesResult.valueOrNull!) {
      ngramSamples
          .putIfAbsent(ns.text, () => [])
          .add(
            WeaknessSample(
              ageInDays: _ageInDays(nowUtc, ns.occurredAtUtc),
              isError: ns.isError,
              flightMs: ns.flightMs,
            ),
          );
    }

    final keyTransitionSamples =
        <(PhysicalKeyId, PhysicalKeyId), List<WeaknessSample>>{};
    for (final kt in keyTransitionSamplesResult.valueOrNull!) {
      keyTransitionSamples
          .putIfAbsent((kt.fromKey, kt.toKey), () => [])
          .add(
            WeaknessSample(
              ageInDays: _ageInDays(nowUtc, kt.occurredAtUtc),
              isError: kt.isError,
              flightMs: kt.flightMs,
            ),
          );
    }

    final charRanked = weaknessRankingCalculator.rank(charSamples);
    final fingerRanked = weaknessRankingCalculator.rank(fingerSamples);
    final ngramRanked = weaknessRankingCalculator.rank(ngramSamples);
    final keyTransitionRanked = weaknessRankingCalculator.rank(
      keyTransitionSamples,
    );

    return Result.ok(
      WeaknessReport(
        weakCharacters: [
          for (final e in charRanked)
            WeakCharacter(character: e.key, score: e.score, trend: e.trend),
        ],
        weakFingers: [
          for (final e in fingerRanked)
            WeakFinger(finger: e.key, score: e.score, trend: e.trend),
        ],
        weakNgrams: [
          for (final e in ngramRanked)
            WeakNgram(text: e.key, score: e.score, trend: e.trend),
        ],
        weakKeyTransitions: [
          for (final e in keyTransitionRanked)
            WeakKeyTransition(
              fromKey: e.key.$1,
              toKey: e.key.$2,
              score: e.score,
              trend: e.trend,
            ),
        ],
      ),
    );
  }

  Future<Result<ActivityReport, AppFailure>> _buildActivityReport({
    required ProfileId profileId,
    required DateTime nowUtc,
  }) async {
    final samplesResult = await _repository.getSessionActivitySamples(
      profileId,
    );
    if (samplesResult.isErr) return Result.err(samplesResult.failureOrNull!);

    return Result.ok(
      activityRankingCalculator.calculate(
        samplesResult.valueOrNull!,
        now: nowUtc,
      ),
    );
  }

  Future<Result<MasteryStatus, AppFailure>> _reevaluateMastery({
    required ProfileId profileId,
    required ContentCategory category,
    required Difficulty difficulty,
    required DateTime evaluatedAt,
  }) async {
    final recentResult = await _repository.getRecentPrecisionResults(
      profileId: profileId,
      category: category,
      difficulty: difficulty,
    );
    if (recentResult.isErr) return Result.err(recentResult.failureOrNull!);

    final existingResult = await _repository.getMasteryStatus(
      profileId: profileId,
      category: category,
      difficulty: difficulty,
    );
    if (existingResult.isErr) return Result.err(existingResult.failureOrNull!);

    final status = masteryEvaluator.evaluate(
      category: category,
      difficulty: difficulty,
      wasMastered: existingResult.valueOrNull?.isMastered ?? false,
      lastFiveNewestFirst: recentResult.valueOrNull!,
      evaluatedAt: evaluatedAt,
    );

    final persistResult = await _repository.persistMasteryStatus(
      profileId: profileId,
      status: status,
    );
    if (persistResult.isErr) return Result.err(persistResult.failureOrNull!);

    return Result.ok(status);
  }

  double _ageInDays(DateTime nowUtc, DateTime occurredAtUtc) {
    return nowUtc.difference(occurredAtUtc).inMicroseconds /
        Duration.microsecondsPerDay;
  }

  DateTime _localDateOf(DateTime dateTime) {
    final local = dateTime.toLocal();
    return DateTime(local.year, local.month, local.day);
  }
}
