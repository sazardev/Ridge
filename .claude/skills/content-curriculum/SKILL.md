---
name: content-curriculum
description: Use when adding/editing snippets in assets/content/snippets/{go,bash,sql}_v1.json, editing a Learning Path's lesson order in assets/content/learning_paths/*.json, or adding a new bilingual content field (schema + domain + drift + presentation). Encodes hard-won rules from building the 51-lesson go-foundations path — two earlier automated ordering attempts both produced real beginner-incoherence bugs before a manual, adversarially-audited pass fixed them. Bash (Arch Linux) and SQL (PostgreSQL, shared library database) are course-only catalogs built the same way.
metadata:
  domain: content
  scope: content-authoring, curriculum-design
  role: specialist
  triggers: snippet, learning path, lesson order, curriculum, tldr, explanationEn, go_v1.json, go_foundations
  related-skills: dart-best-practices, flutter-testing
---

# Content & Curriculum

Owns the bundled, versioned JSON assets that back this app's whole
practice experience: the snippet catalogs (Go
`assets/content/snippets/go_v1.json`, Bash `bash_v1.json`, SQL
`sql_v1.json`, SPEC.md §3), and the curated Learning Path curriculum
(one file per route under `assets/content/learning_paths/`, SPEC.md §5.7).
All are read-only at runtime; snippet catalogs are idempotently seeded
into drift tables on launch, paths are read straight from the bundle.

## When to Use This Skill

- Adding, editing, or deprecating an entry in the snippet catalog
- Reordering, adding, or removing lessons in a Learning Path
- Adding a new bilingual content field (e.g. a `tldrEn`/`tldrEs`-style pair)
- Reviewing whether a curriculum's lesson order is coherent for a beginner

## Core Workflow

1. **Understand the shape first** — read `references/content-model.md` for
   the JSON schema, the domain-entity/DTO/drift-table mapping, and the
   bilingual-field presentation pattern before touching either JSON file.
2. **Reordering a Learning Path?** — read `references/lesson-ordering.md`
   FIRST. Two mechanical approaches (strict difficulty-tag blocks; pure
   code-length sort) were both tried and both produced real beginner-
   incoherence bugs this session. Hand-curate by genuine concept dependency
   instead, then run `scripts/audit_lesson_order.py` (fast, mechanical
   checks) and get an independent adversarial review (a fresh agent/fork
   told to actively hunt for problems, not confirm your own ordering)
   before treating it as done.
3. **Adding a new snippet?** — read `references/snippet-authoring.md`.
   Every new snippet's code MUST be executed for real before it goes in the
   catalog: `gofmt -l` + `go build`/`go run` for Go, a
   `sqlite3`/Bash smoke run for Bash, and a real PostgreSQL 16 run for SQL
   (a disposable `podman run postgres:16-alpine` container works well —
   the SQL course builds a shared `library` database; its `sqlSchema`
   lessons verify cumulatively, every other snippet runs against a freshly
   seeded copy). Never trust generated code unverified.
4. **Adding a new schema field?** — read `references/migrations-and-tests.md`
   for the drift migration pattern and the exact test files/fixtures that
   need updating.
5. **Verify** — `flutter analyze` clean, `flutter test` full suite green,
   and re-run `scripts/audit_lesson_order.py` after any Learning Path edit.

## Constraints

### MUST DO
- Hand-curate Learning Path lesson order by concept dependency; get an
  adversarial second opinion before calling it done (see
  `references/lesson-ordering.md`)
- Check the real dev db (`~/Documents/jit.db.sqlite`,
  `lesson_progress_cache`/`typing_sessions`) for genuine completed progress
  before reassigning which snippet occupies an existing lesson id — bump
  the id scheme (e.g. `-o2-` → `-o3-`) if any real completion exists
- Keep each Learning Path lesson's `id` (the `stepNN` suffix) and `order`
  field in sync with its actual array position after any reorder
- Verify every new snippet by executing it: `gofmt -l` and
  `go build`/`go run` for Go, a real PostgreSQL 16 run for SQL, a shell
  smoke run for Bash
- Keep every (category, difficulty) cell at ≥3 active entries for the 5
  "core" categories of each free-practice language (see
  `snippet_catalog_completeness_test.dart`) before reclassifying or
  deactivating a snippet; course-only catalogs (Bash, SQL) instead require
  every active snippet to be referenced by a bundled path — no orphans
- Delegate large content-authoring batches (10+ entries) to a background
  `general-purpose` agent with a detailed style guide + few-shot examples;
  have it self-validate and write to `/tmp/*.json`; merge with your own
  independent validation script (see `references/snippet-authoring.md`)

### MUST NOT DO
- Order a Learning Path's lessons by grouping strictly into
  (category, difficulty) blocks — a category's "intermediate"/"advanced"
  tier can require unintroduced syntax (e.g. a full `func` body) right
  after a "beginner" tier of bare one-liners, producing a sudden cliff
- Order lessons by pure code length either — length isn't a reliable
  proxy for concept dependency (e.g. "swap two variables" is shorter than,
  but conceptually depends on, "declare a variable")
- Split one category's lessons across two non-contiguous ranges to fix a
  soft cross-category dependency — the category/difficulty-chip UX cost
  of a broken block is usually worse than the dependency issue it fixes
- Silently reorder lesson-id-to-snippet assignment when real
  `lesson_progress_cache` completions exist for those ids
- Add a new required domain field without checking how many test fixtures
  construct `Snippet(...)`/`Lesson(...)` literals directly (they all need
  the new field too)
- Trust LLM-generated Go code in the catalog without running it

## Reference Guide

| Topic | Reference | Load When |
|-------|-----------|-----------|
| Schema/architecture | `references/content-model.md` | Any edit to either JSON asset, or adding a field |
| Lesson ordering | `references/lesson-ordering.md` | Reordering/adding Learning Path lessons |
| Snippet authoring | `references/snippet-authoring.md` | Adding/rewriting snippet catalog entries |
| Migrations & tests | `references/migrations-and-tests.md` | Adding a schema field; any content edit's test fallout |

## Troubleshooting Common Failures

| Symptom | Likely Cause | Recovery |
|---------|-------------|----------|
| User says a lesson jump "feels random"/"too fast" | Ordered by tag-block or length instead of concept dependency | Re-read `references/lesson-ordering.md`, hand-curate, get an adversarial audit |
| `content_drift_integration_test.dart` fails on a count or id-set assertion | Catalog total count changed, or a new snippet contains a searched-for symbol | Update the hardcoded count/id-set to match (see `references/migrations-and-tests.md`) |
| A learner's "completed" lesson shows against the wrong snippet after a reorder | Reused a lesson id for a different snippet while real progress existed under it | Bump the lesson-id version suffix instead; never reuse in place when progress exists |
| `snippet_catalog_completeness_test.dart` "fewer than 3" failure | A reclassify/deactivate dropped a (category, difficulty) cell below 3 | Author a replacement (gofmt+`go run`-verified) or revert the reclassification |
| New required `Snippet`/`Lesson` field breaks ~10 test files | Fixtures construct literals directly, not via DTOs | Batch-patch with a regex script for the common case; fix object-property-reference fixtures manually |
