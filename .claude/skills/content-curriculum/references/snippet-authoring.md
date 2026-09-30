# Authoring/rewriting snippet catalog content

## New Go code: always compile and run it

Never trust LLM-generated Go code in the catalog without actually executing
it. For every new snippet:

```bash
echo '<the exact code, wrapped in package main + imports if it is not already a full file>' > /tmp/check.go
gofmt -l /tmp/check.go        # must print nothing (zero diff)
go run /tmp/check.go          # must compile and produce the expected output
```

Both checks are cheap and have caught real issues before (a snippet that
looked fine by eye but didn't actually gofmt-format cleanly, or wouldn't
compile once wrapped in a runnable `main`). Do this for every new entry,
not just "complex-looking" ones.

## Go 1.26/1.27 snippets (the advanced catalogs): force the toolchain

For snippets that only exist on Go 1.26/1.27 — `go-modern-idioms-v1`
(`go-evol-`, `go-idiom-`, `go-genmeth-`, `go-iter-`, `go-jsonv2-`,
`go-stdlib-`, `go-apidesign-`, `go-errpat-`) and `go-production-v1`
(`go-concpat-`, `go-leak-`, `go-testadv-`, `go-perf-`, `go-obs-`,
`go-tool-`) — the host toolchain (1.26.5 here) is not enough:

- Run everything with `GOTOOLCHAIN=go1.27.0` and a scratch module whose
  `go.mod` says `go 1.27`. The toolchain is cached in the module cache, so
  no download is needed.
- `gofmt` on `PATH` belongs to the host toolchain and rejects 1.27 syntax
  ("method must have no type parameters"); use `$(GOTOOLCHAIN=go1.27.0 go
  env GOROOT)/bin/gofmt`, or `go fmt`.
- Features verified to fail on 1.26.6 and compile on 1.27.0: generic
  methods, promoted field keys in struct literals, generalized function
  type inference, `encoding/json/v2` + `jsontext`, stdlib `uuid`,
  `crypto/mldsa`, GA `goroutineleak`, `net/url` Clone, `rand/v2` generic
  method `N`, `synctest.Sleep`, `httptest.NewTestServer`. The 1.26 group
  (`new(expr)`, self-referential constraints, `errors.AsType`, `reflect`
  iterators, `t.ArtifactDir`, `slog.NewMultiHandler`, scheduler metrics)
  compiles under both, so don't attribute it to 1.27.
- The reusable harness lives at
  `/tmp/opencode/go-adv-course/verify.py` (body/decls/test modes, exact
  stdout assertions, `go fix`/`go generate` cases, and `--against
  <catalog.json>` to re-run the shipped asset). Gotchas it encodes:
  `jsontext` tokens are invalidated by the next read (copy
  `name.String()` before `ReadValue`); `min`/`max` builtins reject slice
  spread (use `slices.Min`/`slices.Max`); a promoted literal key is the
  bare field name (`X:`), never `Point.X`; `//go:embed` into a `string`
  still needs `import _ "embed"` in the compiling file; `go generate`
  cases need a real generator package; `//go:fix inline` is verified by
  running `go fix ./...` and asserting the call site was rewritten (use
  an `int` constant for a clean diff — inlining a typed expression adds a
  conversion); `goroutineleak` detection is asynchronous via the GC, so
  tests assert zero leaks on clean code, never `Count() > 0`
  synchronously.
- Version facts the prose must respect: the `go fix` overhaul and
  `//go:fix inline` are Go 1.26 (1.27 only added more modernizers);
  `/sched/goroutines:goroutines` predates Go 1.16 — only
  `/sched/goroutines-created:goroutines` is new in 1.26; methods on
  generic types have satisfied interfaces since 1.18, only methods with
  their own type parameters can never implement one.

## New SQL code: always run it against PostgreSQL

For the `sql-foundations-v1` catalog, the equivalent of `go run` is
executing against a real PostgreSQL 16 server — a disposable
`podman run -d --rm --name ridge-sql-pg -e POSTGRES_PASSWORD=postgres
docker.io/library/postgres:16-alpine` works well and needs no host
install.

- The course builds a shared `library` database: `authors`, `books`,
  `members`, `loans`. Verify the `sqlSchema` lessons **cumulatively** in
  one psql session (start in `postgres`, run `\l`, `CREATE DATABASE
  library;`, `\c library`, then the `CREATE TABLE`/seed statements in
  lesson order); verify every other snippet against a freshly seeded
  copy, and re-seed before each mutating `INSERT`/`UPDATE`/`DELETE`.
- Assert seed row counts (5 authors, 8 books, 3 members, 5 loans today)
  so a silently-empty multi-row `INSERT` fails loudly.
- Keep catalog `code` ASCII-only: `key_layout_map_test.dart` requires
  every character to map to a physical US-QWERTY key, so accented
  characters in sample data (`'Garcia'`, not `'García'`) are forbidden
  in `code` even though the prose fields keep their accents.
- Bilingual prose is authored separately from code (delegate it to an
  agent as described below); merge it with the execution-verified code
  and re-run the PostgreSQL harness on the merged asset, not just on the
  pre-merge draft.

## New TypeScript code: compile strict and run it

The equivalent of `go run` for a TypeScript snippet is a real compiler plus
a real execution:

