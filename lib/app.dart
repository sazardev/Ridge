import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/router/app_router.dart';
import 'package:ridge/core/splash/app_startup_splash.dart';
import 'package:ridge/core/theme/app_theme.dart';
import 'package:ridge/core/window/app_window_frame.dart';
import 'package:ridge/core/window/desktop_platform.dart';
import 'package:ridge/features/content/presentation/providers/content_providers.dart';
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
      ..watch(deviceInfoSyncProvider);

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
        final splashed = AppStartupSplash(child: child!);
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
