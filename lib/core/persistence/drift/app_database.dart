import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'package:ridge/features/achievements/infrastructure/achievement_dao.dart';
import 'package:ridge/features/achievements/infrastructure/tables/achievements_unlocked_table.dart';
import 'package:ridge/features/content/infrastructure/snippet_dao.dart';
import 'package:ridge/features/content/infrastructure/tables/snippets_table.dart';
import 'package:ridge/features/daily_challenge/infrastructure/daily_challenge_dao.dart';
import 'package:ridge/features/daily_challenge/infrastructure/tables/daily_challenge_completions_table.dart';
import 'package:ridge/features/data_management/infrastructure/data_reset_dao.dart';
import 'package:ridge/features/learning_paths/infrastructure/lesson_progress_dao.dart';
import 'package:ridge/features/learning_paths/infrastructure/tables/lesson_progress_cache_table.dart';
import 'package:ridge/features/practice/infrastructure/practice_dao.dart';
import 'package:ridge/features/practice/infrastructure/tables/keystroke_events_table.dart';
import 'package:ridge/features/practice/infrastructure/tables/typing_sessions_table.dart';
import 'package:ridge/features/profile/infrastructure/guest_profile_dao.dart';
import 'package:ridge/features/profile/infrastructure/tables/guest_profiles_table.dart';
import 'package:ridge/features/progression/infrastructure/progression_dao.dart';
import 'package:ridge/features/progression/infrastructure/tables/mastery_status_cache_table.dart';
import 'package:ridge/features/progression/infrastructure/tables/processed_sessions_table.dart';
import 'package:ridge/features/progression/infrastructure/tables/progress_snapshot_cache_table.dart';

part 'app_database.g.dart';

/// Creates the indices the project plan's `typing_sessions`/
/// `keystroke_events` schema calls for — not expressible inline on the
/// `Table` classes in this drift version, so created here alongside the
/// tables themselves, once, in the same migration step that creates
/// them. All statements are `IF NOT EXISTS`, so re-running this against
/// a database that already has some of them (e.g. the v14->v15 step
/// below, which only needs the last one) is a safe no-op for the rest.
Future<void> _createPracticeIndices(Migrator m) async {
  await m.database.customStatement(
    'CREATE INDEX IF NOT EXISTS idx_typing_sessions_category_difficulty '
    'ON typing_sessions (category, difficulty)',
  );
  await m.database.customStatement(
    'CREATE INDEX IF NOT EXISTS idx_typing_sessions_snippet '
    'ON typing_sessions (snippet_id, snippet_revision)',
  );
  await m.database.customStatement(
    'CREATE INDEX IF NOT EXISTS idx_typing_sessions_started_at '
    'ON typing_sessions (started_at_utc_micros)',
  );
  await m.database.customStatement(
    'CREATE INDEX IF NOT EXISTS idx_typing_sessions_profile_recency '
    'ON typing_sessions (profile_id, started_at_utc_micros)',
  );
  await m.database.customStatement(
    'CREATE INDEX IF NOT EXISTS idx_keystroke_events_expected_char '
    'ON keystroke_events (expected_char)',
  );
  await m.database.customStatement(
    'CREATE INDEX IF NOT EXISTS idx_keystroke_events_finger '
    'ON keystroke_events (finger)',
  );
  await m.database.customStatement(
    'CREATE INDEX IF NOT EXISTS idx_keystroke_events_physical_key_id '
    'ON keystroke_events (physical_key_id)',
  );
  await m.database.customStatement(
    'CREATE INDEX IF NOT EXISTS idx_keystroke_events_recency '
    'ON keystroke_events (session_started_at_utc_micros)',
  );
}