- Compile every snippet with `tsc --strict --target ES2022 --module
  commonjs --outDir <scratch> <file>` (TypeScript 7's native `tsc` works;
  `npx -p typescript tsc` if it isn't installed). `--strict` is the bar
  the catalog is authored against.
- Execute the emitted JS with `node`. Definitions-only snippets (the
  `typescript-algo-*` course: searches, sorts, graphs) must be *driven*:
  concatenate the snippet with a throwaway driver that calls each function
  with edge cases (empty array, one element, target absent, already/never
  sorted), then compile and run the combined file. Never ship an algorithm
  snippet that was never actually executed.
- Titles/prose may reference a type declared in an earlier lesson of the
  same course (e.g. `Graph` from the adjacency-list lesson, exactly like
  `rust-algorithms-v1`'s `fn bfs(graph: &Graph, ...)`) — keep the driver's
  copy of that declaration in the scratch harness so the snippet still
  compiles there.
- Beware `lib.dom`'s globals when a snippet compiles standalone as a
  script: `let name` / `let status` collide with `window.name` /
  `window.status` (`TS2451`). Rename the binding (the JS catalog's `name2`
  dodge is the same workaround).
- Keep `code` ASCII-only — `key_layout_map_test.dart` maps every character
  to a physical US-QWERTY key.

## Go code with third-party deps (TUI/Bubble Tea): extract from a compiled app

For snippets that import external packages (`bubbletea`, `lipgloss`,
`bubbles`), `go run /tmp/check.go` proves little and an interactive program
never exits. The pattern used for `go-tui-notes-v1`:

- Build a small reference app in a scratch module (`/tmp/opencode/jit-tui`)
  with pinned versions (`go get github.com/charmbracelet/bubbletea@v1.3.10`
  etc.), structured so every lesson is a contiguous declaration or method
  chunk.
- Make the app pass `gofmt -l` (no output), `go build ./...`, `go vet ./...`
  and `go test ./...`, including a **headless program test**:
  `tea.NewProgram(m, tea.WithInput(strings.NewReader("q")),
  tea.WithOutput(io.Discard))` run in a goroutine under a timeout — this
  exercises the real event loop (Init/Update/View + commands) with no TTY.
- Extract each snippet mechanically (start/end marker script) into JSON, and
  assert every chunk is a **verbatim substring** of the app source plus
  ASCII-only (the `key_layout_map_test` requirement). Never hand-copy code
  into the catalog.
- A snippet that uses a shared declaration introduced in another snippet
  must *show* that declaration in the earliest lesson that needs it (e.g.
  `const listWidth = 40`), or the learner cannot compile along.
- TUI lessons are unusually interdependent: get a fresh adversarial review of
  the ordering — it is what caught nine forward references (styles/widgets
  used before their own lesson) in the first `go-tui-notes-v1` pass.

## New C code: two compilers, sanitizers, and differential fuzzing

The bar for `c_v1.json` is the strictest in the repo because C has no
runtime safety net:

- Compile every snippet with **both** `gcc` and `clang`:
  `-std=c17 -Wall -Wextra -Werror -pedantic`, plus
  `-fsanitize=address,undefined` and (`ASAN_OPTIONS=detect_leaks=1`) when
  running.
- Snippets containing `int main` compile as-is; statement fragments get
  wrapped in a generated `int main(void) { ... return 0; }` with the
  standard includes; function-definition snippets compile as a TU with a
  driver. The catalog `code` must be a **verbatim substring** of the
  compiled TU (assert it, never hand-copy).
- Definitions-only algorithm snippets must be *driven* and *fuzzed*, not
  just compiled: sorts against libc `qsort` (including size 0/1,
  duplicates, already-sorted, reverse-sorted), searches against each other
  (agreement on presence plus valid, in-range, matching indices), BFS/DFS
  reachability against a flood fill (disconnected graphs, isolated start),
  and Dijkstra against an independently written Bellman-Ford with
  unreachable vertices. `INT_MAX` arithmetic needs an explicit overflow
  guard (`distances[current] <= INT_MAX - weight`) or UBSan fails on legal
  weights.
- Allocations inside a snippet (`malloc` in merge sort) need the same NULL
  check the memory lessons teach; on failure return an error code instead
  of writing through the pointer.
- Keep `code` ASCII-only — `key_layout_map_test.dart` maps every character
  to a physical US-QWERTY key.

## New C++ code: two compilers, generated harnesses, differential fuzzing

`cpp_v1.json` follows C's real-execution bar, against C++20:

- Compile every snippet with **both** `g++` and `clang++`:
  `-std=c++20 -Wall -Wextra -Werror -pthread`. Full programs compile
  as-is; statement fragments are wrapped in a generated `int main() { ... }`
  with a broad standard-header set; definitions-only snippets get a
  per-entry driver. The catalog `code` must be a **verbatim substring** of
  the compiled TU (assert it, never hand-copy).
- Drive and fuzz the 12 algorithm snippets: all six sorts against
  `std::sort` (empty, one element, duplicates, negatives, already sorted,
  reverse sorted, all equal), linear search against `std::find`, binary
  search on sorted input only (multiples, absent target, empty), BFS/DFS
  against an independent traversal (disconnected graphs, self-loops), and
  the O(V^2) Dijkstra against a priority-queue or Bellman-Ford reference
  with unreachable nodes (`-1` sentinel).
- The adversarial pass additionally re-ran the whole catalog under
  ASan/UBSan (the thread lesson under TSan): clean. RAII snippets that own
  a raw resource must be non-copyable
  (`Buffer(const Buffer&) = delete; Buffer& operator=(const Buffer&) = delete;`)
  or the lesson ships a double-free trap, and `find_if` results are checked
  against `end()` before being dereferenced.
- Keep `code` ASCII-only — `key_layout_map_test.dart` maps every character
  to a physical US-QWERTY key.

## New Crystal code: run every snippet in a real compiler

The equivalent of `go run` for a Crystal snippet is executing it with a
real compiler — a disposable container works well and needs no host
install:

```sh
podman run --rm -v <scratch>:/work:Z -w /work \
  docker.io/crystallang/crystal:latest crystal run <file>.cr
```

- Foundations snippets are complete runnable programs (top-level code
  runs; there is no `main`), so check the printed output, not just a
  clean compile.
- Definitions-only snippets (the `crystal-algo-*` course) must be
  *driven*: concatenate the snippet with a throwaway driver that calls
  each method with edge cases (empty array, one element, all-equal,
  already/never sorted, target absent) and compares against an
  independent reference (`Array#sort`, a Bellman-Ford for Dijkstra, a
  flood-fill for BFS/DFS). The algorithms course is cumulative: prepend
  the lesson-9 `Graph` class when driving BFS/DFS.
- Crystal gotchas that have bitten real verification: `/` on two ints
  returns `Float64` (`7 / 2 == 3.5`), so integer division must use `//`;
  there is no `block_given?` and no nilable block type (a method either
  requires a block or captures `&` with an explicit non-nilable
  signature); `String#to_sym` doesn't exist (symbols are literals);
  `String#to_i` raises on invalid input (`to_i?` returns `nil`); `Set`
  and `Deque` live in the prelude (no `require` needed); `struct` values
  copy on assignment while classes are references; and `Box` collides
  with the stdlib's `Box(T)`, so pick another class name.
- Keep `code` ASCII-only — `key_layout_map_test.dart` maps every character
  to a physical US-QWERTY key.

## New CSS code: validate with two independent parsers

CSS has no compiler to run, so the bar for `css_v1.json` is two real
parsers that must both accept every snippet:

- `npx --yes csstree-validator <file-or-dir>` — validates syntax AND each
  property/value against the spec data (it catches unknown properties and
  invalid values, not just unbalanced braces). Exit 0 with no output means
  clean. Sanity-check the validator itself once against a file with a
  deliberate error (`colour: red`, `font-size: banana`) before trusting a
  silent pass.
- `lightningcss` (Parcel/Vite's Rust engine) as the second, independent
  parser: `npm install lightningcss` in a scratch dir and call
  `transform({ filename, code, minify: true })` for every snippet — a
  throw means invalid CSS.

Keep the baseline modern but real: `@layer`, `:is()`/`:where()`,
`hsl(12 88% 60% / 0.15)`, `clamp()`, `inset`, and `rotate(1turn)` are all
valid in current engines and were used in the catalog; both validators
accepted them. A disagreement between engines is the signal to check the
construct, not to silently drop it.

- Keep `code` ASCII-only and comment-free — `key_layout_map_test.dart`
  maps every character to a physical US-QWERTY key, and the catalog's
  "pure code, zero comments" rule applies here too.
- Snippets are standalone rule sets (`selector { ... }`) so they parse as
  a complete stylesheet on their own; never wrap them in HTML, and use
  two-space indentation like the rest of the catalog.

## New Swift code: Swift 6.2 in a container, with differential fuzzing

`swift_v1.json` follows the same real-execution bar as C/C++, against
Swift 6.2 on Linux:

- Compile and run every snippet in the official container:
  `podman run --rm -v <dir>:/work -w /work docker.io/library/swift:6.2
  bash -c 'swiftc -warnings-as-errors -o /tmp/bin main.swift && /tmp/bin'`.
  Top-level statements are only legal in a file named `main.swift`, so
  scripts and generated drivers both go there. `-warnings-as-errors`
  catches Swift's constant-folding diagnostics (a `switch` over a literal
  tuple warns "will never be executed"), so keep `switch` subjects in a
  `var`/parameter when the warning would fire.
- Definitions-only snippets (the 12 algorithms) get a per-entry driver
  appended to the TU; the catalog `code` must stay a verbatim substring
  of the compiled file. BFS/DFS reference the `Graph` type declared by
  the previous lesson — prepend that snippet to the scratch TU (the same
  forward reference `rust-algorithms-v1`/`typescript-algorithms-v1`
  already allow).
- Fuzz the algorithms differentially: all six sorts against `sorted()`,
  linear search against `firstIndex(of:)`, binary search validated as a
  real matching index (with duplicates any valid index is correct —
  comparing to `firstIndex` produces false failures), BFS/DFS
  reachability plus BFS level order against an independent flood-fill,
  and the O(V^2) Dijkstra against an independently written Bellman-Ford
  (unreachable nodes stay absent).
- Trap-proof the ranges: `1...times` and `1..<count` crash on
  empty/zero inputs, so every sort guards `count > 1` and
  `retry(times: 0)` carries an explicit `guard times > 0`. Dijkstra's
  `Int.max` sentinel needs `guard best <= Int.max - edge.weight` before
  adding, or legal near-max weights crash instead of being skipped.
- Keep `code` ASCII-only — `key_layout_map_test.dart` maps every
  character to a physical US-QWERTY key.

## New SwiftUI code: a stub module, because SwiftUI does not exist on Linux

`swift_v1.json` also backs `swift-swiftui-calculator-v1`, whose view lessons
are SwiftUI. **Apple does not ship SwiftUI for Linux**: inside
`docker.io/library/swift:6.2`, `import SwiftUI` fails with
`error: no such module 'SwiftUI'`, so the container above cannot compile a
view snippet at all.

- **Do not reach for OpenSwiftUI.** `github.com/OpenSwiftUIProject/OpenSwiftUI`
  (note: *not* `github.com/OpenSwiftUI`, which does not exist) does compile on
  Linux, but it needs an 8-10 minute build and ~1.2 GB, HEAD requires
  `swift-tools-version 6.3` so it only works on 6.3.3-jammy (or pinned to tag
  `0.20.1` for 6.2), and it is **missing 66 of the APIs this catalog uses** —
  including `Button("7") { }`, the single most idiomatic line in a SwiftUI
  calculator, plus `List`, `TextField`, `ScrollView` and `.buttonStyle`. Its
  `.accessibilityLabel` exists but is `internal`.
- **The bar actually used** is a hand-written stub module at
  `tool/swiftui_stub/` (three files) whose declarations carry real Swift
  signatures, typechecked with
  `tool/swiftui_stub/verify.sh <file.swift>`. That still runs the real swiftc
  6.2 front end, so it catches Swift syntax errors, wrong argument labels,
  wrong generic constraints, result-builder misuse and property-wrapper
  misuse. What it **cannot** check is whether an Apple API exists under exactly
  that name and signature — the surface was transcribed by hand from Apple's
  documentation. Say so in the doc, do not bury it.
- **Flags that matter** (and why): `-parse-as-library` (a lone file is
  otherwise treated as `main.swift`, which rejects `@main`), `-swift-version 5`
  (the stub is deliberately not `@MainActor`-isolated, so Swift 6 language mode
  is not claimed), `-warnings-as-errors` (same bar as the rest of the catalog).
  `verify.sh` injects `import SwiftUI` when a snippet lacks it, because only
  the route's first lesson carries the import. If a snippet refers to a type
  taught in an earlier lesson, put that type in a sibling `<file>.support.swift`
  — it is compiled with the snippet in the same module, which is what keeps the
  shipped `code` the fragment the learner types.
- **Keep the harness honest** with negative controls. Six deliberately broken
  snippets (bad argument type, unknown view, unknown member, unbalanced brace,
  wrong argument label, and a plain `String` where a `Binding` is expected)
  must all fail; the last one matters most because that compiler diagnostic
  ("use wrapper instead") is exactly what the `@Binding` lesson turns on.
- **Stub invariants, each found by bisecting a real compiler error** (they are
  all documented in `SwiftUIStub.swift`'s header): every declaration is
  `public`; `ViewBuilder` needs the full `buildBlock` arity ladder 0…10,
  because a result builder dispatches the whole block through `buildBlock`;
  leaf views declare `typealias Body = Never` and take their `body` from
  `extension View where Body == Never`; `Binding` must **not** declare a public
  `init(wrappedValue:)` or `@Binding var x: String` synthesises a memberwise
  init taking a bare `String` and `.constant(_:)` stops resolving;
  `@EnvironmentObject`/`@Environment` need a no-argument `init()` so Swift
  gives the memberwise parameter a default and `DetailView()` still compiles;
  and `@dynamicMemberLookup` on `Binding` is what makes `$calculator.display`
  legal.
- **A stub may be incomplete, but it must never be MORE permissive than the
  SDK in a way that hides a real error.** This bit for real: the first
  `ObservableObjectWrapper` declared a
  `subscript(dynamicMember: ReferenceWritableKeyPath<...>)`, so
  `$model.display` on an `@StateObject` typechecked against the stub — and does
  **not** compile in SwiftUI, where `ObservedObject.Wrapper` has no such
  subscript (reaching into an observable class needs `@Observable` +
  `@Bindable`, or plain values). The lesson had to be rewritten *and* the stub
  tightened, and it is now covered by three probes: reading `model.display`
  compiles, `$model.display` is rejected, and `$value.display` on a `struct` in a
  `@State` still compiles (that one is real — it goes through `Binding`'s own
  `@dynamicMemberLookup`). Every convenience the stub adds should be one you
  can point at in Apple's documentation, and any suspected fiction needs a
  probe that proves the real SDK rejects it too.
- **Generate the capstone from the engine you tested.** A hand-written copy of a
  tested model will drift: the first capstone had no `formattedDisplay`, no
  `clearEntry`, a `private leftOperand` and an inlined digit cap, so the route's
  own test suite did not build against the finished app while two lessons
  claimed it did. Assemble the capstone's type out of the engine package's own
  declarations — with brace counting, because a SwiftUI `body` is full of nested
  braces and no regex can find where a type ends — so "the suite proves the
  engine" is true of the code that ships.
- **The engine is the test suite's subject, so make the lesson BE the suite.**
  Ship the package's real `Tests/*.swift` file as the testing lesson, verbatim.
  When the engine is a `struct` and the model later becomes a `final class`,
  every test's `var calculator = Calculator()` also has to become `let` or
  `-warnings-as-errors` rejects it — say that in the lesson that changes the
  type, and expect the suite's member count to drift when you add a test.
- **When a lesson adds a key or a case, check nothing else got displaced.**
  Adding `CE` to the capstone's keypad silently deleted `+/-`, leaving
  `negate()` unreachable and `case "+/-"` as dead code — the exact mirror of the
  bug it was fixing. Diff the key set before and after.
- **Split the course's logic from its UI, and run the logic for real.** The
  calculator's 7 engine lessons are pure Swift in a real SwiftPM package under
  marker-delimited regions, compiled cumulatively (lesson N = lessons 15..N plus
  a throwaway driver) with
  `swiftc -warnings-as-errors -o /tmp/bin main.swift -lm` and asserted on exact
  stdout. The route's XCTest lesson is that package's real `Tests/` directory.
  A bare `swiftc file.swift` does **not** link libm the way SwiftPM and Xcode
  do, so any `Double` → whole-number conversion (`rounded()`, `abs()`,
  `Int(exactly:)`) needs `-lm` in the harness.
- **Compose the lessons, do not just typecheck them one by one.** Per-snippet
  typechecking passes while the route as a whole is broken: in the first pass
  lessons 9 and 10 called `KeyButton(title:)`, lesson 11 added `isOperator`
  with no default, and the keypad stopped compiling the moment a learner
  reached lesson 11. Compiling the assembled endpoint of the view block and
  the full capstone as single files caught it.
- **A lesson that adds a stored property needs a default** if earlier lessons
  already construct that type, or it breaks every one of them.
- Keep `code` ASCII-only — `key_layout_map_test.dart` maps every character to a
  physical US-QWERTY key. Use `x` and `-` for the multiply and minus glyphs.
- Add the SwiftUI vocabulary to `SwiftSyntaxTokenizer`'s keyword set: a view is
  almost entirely identifiers (`some View`, property wrappers, chains of
  capitalized constructors), and without them these snippets read as plain
  text.

## New C# code: .NET SDK 10, nullable, warnings-as-errors, differential fuzzing

`csharp_v1.json` is verified against real Roslyn (.NET SDK 10) in a
container:

- `podman run mcr.microsoft.com/dotnet/sdk:10.0` (the image is already
  pulled). A scratch project with `ImplicitUsings=disable`,
  `Nullable=enable`, `TreatWarningsAsErrors=true`, `LangVersion=latest`,
  `InvariantGlobalization=true` and `EnableNETAnalyzers=false` — the .NET
  *linter*'s design suggestions (e.g. CA1852 "seal this internal type")
  conflict with teaching examples that deliberately show inheritance; the
  bar is the compiler's own warnings, same as the other languages. A
  `NuGet.config` with `<clear />` sources keeps restore offline.
- Full programs (top-level statements or a `Main`) compile as `Program.cs`
  as-is. Definitions-only snippets (the algorithms) get a scratch
  `Driver.cs` with the `Main`; snippets that reference a type taught in an
  earlier lesson of the same course (BFS/DFS need `Graph` from the
  adjacency-list lesson) get that declaration as a `Support.cs` — the
  catalog `code` itself stays the fragment, verbatim.
- Drive and fuzz the 12 algorithm snippets independently: sorts vs
  `Array.Sort` (empty, one element, duplicates, negatives, already sorted,
  reverse sorted, all equal), searches against `Array.IndexOf`, BFS/DFS
  reachability against an independent flood fill (disconnected graphs,
  isolated start), and Dijkstra against an independent Bellman-Ford
  (unreachable nodes must be absent from the returned map).
- Keep the algorithms course free of constructs only taught in the
  advanced route: no `record`, no nullable annotations, no `? :` ternary.
  An adversarial review flagged exactly this in the first pass — the
  catalog now uses a small `class Edge`, `ContainsKey` lookups, and
  `if`/`else`. C# also cannot overload *local* functions, so the
  overloading lesson wraps its methods in a `static class`.
- Keep `code` ASCII-only — `key_layout_map_test.dart` maps every character
  to a physical US-QWERTY key.

## New Kotlin code: `kotlinc -Werror` + driven/fuzzed harnesses

`kotlin_v1.json` (foundations + algorithms + advanced, coroutines
included) was verified with the official Kotlin compiler as a portable
unzip — no container needed:

- Download `kotlin-compiler-<version>.zip` from the JetBrains GitHub
  release into a scratch directory and put its `bin/` on `PATH`
  (Kotlin 2.4.20 / JRE 17 here). For the advanced course's coroutine
  snippets also fetch `kotlinx-coroutines-core-jvm` from Maven Central and
  pass it with `-cp` both to `kotlinc` and to `java`.
- The catalog stores fragments: `code` never contains `import`,
  `package`, or `fun main`, so each entry gets a `run/<id>/Main.kt`
  harness that must contain the catalog `code` byte-for-byte as a
  contiguous substring, compile with `-Werror`, and print a deterministic
  expected output. Statement fragments go inside `fun main() { ... }`
  (unindented, so the substring stays verbatim); declaration snippets get
  a driver that exercises the API; coroutine snippets add
  `import kotlinx.coroutines.*` (plus `kotlinx.coroutines.flow.*` for
  `Flow`) and run inside `runBlocking`.
- Compile `-include-runtime` and run `java -jar` for non-coroutine
  entries; for coroutines link the jar on both sides and launch `MainKt`.
- Fuzz the 12 algorithm snippets differentially: the six sorts against
  `IntArray.sortedArray()` (empty, single, duplicates, all-equal,
  negatives, sorted, reverse, `Int.MIN/MAX`), the searches against an
  independent scan (`Int?` null on absent/empty), BFS/DFS against
  independent traversals (disconnected graphs, isolated/absent start),
  and the `Long`-distance Dijkstra against an independent Bellman-Ford
  (unreachable nodes absent, zero weights, huge sums). Do a mutation pass
  too: the adversarial review of this catalog injected 11 deliberate bugs
  and confirmed the fuzz caught all of them.
- `kotlin-null-002` is the only snippet allowed to use `!!` (that is its
  lesson); keep every `code` ASCII-only — `key_layout_map_test.dart` maps
  every character to a physical US-QWERTY key.

## New Dart code: `dart format` + `dart analyze` + `dart run`, algorithms fuzzed

Dart ships with the Flutter SDK, so `dart_v1.json`'s verification needs no
container — the bundled Dart SDK 3.13.3 is the compiler:

- Put the harnesses in a scratch package (`pubspec.yaml` with
  `environment: sdk: ^3.13.0`) so `dart analyze .` resolves. Statement
  fragments are wrapped in a throwaway `void main() { ... }` (or
  `Future<void> main() async { ... }` when they await); definitions-only
  snippets get a per-entry driver. After formatting, the wrapper is removed
  and the catalog `code` must be byte-identical to the dedented,
  `dart format`-clean fragment.
- `dart format --output=none --set-exit-if-changed .` must be clean and
  `dart analyze .` must print `No issues found!` before `dart run` is
  trusted. Dart 3.13's formatter is the tall style — verify the fragment,
  never guess the layout.
- The catalog stores the fragment, not the harness: only `dart-vars-001`
  carries `void main()`, and imports appear only where they are the topic
  (`dart-mod-001`'s `dart:math`) or required for correctness
  (`dart-adv-conc-001`'s `dart:isolate`, the `Completer`/`StreamController`
  lessons' `dart:async`).
- Drive and fuzz the 12 algorithm snippets differentially: the six sorts
  return a new list (never mutate the input) and are checked against
  `List.sort` on empty, single, duplicate, negative, sorted, and reverse
  inputs; searches against an independent linear scan (found -> matching
  in-range index, absent -> `-1`); BFS/DFS against independent traversals
  (disconnected graphs, isolated start, deterministic order); and the
  `O(V^2)` Dijkstra against an independent Bellman-Ford with unreachable
  vertices absent.
- Async snippets must be deterministic: fixed `Future.delayed` delays
  (`10ms`), no `Random`, no wall-clock output; run each one several times
  to catch ordering races. `dart:core` re-exports `Future`/`Stream` but not
  `Completer`/`StreamController` — those need their own `dart:async`
  import. `late` is verified as a runtime `LateInitializationError`, never
  described as a compile-time guarantee.
- Keep `code` ASCII-only — `key_layout_map_test.dart` maps every character
  to a physical US-QWERTY key.

## New PHP code: `php -l` + real 8.4 execution in a container

PHP has no compilation step, so the bar for `php_v1.json` is lint plus a
real execution on the official image (PHP 8.4.25, `pdo_sqlite` included):

```sh
podman run --rm -v <scratch>:/work:Z -w /work docker.io/library/php:8.4-cli \
  bash -c 'for f in *.php; do php -l "$f" && php "$f"; done'
```

- Every catalog `code` fragment is written as a `.php` file with `<?php`
  prepended (only `php-vars-001` carries the tag in the catalog); the
  catalog `code` must be a verbatim substring of that file.
- Web snippets are not standalone: drive them with a setup block that
  pre-fills `$_GET`/`$_POST`/`$_COOKIE` and points `session_save_path()`
  at a scratch dir. The prose must say PHP fills those superglobals in a
  real request, never that the snippet sets them.
- The algorithms course is cumulative: prepend the `Graph` class from
  `php-algo-009` when driving BFS/DFS/Dijkstra, exactly like the
  TypeScript/Crystal courses. Fuzz the six sorts against `sort()` (empty,
  single, duplicates, sorted, reversed, 500 random arrays), both searches
  against `array_search(..., true)`, BFS/DFS against independent
  traversals (disconnected components, isolated start), and the
  `O(V^2)` Dijkstra against an independently written Bellman-Ford
  (unreachable targets return `null`).
- PHP gotchas that have bitten real verification: `#` opens a comment but
  `#[` opens an attribute; a heredoc terminator must sit on its own line
  (indentation allowed since 7.3); `$this` and `${...}` are lexed as
  variables; `never` + `exit` really terminates the process;
  `password_hash` emits `$2y$` hashes whose `$` must never be interpolated
  into a double-quoted string; PDO's `sqlite::memory:` keeps each run
  self-contained.
- Keep `code` ASCII-only and comment-free — `key_layout_map_test.dart`
  maps every character to a physical US-QWERTY key and the catalog's
  "pure code, zero comments" rule applies (the type shapes a docblock
  would carry are explained in the lesson prose instead).

## New Python/Django code: staged reference project, real server checks

For the Django courses (`python-django-foundations-v1`,
`python-django-orm-v1`, `python-django-rest-v1`; their snippets live in
`python_v1.json`), the equivalent of `go run` is a real Django 5.2 LTS +
DRF 3.16 project that is built lesson by lesson and actually executed:

- Pin the stack in a disposable venv (`uv venv --python 3.12`, then
  `uv pip install "Django~=5.2.0" "djangorestframework~=3.16.0"`); no
  container is needed for SQLite. Verify with `manage.py check`,
  `makemigrations --check --dry-run`, `migrate`, and `manage.py test`.
- Author the course as ordered stages: each stage writes only the files
  that lesson changes, then runs the checks above; every snippet must be
  a marker-delimited verbatim slice of a file that ran at that stage
  (`# snip:<id>:start`/`:end` in Python, `{# snip:... #}` in templates)
  or a terminal command that was actually executed. Keep the generated
  migration files as the migration-lesson snippets.
- Exercise behavior, not just the system check: create data through the
  ORM, hit endpoints with `rest_framework.test.APIClient` (token
  credentials or `force_authenticate`), assert status codes/payloads,
  and drive data migrations forwards *and* backwards
  (`migrate bookmarks <previous>` and forward again).
- Model changes need `makemigrations` shown in the lesson or named in
  its prose. Adding `auto_now`/`auto_now_add` to an existing table
  prompts interactively for a one-off default, so introduce timestamp
  fields in the initial model or give new fields a default.
- Widening a lesson's marker to include the file's imports the first
  time a file appears, and labelling fragments (`# <path>`,
  `# inside class X`), keeps snippets runnable on their own; label
  mixed-source snippets (`# manage.py shell` vs `# bookmarks/models.py`)
  so the learner knows where each part goes.
- Keep `code` ASCII-only — `key_layout_map_test.dart` maps every
  character to a physical US-QWERTY key.

## New Git code: a real repository per snippet, deterministic, output asserted

Git snippets are command lines (not programs), so the equivalent of
`go run` is executing each one with the real `git` binary (2.55 here)
against a disposable repository:

- One fresh repo per snippet in a scratch dir, with an **isolated `HOME`**
  (so `git config --global` lessons never touch the developer's config),
  `GIT_CONFIG_NOSYSTEM=1`, `GIT_TERMINAL_PROMPT=0`, `GIT_PAGER=cat`, and
  fixed `GIT_AUTHOR_*`/`GIT_COMMITTER_*` name, email and date — commits
  then hash deterministically across runs.
- Each case declares its own setup (the files, commits, branches and
  remote the command needs), runs the exact catalog `code` **read from the
  final JSON** (a verbatim guarantee; never retype it in the harness), and
  asserts both output (`stdout+stderr` substrings/regexes) and resulting
  state (`git status --short`, `git log --format=...`, `git rev-parse`,
  `test -f ...`).
- Cover the failure path when the failure is the lesson: a conflicting
  `git merge` must exit 1 and leave `.git/MERGE_HEAD`; `git bisect run`
  must finish with the "first bad commit" line (and `reset` to close the
  session); a hook must abort the commit when it exits non-zero.
- Remote lessons need a bare repo (`git init --bare -b main
  ../remote.git`) plus a second clone acting as the teammate;
  `--force-with-lease` is verified by comparing the remote ref with the
  local one after the push, not by the message alone.
- Every command that would open an editor (`rebase -i`, `revert`, merge
  commit messages) is scripted with `GIT_SEQUENCE_EDITOR=:`/`GIT_EDITOR=:`
  or `--no-edit`, so the harness never blocks. Preview commands must carry
  the same flags as the real one (`git clean -nd` before `git clean -fd`),
  or the preview hides whole directories.
- Keep `code` ASCII-only and command-only — `key_layout_map_test.dart`
  maps every character to a physical US-QWERTY key.
- Run the whole harness again against the **final merged asset** (not the
  pre-prose draft) and take a fresh adversarial pass; for Git this caught a
  dry-run that did not preview what the real command deletes, a `bisect`
  lesson that never reached a verdict, and a `--fixup` snippet missing its
  own `git add`.

## New Linux code: one disposable Arch container per snippet, output asserted

Linux snippets are command lines (not programs), so the equivalent of
`go run` is executing each one for real inside
`podman run docker.io/library/archlinux:latest`:

- One fresh container per snippet, with the snippet's own setup (create
  the file/user/unit it operates on) and an empty stdin; only the
  `pacman -S`/`-Rns` lessons pipe stdin from `yes` so the confirmation
  prompt never blocks. Assert both streams and the exit code, plus any
  resulting state the lesson implies (`test -f`, `stat -c`,
  `systemctl is-enabled`, `nft list tables`).
- Privilege-sensitive lessons run with `--privileged` (`ip link set`,
  `nft add/list/delete`); systemd lessons need a real manager:
  `podman run -d --rm --systemd=always --privileged <image> /sbin/init`,
  then poll `systemctl is-system-running` and run the snippet through
  `podman exec` — `systemctl status/start/stop/enable`, `journalctl` and
  `systemd-run --on-active` all behave normally there.
- Time-based units need an explicit accuracy budget: `systemd-run
  --on-active=2` may legally fire up to a minute late (timers default to
  `AccuracySec=1min`), so the catalog sets
  `--timer-property=AccuracySec=100ms` before a short `sleep` plus a
  `journalctl -u` assertion. Piping stdin with `yes |` silently breaks
  the journal attribution of `systemd-run`'s transient unit — keep its
  stdin empty.
- The catalog `code` must be a verbatim substring of what the harness
  executed (read it from the final JSON, never retype it) and must stay
  ASCII-only — `key_layout_map_test.dart` maps every character to a
  physical US-QWERTY key.
- Network lessons (`curl`/`ping` against `archlinux.org`, `pacman -Sy`)
  need internet; assert on environment-independent strings (`200`,
  `2 received`, `tree v`) and keep a stable remote host.
- Make each state-changing lesson self-contained (create the file, user
  or unit it acts on) or explicitly sequential within its route (e.g.
  lesson N installs a package that lesson N+1 removes), because the
  learner's machine only carries what earlier lessons created — the
  harness's per-case setup must mirror that chain, never invent it.

## New GitHub Actions YAML: actionlint + shellcheck, action-validator, act

GitHub Actions snippets are workflow YAML (plus two composite
`action.yml` files, one `.github/dependabot.yml`, and seven `gh` CLI
commands), so the equivalent of `go run` is a stack of real validators
plus selected execution:

- Every workflow goes through `actionlint` (1.7.12 here) with
  `shellcheck` (0.11) on `PATH` — actionlint checks the workflow schema,
  contexts, expressions, `needs` graphs and event payload typing, and
  delegates each `run:` script to ShellCheck. Keep the run scripts clean
  under both tools: a `#` inside an unquoted YAML scalar silently starts a
  YAML comment (use `|` block scalars or drop the `#`), and ShellCheck's
  style findings (SC2129) are still actionlint failures.
- `action-validator` (0.6.0 via `npx`) validates every workflow and every
  `action.yml` against the official JSON schemas. Its schema can lag GA
  features (it rejects the real `attestations: write` permission); keep a
  narrow, documented allowlist instead of changing correct YAML.
- `check-jsonschema --builtin-schema vendor.dependabot` validates the
  Dependabot config; `gh <subcommand> --help` proves every flag used by
  the CLI lessons exists, and ShellCheck the command line too.
- Execute a representative subset for real with `act` (0.2.89) against
  podman (`podman system service` socket + `DOCKER_HOST`), mapping
  `ubuntu-latest` to `ghcr.io/catthehacker/ubuntu:act-latest` and enabling
  `--artifact-server-path`/`--cache-server-path`. `act` limits what is
  runnable: JS artifacts v7 currently fail on its artifact server
  protocol, service-container health polling is unreliable under
  rootless podman, and cloud-registry steps need credentials — validate
  those statically and check the semantics manually (for service health,
  the same container/options map cleanly to a plain `podman run` and a
  `psql` query).
- Never interpolate event data straight into a `run:` shell command when
  it can carry attacker-controlled text (branch/tag names, PR titles):
  put it in `env:` and read `$VAR` in the script. The catalog teaches
  this for `github.ref_name`/`release.tag_name`/`workflow_run.head_branch`.
- Action majors move fast: verify each one against
  `curl -s https://api.github.com/repos/<owner>/<repo>/releases/latest`
  before shipping (the 2026 baseline is checkout@v7, setup-node@v7,
  cache@v6, upload-artifact@v7, download-artifact@v8,
  build-push-action@v7, codeql-action@v4, action-gh-release@v3).
- Keep `code` ASCII-only — `key_layout_map_test.dart` maps every
  character to a physical US-QWERTY key.

## New Docker code: real Docker, one scratch directory per snippet

Docker snippets are shell command lines, Dockerfile fragments,
`.dockerignore` contents, or `compose.yaml` fragments (they never mix two
kinds), so the equivalent of `go run` is a real engine — Docker 29 with
Compose 5.5 here:

- Script snippets run line by line as bash commands (asserting output and
  resulting state between lines); Dockerfile/`.dockerignore`/`compose.yaml`
  snippets are written byte-for-byte to their target filename and driven
  with `docker build` / `docker run` / `docker compose up -d` inside a
  scratch directory, with the context files the lesson names
  (`greeting.txt`, `deps.txt`, `app.txt`, `site/index.html`, `app.env`).
- Use small public images (`alpine:3.22`, `busybox:1.37`, `nginx:alpine`,
  `redis:7-alpine`, `registry:2`) and name every resource; the harness
  must never prune or remove anything it did not create (check
  containers/networks/volumes/images for conflicts before starting).
- Assert state, not just exit 0: `docker inspect --format` for lifecycle,
  health, labels and limits; `docker ps -a --filter`; volume contents
  across `down`/`up`; container DNS by service name on a user-defined
  network; cache hits in a second `docker build` output.
- Failure paths that are the lesson (the write that must fail on a
  `--read-only` root) assert the non-zero exit and the message.
- Keep `code` ASCII-only and comment-free — `key_layout_map_test.dart`
  maps every character to a physical US-QWERTY key.
- Run the whole harness again against the final merged asset, not the
  pre-prose draft.

## New Zig code: official 0.16.0, exact harnesses, differential fuzzing

`zig_v1.json` is a course-only catalog for stable Zig 0.16.0: 46 active
snippets (34 foundations and 12 algorithms). Use the official archive and
its published checksum; do not substitute a host package.

- For x86_64 Linux, download
  `https://ziglang.org/download/0.16.0/zig-x86_64-linux-0.16.0.tar.xz`.
  Read the matching `0.16.0` entry in
  `https://ziglang.org/download/index.json`, verify the published SHA-256,
  then extract the binary. The x86_64 Linux archive checksum is
  `70e49664a74374b48b51e6f3fdfbf437f6395d42509050588bd49abe52ba3d00`; use the
  matching `shasum` for another target. For the x86_64 Linux archive,
  `printf '%s  %s\n' '70e49664a74374b48b51e6f3fdfbf437f6395d42509050588bd49abe52ba3d00' 'zig-x86_64-linux-0.16.0.tar.xz' | sha256sum -c -`
  must pass before extraction. After extraction, `zig version` must report
  `0.16.0` before any harness runs.
- Generate each exact-catalog-code harness from the final JSON entry, never
  from a hand-typed copy. Require the catalog `code` to be a byte-for-byte
  contiguous substring of the compiled file, add only the imports, wrapper,
  or driver needed by that entry, and run `zig fmt --check` on the harness.
  The 46 entries follow the 44 run + 2 test entry pattern: run the 44
  `zig run` cases and the 2 test-oriented cases (`zig-found-033` and
  `zig-found-034`) with `zig test`.
- Make behavioral assertions, not just clean compiles: assert return values,
  errors and optionals, output, and cleanup in the run harnesses; retain
  `std.testing.expect*`/`expectError` assertions and use the testing
  allocator where relevant. Re-run every harness against the final merged
  asset.
- Drive and fuzz the 12 `zig-algo-*` snippets differentially: compare the
  six sorts with an independent sort, both searches with a scan and
  in-range/absent semantics, BFS/DFS with independent traversals including
  disconnected graphs, and Dijkstra with an independent Bellman-Ford with
  unreachable nodes. Prepend the lesson-9 `Graph` support when driving
  BFS/DFS/Dijkstra. Include empty, singleton, duplicate, negative, sorted,
  reverse, and randomized cases.
- Zig 0.16.0 gotchas: prefer unsigned slices so ordinary `%` can test
  parity (signed `%` is rejected, or use `@mod` deliberately); create
  `std.ArrayList(T).empty` and pass the allocator explicitly to `append`,
  `appendSlice`, and `deinit`; I/O now takes an explicit `std.Io` instance
  and uses the 0.16 `std.Io.File`/`std.Io.Dir` APIs, so old `std.io` and
  0.15-style `std.fs` calls are not valid examples. Keep examples on the
  stable 0.16.0 APIs.
- Keep `code` ASCII-only — `key_layout_map_test.dart` maps every character
  to a physical US-QWERTY key.

## Large batch authoring/rewrites (10+ entries): delegate, then validate twice

When rewriting or extending a large slice of the catalog (e.g. adding
`tldrEn/Es` to all 90 entries, or rewriting every `explanationEn/Es`), don't
do it inline in the main conversation — it burns huge context for content
that doesn't need to stay in context afterward. Instead:

1. Dispatch a background `general-purpose` Agent (not a fork — this is
   self-contained content authoring with no need for prior conversation
   context).
2. Give it an **extremely detailed style guide** plus **3-4 fully worked
   few-shot examples** covering the range of content it'll see (short vs.
   long snippets, different categories).
3. Have it **read the real catalog itself** (point it at the file path) —
   never paste dozens of entries into the prompt.
4. Have it write output to a scratch file (`/tmp/*.json`), and
   **self-validate** before returning: exact key-set match against the
   input, non-empty checks, length constraints.
5. Back in the main conversation: spot-check a random sample of the
   output for actual quality (not just structural validity), then merge via
   a small Python script that does its **own independent validation**
   (id-set match against the original, non-empty checks) before it
   overwrites the real asset file.

This two-layer validation (agent self-checks its own output; orchestrator
independently re-checks before merging) has caught real problems — trust
but verify applies to your own dispatched agents too.

## Bilingual field conventions

- `tldrEn/Es`: ≤80 chars, a single skimmable fragment, no punctuation-heavy
  sentence structure.
- `explanationEn/Es`: exactly a tight three sentences — what the code does,
  why it works that way (the language rule that makes it true), and
  when/why you'd reach for this pattern. ≤950 chars observed max.
- Inline code references inside these fields use single-backtick Markdown
  (`` `:=` ``, `` `iota` ``) — the presentation layer (`InlineCodeText`,
  `lib/core/widgets/inline_code_text.dart`) renders these as a highlighted
  pill; never asterisks/bold, the catalog doesn't use them and the renderer
  doesn't parse them.
- New snippets get a realistic `sourceAttribution` (e.g. "hand-authored for
  <context>") — never leave it blank.

## Deprecating/correcting an existing entry

Never edit an already-shipped entry's `code` in place if a real correction
is needed — bump `revision`, add a NEW entry with the same `id` and the
corrected `code`/`revision: N+1`, and mark the OLD revision's `isActive:
false`. This keeps historical sessions (which reference a specific
`snippetId` + implicit revision at the time they were typed) interpretable.
The completeness test enforces exactly one active revision per id, and that
it's the highest revision number.
