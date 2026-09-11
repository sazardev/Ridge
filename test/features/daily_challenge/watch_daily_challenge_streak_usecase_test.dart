// Unit tests for `WatchDailyChallengeStreakUseCase` — maps a profile's
// completed-dates stream through `DailyChallengeStreakCalculator`. A
// hand-written `_FakeDailyChallengeRepository` backed by a
// `StreamController`, no widget/clock/drift needed.
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/daily_challenge/application/usecases/watch_daily_challenge_streak_usecase.dart';
import 'package:ridge/features/daily_challenge/domain/entities/daily_challenge_completion.dart';
import 'package:ridge/features/daily_challenge/domain/repositories/daily_challenge_repository.dart';
import 'package:ridge/features/daily_challenge/domain/value_objects/challenge_date.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';

class _FakeDailyChallengeRepository implements DailyChallengeRepository {
  final _controller = StreamController<List<ChallengeDate>>.broadcast();

  @override
  Stream<List<ChallengeDate>> watchCompletedDates(ProfileId profileId) =>
      _controller.stream;

  @override
  Future<Result<DailyChallengeCompletion?, AppFailure>> getCompletion({
    required ProfileId profileId,
    required ChallengeDate date,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Result<void, AppFailure>> recordCompletion(
    DailyChallengeCompletion completion,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<Result<List<DailyChallengeCompletion>, AppFailure>>
  getRecentCompletions({
    required ProfileId profileId,
    required int limit,
  }) async {
    throw UnimplementedError();
  }
}

void main() {
  late _FakeDailyChallengeRepository repository;
  late WatchDailyChallengeStreakUseCase useCase;

  setUp(() {
    repository = _FakeDailyChallengeRepository();
    useCase = WatchDailyChallengeStreakUseCase(repository);
    addTearDown(() => repository._controller.close());
  });

  test('emits the streak recomputed from each new completion-history '
      'emission', () async {
    final today = ChallengeDate(DateTime.utc(2026, 1, 10));
    final stream = useCase(profileId: ProfileId.generate(), today: today);

    final emissions = <int>[];
    final subscription = stream.listen(emissions.add);
    addTearDown(subscription.cancel);

    repository._controller.add([today]);
    await Future<void>.delayed(Duration.zero);
    repository._controller.add([
      today,
      ChallengeDate(DateTime.utc(2026, 1, 9)),
    ]);
    await Future<void>.delayed(Duration.zero);
    repository._controller.add([ChallengeDate(DateTime.utc(2025))]);
    await Future<void>.delayed(Duration.zero);

    expect(emissions, [1, 2, 0]);
  });
}
