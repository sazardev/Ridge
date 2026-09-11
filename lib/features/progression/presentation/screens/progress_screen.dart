import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/widgets/keyboard_scroll_shortcuts.dart';
import 'package:ridge/features/content/presentation/content_labels.dart';
import 'package:ridge/features/progression/domain/entities/progress_snapshot.dart';
import 'package:ridge/features/progression/presentation/providers/progression_providers.dart';
import 'package:ridge/features/progression/presentation/widgets/activity_report_card.dart';
import 'package:ridge/features/progression/presentation/widgets/keyboard_heatmap.dart';
import 'package:ridge/features/progression/presentation/widgets/personal_history_chart.dart';
import 'package:ridge/features/progression/presentation/widgets/weakness_report_card.dart';
import 'package:ridge/features/progression/presentation/widgets/xp_level_bar.dart';
import 'package:ridge/features/settings/domain/entities/app_settings.dart';
import 'package:ridge/features/settings/domain/entities/app_shortcut_action.dart';
import 'package:ridge/features/settings/presentation/providers/settings_providers.dart';
import 'package:ridge/features/settings/presentation/shortcut_activator.dart';

/// The Progress screen (SPEC.md §4.3/§6): XP/level, streak, weakness
/// diagnostic, activity report, per-category mastery, and a
/// personal-history comparison for recently-practiced content — split
/// across four tabs (Overview/Weaknesses/Activity/History) rather than
/// one long scroll, since the full detail across every metric is too
/// much to take in on a single screen at once.
class ProgressScreen extends ConsumerStatefulWidget {
  /// Creates the progress screen.
  const new({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 4, vsync: this);
  final _overviewScrollController = ScrollController();
  final _weaknessesScrollController = ScrollController();
  final _activityScrollController = ScrollController();
  final _historyScrollController = ScrollController();

  @override
  void dispose() {
    _tabController.dispose();
    _overviewScrollController.dispose();
    _weaknessesScrollController.dispose();
    _activityScrollController.dispose();
    _historyScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final snapshotAsync = ref.watch(progressSnapshotControllerProvider);
    final shortcutBindings =
        ref.watch(settingsControllerProvider).value?.shortcutBindings ??
        AppSettings.initial.shortcutBindings;

    return Scaffold(
      // No title here: the nav rail/bar destination already reads
      // "Progress" right next to this screen, so repeating it would just
      // be noise — the `AppBar` sticks around only to host the tab bar
      // below. `toolbarHeight: 0` collapses the now-empty title row so the
      // tab bar sits flush at the top instead of leaving a blank gap where
      // the title used to be.
      appBar: AppBar(
        toolbarHeight: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.progressTabOverview),
            Tab(text: l10n.progressTabWeaknesses),
            Tab(text: l10n.progressTabActivity),
            Tab(text: l10n.progressTabHistory),
          ],
        ),
      ),
      body: snapshotAsync.when(
        data: (snapshot) {
          if (snapshot == null) {
            return Center(child: Text(l10n.progressEmptyState));
          }
          // Cycle tabs — distinct from the bare PageUp/PageDown each
          // tab's own `KeyboardScrollShortcuts` already binds to
          // scrolling that tab's own list.
          final tabShortcuts = <ShortcutActivator, VoidCallback>{};
          final nextTab = shortcutBindings[AppShortcutAction.cycleNextTab];
          if (nextTab != null) {
            tabShortcuts[nextTab.toActivator()] = () => _tabController
                .animateTo((_tabController.index + 1) % _tabController.length);
          }
          final previousTab =
              shortcutBindings[AppShortcutAction.cyclePreviousTab];
          if (previousTab != null) {
            tabShortcuts[previousTab.toActivator()] = () =>
                _tabController.animateTo(
                  (_tabController.index - 1 + _tabController.length) %
                      _tabController.length,
                );
          }
          return CallbackShortcuts(
            bindings: tabShortcuts,
            child: TabBarView(
              controller: _tabController,
              children: [
                _OverviewTab(
                  scrollController: _overviewScrollController,
                  snapshot: snapshot,
                ),
                _WeaknessesTab(
                  scrollController: _weaknessesScrollController,
                  snapshot: snapshot,
                ),
                _ActivityTab(
                  scrollController: _activityScrollController,
                  snapshot: snapshot,
                ),
                _HistoryTab(
                  scrollController: _historyScrollController,
                  snapshot: snapshot,
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text(l10n.commonSomethingWrong)),
      ),
    );
  }
}

/// XP/level, streak, and per-category mastery — the "how am I doing
/// overall" tab.
class _OverviewTab extends StatelessWidget {
  const new({required this.scrollController, required this.snapshot});

  final ScrollController scrollController;
  final ProgressSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return KeyboardScrollShortcuts(
      controller: scrollController,
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
        children: [
          XpLevelBar(xpSummary: snapshot.xpSummary),
          const SizedBox(height: 8),
          Text(
            l10n.progressStreakLabel(snapshot.currentStreakDays),
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          Text(l10n.progressMasteryTitle, style: textTheme.titleMedium),
          const SizedBox(height: 12),
          if (snapshot.masteryStatuses.isEmpty)
            Text(l10n.progressMasteryEmpty, style: textTheme.bodyMedium)
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final status in snapshot.masteryStatuses)
                  Tooltip(
                    message: status.isMastered
                        ? l10n.progressMasteryCertified
                        : l10n.progressMasteryNotYet,
                    child: Chip(
                      avatar: Icon(
                        status.isMastered
                            ? LucideIcons.badgeCheck600
                            : LucideIcons.circle300,
                        size: 18,
                      ),
                      label: Text(
                        '${status.category.label(l10n)} · '
                        '${status.difficulty.label(l10n)}',
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

/// Character/finger/n-gram/key-transition weakness rankings plus the
/// keyboard heatmap — the "what's holding me back" tab.
class _WeaknessesTab extends StatelessWidget {
  const new({required this.scrollController, required this.snapshot});

  final ScrollController scrollController;
  final ProgressSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return KeyboardScrollShortcuts(
      controller: scrollController,
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
        children: [
          WeaknessReportCard(report: snapshot.weaknessReport),
          const SizedBox(height: 24),
          Text(l10n.progressHeatmapTitle, style: textTheme.titleMedium),
          const SizedBox(height: 12),
          KeyboardHeatmap(
            weakCharacters: snapshot.weaknessReport.weakCharacters,
          ),
        ],
      ),
    );
  }
}

/// Most-practiced/lowest-scoring categories and exercises — the "where
/// am I spending my time" tab.
class _ActivityTab extends StatelessWidget {
  const new({required this.scrollController, required this.snapshot});

  final ScrollController scrollController;
  final ProgressSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return KeyboardScrollShortcuts(
      controller: scrollController,
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
        children: [ActivityReportCard(report: snapshot.activityReport)],
      ),
    );
  }
}

/// The rolling personal-history comparison for the top mastery category
/// — the "am I getting better" tab.
class _HistoryTab extends StatelessWidget {
  const new({required this.scrollController, required this.snapshot});

  final ScrollController scrollController;
  final ProgressSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return KeyboardScrollShortcuts(
      controller: scrollController,
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
        children: [
          if (snapshot.masteryStatuses.isEmpty)
            Text(l10n.progressHistoryEmpty, style: textTheme.bodyMedium)
          else
            Consumer(
              builder: (context, ref, _) {
                final comparisonAsync = ref.watch(
                  personalHistoryForCategoryProvider(
                    snapshot.masteryStatuses.first.category,
                  ),
                );
                return comparisonAsync.when(
                  data: (comparison) =>
                      PersonalHistoryChart(comparison: comparison),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => Text(l10n.commonSomethingWrong),
                );
              },
            ),
          const SizedBox(height: 24),
          // The raw-JSON debug view's entry point (SPEC.md §15: the user
          // can consult/export their own progress report at any time) —
          // lives here rather than up in the app bar next to the tabs,
          // since this tab is already "your history/data", the most
          // natural home for it.
          OutlinedButton.icon(
            onPressed: () => context.push('/progress/stats-json'),
            icon: const Icon(LucideIcons.braces300),
            label: Text(l10n.progressJsonEntryButton),
          ),
        ],
      ),
    );
  }
}
