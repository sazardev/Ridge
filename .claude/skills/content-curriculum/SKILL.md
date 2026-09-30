---
name: content-curriculum
description: Use when adding/editing snippets in assets/content/snippets/{go,bash,sql,rust,zig,python,javascript,typescript,haskell,c,cpp,java,crystal,swift,css,csharp,dart,kotlin,php,git}_v1.json, editing a Learning Path's lesson order in assets/content/learning_paths/*.json (including `zig_foundations_v1.json` and `zig_algorithms_v1.json`), or adding a new bilingual content field (schema + domain + drift + presentation). Encodes hard-won rules from building the 51-lesson go-foundations path — two earlier automated ordering attempts both produced real beginner-incoherence bugs before a manual, adversarially-audited pass fixed them. Bash (Arch Linux), SQL (PostgreSQL, shared library database), Rust, Zig (`zig_v1.json`), Python, JavaScript, TypeScript, Haskell, C, C++, Java, Crystal, Swift, CSS, C#, and Dart are course-only catalogs built the same way (their foundations routes reuse Go's generic categories — Haskell's presents recursion instead of loops, TypeScript's broader tour adds `classesAndObjects`/`modules` as its own categories, C adds `arraysAndStrings`/`memoryManagement`/`preprocessor`/`fileIO`, C++ adds `templates`/`stlContainers`, Swift adds `optionals`/`closures`/`enumsAndPatternMatching` (plus `codable`/`propertyWrappers` in its advanced course), C# adds `patternMatching`/`delegatesAndEvents`/`linq`/`asyncProgramming` (in its advanced course), Dart adds `recordsAndPatterns` (reusing `collections`/`nullSafety`/`asyncProgramming`), Kotlin adds `nullSafety`/`dataClasses`/`lambdas`/`extensions`/`coroutines` (reusing `collections`), CSS uses none of Go's: it adds `cssSelectors`/`cssBoxModel`/`cssColorsAndTypography`/`cssLayout`/`cssPositioning`/`cssCustomProperties`/`cssResponsive`/`cssTransitionsAndAnimations`, and PHP uses none of Go's either: its three routes add nineteen categories (`phpBasics`/`phpStrings`/`phpConditionals`/`phpLoops`/`phpArrays`/`phpFunctions`/`phpClasses`/`phpEnums`/`phpErrorHandling`/`phpNamespaces`/`phpSuperglobals`/`phpForms`/`phpSessions`/`phpDatabase`/`phpJson`/`phpFiles`/`phpSearching`/`phpSorting`/`phpGraphs`), and Git uses none of Go's either: its three routes (`git-foundations-v1`/`git-workflows-v1`/`git-internals-v1`) add ten categories (`gitBasics`/`gitCommits`/`gitBranching`/`gitRemotes`/`gitHistory`/`gitUndo`/`gitCollaboration`/`gitObjects`/`gitRefs`/`gitMaintenance`). Linux (Arch Linux: foundations, administration and networking routes) is course-only too, verified as real command lines in disposable Arch containers (plain, privileged, and systemd-enabled). GitHub Actions (`github_actions_v1.json`) is course-only too: three routes add thirteen categories of their own (a YAML CI/CD pipeline shares no concept with Go's categories), verified with actionlint + ShellCheck, action-validator, check-jsonschema, and 33 workflows actually executed with `act`.
metadata:
  domain: content
  scope: content-authoring, curriculum-design
  role: specialist
  triggers: snippet, learning path, lesson order, curriculum, tldr, explanationEn, go_v1.json, go_foundations, zig_v1.json, zig_foundations_v1, zig_algorithms_v1
  related-skills: dart-best-practices, flutter-testing
---

# Content & Curriculum

