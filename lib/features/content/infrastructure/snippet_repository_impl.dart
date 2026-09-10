import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/content/domain/entities/snippet_length.dart';
import 'package:ridge/features/content/domain/repositories/snippet_repository.dart';
import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
import 'package:ridge/features/content/infrastructure/snippet_dao.dart';
import 'package:ridge/features/content/infrastructure/snippet_mapper.dart';

/// Drift-backed adapter for [SnippetRepository].
///
/// Like `ProfileRepositoryImpl`, `watchCatalog` simply maps drift's
/// already-reactive `.watch()` stream — no hand-rolled `StreamController`
/// needed. Writes follow the established try/catch →
/// `Result.err(StorageFailure(...))` shape.
class SnippetRepositoryImpl implements SnippetRepository {
  /// Creates the adapter over the given [SnippetDao].
  const new(this._dao);

  final SnippetDao _dao;

  @override
  Stream<List<Snippet>> watchCatalog() {
    return _dao.watchCatalog().map(
      (rows) => [for (final row in rows) row.toDto().toDomain()],
    );
  }

  @override
  Future<Result<Snippet, AppFailure>> getById(SnippetId id) async {
    try {
      final row = await _dao.getById(id.value);
      if (row == null) {
        return Result.err(NotFoundFailure('No snippet with id ${id.value}'));
      }
      return Result.ok(row.toDto().toDomain());
    } on Exception catch (e) {
      return Result.err(StorageFailure('Could not load snippet', cause: e));
    }
  }

  @override
  Future<Result<List<Snippet>, AppFailure>> findByFilters({
    ProgrammingLanguage? language,
    Difficulty? difficulty,
    ContentCategory? category,
    SnippetLength? length,
  }) async {
    try {
      final rows = await _dao.findByFilters(
        language: language?.name,
        difficulty: difficulty?.name,
        category: category?.name,
        length: length?.name,
      );
      return Result.ok([for (final row in rows) row.toDto().toDomain()]);
    } on Exception catch (e) {
      return Result.err(
        StorageFailure('Could not filter snippet catalog', cause: e),
      );
    }
  }

  @override
  Future<Result<List<Snippet>, AppFailure>> findContainingSymbols(
    Set<String> characters,
  ) async {
    try {
      final rows = await _dao.findContainingSymbols(characters);
      return Result.ok([for (final row in rows) row.toDto().toDomain()]);
    } on Exception catch (e) {
      return Result.err(
        StorageFailure('Could not search snippet catalog', cause: e),
      );
    }
  }

  @override
  Future<Result<void, AppFailure>> upsertCatalogEntries(
    List<Snippet> entries,
  ) async {
    try {
      await _dao.upsertSnippets([
        for (final entry in entries) entry.toDto().toCompanion(),
      ]);
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.err(
        StorageFailure('Could not seed snippet catalog', cause: e),
      );
    }
  }

  @override
  Future<Result<List<Snippet>, AppFailure>> getByIds(Set<SnippetId> ids) async {
    try {
      final rows = await _dao.getByIds({for (final id in ids) id.value});
      return Result.ok([for (final row in rows) row.toDto().toDomain()]);
    } on Exception catch (e) {
      return Result.err(StorageFailure('Could not load snippets', cause: e));
    }
  }
}
