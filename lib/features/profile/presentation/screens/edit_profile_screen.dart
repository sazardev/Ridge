import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/core/widgets/app_filter_chip.dart';
import 'package:ridge/core/widgets/bouncy_tap.dart';
import 'package:ridge/core/widgets/escape_to_pop.dart';
import 'package:ridge/core/widgets/keyboard_scroll_shortcuts.dart';
import 'package:ridge/core/widgets/staggered_entrance.dart';
import 'package:ridge/features/profile/domain/entities/favorite_language.dart';
import 'package:ridge/features/profile/domain/entities/guest_profile.dart';
import 'package:ridge/features/profile/presentation/profile_labels.dart';
import 'package:ridge/features/profile/presentation/profile_suggestions.dart';
import 'package:ridge/features/profile/presentation/providers/profile_providers.dart';
import 'package:ridge/features/profile/presentation/widgets/suggestion_field.dart';

/// Full-screen editor for the Guest Profile — username plus the
/// profile-flair fields (favorite languages, favorite quote/programmer,
/// links) in one place, pushed as `/profile/edit` with the current
/// [GuestProfile] as `extra`.
///
/// The keyboard (layout, brand/model and the advanced customization) has
/// its own dedicated editor at `/profile/keyboard/customize`, reachable
/// from the keyboard card below; the two forms write disjoint columns so
/// neither can clobber the other.
class EditProfileScreen extends ConsumerStatefulWidget {
  /// Creates the screen pre-filled with [profile]'s current values.
  const new({required this.profile, super.key});

  /// The Guest Profile whose self-expression fields this screen edits.
  final GuestProfile profile;

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _usernameController = TextEditingController(
    text: widget.profile.username,
  );
  late final Set<FavoriteLanguage> _languages = {
    ...widget.profile.favoriteLanguages,
  };
  String _programmer = '';
  late final TextEditingController _quoteController = TextEditingController(
    text: widget.profile.favoriteQuote ?? '',
  );
  late final TextEditingController _githubController = TextEditingController(
    text: widget.profile.githubUsername ?? '',
  );
  late final TextEditingController _websiteController = TextEditingController(
    text: widget.profile.websiteUrl ?? '',
  );
  final TextEditingController _languageSearchController =
      TextEditingController();
  String _languageQuery = '';

  /// How many of the (filtered, alphabetized) languages are shown —
  /// starts at one batch and grows by [_languageBatchSize] each time
  /// "More…" is tapped, so a long list never dumps everything on screen
  /// at once.
  int _visibleLanguageCount = _languageBatchSize;
  static const _languageBatchSize = 5;

  bool _submitting = false;
  String? _errorText;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _programmer = widget.profile.favoriteProgrammer ?? '';
    _languageSearchController.addListener(() {
      setState(() {
        _languageQuery = _languageSearchController.text.trim().toLowerCase();
        // A new search is a new result set — start it back at one batch
        // rather than carrying over however far a previous search was
        // expanded.
        _visibleLanguageCount = _languageBatchSize;
      });
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _quoteController.dispose();
    _githubController.dispose();
    _websiteController.dispose();
    _languageSearchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _submitting = true;
      _errorText = null;
    });
    final notifier = ref.read(activeProfileControllerProvider.notifier);

    final renameResult = await notifier.rename(_usernameController.text);
    if (!mounted) return;
    if (renameResult.isErr) {
      setState(() {
        _submitting = false;
        _errorText = l10n.profileUsernameInvalid;
      });
      return;
    }

    final customizationResult = await notifier.updateCustomization(
      favoriteLanguages: _languages.toList(),
      favoriteQuote: _quoteController.text,
      favoriteProgrammer: _programmer,
      githubUsername: _githubController.text,
      websiteUrl: _websiteController.text,
    );
    if (!mounted) return;
    if (customizationResult.isOk) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _submitting = false;
      _errorText = l10n.profileCustomizationInvalid;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final filteredLanguages =
        FavoriteLanguage.values
            .where((l) => l.label(l10n).toLowerCase().contains(_languageQuery))
            .toList()
          ..sort((a, b) => a.label(l10n).compareTo(b.label(l10n)));

