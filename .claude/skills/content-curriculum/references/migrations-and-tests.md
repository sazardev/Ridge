# Adding a schema field: migration + test fallout

## Drift migration pattern

`lib/core/persistence/drift/app_database.dart` — bump `schemaVersion` by
exactly 1, add one new `if (from < N)` block to `migration`'s `onUpgrade`:

```dart
// vN-1 -> vN: added a bilingual foo_en/foo_es column pair to snippets —
// <one sentence on what it's for>. Existing rows get '' until the next
// catalog seed overwrites every column with the real text.
if (from < N) {
  await m.addColumn(snippets, snippets.fooEn);
  await m.addColumn(snippets, snippets.fooEs);
}
```

The comment convention (what changed, why existing rows are safe, what
backfills them) is followed for every prior migration in this file — keep
matching it. New optional columns use
`.withDefault(const Constant(''))` in the table definition
(`lib/features/content/infrastructure/tables/snippets_table.dart`) so
they're optional in `...Companion.insert()` — but this does NOT make the
generated `...Row` data class's constructor field optional (it stays
`required`), and it does NOT mean the domain entity field should be
optional either (defaults exist purely for migration/JSON-parsing
leniency, not because the concept itself is optional).

**After changing the schema**: verify against the real dev database, not
just tests —

```bash
sqlite3 ~/Documents/ridge.db.sqlite "PRAGMA user_version;"          # matches new schemaVersion
sqlite3 ~/Documents/ridge.db.sqlite "PRAGMA table_info(snippets);"  # new columns present
```

(The migration only actually runs the next time the real app launches and
opens that file — a stale `PRAGMA user_version` after a code change usually
means you haven't relaunched the app since editing, not a migration bug.)

## Tests that WILL break, and how to fix them

**`test/features/content/content_drift_integration_test.dart`** —
hardcodes the total catalog row count (e.g. `90`) in several places
(a stream-settling predicate, multiple `hasLength(N)` expectations) and
hardcodes specific id-sets for `findContainingSymbols` tests (which ids
contain a literal `_` or `%`, etc.). Adding/removing a catalog entry means:
update every hardcoded count, and re-check (e.g. with a quick Python
one-liner) whether the new entry's `code` contains any of the symbols each
`findContainingSymbols` test searches for — add it to that test's expected
id-set if so.

**`test/features/content/snippet_catalog_completeness_test.dart`** — no
hardcoded counts, but will fail if you drop a (category, difficulty) cell
below 3 (5 core categories) or 1 (the rest), leave a bilingual field empty
or over-length, or leave two revisions of one id both active.

**~10 test fixture files construct `Snippet(...)`/`Lesson(...)` literals
directly** (not via DTOs), so a new *required* domain field breaks all of
them at once:
`test/features/learning_paths/learning_paths_drift_integration_test.dart`,
`test/features/practice/snippet_info_screen_test.dart`,
`test/features/practice/get_next_sprint_snippet_usecase_test.dart`,
`test/features/practice/keystroke_capture_field_test.dart`,
`test/features/practice/practice_drift_integration_test.dart`,
`test/features/practice/finish_practice_session_usecase_test.dart`,
`test/features/data_management/data_management_drift_integration_test.dart`,
`test/features/achievements/achievements_drift_integration_test.dart`,
`test/features/progression/progression_drift_integration_test.dart`,
`test/features/content/snippet_mapper_test.dart`. A batch Python script
inserting the new field's line immediately before an existing anchor field
(e.g. right before `explanationEn:`) handles most of these; `snippet_mapper_test.dart`
needs manual fixing since a couple of its fixtures reference object
properties (`multi.tldrEn`, `dto.tldrEn`) rather than literals.

Run `flutter analyze` after the batch patch — it catches any fixture the
script missed far faster than running the full test suite first.

## Reordering-only changes (no schema change)

A pure Learning-Path lesson reorder touches none of the above — but DOES
risk breaking any test with a hardcoded lesson id. Check first:

```bash
grep -rn "go-foundations-v1-" test/
```

Tests that construct their OWN fake `LearningPath`/lessons (not reading the
real bundled JSON) only care that the id STRING matches what they wrote —
update those constants if your reorder changed which snippet occupies that
position. Tests that load the real asset via `rootBundle` need no changes
for a pure reorder, since they resolve whatever the file currently says.
