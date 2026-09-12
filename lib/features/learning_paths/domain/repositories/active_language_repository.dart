import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';

/// Driven port: the language the user is currently learning, picked in
/// the Practice tab's language catalog (SPEC.md §5.7). `null` means "not
/// chosen yet", which is what makes Practice show the catalog instead of
/// a roadmap.
abstract interface class ActiveLanguageRepository {
  /// Returns the persisted active language, or `null` if none was ever
  /// chosen (or the stored name no longer maps to a known language).
  Future<Result<ProgrammingLanguage?, AppFailure>> read();

  /// Persists [language] as the active one; `null` clears the choice.
  Future<Result<void, AppFailure>> write(ProgrammingLanguage? language);
}
