import 'package:drift/drift.dart';

import 'package:just_in_time/core/persistence/drift/app_database.dart';
import 'package:just_in_time/features/content/infrastructure/tables/snippets_table.dart';

part 'snippet_dao.g.dart';

/// Escapes SQLite `LIKE` wildcards (`%`, `_`) and the escape character
/// itself so a literal character search never accidentally behaves like
/// a wildcard match — critical here since Go source legitimately
/// contains both `_` (blank identifier, snake-ish names) and `%` (format
/// verbs), and either would otherwise match "any single character".
String _escapeForLike(String raw) {
  return raw
      .replaceAll(r'\', r'\\')
      .replaceAll('%', r'\%')
      .replaceAll('_', r'\_');
}

/// Typed queries against the [Snippets] table.
@DriftAccessor(tables: [Snippets])
class SnippetDao extends DatabaseAccessor<AppDatabase> with _$SnippetDaoMixin {
  /// Creates the DAO bound to the shared [AppDatabase].
  new(super.attachedDatabase);

  /// Emits every active row, and every subsequent change to the table.
  Stream<List<SnippetRow>> watchCatalog() {
    return (select(
      snippets,
    )..where((row) => row.isActive.equals(true))).watch();
  }

  /// Returns the row identified by [id], regardless of active status.
  Future<SnippetRow?> getById(String id) {
    return (select(
      snippets,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
  }

  /// Returns every active row matching all of the given, optional column
  /// filters.
  Future<List<SnippetRow>> findByFilters({
    String? language,
    String? difficulty,
    String? category,
    String? length,
  }) {
    final query = select(snippets)..where((row) => row.isActive.equals(true));
    if (language != null) {
      query.where((row) => row.language.equals(language));
    }
    if (difficulty != null) {
      query.where((row) => row.difficulty.equals(difficulty));
    }
    if (category != null) {
      query.where((row) => row.category.equals(category));
    }
    if (length != null) {
      query.where((row) => row.length.equals(length));
    }
    return query.get();
  }

  /// Returns every active row whose `code` contains at least one of the
  /// given literal [characters].
  Future<List<SnippetRow>> findContainingSymbols(Set<String> characters) {
    if (characters.isEmpty) return Future.value(const []);
    final query = select(snippets)
      ..where((row) {
        final matchesAnyCharacter = Expression.or([
          for (final character in characters)
            row.code.like('%${_escapeForLike(character)}%', escapeChar: r'\'),
        ]);
        return matchesAnyCharacter & row.isActive.equals(true);
      });
    return query.get();
  }

  /// Inserts [row], or replaces the existing row with the same id.
  Future<void> upsertSnippet(SnippetsCompanion row) {
    return into(snippets).insertOnConflictUpdate(row);
  }
}
