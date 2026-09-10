import 'package:drift/drift.dart';

import 'package:ridge/core/persistence/drift/app_database.dart';
import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/content/domain/entities/snippet_length.dart';
import 'package:ridge/features/content/domain/entities/symbol_focus.dart';
import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
import 'package:ridge/features/content/infrastructure/snippet_dto.dart';

const _symbolFocusSeparator = ',';

/// Converts a [SnippetDto] into its domain [Snippet] representation and
/// into a drift row-insert companion.
extension SnippetDtoMapper on SnippetDto {
  /// Maps this DTO to the domain entity.
  Snippet toDomain() {
    return Snippet(
      id: SnippetId(id),
      revision: revision,
      language: ProgrammingLanguage.values.byName(language),
      difficulty: Difficulty.values.byName(difficulty),
      category: ContentCategory.values.byName(category),
      symbolFocus: symbolFocus.map(SymbolFocus.values.byName).toSet(),
      length: SnippetLength.values.byName(length),
      titleEn: titleEn,
      titleEs: titleEs,
      code: code,
      sourceAttribution: sourceAttribution,
      isActive: isActive,
      tldrEn: tldrEn,
      tldrEs: tldrEs,
      explanationEn: explanationEn,
      explanationEs: explanationEs,
    );
  }

  /// Maps this DTO to a drift row-insert companion, computing the
  /// denormalized `charCount` column from `code.length`.
  SnippetsCompanion toCompanion() {
    return SnippetsCompanion.insert(
      id: id,
      revision: revision,
      language: language,
      difficulty: difficulty,
      category: category,
      symbolFocus: Value(
        symbolFocus.isEmpty ? null : symbolFocus.join(_symbolFocusSeparator),
      ),
      length: length,
      titleEn: Value(titleEn),
      titleEs: Value(titleEs),
      code: code,
      sourceAttribution: sourceAttribution,
      charCount: code.length,
      isActive: isActive,
      tldrEn: Value(tldrEn),
      tldrEs: Value(tldrEs),
      explanationEn: Value(explanationEn),
      explanationEs: Value(explanationEs),
    );
  }
}

/// Converts a [Snippet] domain entity into its storage [SnippetDto].
extension SnippetMapper on Snippet {
  /// Maps this entity to its wire/storage shape.
  SnippetDto toDto() {
    return SnippetDto(
      id: id.value,
      revision: revision,
      language: language.name,
      difficulty: difficulty.name,
      category: category.name,
      symbolFocus: symbolFocus.map((focus) => focus.name).toList(),
      length: length.name,
      titleEn: titleEn,
      titleEs: titleEs,
      code: code,
      sourceAttribution: sourceAttribution,
      isActive: isActive,
      tldrEn: tldrEn,
      tldrEs: tldrEs,
      explanationEn: explanationEn,
      explanationEs: explanationEs,
    );
  }
}

/// Converts a drift [SnippetRow] into its storage [SnippetDto].
extension SnippetRowMapper on SnippetRow {
  /// Maps this row to the storage DTO.
  SnippetDto toDto() {
    final storedFocus = symbolFocus;
    return SnippetDto(
      id: id,
      revision: revision,
      language: language,
      difficulty: difficulty,
      category: category,
      symbolFocus: storedFocus == null || storedFocus.isEmpty
          ? const []
          : storedFocus.split(_symbolFocusSeparator),
      length: length,
      titleEn: titleEn,
      titleEs: titleEs,
      code: code,
      sourceAttribution: sourceAttribution,
      isActive: isActive,
      tldrEn: tldrEn,
      tldrEs: tldrEs,
      explanationEn: explanationEn,
      explanationEs: explanationEs,
    );
  }
}
