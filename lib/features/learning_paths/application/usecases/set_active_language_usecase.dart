import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/learning_paths/domain/repositories/active_language_repository.dart';

/// Persists the language the user just activated in the Practice tab's
/// language catalog (SPEC.md §5.7).
class SetActiveLanguageUseCase {
  /// Creates the use case over the given port.
  const new(this._repository);

  final ActiveLanguageRepository _repository;

  /// Persists [language] as active; `null` clears the choice.
  Future<Result<void, AppFailure>> call(ProgrammingLanguage? language) =>
      _repository.write(language);
}
