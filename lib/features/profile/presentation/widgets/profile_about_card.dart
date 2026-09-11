import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/features/profile/domain/entities/guest_profile.dart';
import 'package:ridge/features/profile/presentation/profile_labels.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_visual.dart';

/// A card of the active profile's self-expression flair — favorite
/// language, keyboard layout/brand, and favorite quote/programmer — with
/// an empty-state prompt when none of it has been set yet.
class ProfileAboutCard extends StatelessWidget {
  /// Creates the card for [profile], calling [onEdit] when the user wants
  /// to add or change any of this flair.
  const new({required this.profile, required this.onEdit, super.key});

  /// The profile whose self-expression fields this card renders.
  final GuestProfile profile;

  /// Called when the edit/customize action is tapped.
  final VoidCallback onEdit;

  bool get _hasAnything =>
      profile.favoriteLanguages.isNotEmpty ||
      profile.keyboardLayout != null ||
      (profile.keyboardBrand?.isNotEmpty ?? false) ||
      (profile.keyboardModel?.isNotEmpty ?? false) ||
      (profile.favoriteQuote?.isNotEmpty ?? false) ||
      (profile.favoriteProgrammer?.isNotEmpty ?? false);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      shape: AppShapes.of(context).largeShape,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.profileAboutTitle,
                    style: textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(LucideIcons.squarePen300),
                  tooltip: l10n.profileEditCustomizationAction,
                ),
              ],
            ),
            if (!_hasAnything) ...[
              const SizedBox(height: 4),
              Text(
                l10n.profileAboutEmptyState,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: onEdit,
                icon: const Icon(LucideIcons.sparkles300),
                label: Text(l10n.profileEditCustomizationAction),
              ),
            ] else ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final language in profile.favoriteLanguages)
                    Chip(
                      avatar: const Icon(LucideIcons.code300, size: 18),
                      label: Text(language.label(l10n)),
                    ),
                  if (profile.keyboardLayout != null)
                    Chip(
                      avatar: const Icon(LucideIcons.keyboard300, size: 18),
                      label: Text(profile.keyboardLayout!.label(l10n)),
                    ),
                  if (profile.keyboardBrand?.isNotEmpty ?? false)
                    Chip(
                      avatar: const Icon(LucideIcons.memoryStick300, size: 18),
                      label: _ChipLabel(profile.keyboardBrand!),
                    ),
                  if (profile.keyboardModel?.isNotEmpty ?? false)
                    Chip(
                      avatar: const Icon(LucideIcons.circuitBoard300, size: 18),
                      label: _ChipLabel(profile.keyboardModel!),
                    ),
                  if (profile.favoriteProgrammer?.isNotEmpty ?? false)
                    Chip(
                      avatar: const Icon(LucideIcons.user300, size: 18),
                      label: _ChipLabel(profile.favoriteProgrammer!),
                    ),
                ],
              ),
              if (profile.keyboardModel?.isNotEmpty ?? false) ...[
                const SizedBox(height: 16),
                KeyboardVisual(model: profile.keyboardModel),
              ],
              if (profile.favoriteQuote?.isNotEmpty ?? false) ...[
                const SizedBox(height: 16),
                DecoratedBox(
                  decoration: ShapeDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    shape: AppShapes.of(context).mediumShape,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(LucideIcons.quote300, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            profile.favoriteQuote!,
                            style: textTheme.bodyMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

/// A [Chip] label capped to a sane width — the free-text fields these
/// chips render (keyboard brand/model, favorite programmer) allow up to
/// 60 characters, wide enough to overflow a narrow phone on its own.
class _ChipLabel extends StatelessWidget {
  const new(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 160),
      child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}
