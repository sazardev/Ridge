import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:just_in_time/features/content/domain/entities/content_category.dart';
import 'package:just_in_time/features/content/domain/entities/difficulty.dart';
import 'package:just_in_time/features/content/domain/entities/programming_language.dart';
import 'package:just_in_time/features/content/domain/entities/snippet_length.dart';
import 'package:just_in_time/features/content/domain/entities/symbol_focus.dart';
import 'package:just_in_time/features/content/domain/value_objects/snippet_id.dart';

part 'snippet.freezed.dart';

/// A single curated, real-code catalog entry (SPEC.md §3) — the unit of
/// practice material for every offline game mode.
///
/// A snippet is versioned and immutable once published: a correction is
/// published as a new [revision] for the same [id] rather than mutating
/// history, so past sessions referencing an older revision stay
/// interpretable (SPEC.md §3.2).
@freezed
abstract class Snippet with _$Snippet {
  /// Creates an immutable catalog entry snapshot.
  const factory({
    required SnippetId id,
    required int revision,
    required ProgrammingLanguage language,
    required Difficulty difficulty,
    required ContentCategory category,
    required Set<SymbolFocus> symbolFocus,
    required SnippetLength length,
    required String titleEn,
    required String titleEs,
    required String code,
    required String sourceAttribution,
    required bool isActive,
    required String tldrEn,
    required String tldrEs,
    required String explanationEn,
    required String explanationEs,
  }) = _Snippet;

  // The project-wide "elide the type name in a constructor" convention
  // (see AppFailure, ProfileId) only has a valid spelling for the
  // unnamed constructor (`new(...)`) and named *factory* constructors
  // (`factory name(...)`) — there is no elided form for a private named
  // *non-factory* constructor like this one; `new._()` is a parse error
  // (`new` can't be followed by `.`), and a bare `_()` parses as a
  // method, not a constructor. The explicit class name is required here.
  // ignore: unnecessary_type_name_in_constructor
  const Snippet._();

  /// Number of characters in [code].
  ///
  /// Always derived from [code], never stored on this entity — a stored
  /// counter could silently drift out of sync with [code] if either were
  /// ever changed independently of the other.
  int get charCount => code.length;
}
