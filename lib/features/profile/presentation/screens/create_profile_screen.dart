import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/core/theme/app_motion.dart';
import 'package:just_in_time/core/window/window_bar.dart';
import 'package:just_in_time/features/profile/domain/entities/favorite_language.dart';
import 'package:just_in_time/features/profile/presentation/profile_labels.dart';
import 'package:just_in_time/features/profile/presentation/providers/profile_providers.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// First-run screen: choose a username and create the on-device Guest
/// Profile (SPEC.md §7.1), plus an optional quick pick of favorite
/// languages — a `GuestProfile` self-expression field (see
/// `EditProfileScreen`, reachable later for the rest of that form), so it
/// belongs here rather than in `OnboardingScreen`, which only ever touches
/// app-wide `AppSettings`. Sits outside the shell, same shape as
/// `LockScreen` — there is no identity yet, so there is nothing else to
/// navigate to.
class CreateProfileScreen extends ConsumerStatefulWidget {
  /// Creates the create-profile screen.
  const new({super.key});

  @override
  ConsumerState<CreateProfileScreen> createState() =>
      _CreateProfileScreenState();
}

class _CreateProfileScreenState extends ConsumerState<CreateProfileScreen> {
  /// Shown as quick-pick chips — the first dozen `FavoriteLanguage` values,
  /// which are already declared in roughly descending real-world
  /// popularity (see the enum's own doc comments). The rest stay reachable
  /// later via `EditProfileScreen`'s full, searchable list — no need to
  /// duplicate that here for a one-time, optional pick.
  static const _quickPickLanguages = 12;

  final _controller = TextEditingController();
  final _languages = <FavoriteLanguage>{};
  bool _submitting = false;
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _submitting = true;
      _errorText = null;
    });
    final result = await ref
        .read(activeProfileControllerProvider.notifier)
        .create(_controller.text);
    if (!mounted) return;
    if (result.isOk) {
      if (_languages.isNotEmpty) {
        await ref
            .read(activeProfileControllerProvider.notifier)
            .updateCustomization(favoriteLanguages: _languages.toList());
        if (!mounted) return;
      }
      context.go('/practice');
      return;
    }
    setState(() {
      _submitting = false;
      _errorText = l10n.profileUsernameInvalid;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Column(
        children: [
          const WindowBar(),
          Expanded(
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 360),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.user,
                          size: 40,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          l10n.profileCreateTitle,
                          style: textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.profileCreateSubtitle,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        TextField(
                          controller: _controller,
                          autofocus: true,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: l10n.profileUsernameLabel,
                            errorText: _errorText,
                          ),
                          onSubmitted: _submitting ? null : (_) => _submit(),
                        ),
                        const SizedBox(height: 28),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            l10n.profileFavoriteLanguageLabel,
                            style: textTheme.labelLarge,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final language in FavoriteLanguage.values.take(
                              _quickPickLanguages,
                            ))
                              FilterChip(
                                label: Text(language.label(l10n)),
                                selected: _languages.contains(language),
                                onSelected: (selected) => setState(() {
                                  if (selected) {
                                    _languages.add(language);
                                  } else {
                                    _languages.remove(language);
                                  }
                                }),
                              ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: _submitting ? null : _submit,
                            child: AnimatedSwitcher(
                              duration: AppMotion.effectsDefault,
                              child: _submitting
                                  ? const SizedBox(
                                      key: ValueKey('loading'),
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      l10n.profileCreateStart,
                                      key: const ValueKey('label'),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
