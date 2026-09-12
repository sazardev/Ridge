import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/learning_paths/domain/repositories/active_language_repository.dart';

/// Loads the persisted active learning language (SPEC.md §5.7) so the
/// Practice tab knows whether to show its language catalog or a roadmap.
class GetActiveLanguageUseCase {
  /// Creates the use case over the given port.
  const new(this._repository);

  final ActiveLanguageRepository _repository;

  /// Returns the persisted active language, or `null` if none was chosen.
  Future<Result<ProgrammingLanguage?, AppFailure>> call() => _repository.read();
}