    return EscapeToPop(
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.profileEditProfileTitle),
          actions: [
            IconButton(
              onPressed: _submitting ? null : _submit,
              tooltip: l10n.profileSave,
              icon: _submitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(LucideIcons.check300),
            ),
          ],
        ),
        body: KeyboardScrollShortcuts(
          controller: _scrollController,
          child: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              if (_errorText != null) ...[
                Text(
                  _errorText!,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              TextField(
                controller: _usernameController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: l10n.profileUsernameLabel,
                  prefixIcon: const Icon(LucideIcons.userRound300),
                ),
              ).staggeredIn(context, 0),
              const SizedBox(height: 28),
              Text(
                l10n.profileFavoriteLanguageLabel,
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _languageSearchController,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: l10n.profileSearchLanguageHint,
                  prefixIcon: const Icon(LucideIcons.search300),
                  suffixIcon: _languageQuery.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(LucideIcons.x300),
                          onPressed: _languageSearchController.clear,
                        ),
                ),
              ),
              const SizedBox(height: 12),
              if (filteredLanguages.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    l10n.profileSearchNoResults,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final language in filteredLanguages.take(
                      _visibleLanguageCount,
                    ))
                      AppFilterChip(
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
                    if (filteredLanguages.length > _visibleLanguageCount)
                      ActionChip(
                        avatar: const Icon(
                          LucideIcons.chevronDown300,
                          size: 18,
                        ),
                        label: Text(l10n.profileLanguageShowMore),
                        onPressed: () => setState(
                          () => _visibleLanguageCount += _languageBatchSize,
                        ),
                      ),
                  ],
                ),
              const SizedBox(height: 28),
              _KeyboardCard(profile: widget.profile).staggeredIn(context, 2),
              const SizedBox(height: 28),
              SuggestionField(
                label: l10n.profileFavoriteProgrammerLabel,
                icon: LucideIcons.user300,
                initialValue: _programmer,
                suggestions: kFavoriteProgrammerSuggestions,
                onChanged: (value) => _programmer = value,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _quoteController,
                maxLines: 3,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: l10n.profileFavoriteQuoteLabel,
                  alignLabelWithHint: true,
                  prefixIcon: const Icon(LucideIcons.quote300),
                ),
              ),
              const SizedBox(height: 28),
              Text(l10n.profileLinksTitle, style: textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _githubController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: l10n.profileGithubLabel,
                  hintText: l10n.profileGithubHint,
                  prefixIcon: const Icon(LucideIcons.gitBranch300),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _websiteController,
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: l10n.profileWebsiteLabel,
                  hintText: l10n.profileWebsiteHint,
                  prefixIcon: const Icon(LucideIcons.globe300),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A read-only summary of the profile's keyboard setup that links to the
/// dedicated editor at `/profile/keyboard/customize`. The keyboard earns
/// its own screen — a big live 3D preview plus many controls — so this
/// form only shows what's currently set and hands off; both forms write
/// disjoint columns of the same profile row.
class _KeyboardCard extends StatelessWidget {
  const new({required this.profile});

  final GuestProfile profile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final shapes = AppShapes.of(context);
    final brand = profile.keyboardBrand;
    final model = profile.keyboardModel;
    final hasModel = model != null && model.isNotEmpty;
    final layout = profile.keyboardLayout;
    final customization = profile.keyboardCustomization;

    final title = hasModel
        ? [if (brand != null && brand.isNotEmpty) brand, model].join(' ')
        : l10n.profileKeyboardNotSet;
    final details = <String>[
      if (layout != null) layout.label(l10n),
      if (customization != null) customization.keycapShape.label(l10n),
      if (customization?.rgbEnabled ?? false)
        l10n.profileKeyboardRgbEnabledLabel,
    ];

    return BouncyTap(
      enabled: true,
      child: Card(
        shape: shapes.largeShape,
        child: InkWell(
          onTap: () =>
              context.push('/profile/keyboard/customize', extra: profile),
          customBorder: shapes.largeShape,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(LucideIcons.keyboard300, color: colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.profileKeyboardSectionTitle,
                        style: textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium,
                      ),
                      if (details.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          details.join(' · '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  LucideIcons.chevronRight300,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
