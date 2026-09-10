# Ordering a Learning Path's lessons

This is the single most bug-prone part of curriculum work. Two mechanical
shortcuts were both tried while building the 51-lesson `go-foundations-v1`
path this session, and both produced real, user-visible incoherence before
a manual, adversarially-audited pass got it right.

## What NOT to do (both tried, both failed)

**1. Group strictly by (category, difficulty) in fixed blocks** (e.g. all
`beginner` lessons of a category, then all `intermediate`, then all
`advanced`). Failure mode: a category's `intermediate` tier can be entirely
`func`-wrapped (full function bodies) while its `beginner` tier is bare
one-line statements. The learner hits a full `func name(params) returnType {
...}` with zero warning, right at the tier boundary — a sudden, jarring
cliff. (User's own words: "de swam two variables a format dimension... de
la nada, escala muy alto.")

**2. Sort purely by code length** (as a proxy for "complexity"). Failure
mode: length isn't a proxy for *dependency*. "Swap two variables"
(`a, b = b, a`, 24 chars) is shorter than "declare a variable with `:=`"
(45 chars) — but swap conceptually assumes you already understand
assignment, so putting it first is backwards even though it's shorter.
(User: "que sea primero swap? pero y la declaracion?")

## What to do instead: hand-curate by concept dependency

For each category, read every candidate snippet's actual `code` +
`explanationEn` (not just its difficulty tag or length), and ask: *what
must the learner already understand, from an EARLIER lesson in this
category or a prior category, to make sense of this one?* Build the
sequence as a dependency chain, not a sort by any single metric. Concretely:
declare → build on that declaration → introduce one genuinely new construct
→ combine it with what came before → ... A capstone ("put it together")
lesson belongs as a checkpoint right after the specific sub-skills it
exercises, not necessarily at the very end of the category, if later
lessons in that category cover harder material the capstone doesn't touch.

**Difficulty tags stay attached to snippets as metadata** (shown as a chip,
used for Sprint/Precision-mode filtering elsewhere in the app) but are NOT
the primary Learning-Path ordering key. A tag reflects Go-concept novelty,
not typing/scale complexity, and the two frequently diverge (a short
`switch` example can be tagged "advanced" while being trivial to type).

## Category-level (macro) order

Categories themselves stay as one contiguous, unbroken block each — never
split a category's lessons across two ranges to fix a cross-category
dependency issue. Rationale: doing so makes the per-lesson category chip
non-monotonic (e.g. "Error Handling" → "Functions" → "Error Handling"
again), which is a worse, more visible UX cost than the soft dependency
issue it fixes. If a category's content has a genuine soft-dependency on a
later category (e.g. some `errorHandling` lessons read more easily once
`functions` fluency exists, even though the ONE syntax element they
specifically need — a method receiver — is already taught even earlier, in
`variablesAndTypes`), that's an acceptable, bounded trade-off: leave the
category where it is.

**This cuts both ways — check contiguity BEFORE assigning a category to a
new lesson, not after.** Building the `go-ddd-hexagonal-notes-v1` path, two
lessons (hand-written test fakes + the table-driven test using them) were
initially tagged the same category as an earlier block of lessons
(`applicationUseCases`, since they test a use case) purely by topical
similarity — but they were positioned at the very END of the path (after
persistence/REST/wiring lessons), so that category tag now appeared twice,
non-contiguously. `scripts/audit_lesson_order.py` catches this
mechanically, but the fix isn't to move the lessons earlier (that would
lose the deliberate "testing ties everything together" capstone
placement) — it's to give them their own category
(`testingWithFakes`) instead. When a new category is topically similar to
an existing one but will land at a different POSITION in the sequence,
give it its own tag rather than reusing the existing one.

**Accepted trade-off, don't re-litigate it every time**: a category early
in the macro order will sometimes need to use a construct (e.g. `func`, or
`for range`) that its own formally-dedicated category doesn't teach until
later. This is fine PROVIDED the early usage isn't an isolated spike among
otherwise much-simpler siblings — mitigate by placing the first instance of
a new construct next to other similarly-complex lessons (often near the
end of its category), not sandwiched among the simplest ones.

## Lesson-id / progress data-integrity protocol

`LessonAttempt`/`LessonProgress` (drift, `lesson_progress_cache`) are keyed
**purely by `lessonId` string** — never by `snippetId` or array position.
Before reassigning which snippet occupies an existing lesson id (i.e. any
reorder), always check the real dev database first:

```bash
sqlite3 ~/Documents/ridge.db.sqlite \
  "SELECT lesson_id, status FROM lesson_progress_cache WHERE status != 'locked';"
```

- If nothing but the first lesson shows `unlocked` (the always-auto-derived
  default with no real attempt behind it) — safe to reorder in place,
  reusing the same lesson-id scheme.
- If any lesson shows `completed` (or a real attempt exists in
  `typing_sessions` tagged with that lesson id) — bump the lesson-id
  version suffix instead (e.g. `go-foundations-v1-o2-stepNN` →
  `-o3-stepNN`) so old completions don't silently misattach to whatever
  DIFFERENT snippet now occupies that same id/position. `replaceProgress`
  (see `lesson_progress_repository_impl.dart`) deletes-then-reinserts a
  profile's whole cache on next recompute, so old ids under the retired
  scheme just disappear on their own — no manual cleanup needed.

**After any reorder**, regenerate BOTH the lesson `id` (the `stepNN` suffix)
AND the `order` field from the final array position — never shift one
without the other. A prior mistake this session: a reorder script updated
`order` but left each lesson object's original `id` attached to whichever
snippet it originally belonged to, producing `id: step06` / `order: 5` on
the same object. Always assert `l['id'] == f'...step{l["order"]:02d}'` for
every lesson before writing the file back.

## Verification checklist after any reorder

1. Run `scripts/audit_lesson_order.py` (mechanical checks: id/order sync,
   category contiguity, snippet-set unchanged, per-category length-jump
   report for a quick visual sanity pass).
2. Get an independent, adversarial review — a fresh agent or fork
   explicitly instructed to hunt for problems (unintroduced syntax,
   complexity cliffs, dependency violations) rather than confirm the
   existing order. Self-review by the same author who wrote the order has
   a real blind spot (demonstrated twice this session).
3. `flutter analyze` clean, `flutter test` full suite green — check
   specifically whether any test hardcodes a lesson id
   (`grep -rn "go-foundations-v1" test/`) that your reorder's id-scheme
   change might have invalidated.
