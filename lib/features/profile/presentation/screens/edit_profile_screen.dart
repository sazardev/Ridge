import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/core/widgets/escape_to_pop.dart';
import 'package:just_in_time/features/profile/domain/entities/favorite_language.dart';
import 'package:just_in_time/features/profile/domain/entities/guest_profile.dart';
import 'package:just_in_time/features/profile/domain/entities/keyboard_layout.dart';
import 'package:just_in_time/features/profile/presentation/profile_labels.dart';
import 'package:just_in_time/features/profile/presentation/profile_suggestions.dart';
import 'package:just_in_time/features/profile/presentation/providers/profile_providers.dart';

/// Full-screen editor for the Guest Profile's self-expression fields
/// (favorite languages, keyboard layout/brand/model, favorite
/// quote/programmer), pushed as `/profile/edit` with the current
/// [GuestProfile] as `extra`.
class EditProfileScreen extends ConsumerStatefulWidget {
  /// Creates the screen pre-filled with [profile]'s current values.
  const new({required this.profile, super.key});

  /// The Guest Profile whose self-expression fields this screen edits.
  final GuestProfile profile;

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final Set<FavoriteLanguage> _languages = {
    ...widget.profile.favoriteLanguages,
  };
  late KeyboardLayout? _layout = widget.profile.keyboardLayout;
  String _brand = '';
  String _model = '';
  String _programmer = '';
  late final TextEditingController _quoteController = TextEditingController(
    text: widget.profile.favoriteQuote ?? '',
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

  @override
  void initState() {
    super.initState();
    _brand = widget.profile.keyboardBrand ?? '';
    _model = widget.profile.keyboardModel ?? '';
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
    _quoteController.dispose();
    _languageSearchController.dispose();
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
        .updateCustomization(
          favoriteLanguages: _languages.toList(),
          keyboardLayout: _layout,
          keyboardBrand: _brand,
          keyboardModel: _model,
          favoriteQuote: _quoteController.text,
          favoriteProgrammer: _programmer,
        );
    if (!mounted) return;
    if (result.isOk) {
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
          title: Text(l10n.profileEditCustomizationTitle),
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
                  : const Icon(Icons.check_rounded),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            if (_errorText != null) ...[
              Text(
                _errorText!,
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
              ),
              const SizedBox(height: 16),
            ],
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
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _languageQuery.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear_rounded),
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
                  if (filteredLanguages.length > _visibleLanguageCount)
                    ActionChip(
                      avatar: const Icon(Icons.expand_more_rounded, size: 18),
                      label: Text(l10n.profileLanguageShowMore),
                      onPressed: () => setState(
                        () => _visibleLanguageCount += _languageBatchSize,
                      ),
                    ),
                ],
              ),
            const SizedBox(height: 28),
            Text(l10n.profileKeyboardLayoutLabel, style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final layout in KeyboardLayout.values)
                  ChoiceChip(
                    label: Text(layout.label(l10n)),
                    selected: _layout == layout,
                    onSelected: (selected) =>
                        setState(() => _layout = selected ? layout : null),
                  ),
              ],
            ),
            const SizedBox(height: 28),
            _SuggestionField(
              label: l10n.profileKeyboardBrandLabel,
              icon: Icons.keyboard_alt_outlined,
              initialValue: _brand,
              suggestions: kKeyboardBrandSuggestions,
              onChanged: (value) => _brand = value,
            ),
            const SizedBox(height: 16),
            _SuggestionField(
              label: l10n.profileKeyboardModelLabel,
              icon: Icons.memory_rounded,
              initialValue: _model,
              suggestions: kKeyboardModelSuggestions,
              onChanged: (value) => _model = value,
            ),
            const SizedBox(height: 16),
            _SuggestionField(
              label: l10n.profileFavoriteProgrammerLabel,
              icon: Icons.person_outline_rounded,
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
                prefixIcon: const Icon(Icons.format_quote_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A text field backed by a curated [suggestions] list — the autocomplete
/// overlay narrows as the user types, but any value (including one not in
/// the list) is still accepted, since these are just a fast-completion
/// aid, not a closed set of valid answers.
class _SuggestionField extends StatelessWidget {
  const new({
    required this.label,
    required this.icon,
    required this.initialValue,
    required this.suggestions,
    required this.onChanged,
  });

  final String label;
  final IconData icon;
  final String initialValue;
  final List<String> suggestions;
  final ValueChanged<String> onChanged;

  /// The most matches shown at once — plenty to scroll through, but a
  /// hard ceiling so a broad query (e.g. a single common letter) against
  /// a long suggestion list never has to lay out hundreds of rows just to
  /// render the first few.
  static const _maxOptions = 30;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      initialValue: TextEditingValue(text: initialValue),
      optionsBuilder: (value) {
        if (value.text.isEmpty) return const Iterable<String>.empty();
        final query = value.text.toLowerCase();
        // Single pass: prefix matches ("Key" -> "Keychron...") are the
        // most relevant, so they're returned ahead of mid-string ones.
        final startsWith = <String>[];
        final contains = <String>[];
        for (final suggestion in suggestions) {
          final lower = suggestion.toLowerCase();
          if (lower.startsWith(query)) {
            startsWith.add(suggestion);
          } else if (lower.contains(query)) {
            contains.add(suggestion);
          }
        }
        return startsWith.followedBy(contains).take(_maxOptions);
      },
      onSelected: onChanged,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          textInputAction: TextInputAction.next,
          onChanged: onChanged,
          decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
        );
      },
    );
  }
}
