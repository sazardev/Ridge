import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/core/theme/app_motion.dart';
import 'package:just_in_time/core/window/window_bar.dart';
import 'package:just_in_time/features/onboarding/presentation/widgets/onboarding_appearance_page.dart';
import 'package:just_in_time/features/onboarding/presentation/widgets/onboarding_device_info_page.dart';
import 'package:just_in_time/features/onboarding/presentation/widgets/onboarding_page.dart';
import 'package:just_in_time/features/onboarding/presentation/widgets/onboarding_page_dots.dart';
import 'package:just_in_time/features/settings/presentation/providers/settings_providers.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// First-run, full-screen introduction shown exactly once — before the
/// Guest Profile even exists (see `app_router.dart`'s redirect) — walking
/// through the product's core value in a handful of swipeable steps.
/// "Skip" and the last step's CTA both just flip the persisted
/// `onboardingCompleted` flag; the router's own redirect (already
/// listening to `settingsControllerProvider`) takes it from there,
/// exactly like `LockScreen` never navigates to `/practice` itself either.
class OnboardingScreen extends ConsumerStatefulWidget {
  /// Creates the onboarding screen.
  const new({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// The onboarding carousel — mostly static value-prop pages, plus one
  /// live, interactive step ([OnboardingAppearancePage]) for the
  /// app-wide look-and-feel settings, since those are `AppSettings`
  /// fields, not profile data — nothing here needs its own persistence
  /// path beyond what `settingsControllerProvider` already offers. The
  /// device-info step is live too, but read-only: no Guest Profile
  /// exists yet to persist it onto (see `OnboardingDeviceInfoPage`).
  List<Widget> _pages(AppLocalizations l10n) => [
    OnboardingPage(
      data: OnboardingPageData(
        icon: LucideIcons.terminal,
        title: l10n.onboardingWelcomeTitle,
        description: l10n.onboardingWelcomeDescription,
      ),
    ),
    OnboardingPage(
      data: OnboardingPageData(
        icon: LucideIcons.chartLine,
        title: l10n.onboardingMetricsTitle,
        description: l10n.onboardingMetricsDescription,
      ),
    ),
    OnboardingPage(
      data: OnboardingPageData(
        icon: LucideIcons.route,
        title: l10n.onboardingPathsTitle,
        description: l10n.onboardingPathsDescription,
      ),
    ),
    const OnboardingAppearancePage(),
    const OnboardingDeviceInfoPage(),
    OnboardingPage(
      data: OnboardingPageData(
        icon: LucideIcons.rocket,
        title: l10n.onboardingReadyTitle,
        description: l10n.onboardingReadyDescription,
      ),
    ),
  ];

  Future<void> _complete() {
    return ref
        .read(settingsControllerProvider.notifier)
        .setOnboardingCompleted(value: true);
  }

  void _onNext(int pageCount) {
    if (_page == pageCount - 1) {
      unawaited(_complete());
      return;
    }
    _pageController.nextPage(
      duration: AppMotion.spatialDefault,
      curve: AppMotion.spatial,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = _pages(l10n);
    final isLastPage = _page == pages.length - 1;

    return Scaffold(
      body: Column(
        children: [
          const WindowBar(),
          Expanded(
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 48,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: AnimatedOpacity(
                        duration: AppMotion.effectsDefault,
                        opacity: isLastPage ? 0 : 1,
                        child: IgnorePointer(
                          ignoring: isLastPage,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: TextButton(
                              onPressed: _complete,
                              child: Text(l10n.onboardingSkip),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: pages.length,
                      onPageChanged: (index) => setState(() => _page = index),
                      itemBuilder: (context, index) => pages[index],
                    ),
                  ),
                  const SizedBox(height: 24),
                  OnboardingPageDots(length: pages.length, activeIndex: _page),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => _onNext(pages.length),
                        child: AnimatedSwitcher(
                          duration: AppMotion.effectsDefault,
                          child: Text(
                            isLastPage
                                ? l10n.onboardingGetStarted
                                : l10n.onboardingNext,
                            key: ValueKey(isLastPage),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
