import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_motion.dart';
import 'package:ridge/core/window/window_bar.dart';

/// A one-time branding splash — logo, wordmark, and tagline — shown over
/// [child] for a fixed beat when the app cold-starts, then faded away for
/// good. Sits in `MaterialApp.router`'s `builder` slot (see `app.dart`), so
/// [child] (the real routed app) keeps building underneath the whole time;
/// that's deliberate, not just for the crossfade — it means whatever the
/// router's redirect logic lands on first (onboarding, lock, practice) is
/// already settled by the time the splash lifts, instead of flashing the
/// wrong screen for a frame.
class AppStartupSplash extends StatefulWidget {
  /// Creates the splash overlay above [child].
  const new({required this.child, super.key});

  /// The real app content, already building beneath the splash.
  final Widget child;

  @override
  State<AppStartupSplash> createState() => _AppStartupSplashState();
}

class _AppStartupSplashState extends State<AppStartupSplash> {
  static const _minDisplay = Duration(milliseconds: 1400);
  static const Duration _fadeOut = AppMotion.effectsSlow;

  bool _dismissing = false;
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(_minDisplay, () {
      if (!mounted) return;
      setState(() => _dismissing = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return widget.child;

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    return Stack(
      children: [
        Positioned.fill(child: widget.child),
        Positioned.fill(
          child: IgnorePointer(
            ignoring: _dismissing,
            child: AnimatedOpacity(
              opacity: _dismissing ? 0 : 1,
              duration: _fadeOut,
              curve: AppMotion.exit,
              onEnd: () {
                if (_dismissing) setState(() => _dismissed = true);
              },
              child: ColoredBox(
                color: colorScheme.surface,
                child: Column(
                  children: [
                    // Keeps the desktop window draggable/closable even
                    // while the splash is up — every other screen gets
                    // this from its own `Scaffold` (see `LockScreen`), but
                    // the splash sits above all of them, so it needs its
                    // own copy. Renders nothing on Android.
                    // `showTooltips: false`: this instance renders inside
                    // `MaterialApp.router`'s `builder` slot, above the
                    // `Router`/`Navigator` entirely, so it has no ancestor
                    // `Overlay` for a hover `Tooltip` to pop into — a
                    // non-issue given how briefly and non-interactively
                    // this copy is ever on screen.
                    const WindowBar(showTooltips: false),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                                  width: 72,
                                  height: 72,
                                  child: SvgPicture.asset(
                                    'assets/icons/r_mark.svg',
                                    colorFilter: ColorFilter.mode(
                                      colorScheme.primary,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                )
                                .animate()
                                .fadeIn(duration: AppMotion.effectsDefault)
                                .scale(
                                  begin: const Offset(0.85, 0.85),
                                  curve: AppMotion.enter,
                                  duration: AppMotion.spatialDefault,
                                ),
                            const SizedBox(height: 20),
                            Text(
                                  l10n.appName,
                                  style: textTheme.displaySmall?.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                )
                                .animate(
                                  delay: const Duration(milliseconds: 150),
                                )
                                .fadeIn(duration: AppMotion.effectsDefault)
                                .slideY(
                                  begin: 0.2,
                                  end: 0,
                                  curve: AppMotion.enter,
                                  duration: AppMotion.spatialFast,
                                ),
                            const SizedBox(height: 8),
                            Text(
                                  l10n.splashSlogan,
                                  style: textTheme.titleMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                )
                                .animate(
                                  delay: const Duration(milliseconds: 300),
                                )
                                .fadeIn(duration: AppMotion.effectsDefault)
                                .slideY(
                                  begin: 0.2,
                                  end: 0,
                                  curve: AppMotion.enter,
                                  duration: AppMotion.spatialFast,
                                ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
