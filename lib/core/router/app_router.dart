import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:ridge/core/router/app_shell.dart';
import 'package:ridge/features/achievements/presentation/screens/achievements_screen.dart';
import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/content/presentation/screens/snippet_browser_screen.dart';
import 'package:ridge/features/content/presentation/widgets/practice_mode_picker_sheet.dart';
import 'package:ridge/features/learning_paths/domain/value_objects/learning_path_id.dart';
import 'package:ridge/features/learning_paths/domain/value_objects/lesson_id.dart';
import 'package:ridge/features/learning_paths/presentation/screens/learning_paths_screen.dart';
import 'package:ridge/features/learning_paths/presentation/screens/lesson_deep_link_screen.dart';
import 'package:ridge/features/learning_paths/presentation/screens/lesson_detail_screen.dart';
import 'package:ridge/features/lock/presentation/providers/lock_providers.dart';
import 'package:ridge/features/lock/presentation/screens/lock_screen.dart';
import 'package:ridge/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:ridge/features/practice/domain/entities/practice_mode.dart';
import 'package:ridge/features/practice/presentation/screens/free_practice_screen.dart';
import 'package:ridge/features/practice/presentation/screens/practice_session_screen.dart';
import 'package:ridge/features/practice/presentation/screens/snippet_info_screen.dart';
import 'package:ridge/features/profile/domain/entities/guest_profile.dart';
import 'package:ridge/features/profile/presentation/providers/profile_providers.dart';
import 'package:ridge/features/profile/presentation/screens/create_profile_screen.dart';
import 'package:ridge/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:ridge/features/profile/presentation/screens/keyboard_customize_screen.dart';
import 'package:ridge/features/profile/presentation/screens/keyboard_viewer_screen.dart';
import 'package:ridge/features/profile/presentation/screens/profile_screen.dart';
import 'package:ridge/features/progression/presentation/screens/progress_screen.dart';
import 'package:ridge/features/progression/presentation/screens/stats_json_screen.dart';
import 'package:ridge/features/settings/presentation/providers/settings_providers.dart';
import 'package:ridge/features/settings/presentation/screens/changelog_screen.dart';
import 'package:ridge/features/settings/presentation/screens/settings_screen.dart';
import 'package:ridge/features/settings/presentation/screens/shortcuts_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// Reconstructs a real `PracticeMode` from the plain string [modeKind]
/// `content`'s (deliberately `practice`-free) mode picker produced — the
/// router is the one place already wired to both features, so this is
/// where the two meet back up. Precision uses `PracticeMode.precision`'s
/// default threshold (98%, SPEC.md §5.3) — not exposed as a settings
/// override. An unrecognized [modeKind] falls back to Zen rather than
/// throwing, since this only ever originates from the picker's own
/// constants.
PracticeMode _practiceModeFromKind(String modeKind) => switch (modeKind) {
  practiceModeKindSprint30 => const PracticeMode.sprint(
    window: Duration(seconds: 30),
  ),
  practiceModeKindSprint60 => const PracticeMode.sprint(
    window: Duration(seconds: 60),
  ),
  practiceModeKindSprint120 => const PracticeMode.sprint(
    window: Duration(seconds: 120),
  ),
  practiceModeKindPrecision => const PracticeMode.precision(),
  practiceModeKindSurvival => const PracticeMode.survival(),
  _ => const PracticeMode.zen(),
};

class _RouterRefreshNotifier extends ChangeNotifier {
  new(Ref ref) {
    ref
      ..listen(hasGuestProfileProvider, (_, _) => notifyListeners())
      ..listen(settingsControllerProvider, (_, _) => notifyListeners())
      ..listen(appLockSessionProvider, (_, _) => notifyListeners())
      ..onDispose(dispose);
  }
}

