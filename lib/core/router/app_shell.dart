import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/widgets/app_navigation_shortcuts.dart';
import 'package:ridge/core/window/window_bar.dart';
import 'package:ridge/features/settings/domain/entities/app_settings.dart';
import 'package:ridge/features/settings/presentation/providers/settings_providers.dart';

/// Adaptive navigation frame: a rail on wide (Linux desktop) windows, a
/// bottom bar on narrow (Android phone) ones — same destinations
/// either way, driven by the same [StatefulNavigationShell].
class AppShell extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings =
        ref.watch(settingsControllerProvider).value ?? AppSettings.initial;
    final shortcutBindings = settings.shortcutBindings;
    final railExpanded = settings.navigationRailExpanded;
    // Order matches `app_router.dart`'s `StatefulShellRoute` branches
    // exactly — this list is indexed positionally by
    // [StatefulNavigationShell.currentIndex].
    final destinations = [
      (
        icon: LucideIcons.keyboard300,
        selectedIcon: LucideIcons.keyboard600,
        label: l10n.navPractice,
      ),
      (
        icon: LucideIcons.chartLine300,
        selectedIcon: LucideIcons.chartLine600,
        label: l10n.navProgress,
      ),
      (
        icon: LucideIcons.zap300,
        selectedIcon: LucideIcons.zap600,
        label: l10n.navFreePractice,
      ),
      (
        icon: LucideIcons.user300,
        selectedIcon: LucideIcons.user600,
        label: l10n.navProfile,
      ),
      (
        icon: LucideIcons.settings300,
        selectedIcon: LucideIcons.settings600,
        label: l10n.navSettings,
      ),
    ];

    return AppNavigationShortcuts(
      currentIndex: navigationShell.currentIndex,
      branchCount: destinations.length,
      bindings: shortcutBindings,
      onSelectBranch: _onSelect,
      child: Column(
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
                          labelType: railExpanded
                              ? NavigationRailLabelType.all
                              : NavigationRailLabelType.none,
                          minWidth: railExpanded ? 80 : 64,
                          destinations: [
                            for (final d in destinations)
                              NavigationRailDestination(
                                icon: IconTheme.merge(
                                  data: IconThemeData(
                                    size: railExpanded ? 24 : 20,
                                  ),
                                  child: Icon(d.icon),
                                ),
                                selectedIcon: IconTheme.merge(
                                  data: IconThemeData(
                                    size: railExpanded ? 24 : 20,
                                  ),
                                  child: Icon(d.selectedIcon),
                                ),
                                label: Text(d.label),
                              ),
                          ],
                          trailing: Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: IconButton(
                                  icon: Icon(
                                    railExpanded
                                        ? LucideIcons.panelLeftClose300
                                        : LucideIcons.panelLeftOpen300,
                                  ),
                                  tooltip: railExpanded
                                      ? l10n.navRailCollapse
                                      : l10n.navRailExpand,
                                  onPressed: () => ref
                                      .read(settingsControllerProvider.notifier)
                                      .setNavigationRailExpanded(
                                        value: !railExpanded,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
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
      ),
    );
  }
}
