import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/widgets/keyboard_scroll_shortcuts.dart';
import 'package:ridge/core/widgets/staggered_entrance.dart';
import 'package:ridge/features/profile/presentation/providers/profile_providers.dart';
import 'package:ridge/features/profile/presentation/widgets/profile_about_card.dart';
import 'package:ridge/features/profile/presentation/widgets/profile_achievements_card.dart';
import 'package:ridge/features/profile/presentation/widgets/profile_avatar.dart';
import 'package:ridge/features/profile/presentation/widgets/profile_device_card.dart';
import 'package:ridge/features/profile/presentation/widgets/profile_keyboard_hero_card.dart';
import 'package:ridge/features/profile/presentation/widgets/profile_links_card.dart';
import 'package:ridge/features/profile/presentation/widgets/profile_stats_card.dart';

/// The Profile screen: the Guest Profile's identity (SPEC.md §7.1), a
/// progression-history preview, an achievements preview linking to
/// `/achievements` (SPEC.md §12), and self-expression flair (favorite
/// language, keyboard, quote, ...) — the full XP/level/streak picture
/// still lives on the Progress screen, this only previews it.
///
/// No `AppBar`: editing lives as a pencil `IconButton` right next to the
/// username instead, pushing `/profile/edit` for the whole `GuestProfile`
/// form (username included) in one place, rather than splitting rename
/// into a separate action.
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

    // No `AppBar`: the nav rail/bar destination already reads "Profile"
    // right next to this screen, so a title would just be noise
    // (`SafeArea` stands in for the status-bar inset an `AppBar` would
    // otherwise have handled).
    return Scaffold(
      body: SafeArea(
        child: profileAsync.when(
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
                  ProfileAvatar(
                    username: profile.username,
                    githubUsername: profile.githubUsername,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          profile.username,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.headlineSmall,
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            context.push('/profile/edit', extra: profile),
                        icon: const Icon(LucideIcons.squarePen300),
                        tooltip: l10n.profileEditProfileAction,
                      ),
                    ],
                  ),
                  Text(
                    l10n.profileMemberSince(
                      DateFormat.yMMMd().format(profile.createdAt),
                    ),
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (profile.keyboardModel?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 20),
                    ProfileKeyboardHeroCard(profile: profile)
                        .staggeredIn(context, 0),
                  ],
                  const SizedBox(height: 24),
                  const ProfileStatsCard().staggeredIn(context, 1),
                  const SizedBox(height: 16),
                  const ProfileAchievementsCard().staggeredIn(context, 2),
                  const SizedBox(height: 16),
                  ProfileAboutCard(
                    profile: profile,
                    onEdit: () => context.push('/profile/edit', extra: profile),
                  ).staggeredIn(context, 3),
                  if (profile.githubUsername != null ||
                      profile.websiteUrl != null) ...[
                    const SizedBox(height: 16),
                    ProfileLinksCard(profile: profile).staggeredIn(context, 4),
                  ],
                  const SizedBox(height: 16),
                  ProfileDeviceCard(profile: profile).staggeredIn(context, 5),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text(l10n.commonSomethingWrong)),
        ),
      ),
    );
  }
}
