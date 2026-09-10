import 'package:ridge/core/persistence/drift/app_database.dart';
import 'package:ridge/core/persistence/drift/database_provider.dart';
import 'package:ridge/features/content/presentation/providers/content_providers.dart';
import 'package:ridge/features/practice/application/usecases/finish_practice_session_usecase.dart';
import 'package:ridge/features/practice/application/usecases/get_next_sprint_snippet_usecase.dart';
import 'package:ridge/features/practice/application/usecases/start_practice_session_usecase.dart';
import 'package:ridge/features/practice/domain/repositories/session_repository.dart';
import 'package:ridge/features/practice/infrastructure/practice_dao.dart';
import 'package:ridge/features/practice/infrastructure/session_repository_impl.dart';
import 'package:ridge/features/practice/presentation/services/keystroke_sound_player.dart';
import 'package:ridge/features/settings/domain/entities/app_sound_pack.dart';
import 'package:ridge/features/settings/presentation/providers/settings_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'practice_providers.g.dart';

/// Provides the [PracticeDao] bound to the shared [AppDatabase].
@Riverpod(keepAlive: true)
PracticeDao practiceDao(Ref ref) {
  return ref.watch(appDatabaseProvider).practiceDao;
}

/// Provides the [SessionRepository] implementation used across the app.
@Riverpod(keepAlive: true)
SessionRepository sessionRepository(Ref ref) {
  return SessionRepositoryImpl(ref.watch(practiceDaoProvider));
}

/// Provides the [StartPracticeSessionUseCase] for validating a session
/// before it starts.
@riverpod
StartPracticeSessionUseCase startPracticeSessionUseCase(Ref ref) {
  return const StartPracticeSessionUseCase();
}

/// Provides the [FinishPracticeSessionUseCase] for computing metrics and
/// persisting a finished session.
@riverpod
FinishPracticeSessionUseCase finishPracticeSessionUseCase(Ref ref) {
  return FinishPracticeSessionUseCase(ref.watch(sessionRepositoryProvider));
}

/// Provides the [GetNextSprintSnippetUseCase] Sprint mode uses to advance
/// through its same-difficulty snippet queue (SPEC.md §5.2).
@riverpod
GetNextSprintSnippetUseCase getNextSprintSnippetUseCase(Ref ref) {
  return GetNextSprintSnippetUseCase(ref.watch(snippetRepositoryProvider));
}

/// Provides the app-lifetime [KeystrokeSoundPlayer] for the current
/// settings-chosen sound pack — kept alive (rather than one per session)
/// so its audio pools stay pre-loaded across every practice session
/// instead of reloading on each one. Rebuilds (disposing the old pools,
/// loading the new pack's) whenever the sound pack setting changes.
@Riverpod(keepAlive: true)
KeystrokeSoundPlayer keystrokeSoundPlayer(Ref ref) {
  final pack =
      ref.watch(settingsControllerProvider).value?.soundPack ??
      AppSoundPack.mechanical;
  final player = KeystrokeSoundPlayer(pack);
  ref.onDispose(player.dispose);
  return player;
}
