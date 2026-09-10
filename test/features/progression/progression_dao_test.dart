// Direct, real-drift-DB tests for `ProgressionDao`'s two self-join/scan
// queries added for key-transition weakness ranking and activity
// ranking — `getKeyTransitionSamplesRaw` and `getSessionActivityRaw`.
// `progression_drift_integration_test.dart` already proves the happy
// path end-to-end through the real capture pipeline; this file targets
// the self-join's edge cases directly (non-adjacent `seq`, cross-session
// leakage) that a hand-typed session would never naturally exercise.
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_in_time/core/persistence/drift/app_database.dart';
import 'package:just_in_time/features/progression/infrastructure/progression_dao.dart';

KeystrokeEventsCompanion _event({
  required String sessionId,
  required int seq,
  required String physicalKeyId,
  bool isCorrection = false,
  String result = 'correct',
  int sessionStartedAtUtcMicros = 0,
}) {
  return KeystrokeEventsCompanion.insert(
    sessionId: sessionId,
    seq: seq,
    sessionStartedAtUtcMicros: sessionStartedAtUtcMicros,
    result: result,
    isCorrection: isCorrection,
    physicalKeyId: physicalKeyId,
    finger: 'leftIndex',
    keyboardRow: 'homeRow',
    flightMicros: const Value(10000),
    thirdIndex: 0,
  );
}

TypingSessionsCompanion _session({
  required String id,
  required String profileId,
  String category = 'loops',
}) {
  return TypingSessionsCompanion.insert(
    id: id,
    profileId: profileId,
    mode: 'zen',
    snippetId: 'snippet-1',
    snippetRevision: 1,
    category: category,
    difficulty: 'beginner',
    startedAtUtcMicros: 0,
    durationMicros: 60000000,
    rawSpeedCpm: 100,
    netSpeedCpm: 100,
    accuracyPct: 100,
    consistencyScore: 100,
    maxStreak: 5,
    fatigueFirstThirdCpm: 100,
    fatigueMiddleThirdCpm: 100,
    fatigueLastThirdCpm: 100,
    handBalanceRatio: 1,
  );
}

void main() {
  late AppDatabase database;
  late ProgressionDao dao;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    dao = database.progressionDao;
    addTearDown(() => database.close());
  });

  group('getKeyTransitionSamplesRaw', () {
    test('pairs only adjacent seq within the same session', () async {
      await database
          .into(database.typingSessions)
          .insert(_session(id: 's1', profileId: 'p1'));
      await database.batch((batch) {
        batch.insertAll(database.keystrokeEvents, [
          _event(sessionId: 's1', seq: 0, physicalKeyId: 'keyA'),
          _event(sessionId: 's1', seq: 1, physicalKeyId: 'keyB'),
          // Gap: seq 3 is not seq(2)+1, so (keyB, keyD) is never paired.
          _event(sessionId: 's1', seq: 3, physicalKeyId: 'keyD'),
        ]);
      });

      final rows = await dao.getKeyTransitionSamplesRaw(
        profileId: 'p1',
        sinceUtcMicros: 0,
      );

      expect(rows, hasLength(1));
      expect(rows.single.fromKey, 'keyA');
      expect(rows.single.toKey, 'keyB');
    });

    test('never pairs keystrokes across two different sessions', () async {
      await database.batch((batch) {
        batch.insertAll(database.typingSessions, [
          _session(id: 's1', profileId: 'p1'),
          _session(id: 's2', profileId: 'p1'),
        ]);
      });
      await database.batch((batch) {
        batch.insertAll(database.keystrokeEvents, [
          // s1's last event is seq 0; s2's first event is also seq 1 in
          // a *different* session — the join must not bridge them.
          _event(sessionId: 's1', seq: 0, physicalKeyId: 'keyA'),
          _event(sessionId: 's2', seq: 1, physicalKeyId: 'keyZ'),
        ]);
      });

      final rows = await dao.getKeyTransitionSamplesRaw(
        profileId: 'p1',
        sinceUtcMicros: 0,
      );

      expect(rows, isEmpty);
    });

    test('only returns transitions for the requested profile', () async {
      await database.batch((batch) {
        batch.insertAll(database.typingSessions, [
          _session(id: 's1', profileId: 'p1'),
          _session(id: 's2', profileId: 'p2'),
        ]);
      });
      await database.batch((batch) {
        batch.insertAll(database.keystrokeEvents, [
          _event(sessionId: 's1', seq: 0, physicalKeyId: 'keyA'),
          _event(sessionId: 's1', seq: 1, physicalKeyId: 'keyB'),
          _event(sessionId: 's2', seq: 0, physicalKeyId: 'keyX'),
          _event(sessionId: 's2', seq: 1, physicalKeyId: 'keyY'),
        ]);
      });

      final rows = await dao.getKeyTransitionSamplesRaw(
        profileId: 'p1',
        sinceUtcMicros: 0,
      );

      expect(rows, hasLength(1));
      expect(rows.single.fromKey, 'keyA');
      expect(rows.single.toKey, 'keyB');
    });
  });

  group('getSessionActivityRaw', () {
    test('only returns sessions for the requested profile', () async {
      await database.batch((batch) {
        batch.insertAll(database.typingSessions, [
          _session(id: 's1', profileId: 'p1'),
          _session(id: 's2', profileId: 'p1', category: 'functions'),
          _session(id: 's3', profileId: 'p2', category: 'pointers'),
        ]);
      });

      final rows = await dao.getSessionActivityRaw('p1');

      expect(rows, hasLength(2));
      expect(rows.map((r) => r.id), containsAll(['s1', 's2']));
    });
  });
}
