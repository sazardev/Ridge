#!/usr/bin/env python3
"""Fast, mechanical sanity checks for a Learning Path's lesson order.

This is a pre-check, NOT a replacement for hand-curating lesson order by
concept dependency or for getting an independent adversarial review — see
references/lesson-ordering.md in this skill for why. It catches the
mechanical bugs (id/order desync, non-contiguous categories, catalog
completeness regressions) and prints a per-category length/difficulty
table so a human can eyeball the ramp, but it cannot judge whether lesson N
actually depends on a concept lesson N-1 taught.

Usage (from repo root):
    python3 .claude/skills/content-curriculum/scripts/audit_lesson_order.py \
        [path/to/go_v1.json] [path/to/go_foundations_v1.json]

Exits non-zero if any hard check fails.
"""
from __future__ import annotations

import json
import re
import sys
from collections import OrderedDict, defaultdict
from pathlib import Path

CORE_CATEGORIES = {
    "variablesAndTypes",
    "conditionals",
    "loops",
    "functions",
    "errorHandling",
}

# Mirrors `_architectureLayerCategories` in
# snippet_catalog_completeness_test.dart — these represent a DDD/hexagonal
# or TUI ARCHITECTURE LAYER rather than a Go language feature, so there's
# no meaningful "beginner"/"expert" tier for them; held to a looser bar
# (>=1 active entry across ANY difficulty) than every other category.
ARCHITECTURE_LAYER_CATEGORIES = {
    "domainModeling",
    "hexagonalPorts",
    "applicationUseCases",
    "persistenceAdapters",
    "restAdapters",
    "testingWithFakes",
    "tuiArchitecture",
    "tuiStyling",
    "tuiComponents",
    "tuiAdapter",
    # Mirrors `_algorithmTopicCategories` — topic categories for the
    # go-algorithms-v1 / rust-algorithms-v1 Learning Routes. Individual
    # snippets DO carry a real difficulty here, but the category itself
    # gets the same looser total-count bar as the architecture-layer ones.
    "searchingAlgorithms",
    "sortingAlgorithms",
    "graphAlgorithms",
}

# Languages whose catalog exists only to compose a Learning Path (never a
# free-standing practice pool). Their catalogs are exempt from the dense
# (category, difficulty) grid — instead every active entry must be used by
# one of the bundled paths (no orphan practice material). Mirrors
# `_freePracticeLanguages` in
# `test/features/content/snippet_catalog_completeness_test.dart`; see
# SPEC.md §3.2's two catalog tiers.
COURSE_ONLY_LANGUAGES = {"bash", "sql", "rust", "python", "javascript"}


def load(path: Path):
    with path.open() as f:
        return json.load(f)


def check_catalog_completeness(catalog: list[dict]) -> list[str]:
    problems = []
    active = [s for s in catalog if s.get("isActive")]

    by_id: dict[str, list[dict]] = defaultdict(list)
    for s in catalog:
        by_id[s["id"]].append(s)
    for sid, revisions in by_id.items():
        active_revs = [s for s in revisions if s.get("isActive")]
        if len(active_revs) != 1:
            problems.append(
                f"{sid}: {len(active_revs)} active revisions (expected exactly 1)"
            )
            continue
        highest = max(s["revision"] for s in revisions)
        if active_revs[0]["revision"] != highest:
            problems.append(
                f"{sid}: active revision {active_revs[0]['revision']} "
                f"is not the highest ({highest})"
            )

    counts: dict[tuple[str, str], int] = defaultdict(int)
    totals_by_category: dict[str, int] = defaultdict(int)
    for s in active:
        counts[(s["category"], s["difficulty"])] += 1
        totals_by_category[s["category"]] += 1
    difficulties = {s["difficulty"] for s in catalog} or {
        "beginner",
        "intermediate",
        "advanced",
        "expert",
    }
    categories = {s["category"] for s in catalog}
    language = catalog[0].get("language") if catalog else None
    # A course-only language's catalog is checked by its path coverage in
    # `main()` instead of the dense-grid rule below.
    if language not in COURSE_ONLY_LANGUAGES:
        for cat in categories:
            if cat in ARCHITECTURE_LAYER_CATEGORIES:
                if totals_by_category.get(cat, 0) == 0:
                    problems.append(f"{cat}: 0 active entries (any difficulty)")
                continue
            min_count = 3 if cat in CORE_CATEGORIES else 1
            for diff in difficulties:
                n = counts.get((cat, diff), 0)
                if n < min_count:
                    problems.append(
                        f"{cat}/{diff}: only {n} active (need >= {min_count})"
                    )

    for s in catalog:
        for field in ("tldrEn", "tldrEs"):
            text = s.get(field, "")
            if not text.strip():
                problems.append(f"{s['id']}: {field} is empty")
            elif len(text) > 80:
                problems.append(f"{s['id']}: {field} is {len(text)} chars (>80)")
        for field in ("explanationEn", "explanationEs"):
            text = s.get(field, "")
            if not text.strip():
                problems.append(f"{s['id']}: {field} is empty")
            elif len(text) > 950:
                problems.append(f"{s['id']}: {field} is {len(text)} chars (>950)")

    return problems


