import 'package:freezed_annotation/freezed_annotation.dart';

part 'snippet_dto.freezed.dart';
part 'snippet_dto.g.dart';

/// Wire/storage shape for a `Snippet`. Mirrors the bundled JSON asset's
/// shape exactly (`assets/content/snippets/go_v1.json`) so a future
/// content-format change never leaks into business logic — only
/// `SnippetMapper` needs to change.
///
/// Deliberately excludes `charCount`: that value is always derived from
/// `code.length`, never authored in the JSON asset, so it has no place
/// in the wire format — `SnippetMapper` computes it only when building
/// the drift row that needs to store it as a real, queryable column.
@freezed
abstract class SnippetDto with _$SnippetDto {
  /// Creates a DTO snapshot ready for JSON serialization.
  const factory({
    required String id,
    required int revision,
    required String language,
    required String difficulty,
    required String category,
    required String length,
    required String titleEn,
    required String titleEs,
    required String code,
    required String sourceAttribution,
    required bool isActive,
    required String explanationEn,
    required String explanationEs,
    // Guarded non-empty for every bundled entry by
    // `snippet_catalog_completeness_test.dart`; defaults to '' (mirroring
    // the drift column's own `withDefault('')` in snippets_table.dart) so
    // a content edit that temporarily drops one fails that test instead
    // of crashing catalog loading entirely.
    @Default('') String tldrEn,
    @Default('') String tldrEs,
    @Default(<String>[]) List<String> symbolFocus,
  }) = _SnippetDto;

  /// Deserializes a DTO from decoded JSON.
  factory fromJson(Map<String, Object?> json) => _$SnippetDtoFromJson(json);
}
