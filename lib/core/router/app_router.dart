import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:just_in_time/core/router/app_shell.dart';
import 'package:just_in_time/features/lock/presentation/providers/lock_providers.dart';
import 'package:just_in_time/features/lock/presentation/screens/lock_screen.dart';
import 'package:just_in_time/features/settings/presentation/providers/settings_providers.dart';
import 'package:just_in_time/features/settings/presentation/screens/settings_screen.dart';
import 'package:just_in_time/features/tasks/presentation/screens/tasks_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

class _RouterRefreshNotifier extends ChangeNotifier {
  new(Ref ref) {
    ref
      ..listen(settingsControllerProvider, (_, _) => notifyListeners())
      ..listen(appLockSessionProvider, (_, _) => notifyListeners())
      ..onDispose(dispose);
  }
}

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final refresh = _RouterRefreshNotifier(ref);

  return GoRouter(
    initialLocation: '/tasks',
    refreshListenable: refresh,
    redirect: (context, state) {
      final settings = ref.read(settingsControllerProvider).value;
      final isLocked =
          (settings?.appLockEnabled ?? false) &&
          !ref.read(appLockSessionProvider);
      final onLockRoute = state.matchedLocation == '/lock';

      if (isLocked && !onLockRoute) return '/lock';
      if (!isLocked && onLockRoute) return '/tasks';
      return null;
    },
    routes: [
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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tasks',
                builder: (context, state) => const TasksScreen(),
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
