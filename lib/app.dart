import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/router/app_router.dart';
import 'package:ridge/core/router/deep_link_providers.dart';
import 'package:ridge/core/splash/app_startup_splash.dart';
import 'package:ridge/core/theme/app_theme.dart';
import 'package:ridge/core/window/app_window_frame.dart';
import 'package:ridge/core/window/desktop_platform.dart';
import 'package:ridge/features/content/presentation/providers/content_providers.dart';
import 'package:ridge/features/learning_paths/presentation/providers/learning_paths_providers.dart';
import 'package:ridge/features/profile/presentation/providers/profile_providers.dart';
import 'package:ridge/features/settings/domain/entities/app_settings.dart';
import 'package:ridge/features/settings/domain/entities/app_theme_mode.dart';
import 'package:ridge/features/settings/presentation/providers/settings_providers.dart';

/// The app's root widget: wires the router, theme, and locale to the
/// current [AppSettings] so a settings change repaints the whole tree.
class RidgeApp extends ConsumerWidget {
  /// Creates the app's root widget.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final settings =
        ref.watch(settingsControllerProvider).value ?? AppSettings.initial;
    // Fire the (idempotent, keepAlive) catalog seed as soon as the app
    // starts, regardless of which route the router lands on first. Not
    // gated on the startup splash below or anything else: the browser
    // screen's own reactive stream picks up the seeded rows the moment
    // they land, seed too small to bother waiting for.
    ref
      ..watch(catalogSeedProvider)
      // Same idempotent, keepAlive, fire-on-start shape as the catalog
      // seed above — detects and stores device info once a Guest
      // Profile exists, then no-ops on every subsequent profile update.
      ..watch(deviceInfoSyncProvider)
      // Same fire-on-start shape again — listens for incoming `ridge://`
      // links for the app's lifetime.
      ..watch(deepLinkListenerProvider);

    // Drives `AppStartupSplash.ready` below: `/practice` (the initial
    // route) is `LearningPathsScreen`, which shows its own
    // `CircularProgressIndicator` while `learningPathsControllerProvider`
    // is still loading. Gating the splash on this too (not just its own
    // minimum display) means that spinner never gets a chance to flash
    // right as the splash lifts — a non-empty overview list is the
    // signal the bundled catalog has actually seeded and joined, since
    // the controller otherwise reports an empty list while that seed is
    // still in flight (see its own doc comment).
    final learningPathsReady = ref.watch(learningPathsControllerProvider);
    final coreContentReady =
        learningPathsReady.hasError ||
        (learningPathsReady.value?.isNotEmpty ?? false);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: AppTheme.light(
        expressiveColor: settings.expressiveColor,
        palette: settings.palette,
        cornerStyle: settings.cornerStyle,
      ),
      darkTheme: AppTheme.dark(
        expressiveColor: settings.expressiveColor,
        palette: settings.palette,
        cornerStyle: settings.cornerStyle,
      ),
      themeMode: switch (settings.themeMode) {
        AppThemeMode.system => ThemeMode.system,
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.dark => ThemeMode.dark,
      },
      locale: settings.languageCode == null
          ? null
          : Locale(settings.languageCode!),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      builder: (context, child) {
        // Performance mode reuses the platform reduced-motion signal, so
        // every widget that already honors `disableAnimations` switches
        // off without knowing about the setting.
        final content = settings.performanceMode
            ? MediaQuery(
                data: MediaQuery.of(context).copyWith(disableAnimations: true),
                child: child!,
              )
            : child!;
        final splashed = AppStartupSplash(
          ready: coreContentReady,
          child: content,
        );
        if (!isDesktopPlatform || !settings.windowBorderEnabled) {
          return splashed;
        }
        return AppWindowFrame(
          radius: windowFrameRadiusFor(settings.cornerStyle),
          borderWidth: windowFrameBorderWidthFor(settings.windowBorderWidth),
          child: splashed,
        );
      },
    );
  }
}