/// The app's single [GoRouter], reactive to auth/lock and settings state via
/// [_RouterRefreshNotifier] so a change in either redirects immediately
/// without waiting for the next navigation event.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final refresh = _RouterRefreshNotifier(ref);

  return GoRouter(
    initialLocation: '/practice',
    refreshListenable: refresh,
    redirect: (context, state) {
      final hasProfile = ref.read(hasGuestProfileProvider);
      final onOnboardingRoute = state.matchedLocation == '/onboarding';
      final onProfileCreateRoute = state.matchedLocation == '/profile/create';

      final settings = ref.read(settingsControllerProvider).value;
      // Defaults to "already seen" while settings are still hydrating, same
      // defensive reasoning as `appLockEnabled` below and as
      // `hasGuestProfileProvider`'s own doc comment — a cold start should
      // never flash the onboarding flow for a returning user.
      final onboardingCompleted = settings?.onboardingCompleted ?? true;
      final isLocked =
          (settings?.appLockEnabled ?? false) &&
          !ref.read(appLockSessionProvider);
      final onLockRoute = state.matchedLocation == '/lock';

      if (!hasProfile) {
        if (!onboardingCompleted) {
          return onOnboardingRoute ? null : '/onboarding';
        }
        return onProfileCreateRoute ? null : '/profile/create';
      }
      if (onOnboardingRoute || onProfileCreateRoute) return '/practice';
      if (isLocked && !onLockRoute) return '/lock';
      if (!isLocked && onLockRoute) return '/practice';
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/profile/create',
        builder: (context, state) => const CreateProfileScreen(),
      ),
      GoRoute(
        path: '/lock',
        builder: (context, state) =>
            const LockScreen(mode: LockScreenMode.unlock),
      ),
      GoRoute(
        path: '/lock-setup',
        builder: (context, state) =>
            const LockScreen(mode: LockScreenMode.setup),
      ),
      // Pushed as a non-shell route reachable from Profile (SPEC.md §12),
      // same shape as `/practice/session`.
      GoRoute(
        path: '/achievements',
        builder: (context, state) => const AchievementsScreen(),
      ),
      // Pushed as a non-shell route from Settings > About (same shape as
      // `/achievements`) — the running app's own release history, read
      // straight off the bundled `CHANGELOG.md` asset (STACK.md §10.4).
      GoRoute(
        path: '/changelog',
        builder: (context, state) => const ChangelogScreen(),
      ),
      // Pushed as a non-shell route from Settings > "Atajos de teclado"
      // (same shape as `/changelog`) — rebinding UI for
      // `AppSettings.shortcutBindings`.
      GoRoute(
        path: '/shortcuts',
        builder: (context, state) => const ShortcutsScreen(),
      ),
      // Pushed as a non-shell route from the Progress screen's app bar
      // (same shape as `/changelog`) — the active profile's full
      // `ProgressSnapshot` as raw, exportable JSON (SPEC.md §15).
      GoRoute(
        path: '/progress/stats-json',
        builder: (context, state) => const StatsJsonScreen(),
      ),
      // Pushed as a non-shell route from Profile's "Customize profile"
      // action, the current `GuestProfile` handed over as `extra` since
      // the caller already has it in hand (same shape as
      // `/practice/session`'s `Snippet`/`PracticeMode`).
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) =>
            EditProfileScreen(profile: state.extra! as GuestProfile),
      ),
      // Pushed as a non-shell route from the keyboard hero card's expand
      // action (same `extra` handover as `/profile/edit`) — a fullscreen
      // inspector of the same `KeyboardVisual` the card previews, with
      // room for orbit and zoom.
      GoRoute(
        path: '/profile/keyboard',
        builder: (context, state) =>
            KeyboardViewerScreen(profile: state.extra! as GuestProfile),
      ),
      // Pushed as a non-shell route from the keyboard hero card's edit
      // action and from the keyboard card in the profile editor — the
      // dedicated keyboard editor: a pinned live 3D preview plus every
      // keyboard metadata control, saved as one disjoint write.
      GoRoute(
        path: '/profile/keyboard/customize',
        builder: (context, state) =>
            KeyboardCustomizeScreen(profile: state.extra! as GuestProfile),
      ),
      // Pushed as a non-shell route reachable from the Practice hub's
      // "Browse all snippets" action — the catalog browser used to be
      // its own shell tab (`/library`); it's now folded into Practice
      // per the final five-destination shell (see `app_shell.dart`). The
      // "tap a tile -> mode picker -> start session" flow inside it is
      // unchanged (see `SnippetListTile`).
      GoRoute(
        path: '/practice/browse',
        builder: (context, state) => const SnippetBrowserScreen(),
      ),
      // Pushed as a non-shell route (same shape as `/lock`) so the nav
      // rail/bottom bar disappears during capture.
      //
      // Two callers push this route with two different `extra` shapes:
      // `content` (decoupled from `practice`, see
      // `practice_mode_picker_sheet.dart`'s class doc) passes a plain
      // string `modeKind`; `learning_paths` (allowed to depend on
      // `practice` directly per the project plan's feature dependency
      // order) already has a real `PracticeMode.learningRouteLesson` to
      // hand over, plus an optional `onContinue` (the "Continue to next
      // lesson" action, `null` on the path's last lesson) and an
      // `onShare` (shares a link to this lesson, shown once the result
      // screen shows a pass) that `LessonNavigation` already builds with
      // a real target. This route — already wired to every feature
      // involved — is the one place that tells the two apart.
      GoRoute(
        path: '/practice/session',
        builder: (context, state) {
          final extra = state.extra;
          if (extra
              is ({
                Snippet snippet,
                PracticeMode mode,
                VoidCallback? onContinue,
                VoidCallback? onShare,
              })) {
            return PracticeSessionScreen(
              snippet: extra.snippet,
              mode: extra.mode,
              onContinue: extra.onContinue,
              onShare: extra.onShare,
            );
          }
          final request = extra! as ({Snippet snippet, String modeKind});
          return PracticeSessionScreen(
            snippet: request.snippet,
            mode: _practiceModeFromKind(request.modeKind),
          );
        },
        routes: [
          // The result screen's fixed-footer "info" action — a
          // full-screen, no-capture reading view of whichever snippet
          // was just typed (SPEC.md-adjacent, mirrors syntax
          // highlighting's own addition).
          GoRoute(
            path: 'info',
            builder: (context, state) =>
                SnippetInfoScreen(snippet: state.extra! as Snippet),
          ),
        ],
      ),
      // Final five-destination shell (SPEC.md §5/§6.3): Practice (the
      // structured learning roadmap, SPEC.md §5.7 — the default,
      // deliberately-ordered entry point, never a random pick), Progress,
      // Free practice (Zen/Sprint/Precision + the full catalog — one
      // tab over, not the default), Profile, Settings, in that order —
      // branch order here is what `app_shell.dart`'s destinations list
      // is positionally indexed against.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/practice',
                builder: (context, state) => const LearningPathsScreen(),
                routes: [
                  GoRoute(
                    path: ':pathId',
                    builder: (context, state) => LessonDetailScreen(
                      pathId: LearningPathId(state.pathParameters['pathId']!),
                    ),
                    routes: [
                      // A URL-addressable single lesson — reachable from a
                      // shared link or (once v2 push notifications exist,
                      // STACK.md §14) a notification tap. Resolves and
                      // forwards into `/practice/session`; never a
                      // destination on its own (`LessonDeepLinkScreen`).
                      GoRoute(
                        path: 'lessons/:lessonId',
                        builder: (context, state) => LessonDeepLinkScreen(
                          pathId: LearningPathId(
                            state.pathParameters['pathId']!,
                          ),
                          lessonId: LessonId(state.pathParameters['lessonId']!),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/progress',
                builder: (context, state) => const ProgressScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/free-practice',
                builder: (context, state) => const FreePracticeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