Owns the bundled, versioned JSON assets that back this app's whole
practice experience: the snippet catalogs (Go
`assets/content/snippets/go_v1.json`, Bash `bash_v1.json`, SQL
`sql_v1.json`, Rust `rust_v1.json`, Zig `zig_v1.json`, Python `python_v1.json` (which also
backs the three Django routes `python-django-foundations-v1`/
`python-django-orm-v1`/`python-django-rest-v1`), JavaScript
`javascript_v1.json`, TypeScript `typescript_v1.json`, Haskell
`haskell_v1.json`, C `c_v1.json`, C++ `cpp_v1.json`, Java
`java_v1.json`, Crystal `crystal_v1.json`, Swift `swift_v1.json`, CSS `css_v1.json`, C# `csharp_v1.json`, Dart `dart_v1.json`, Kotlin `kotlin_v1.json`, PHP `php_v1.json`, Git `git_v1.json`, Linux `linux_v1.json`, GitHub Actions `github_actions_v1.json`, Docker `docker_v1.json`, SPEC.md §3), and the
curated Learning Path curriculum, including
`zig_foundations_v1.json` (`zig-foundations-v1`) and
`zig_algorithms_v1.json` (`zig-algorithms-v1`) under
`assets/content/learning_paths/`, and `swift_swiftui_calculator_v1.json`
(`swift-swiftui-calculator-v1`, 34 lessons that build a working calculator:
view layer, a pure-Swift testable engine, and SwiftUI state) (one file per route, SPEC.md §5.7).
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
   catalog: `gofmt -l` + `go build`/`go run` for Go (for the Go 1.26/1.27
   advanced catalogs force `GOTOOLCHAIN=go1.27.0` and the toolchain's own
   `gofmt` — see `references/snippet-authoring.md`), a
   `sqlite3`/Bash smoke run for Bash, a real PostgreSQL 16 run for SQL
   (a disposable `podman run postgres:16-alpine` container works well —
   the SQL course builds a shared `library` database; its `sqlSchema`
   lessons verify cumulatively, every other snippet runs against a freshly
   seeded copy), `rustfmt --check` + `rustc`/run for Rust (wrap bare
   statement fragments in a throwaway `fn main() { ... }` to compile-check
   them; the catalog itself stores the fragment unindented, matching how
   Go's own bare-statement categories are stored), `tsc --strict` plus node
   for TypeScript (compile every snippet for real and execute it; drive
   definitions-only algorithm snippets with a throwaway concatenated
   driver — see `references/snippet-authoring.md`), and `ghc -fno-code` +
   `runghc` for Haskell (a disposable `podman run haskell:9.8-slim`
   container; GHC lives at `/opt/ghc/9.8.4/bin`, wrap fragments in
   `module Check where` and prepend the types/imports the fragment assumes,
   e.g. `type Graph`), and real `gcc` + `clang` for C
   (`-std=c17 -Wall -Wextra -Werror -pedantic`, plus
   `-fsanitize=address,undefined`; wrap statement fragments in a throwaway
   `int main(void) { ... return 0; }`, drive definitions-only algorithm
   snippets, and differentially fuzz every sort/search/graph against libc
   `qsort` and an independent Bellman-Ford/flood-fill reference — see
   `references/snippet-authoring.md`), real `g++` + `clang++` for C++
   (`-std=c++20 -Wall -Wextra -Werror -pthread`; statement fragments and
   definitions-only snippets compile inside generated harnesses, and the 12
   algorithm snippets are differentially fuzzed against independent
   references — see `references/snippet-authoring.md`), real `javac` +
   `java` for Java (statement fragments wrapped in a throwaway class, and
   the 12 algorithm snippets driven with edge cases — see
   `references/snippet-authoring.md`), and real Crystal 1.21 via
   `podman run docker.io/crystallang/crystal:latest` (every foundations
   snippet is a runnable program; definitions-only algorithm snippets get
   a throwaway driver with edge cases — see
   `references/snippet-authoring.md`), real Swift 6.2 via
   `podman run docker.io/library/swift:6.2` (every snippet must compile with
   `swiftc -warnings-as-errors`; definitions-only algorithm snippets get a
   driver and all 12 are differentially fuzzed against independent
    references — see `references/snippet-authoring.md`). **SwiftUI view
    snippets are the exception**: Apple ships no SwiftUI for Linux, so they are
    typechecked by the real swiftc front end against a hand-written stub
    module (`bash tool/swiftui_stub/verify.sh <file>`) *and* by composing the
    whole route into one compilable file, with the pure-Swift engine lessons
    compiled and run for real — see `references/snippet-authoring.md`), two
    independent
    parsers for CSS (`npx --yes csstree-validator` validates every property/value
    against the spec, and `lightningcss` parses it again as a second
    engine; both must be clean — see `references/snippet-authoring.md`), and
    real C# on .NET SDK 10 (`podman run mcr.microsoft.com/dotnet/sdk:10.0`;
    every catalog snippet is compiled as `Program.cs` with
    `<Nullable>enable</Nullable>` and `<TreatWarningsAsErrors>true</TreatWarningsAsErrors>`,
    executed, and the 12 algorithm snippets are differentially fuzzed against
    `Array.Sort`/`Array.IndexOf`, an independent flood fill, and Bellman-Ford
    — see `references/snippet-authoring.md`), and the bundled Dart SDK 3.13
    (`dart format`, `dart analyze`, `dart run`; statement fragments are wrapped
    in a throwaway `void main()`, definitions-only snippets get a driver, and
    the 12 algorithm snippets are differentially fuzzed against `List.sort`,
    an independent scan, flood fill, and Bellman-Ford — see
    `references/snippet-authoring.md`). Kotlin uses real `kotlinc` 2.4
    (`-Werror`, `-include-runtime`, plus the `kotlinx-coroutines-core-jvm`
    jar for the advanced course): each catalog fragment is compiled inside a
    `fun main()` wrapper or a per-entry driver and must be a verbatim
    substring of the compiled file, and the 12 algorithm snippets are
    differentially fuzzed against `sortedArray`, an independent scan, flood
    fill, and Bellman-Ford — see `references/snippet-authoring.md`. PHP uses
    the official `php:8.4-cli` image (PHP 8.4.25, with `pdo_sqlite`): every
    snippet is linted with `php -l` and executed, superglobal snippets are
    driven with pre-filled `$_GET`/`$_POST`/`$_COOKIE`, the `Graph` lesson is
    prepended when driving BFS/DFS/Dijkstra, and the 12 algorithm snippets
    are differentially fuzzed against `sort`/`array_search`/an independent
    traversal/Bellman-Ford — see `references/snippet-authoring.md`.
    Git is verified with the real `git` binary (2.55 here): every snippet runs
    in a fresh disposable repository with an isolated `HOME`, fixed
    author/committer identity and dates, and asserted output/state, and the
    catalog is re-run against the final merged asset — see
    `references/snippet-authoring.md`. Linux (`assets/content/snippets/linux_v1.json`)
    runs every command in a disposable `archlinux:latest` container — plain for
    read-only lessons, `--privileged` for `ip`/`nft`, and `--systemd=always
    --privileged` with `/sbin/init` for `systemctl`/`journalctl`/`systemd-run`
    — asserting output, exit code and resulting state, and re-running the whole
    harness against the final merged asset — see
    `references/snippet-authoring.md`. GitHub Actions
    (`github_actions_v1.json`) goes through `actionlint` with `shellcheck`
    on `PATH` (workflow schema, contexts, expressions, and every `run:`
    script), `action-validator` (workflows + composite `action.yml`),
    `check-jsonschema --builtin-schema vendor.dependabot`, `gh <cmd>
    --help` for the CLI lessons, and a representative subset actually
    executed with `act` + podman — see `references/snippet-authoring.md`.
    Docker (`docker_v1.json`) runs every snippet against a real engine
    (Docker 29 + Compose 5.5): command lines line by line, and
    Dockerfile/`.dockerignore`/`compose.yaml` fragments written verbatim
    to their target filename and driven with `docker build`/`docker run`/
    `docker compose up -d`, asserting output and post-state — see
    `references/snippet-authoring.md`.
    Zig (`zig_v1.json`) uses the
    official stable 0.16.0 binary/checksum, runs `zig fmt --check`, and
    executes 44 run cases with `zig run` plus 2 test cases with `zig test`;
    every harness uses the exact catalog `code`, asserts behavior, and
    differentially fuzzes the 12 algorithms. The app integration has
    targeted tests — see `references/snippet-authoring.md`.
    Never trust generated code unverified.
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
- Check the real dev db (`~/Documents/ridge.db.sqlite`,
  `lesson_progress_cache`/`typing_sessions`) for genuine completed progress
  before reassigning which snippet occupies an existing lesson id — bump
  the id scheme (e.g. `-o2-` → `-o3-`) if any real completion exists
