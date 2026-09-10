import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/practice/domain/entities/practice_mode.dart';

/// Validates that a [Snippet] + [PracticeMode] combination can actually
/// be started. Deliberately thin: the real running state (buffer,
/// elapsed time, status) lives in `PracticeSessionController` — this is
/// just the guard clause before that state machine is allowed to move
/// past `idle`.
class StartPracticeSessionUseCase {
  /// Creates the (stateless) use case.
  const new();

  /// Returns [snippet] unchanged if it's safe to start typing, or a
  /// [ValidationFailure] describing why not.
  Result<Snippet, AppFailure> call({
    required Snippet snippet,
    required PracticeMode mode,
  }) {
    if (snippet.code.isEmpty) {
      return const Result.err(ValidationFailure('Snippet has no code to type'));
    }
    if (!snippet.isActive) {
      return const Result.err(
        ValidationFailure('Snippet is no longer active in the catalog'),
      );
    }
    return Result.ok(snippet);
  }
}
