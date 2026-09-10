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