/// The single shared drift (SQLite) database for the whole app. Each
/// feature owns its own `Table`/DAO classes under its own
/// `infrastructure/`, imported here so schema and migrations stay
/// centralized in one place as more features land (STACK.md §2.7).
@DriftDatabase(
  tables: [
    GuestProfiles,
    Snippets,
    TypingSessions,
    KeystrokeEvents,
    ProgressSnapshotCache,
    MasteryStatusCache,
    ProcessedSessions,
    LessonProgressCache,
    AchievementsUnlocked,
    DailyChallengeCompletions,
  ],
  daos: [
    GuestProfileDao,
    SnippetDao,
    PracticeDao,
    ProgressionDao,
    LessonProgressDao,
    AchievementDao,
    DataResetDao,
    DailyChallengeDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Opens the database, optionally over a custom [executor] — tests pass
  /// `NativeDatabase.memory()`, production falls back to `drift_flutter`'s
  /// cross-platform opener.
  new([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'ridge.db'));

  @override
  int get schemaVersion => 15;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _createPracticeIndices(m);
    },
    onUpgrade: (m, from, to) async {
      // v1 -> v2: added the `content` feature's Snippets table. Existing
      // GuestProfiles data is untouched — only the new table is created.
      if (from < 2) {
        await m.createTable(snippets);
      }
      // v2 -> v3: added the `practice` feature's TypingSessions and
      // KeystrokeEvents tables (+ their indices) for Zen-mode capture.
      // Nothing existing is touched, only new tables are created.
      if (from < 3) {
        await m.createTable(typingSessions);
        await m.createTable(keystrokeEvents);
        await _createPracticeIndices(m);
      }
      // v3 -> v4: added the `progression` feature's cache/marker tables
      // (progress_snapshot_cache, mastery_status_cache,
      // processed_sessions). Nothing existing is touched, only new
      // tables are created.
      if (from < 4) {
        await m.createTable(progressSnapshotCache);
        await m.createTable(masteryStatusCache);
        await m.createTable(processedSessions);
      }
      // v4 -> v5: added the `learning_paths` feature's
      // lesson_progress_cache table. Nothing existing is touched, only
      // the new table is created.
      if (from < 5) {
        await m.createTable(lessonProgressCache);
      }
      // v5 -> v6: added the `achievements` feature's achievements_unlocked
      // table. Nothing existing is touched, only the new table is
      // created.
      if (from < 6) {
        await m.createTable(achievementsUnlocked);
      }
      // v6 -> v7: added five nullable self-expression columns (favorite
      // languages, keyboard layout/brand, favorite quote/programmer) to
      // guest_profiles for the profile-customization screen. Existing
      // rows simply get NULL in each new column.
      if (from < 7) {
        await m.addColumn(guestProfiles, guestProfiles.favoriteLanguages);
        await m.addColumn(guestProfiles, guestProfiles.keyboardLayout);
        await m.addColumn(guestProfiles, guestProfiles.keyboardBrand);
        await m.addColumn(guestProfiles, guestProfiles.favoriteQuote);
        await m.addColumn(guestProfiles, guestProfiles.favoriteProgrammer);
      }
      // v7 -> v8: added the keyboard_model column, and — for the rare
      // local-dev database that ran the *original* v7 migration before
      // favorite language became multi-select — repairs the singular
      // `favorite_language` column it created into the list-shaped
      // `favorite_languages` one above (carrying over any value, then
      // dropping the old column). A v6 database jumping straight to v8
      // via the block above never had the old column, so the repair is a
      // guarded no-op for it.
      if (from < 8) {
        await m.addColumn(guestProfiles, guestProfiles.keyboardModel);
        final hasLegacyColumn = await m.database
            .customSelect(
              "SELECT 1 FROM pragma_table_info('guest_profiles') "
              "WHERE name = 'favorite_language'",
            )
            .getSingleOrNull();
        if (hasLegacyColumn != null) {
          await m.addColumn(guestProfiles, guestProfiles.favoriteLanguages);
          await m.database.customStatement(
            'UPDATE guest_profiles SET favorite_languages = favorite_language '
            "WHERE favorite_language IS NOT NULL AND favorite_language != ''",
          );
          await m.dropColumn(guestProfiles, 'favorite_language');
        }
      }
      // v8 -> v9: added the bilingual explanation_en/explanation_es
      // columns to snippets, for the post-session "what did you just
      // type?" learning card. Existing rows get '' until the next
      // catalog seed (an upsert keyed by id) overwrites every column,
      // these two included, with the real authored text.
      if (from < 9) {
        await m.addColumn(snippets, snippets.explanationEn);
        await m.addColumn(snippets, snippets.explanationEs);
      }
      // v9 -> v10: split snippets' single (English-only) `title` column
      // into bilingual `title_en`/`title_es` — the app's content is
      // being fully internationalized, matching the explanation
      // columns' own En/Es split above. The old column is dropped
      // outright (not backfilled into `title_en`): the very next
      // catalog seed (an upsert keyed by id) overwrites every column
      // anyway, this one included, with the real bilingual titles.
      if (from < 10) {
        await m.addColumn(snippets, snippets.titleEn);
        await m.addColumn(snippets, snippets.titleEs);
        await m.dropColumn(snippets, 'title');
      }
      // v10 -> v11: added a bilingual tldr_en/tldr_es column pair to
      // snippets — a skimmable one-liner shown above the fuller
      // explanation_en/explanation_es. Existing rows get '' until the
      // next catalog seed overwrites every column with the real text.
      if (from < 11) {
        await m.addColumn(snippets, snippets.tldrEn);
        await m.addColumn(snippets, snippets.tldrEs);
      }
      // v11 -> v12: added the nullable activity_report_json column to
      // progress_snapshot_cache (SPEC.md §4.2/§4.3's "dónde practicas
      // más"/"dónde tienes el puntaje más bajo" report). Existing cached
      // rows get NULL until the next recompute backfills a real value —
      // `ProgressSnapshotCacheRowMapper` treats NULL as
      // `ActivityReport.empty` in the meantime.
      if (from < 12) {
        await m.addColumn(
          progressSnapshotCache,
          progressSnapshotCache.activityReportJson,
        );
      }
      // v12 -> v13: added three nullable auto-detected columns (platform,
      // operating_system_version, device_model) to guest_profiles.
      // Existing rows get NULL until `EnsureDeviceInfoUseCase` runs once
      // on the next app start and fills them in.
      if (from < 13) {
        await m.addColumn(guestProfiles, guestProfiles.platform);
        await m.addColumn(guestProfiles, guestProfiles.operatingSystemVersion);
        await m.addColumn(guestProfiles, guestProfiles.deviceModel);
      }
      // v13 -> v14: added the `daily_challenge` feature's
      // daily_challenge_completions table (SPEC.md §5.4, offline Phase 0
      // — see project plan). Nothing existing is touched, only the new
      // table is created.
      if (from < 14) {
        await m.createTable(dailyChallengeCompletions);
      }
      // v14 -> v15: added an index on
      // typing_sessions(profile_id, started_at_utc_micros). Every device
      // has exactly one guest profile today, so `watchSessionsForProfile`
      // (practice_dao.dart) filtering by profile_id gains nothing yet —
      // but it needs to be in place before multi-profile/sync (STACK.md
      // §6) makes profile_id actually selective. Reruns
      // `_createPracticeIndices`, whose other statements are already
      // `IF NOT EXISTS` no-ops on an existing database.
      if (from < 15) {
        await _createPracticeIndices(m);
      }
    },
  );
}
