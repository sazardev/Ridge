import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/learning_paths/domain/repositories/active_language_repository.dart';
import 'package:ridge/features/learning_paths/infrastructure/active_language_local_data_source.dart';

/// Local-storage adapter for [ActiveLanguageRepository]. Maps between the
/// persisted enum name and [ProgrammingLanguage]; a stored name that no
/// longer exists (content removed a language) reads back as `null`, which
/// gracefully sends the user back to the language catalog.
class ActiveLanguageRepositoryImpl implements ActiveLanguageRepository {
  /// Creates the adapter over the given [ActiveLanguageLocalDataSource].
  const new(this._dataSource);

  final ActiveLanguageLocalDataSource _dataSource;

  @override
  Future<Result<ProgrammingLanguage?, AppFailure>> read() async {
    try {
      final name = await _dataSource.read();
      if (name == null) return const Result.ok(null);
      for (final language in ProgrammingLanguage.values) {
        if (language.name == name) return Result.ok(language);
      }
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.err(
        StorageFailure('Could not read active language', cause: e),
      );
    }
  }

  @override
  Future<Result<void, AppFailure>> write(ProgrammingLanguage? language) async {
    try {
      await _dataSource.write(language?.name);
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.err(
        StorageFailure('Could not save active language', cause: e),
      );
    }
  }
}
