// Unit tests for `DailyChallengeSelector` — the deterministic
// date-to-snippet pick that makes "everyone gets the same snippet
// today" hold without a server (SPEC.md §5.4). Fabricated `Snippet`s, no
// widget/drift/clock needed.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/content/domain/entities/snippet_length.dart';
import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
import 'package:ridge/features/daily_challenge/domain/services/daily_challenge_selector.dart';
import 'package:ridge/features/daily_challenge/domain/value_objects/challenge_date.dart';

Snippet _snippet(String id) {
  return Snippet(
    id: SnippetId(id),
    revision: 1,
    language: ProgrammingLanguage.go,
    difficulty: Difficulty.beginner,
    category: ContentCategory.variablesAndTypes,
    symbolFocus: const {},
    length: SnippetLength.short,
    titleEn: id,
    titleEs: id,
    code: 'x',
    sourceAttribution: 'hand-authored for test',
    isActive: true,
    tldrEn: 'Test tl;dr.',
    tldrEs: 'Tl;dr de prueba.',
    explanationEn: 'Test explanation.',
    explanationEs: 'Explicación de prueba.',
  );
}

void main() {
  const selector = DailyChallengeSelector();
  final candidates = [_snippet('go-c'), _snippet('go-a'), _snippet('go-b')];

  test('an empty candidate pool has no pick', () {
    final result = selector.selectFor(
      date: ChallengeDate.fromUtc(DateTime.utc(2026, 1, 10)),
      candidates: const [],
    );
    expect(result, isNull);
  });

  test('the same date always picks the same snippet', () {
    final date = ChallengeDate.fromUtc(DateTime.utc(2026, 1, 10));
    final first = selector.selectFor(date: date, candidates: candidates);
    final second = selector.selectFor(date: date, candidates: candidates);
    expect(first, isNotNull);
    expect(first!.id, second!.id);
  });

  test('the pick is independent of the candidate list order — every device '
      'must agree regardless of JSON-asset/map iteration order', () {
    final date = ChallengeDate.fromUtc(DateTime.utc(2026, 1, 10));
    final shuffled = [candidates[2], candidates[0], candidates[1]];
    final fromOriginalOrder = selector.selectFor(
      date: date,
      candidates: candidates,
    );
    final fromShuffledOrder = selector.selectFor(
      date: date,
      candidates: shuffled,
    );
    expect(fromOriginalOrder!.id, fromShuffledOrder!.id);
  });

  test('different dates can pick different snippets out of the same pool', () {
    final pickedIds = {
      for (final isoDate in ['2026-01-10', '2026-01-11', '2026-06-15'])
        selector
            .selectFor(
              date: ChallengeDate.parse(isoDate),
              candidates: candidates,
            )!
            .id
            .value,
    };
    expect(pickedIds.length, greaterThan(1));
  });

  // Pinned regression values for the hand-written FNV-1a hash over these
  // exact three candidate ids and dates — if this ever changes, either
  // the hash implementation changed (a real, deliberate decision to
  // re-verify) or something broke it by accident.
  test('pinned FNV-1a regression: 2026-01-10 picks go-a', () {
    final result = selector.selectFor(
      date: ChallengeDate.parse('2026-01-10'),
      candidates: candidates,
    );
    expect(result!.id, const SnippetId('go-a'));
  });

  test('pinned FNV-1a regression: 2026-01-11 picks go-b', () {
    final result = selector.selectFor(
      date: ChallengeDate.parse('2026-01-11'),
      candidates: candidates,
    );
    expect(result!.id, const SnippetId('go-b'));
  });

  test('pinned FNV-1a regression: 2026-06-15 picks go-c', () {
    final result = selector.selectFor(
      date: ChallengeDate.parse('2026-06-15'),
      candidates: candidates,
    );
    expect(result!.id, const SnippetId('go-c'));
  });
}