- Keep each Learning Path lesson's `id` (the `stepNN` suffix) and `order`
  field in sync with its actual array position after any reorder
- Verify every new snippet by executing it: `gofmt -l` and
  `go build`/`go run` for Go, a real PostgreSQL 16 run for SQL, a shell
  smoke run for Bash, `rustfmt --check` and `rustc`+run for Rust, and
  `tsc --strict` plus node on the emitted JS for TypeScript,
  `ghc -fno-code` + `runghc` for Haskell, `gcc` + `clang` with
  `-std=c17 -Wall -Wextra -Werror -pedantic` (ASan/UBSan and differential
  fuzzing included) for C, `g++` + `clang++` with
  `-std=c++20 -Wall -Wextra -Werror -pthread` for C++, `javac` + `java`
  for Java, `podman run docker.io/crystallang/crystal` (Crystal 1.21)
  for Crystal, `podman run docker.io/library/swift:6.2` (Swift 6.2,
  `swiftc -warnings-as-errors` plus differential fuzzing) for Swift — and for
  **SwiftUI**, `tool/swiftui_stub/verify.sh` against the stub module plus a
  composed-route compile, since Apple ships no SwiftUI for Linux,
  `csstree-validator` + `lightningcss` for CSS, and .NET SDK 10
  (`mcr.microsoft.com/dotnet/sdk:10.0`, nullable + warnings-as-errors) for C#,
  and `dart format` + `dart analyze` + `dart run` with the bundled Dart SDK
  3.13 for Dart (statement fragments wrapped in `void main()`, algorithms
  driven and fuzzed), official Zig 0.16.0 with `zig fmt --check` and
   exact-catalog harnesses (44 `zig run` cases, 2 `zig test` cases,
  behavioral assertions, and differential algorithm fuzzing) for Zig, and
  real `kotlinc` 2.4 with `-Werror`
  (coroutine snippets link `kotlinx-coroutines-core-jvm`) for Kotlin,
  compiling every fragment inside a `fun main()` wrapper or a per-entry
  driver and fuzzing the 12 algorithms, and `php -l` plus
  `podman run docker.io/library/php:8.4-cli` (PHP 8.4) for PHP, driving
  superglobals and the cumulative `Graph` lesson and fuzzing the 12
  algorithms vs `sort`/`array_search`/Bellman-Ford, the real `git`
   binary (2.55) for Git, one disposable repository per snippet with an
   isolated `HOME` and fixed author/date, asserting output and state,
   `podman run docker.io/library/archlinux:latest` for Linux (plain,
   `--privileged`, or `--systemd=always --privileged /sbin/init`), one
   disposable container per snippet with its own setup, asserting
   stdout/stderr/exit code and post-state, and `actionlint` + ShellCheck,
   `action-validator`, `check-jsonschema` and `act` + podman for GitHub
   Actions (33 workflows executed) with the event-data-in-`env` rule,
   and a real Docker 29 + Compose 5.5 engine for Docker (commands run
   line by line, Dockerfiles/`.dockerignore`/`compose.yaml` driven with
   real `docker build`/`compose up` and asserted on output and state)
- Keep every (category, difficulty) cell at ≥3 active entries for the 5
  "core" categories of each free-practice language (see
  `snippet_catalog_completeness_test.dart`) before reclassifying or
  deactivating a snippet; course-only catalogs (Bash, SQL, Rust, Zig, Python,
  JavaScript, TypeScript, Haskell, C, C++, Java, Crystal, Swift, CSS, C#,
   Dart, Kotlin, PHP, Git, Linux, GitHub Actions, Docker) instead require
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
