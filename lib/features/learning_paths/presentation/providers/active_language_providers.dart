import 'package:ridge/core/persistence/preferences_provider.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/learning_paths/application/usecases/get_active_language_usecase.dart';
import 'package:ridge/features/learning_paths/application/usecases/set_active_language_usecase.dart';
import 'package:ridge/features/learning_paths/domain/repositories/active_language_repository.dart';
import 'package:ridge/features/learning_paths/infrastructure/active_language_local_data_source.dart';
import 'package:ridge/features/learning_paths/infrastructure/active_language_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_language_providers.g.dart';

/// Provides the [ActiveLanguageLocalDataSource] backed by shared
/// preferences.
@Riverpod(keepAlive: true)
ActiveLanguageLocalDataSource activeLanguageLocalDataSource(Ref ref) {
  return ActiveLanguageLocalDataSource(ref.watch(sharedPreferencesProvider));
}

/// Provides the [ActiveLanguageRepository] implementation used across the
/// app.
@Riverpod(keepAlive: true)
ActiveLanguageRepository activeLanguageRepository(Ref ref) {
  return ActiveLanguageRepositoryImpl(
    ref.watch(activeLanguageLocalDataSourceProvider),
  );
}

/// Provides the [GetActiveLanguageUseCase].
@riverpod
GetActiveLanguageUseCase getActiveLanguageUseCase(Ref ref) {
  return GetActiveLanguageUseCase(ref.watch(activeLanguageRepositoryProvider));
}

/// Provides the [SetActiveLanguageUseCase].
@riverpod
SetActiveLanguageUseCase setActiveLanguageUseCase(Ref ref) {
  return SetActiveLanguageUseCase(ref.watch(activeLanguageRepositoryProvider));
}

/// Exposes the persisted active learning language and the mutation the
/// language catalog requests (SPEC.md §5.7). `null` means "no language
/// chosen yet" — the Practice tab shows its catalog in that case.
@Riverpod(keepAlive: true)
class ActiveLanguageController extends _$ActiveLanguageController {
  @override
  Future<ProgrammingLanguage?> build() async {
    final result = await ref.watch(getActiveLanguageUseCaseProvider)();
    return result.valueOrNull;
  }

  /// Persists [language] as the active one (or clears the choice with
  /// `null`) and updates the exposed state. A storage failure leaves the
  /// previous state untouched.
  Future<void> activate(ProgrammingLanguage? language) async {
    final result = await ref.read(setActiveLanguageUseCaseProvider)(language);
    if (result.isErr) return;
    state = AsyncData(language);
  }
}
