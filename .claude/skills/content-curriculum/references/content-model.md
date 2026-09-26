# Content model: schema, layers, bilingual pattern

## The two bundled JSON assets

**Snippet catalog** — `assets/content/snippets/go_v1.json`, a flat array.
Each entry:

```jsonc
{
  "id": "go-vars-001",          // stable across revisions
  "revision": 1,                 // bumped on a correction; old id+revision stays, isActive:false
  "language": "go",
  "difficulty": "beginner",      // beginner | intermediate | advanced | expert
  "category": "variablesAndTypes",
  "length": "short",             // short | medium | long — independent of difficulty
  "titleEn": "...", "titleEs": "...",
  "code": "name, age := \"Ada\", 36\nfmt.Println(name, age)",
  "sourceAttribution": "hand-authored for ...",
  "isActive": true,
  "explanationEn": "...", "explanationEs": "...",  // 3 sentences: what / why / when-it's-used
  "tldrEn": "...", "tldrEs": "...",                 // <=80 chars, skimmable one-liner
  "symbolFocus": ["_", "%"]       // optional, drives findContainingSymbols weakness lookups
}
```

Invariants enforced by `test/features/content/snippet_catalog_completeness_test.dart`:
- Every (category, difficulty) cell has ≥3 active entries for the 5 "core"
  categories (variablesAndTypes, conditionals, loops, functions,
  errorHandling); ≥1 for the other 7. **This depth rule applies to
  free-practice languages only (currently Go)** — a course-only language's
  catalog instead must contain exactly the snippets its bundled paths use,
  no orphan practice material (see "Language tiers" below).
- Exactly one active revision per id, and it's the highest revision number.
- `explanationEn/Es` non-empty, ≤950 chars (a tight three sentences).
- `tldrEn/Es` non-empty, ≤80 chars.
- `titleEn/Es` non-empty.
- Every Learning Path lesson's `snippetId` resolves to an active entry.

## Language tiers (SPEC.md §3.2)

A language is either **free-practice** or **course-only**:

| Tier | Example | Catalog role | Completeness bar |
|---|---|---|---|
| Free-practice | Go | backs Zen/Sprint/Precision and the browser | dense grid: ≥3 per (category, difficulty) cell in core categories, ≥1 elsewhere |
| Course-only | Bash, SQL, Rust, Python, JavaScript, TypeScript, Haskell, C, C++, Java, Crystal, Swift, CSS, C#, Dart, Kotlin, PHP, Git, Linux, GitHub Actions, Docker, Zig | exists only to compose its Learning Route(s) | every active snippet must be used by a bundled path; no orphans |

Zig currently has 46 active snippets across `zig-foundations-v1` (34) and `zig-algorithms-v1` (12), and adds the two generic `ContentCategory` values `comptime` and `testing`.

Practical consequences:
- A course-only language's snippet set is authored together with its path —
  there is no "extra practice pool" to keep stocked.
- The browser and free-practice screens filter by language (default Go), so
  a course-only language never leaks into random practice.
- Register a new language in `ProgrammingLanguage`, add its tokenizer and any
  new `ContentCategory` values, and add every bundled snippet/path asset to
  the relevant `defaultAssetPaths`, `pubspec.yaml`, and test asset lists. The
  Learning Paths screen and language selector already handle any number of
  languages. Zig reuses the existing categories and adds `comptime` and
  `testing`; adding its bundled catalog and paths requires no drift
  migration.

**Learning Path** — `assets/content/learning_paths/go_foundations_v1.json`,
an array with one path object:

```jsonc
{
  "id": "go-foundations-v1",
  "language": "go",
  "titleEn": "...", "titleEs": "...",       // short — one line, no subtitle clause
  "descriptionEn": "...", "descriptionEs": "...",  // ONE short sentence (~80-100 chars) — shown alongside chips, not instead of them
  "tagEn": "...", "tagEs": "...",           // one short word/phrase for the card's topic chip, e.g. "Backend" / "Fundamentals"
  "lessons": [
    {
      "id": "go-foundations-v1-o2-step01",  // must match "order" (see lesson-ordering.md)
      "snippetId": "go-vars-001",
      "order": 1,
      "titleEn": "...", "titleEs": "..."    // copied verbatim from the snippet's own title
    }
    // ...
  ]
}
```

## Layer mapping (hexagonal — read-side is asset-only, no drift needed for the path itself)

| Layer | File | Notes |
|---|---|---|
| Domain entity | `lib/features/content/domain/entities/snippet.dart` | All bilingual fields `required String`, never optional |
| DTO | `lib/features/content/infrastructure/snippet_dto.dart` | Mirrors the JSON shape exactly; newer fields may be `@Default('')` for parsing leniency even though the domain entity stays required (compatible: `toDomain()` always supplies a resolved value) |
| Drift table | `lib/features/content/infrastructure/tables/snippets_table.dart` | New optional columns use `.withDefault(const Constant(''))` |
| Mapper | `lib/features/content/infrastructure/snippet_mapper.dart` | 4 directions: DTO↔domain, DTO↔drift row/companion |
| Repository | `lib/features/content/infrastructure/snippet_repository_impl.dart` | `getById` queries the drift table directly — no in-memory cache to race against |
| Learning Path repo | `lib/features/learning_paths/infrastructure/learning_path_repository_impl.dart` | Reads every bundled path asset directly via `rootBundle` on every call (one file per path, listed in `defaultAssetPaths`) — never seeded into drift (curriculum is tiny, read-only, never user-mutated). A new path means: add its JSON file, list it in both `defaultAssetPaths` and `pubspec.yaml`'s assets, add it to `_learningPathAssetPaths` in `snippet_catalog_completeness_test.dart` |

`lesson_progress_cache` (drift table, IS persisted) is the only
Learning-Path-adjacent state that's actually stored — keyed by
`(profileId, lessonId)`, fully derived/re-derivable, see
`RecomputeLessonProgressUseCase`.

## Bilingual field pattern

Every bilingual field is a `fooEn`/`fooEs` pair on the domain entity, plus a
presentation-layer resolver extension in
`lib/features/content/presentation/content_labels.dart`:

```dart
extension SnippetTldrLabel on Snippet {
  String tldrFor(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'es' ? tldrEs : tldrEn;
}
```

Adding a new bilingual field means touching, in order: domain entity → DTO →
drift table (+ migration, see `migrations-and-tests.md`) → mapper (all 4
directions) → presentation extension → the actual UI widget consuming it →
~10 test fixtures that construct `Snippet(...)` literals directly.
