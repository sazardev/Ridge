import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/core/window/window_bar.dart';

/// Adaptive navigation frame: a rail on wide (Linux desktop) windows, a
/// bottom bar on narrow (Android phone) ones — same destinations
/// either way, driven by the same [StatefulNavigationShell].
class AppShell extends StatelessWidget {
  /// Creates the shell around the given [navigationShell] branches.
  const new({required this.navigationShell, super.key});

  /// The persistent, stateful navigation branches this shell wraps.
  final StatefulNavigationShell navigationShell;

  static const _wideBreakpoint = 640.0;

  /// Below this width the bottom bar's 5 destinations don't have room for
  /// both an icon and a label each — drop the labels and go icon-only
  /// rather than let Material's `NavigationBar` wrap/clip them. Matches
  /// Android's `sw360dp` "small phone" breakpoint.
  static const _compactBreakpoint = 360.0;

  void _onSelect(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Order matches `app_router.dart`'s `StatefulShellRoute` branches
    // exactly — this list is indexed positionally by
    // [StatefulNavigationShell.currentIndex].
    final destinations = [
      (
        icon: Icons.school_outlined,
        selectedIcon: Icons.school_rounded,
        label: l10n.navPractice,
      ),
      (
        icon: Icons.insights_outlined,
        selectedIcon: Icons.insights_rounded,
        label: l10n.navProgress,
      ),
      (
        icon: Icons.keyboard_outlined,
        selectedIcon: Icons.keyboard_rounded,
        label: l10n.navFreePractice,
      ),
      (
        icon: Icons.person_outline_rounded,
        selectedIcon: Icons.person_rounded,
        label: l10n.navProfile,
      ),
      (
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings_rounded,
        label: l10n.navSettings,
      ),
    ];

    return Column(
      children: [
        const WindowBar(),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= _wideBreakpoint) {
                return Scaffold(
                  body: Row(
                    children: [
                      NavigationRail(
                        selectedIndex: navigationShell.currentIndex,
                        onDestinationSelected: _onSelect,
                        labelType: NavigationRailLabelType.all,
                        destinations: [
                          for (final d in destinations)
                            NavigationRailDestination(
                              icon: Icon(d.icon),
                              selectedIcon: Icon(d.selectedIcon),
                              label: Text(d.label),
                            ),
                        ],
                      ),
                      const VerticalDivider(width: 1),
                      Expanded(child: navigationShell),
                    ],
                  ),
                );
              }

              return Scaffold(
                body: navigationShell,
                bottomNavigationBar: NavigationBar(
                  selectedIndex: navigationShell.currentIndex,
                  onDestinationSelected: _onSelect,
                  labelBehavior: constraints.maxWidth < _compactBreakpoint
                      ? NavigationDestinationLabelBehavior.alwaysHide
                      : NavigationDestinationLabelBehavior.alwaysShow,
                  destinations: [
                    for (final d in destinations)
                      NavigationDestination(
                        icon: Icon(d.icon),
                        selectedIcon: Icon(d.selectedIcon),
                        label: d.label,
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
