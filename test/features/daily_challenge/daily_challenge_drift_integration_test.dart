// Exercises `DailyChallengeRepositoryImpl` against a *real* in-memory
// drift (SQLite) database — proof that the composite (profileId,
// challengeDate) primary key really enforces "one attempt counts per
// day" (an upsert, not a duplicate row), and that `watchCompletedDates`
// reactively picks up a new completion without a manual refresh.
// Mirrors `achievements_drift_integration_test.dart`'s style.
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/persistence/drift/app_database.dart';
import 'package:ridge/core/persistence/drift/database_provider.dart';
import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
import 'package:ridge/features/daily_challenge/domain/entities/daily_challenge_completion.dart';
import 'package:ridge/features/daily_challenge/domain/value_objects/challenge_date.dart';
import 'package:ridge/features/daily_challenge/presentation/providers/daily_challenge_providers.dart';
import 'package:ridge/features/practice/domain/value_objects/typing_session_id.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';

DailyChallengeCompletion _completion({
  required ProfileId profileId,
  required ChallengeDate date,
  int score = 8,
  bool passed = true,
}) {
  return DailyChallengeCompletion(
    profileId: profileId,
    date: date,
    snippetId: const SnippetId('go-daily-test'),
    snippetRevision: 1,
    sessionId: TypingSessionId.generate(),
    score: score,
    passed: passed,
    completedAtUtc: DateTime.utc(2026, 3, 4, 12),
  );
}

void main() {
  late AppDatabase database;
  late ProviderContainer container;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(database)],
    );
    addTearDown(() => database.close());
    addTearDown(container.dispose);
  });

  test('a recorded completion round-trips through getCompletion', () async {
    final repository = container.read(dailyChallengeRepositoryProvider);
    final profileId = ProfileId.generate();
    final date = ChallengeDate(DateTime.utc(2026, 3, 4));

    final recordResult = await repository.recordCompletion(
      _completion(profileId: profileId, date: date),
    );
    expect(recordResult.isOk, isTrue);

    final getResult = await repository.getCompletion(
      profileId: profileId,
      date: date,
    );
    expect(getResult.isOk, isTrue);
    expect(getResult.valueOrNull, isNotNull);
    expect(getResult.valueOrNull!.score, 8);
    expect(getResult.valueOrNull!.passed, isTrue);
  });

  test('a different profile has no completion for that same date', () async {
    final repository = container.read(dailyChallengeRepositoryProvider);
    final date = ChallengeDate(DateTime.utc(2026, 3, 4));
    await repository.recordCompletion(
      _completion(profileId: ProfileId.generate(), date: date),
    );

    final getResult = await repository.getCompletion(
      profileId: ProfileId.generate(),
      date: date,
    );

    expect(getResult.valueOrNull, isNull);
  });

  test('recording the same (profile, date) twice upserts — one row, latest '
      'values win — never a duplicate', () async {
    final repository = container.read(dailyChallengeRepositoryProvider);
    final profileId = ProfileId.generate();
    final date = ChallengeDate(DateTime.utc(2026, 3, 4));

    await repository.recordCompletion(
      _completion(profileId: profileId, date: date, score: 6, passed: false),
    );
    await repository.recordCompletion(
      _completion(profileId: profileId, date: date, score: 9),
    );

    final rows = await database
        .select(database.dailyChallengeCompletions)
        .get();
    expect(rows, hasLength(1));
    expect(rows.single.score, 9);
    expect(rows.single.passed, isTrue);
  });

  test('watchCompletedDates reactively emits a new completion without a '
      'manual refresh', () async {
    final repository = container.read(dailyChallengeRepositoryProvider);
    final profileId = ProfileId.generate();
    final date = ChallengeDate(DateTime.utc(2026, 3, 4));

    final emissions = <List<ChallengeDate>>[];
    final subscription = repository
        .watchCompletedDates(profileId)
        .listen(emissions.add);
    addTearDown(subscription.cancel);

    await repository.recordCompletion(
      _completion(profileId: profileId, date: date),
    );
    await Future<void>.delayed(Duration.zero);

    expect(emissions.last, [date]);
  });

  test('getRecentCompletions returns newest challenge day first', () async {
    final repository = container.read(dailyChallengeRepositoryProvider);
    final profileId = ProfileId.generate();
    await repository.recordCompletion(
      _completion(
        profileId: profileId,
        date: ChallengeDate(DateTime.utc(2026, 3)),
      ),
    );
    await repository.recordCompletion(
      _completion(
        profileId: profileId,
        date: ChallengeDate(DateTime.utc(2026, 3, 3)),
      ),
    );
    await repository.recordCompletion(
      _completion(
        profileId: profileId,
        date: ChallengeDate(DateTime.utc(2026, 3, 2)),
      ),
    );

    final result = await repository.getRecentCompletions(
      profileId: profileId,
      limit: 2,
    );

    expect(result.isOk, isTrue);
    expect(
      [for (final c in result.valueOrNull!) c.date.isoKey],
      ['2026-03-03', '2026-03-02'],
    );
  });
}