def check_lesson_order(path_obj: dict, by_id: dict[str, dict]) -> tuple[list[str], list[str]]:
    """Returns (hard_problems, soft_notes)."""
    problems: list[str] = []
    notes: list[str] = []
    lessons = path_obj["lessons"]

    # id/order sync — infer the "...stepNN" suffix from the first lesson.
    if lessons:
        m = re.match(r"^(.*step)(\d+)$", lessons[0]["id"])
        if m:
            prefix, first_num_str = m.groups()
            width = len(first_num_str)
            for lesson in lessons:
                expected_id = f"{prefix}{lesson['order']:0{width}d}"
                if lesson["id"] != expected_id:
                    problems.append(
                        f"lesson id/order mismatch: id={lesson['id']!r} "
                        f"but order={lesson['order']} (expected id {expected_id!r})"
                    )
        else:
            notes.append(
                f"could not parse a '...stepNN' suffix from {lessons[0]['id']!r}; "
                "skipped id/order sync check"
            )

    # order is 1..N with no gaps/duplicates
    orders = [l["order"] for l in lessons]
    if orders != list(range(1, len(lessons) + 1)):
        problems.append(
            f"lesson 'order' values are not a contiguous 1..{len(lessons)} "
            f"sequence: {orders}"
        )

    # snippetId resolves to an active catalog entry
    active_ids = {sid for sid, s in by_id.items() if s.get("isActive")}
    for lesson in lessons:
        if lesson["snippetId"] not in active_ids:
            problems.append(
                f"{lesson['id']}: snippetId {lesson['snippetId']!r} is not an "
                "active catalog entry"
            )

    # category contiguity
    seen_categories: list[str] = []
    prev_cat = None
    for lesson in lessons:
        snippet = by_id.get(lesson["snippetId"])
        if snippet is None:
            continue
        cat = snippet["category"]
        if cat != prev_cat:
            if cat in seen_categories:
                problems.append(
                    f"category '{cat}' re-appears at lesson {lesson['id']} "
                    "after the sequence had already moved past it — "
                    "categories must stay as one contiguous block each"
                )
            seen_categories.append(cat)
        prev_cat = cat

    return problems, notes


def print_report(path_obj: dict, by_id: dict[str, dict]) -> None:
    print("\n--- per-category length/difficulty report (eyeball the ramp) ---")
    prev_cat = None
    prev_len = None
    for lesson in path_obj["lessons"]:
        snippet = by_id.get(lesson["snippetId"])
        if snippet is None:
            continue
        cat = snippet["category"]
        length = len(snippet["code"])
        marker = ""
        if cat != prev_cat:
            marker = "  <<< new category"
            prev_len = None
        elif prev_len is not None and prev_len > 0 and length / prev_len >= 2:
            marker = f"  !!! {prev_len}->{length} is a >=2x jump within this category"
        print(
            f"{lesson['order']:3} {snippet['difficulty']:12} {cat:20} "
            f"len={length:4} {lesson.get('titleEn', '')}{marker}"
        )
        prev_cat = cat
        prev_len = length


def main() -> int:
    repo_root = Path(__file__).resolve().parents[4]
    snippets_path = (
        Path(sys.argv[1])
        if len(sys.argv) > 1
        else repo_root / "assets/content/snippets/go_v1.json"
    )
    # One or more Learning Path files may be passed (a language can bundle
    # several routes sharing one catalog, e.g. Bash foundations + toolkit).
    path_paths = (
        [Path(arg) for arg in sys.argv[2:]]
        if len(sys.argv) > 2
        else [repo_root / "assets/content/learning_paths/go_foundations_v1.json"]
    )

    catalog = load(snippets_path)
    by_id = {s["id"]: s for s in catalog}
    paths = []
    for path_path in path_paths:
        paths.extend(load(path_path))

    all_problems: list[str] = []
    all_problems.extend(check_catalog_completeness(catalog))

    language = catalog[0].get("language") if catalog else None
    if language in COURSE_ONLY_LANGUAGES:
        referenced = {
            lesson["snippetId"]
            for path_obj in paths
            for lesson in path_obj["lessons"]
        }
        active_ids = {s["id"] for s in catalog if s.get("isActive")}
        orphans = active_ids - referenced
        if orphans:
            all_problems.append(
                f"[catalog] {language}: {len(orphans)} active snippet(s) not "
                f"used by any bundled path: {sorted(orphans)}"
            )
        else:
            print(
                f"NOTE [{language}]: course-only catalog — skipped the dense "
                f"grid check; every active snippet is used by a bundled path."
            )

    for path_obj in paths:
        problems, notes = check_lesson_order(path_obj, by_id)
        all_problems.extend(f"[{path_obj['id']}] {p}" for p in problems)
        for note in notes:
            print(f"NOTE [{path_obj['id']}]: {note}")
        print_report(path_obj, by_id)

    print()
    if all_problems:
        print(f"FAILED — {len(all_problems)} problem(s):")
        for p in all_problems:
            print(f"  - {p}")
        return 1

    print("All mechanical checks passed. Remember: this does NOT verify "
          "concept-dependency coherence — get a hand review / adversarial "
          "audit too (see references/lesson-ordering.md).")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
