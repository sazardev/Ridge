import 'package:freezed_annotation/freezed_annotation.dart';

part 'snippet_id.freezed.dart';

/// Type-safe identifier for a catalog Snippet.
///
/// Unlike `ProfileId`, this is never randomly generated: snippet ids are
/// stable, human-assigned strings (e.g. `go-vars-001`) chosen by whoever
/// curates the JSON catalog (SPEC.md §3.2), so the content file itself
/// stays reviewable and diffable in source control across revisions.
@freezed
abstract class SnippetId with _$SnippetId {
  /// Wraps the raw identifier [value].
  const factory(String value) = _SnippetId;
}
