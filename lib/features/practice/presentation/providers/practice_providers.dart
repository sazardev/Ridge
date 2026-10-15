import 'package:ridge/core/persistence/drift/app_database.dart';
import 'package:ridge/core/persistence/drift/database_provider.dart';
import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/content/presentation/providers/content_providers.dart';
import 'package:ridge/features/practice/application/usecases/finish_practice_session_usecase.dart';
import 'package:ridge/features/practice/application/usecases/get_ghost_run_usecase.dart';
import 'package:ridge/features/practice/application/usecases/get_next_sprint_snippet_usecase.dart';
import 'package:ridge/features/practice/application/usecases/start_practice_session_usecase.dart';
import 'package:ridge/features/practice/application/usecases/watch_hardware_keyboard_connected_usecase.dart';
import 'package:ridge/features/practice/domain/entities/ghost_run.dart';
import 'package:ridge/features/practice/domain/entities/practice_mode.dart';
import 'package:ridge/features/practice/domain/entities/typing_session.dart';
import 'package:ridge/features/practice/domain/repositories/hardware_keyboard_repository.dart';
import 'package:ridge/features/practice/domain/repositories/session_repository.dart';
import 'package:ridge/features/practice/infrastructure/hardware_keyboard_repository_impl.dart';
import 'package:ridge/features/practice/infrastructure/practice_dao.dart';
import 'package:ridge/features/practice/infrastructure/session_repository_impl.dart';
import 'package:ridge/features/practice/presentation/services/keystroke_sound_player.dart';
import 'package:ridge/features/profile/presentation/providers/profile_providers.dart';
import 'package:ridge/features/progression/presentation/providers/progression_providers.dart';
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

/// Streams every finished session for the active profile, newest first —
/// the shared read surface for cross-feature summaries (the Progress
/// weekly report, the daily-reminder guard).
@Riverpod(keepAlive: true)
Stream<List<TypingSession>> typingSessions(Ref ref) {
  final profile = ref.watch(activeProfileControllerProvider).value;
  if (profile == null) return const Stream.empty();
  return ref
      .watch(sessionRepositoryProvider)
      .watchSessionsForProfile(profile.id);
}

/// The in-app exercise nudge's data: the profile practiced before but not
/// today, so there's a streak to protect or a gap to close. `null` when
/// there's nothing to nudge about (practiced today, or no history yet) —
/// the card stays hidden rather than nagging a brand-new profile.
typedef DailyPracticeNudgeData = ({int streakDays, int daysSinceLastSession});

/// Resolves [DailyPracticeNudgeData] for the active profile.
@riverpod
Future<DailyPracticeNudgeData?> dailyPracticeNudge(Ref ref) async {
  final profile = ref.watch(activeProfileControllerProvider).value;
  if (profile == null) return null;

  final sessions = await ref.watch(typingSessionsProvider.future);
  if (sessions.isEmpty) return null;

  final now = DateTime.now();
  final last = sessions.first.startedAtUtc.toLocal();
  if (last.year == now.year && last.month == now.month && last.day == now.day) {
    return null;
  }

  final snapshot = await ref.watch(progressSnapshotControllerProvider.future);
  // Calendar-day distance via UTC midnights: immune to DST making a local
  // day 23 or 25 hours long, which would round to the wrong count.
  final days = DateTime.utc(
    now.year,
    now.month,
    now.day,
  ).difference(DateTime.utc(last.year, last.month, last.day)).inDays;
  return (
    streakDays: snapshot?.currentStreakDays ?? 0,
    daysSinceLastSession: days,
  );
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

/// Provides the [GetGhostRunUseCase] for the ghost-race overlay.
@riverpod
GetGhostRunUseCase getGhostRunUseCase(Ref ref) {
  return GetGhostRunUseCase(ref.watch(sessionRepositoryProvider));
}

/// The ghost run for [snippet] under [mode], or `null` when there's
/// nothing to race against — no prior attempt, or [mode] is one of the
/// multi-snippet streams (Sprint/Survival) whose stored attempts have no
/// single-snippet boundary to line up with. Fetched once per session;
/// the capture field replays it against its own clock.
@riverpod
Future<GhostRun?> ghostRun(Ref ref, Snippet snippet, PracticeMode mode) async {
  final singleSnippet = mode.maybeWhen(
    zen: () => true,
    precision: () => true,
    learningRouteLesson: (_) => true,
    dailyChallenge: (_) => true,
    orElse: () => false,
  );
  if (!singleSnippet) return null;

  final profile = ref.watch(activeProfileControllerProvider).value;
  if (profile == null) return null;

  final result = await ref.watch(getGhostRunUseCaseProvider)(
    profileId: profile.id,
    snippetId: snippet.id,
  );
  return result.valueOrNull;
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

/// Provides the [HardwareKeyboardRepository] implementation used across
/// the app.
@Riverpod(keepAlive: true)
HardwareKeyboardRepository hardwareKeyboardRepository(Ref ref) {
  return const HardwareKeyboardRepositoryImpl();
}

/// Provides the [WatchHardwareKeyboardConnectedUseCase].
@riverpod
WatchHardwareKeyboardConnectedUseCase watchHardwareKeyboardConnectedUseCase(
  Ref ref,
) {
  return WatchHardwareKeyboardConnectedUseCase(
    ref.watch(hardwareKeyboardRepositoryProvider),
  );
}

/// Whether a physical/Bluetooth keyboard is currently attached — gates
/// `KeystrokeCaptureField` behind `KeyboardRequiredNotice` when it isn't
/// (Android only; every other platform always reports connected, see
/// `HardwareKeyboardRepositoryImpl`). Not kept alive: only worth polling
/// while an actual typing screen is watching it.
@riverpod
Stream<bool> hardwareKeyboardConnected(Ref ref) {
  return ref.watch(watchHardwareKeyboardConnectedUseCaseProvider)();
}
