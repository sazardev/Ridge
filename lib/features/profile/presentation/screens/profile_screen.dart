import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/core/widgets/keyboard_scroll_shortcuts.dart';
import 'package:just_in_time/features/profile/presentation/providers/profile_providers.dart';
import 'package:just_in_time/features/profile/presentation/widgets/profile_about_card.dart';
import 'package:just_in_time/features/profile/presentation/widgets/profile_device_card.dart';
import 'package:just_in_time/features/profile/presentation/widgets/profile_stats_card.dart';
import 'package:just_in_time/features/profile/presentation/widgets/rename_profile_sheet.dart';

/// The Profile screen: the Guest Profile's identity (SPEC.md §7.1), a
/// progression-history preview, self-expression flair (favorite
/// language, keyboard, quote, ...), and a "View achievements" action
/// pushing `/achievements` (SPEC.md §12) — the full XP/level/streak
/// picture still lives on the Progress screen, this only previews it.
///
/// Rename/achievements live as icon-only `AppBar` actions (with
/// tooltips) rather than labeled body buttons — standard Material
/// convention for a detail screen's actions, and it means they never
/// overflow on a narrow phone regardless of locale string length, unlike
/// a `Row` of full `OutlinedButton.icon`s would.
class ProfileScreen extends ConsumerStatefulWidget {
  /// Creates the profile screen.
  const new({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profileAsync = ref.watch(activeProfileControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final profile = profileAsync.value;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileTitle),
        actions: profile == null
            ? null
            : [
                IconButton(
                  onPressed: () => showRenameProfileSheet(
                    context,
                    currentUsername: profile.username,
                  ),
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: l10n.profileRenameAction,
                ),
                IconButton(
                  onPressed: () => context.push('/achievements'),
                  icon: const Icon(Icons.emoji_events_outlined),
                  tooltip: l10n.profileAchievementsAction,
                ),
              ],
      ),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return Center(child: Text(l10n.commonLoading));
          }
          return KeyboardScrollShortcuts(
            controller: _scrollController,
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
              children: [
                Center(
                  child: Container(
                    width: 96,
                    height: 96,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [colorScheme.primary, colorScheme.tertiary],
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundColor: colorScheme.surface,
                      child: CircleAvatar(
                        radius: 42,
                        backgroundColor: colorScheme.primaryContainer,
                        child: Text(
                          profile.username.isEmpty
                              ? '?'
                              : profile.username[0].toUpperCase(),
                          style: textTheme.headlineMedium?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  profile.username,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.profileMemberSince(
                    DateFormat.yMMMd().format(profile.createdAt),
                  ),
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                const ProfileStatsCard(),
                const SizedBox(height: 16),
                ProfileAboutCard(
                  profile: profile,
                  onEdit: () => context.push('/profile/edit', extra: profile),
                ),
                const SizedBox(height: 16),
                ProfileDeviceCard(profile: profile),
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
