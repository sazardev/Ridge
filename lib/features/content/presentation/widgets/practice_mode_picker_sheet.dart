import 'package:flutter/material.dart';

import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/core/theme/app_shapes.dart';

/// Plain string identifiers for the practice-mode choices offered by
/// [showPracticeModePickerSheet] — deliberately *not* `practice`'s own
/// `PracticeMode` type, so `content`'s presentation layer never has to
/// depend on `practice` (the project plan's feature dependency order has
/// `practice` depend on `content`, never the reverse). Whatever pushes
/// `/practice/session` after this sheet returns is the one place already
/// wired to both features, and turns this back into a real `PracticeMode`.
///
/// Shared by the catalog browser (`SnippetListTile`) and the Practice
/// hub's recommended-snippet card — the one picker sheet, reused rather
/// than duplicated.
const practiceModeKindZen = 'zen';

/// A 30-second Sprint (SPEC.md §5.2).
const practiceModeKindSprint30 = 'sprint30';

/// A 60-second Sprint (SPEC.md §5.2).
const practiceModeKindSprint60 = 'sprint60';

/// A 120-second Sprint (SPEC.md §5.2).
const practiceModeKindSprint120 = 'sprint120';

/// A Precision test at the fixed default threshold (SPEC.md §5.3).
const practiceModeKindPrecision = 'precision';

/// A Survival arcade run with lives and a combo multiplier (SPEC.md §5.8).
const practiceModeKindSurvival = 'survival';

/// Shows a modal sheet letting the user choose which practice mode to
/// start (SPEC.md §5.1-§5.3, §5.8). Returns one of the `practiceModeKind*`
/// constants above, or `null` if dismissed without a choice.
Future<String?> showPracticeModePickerSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => const _PracticeModePickerSheet(),
  );
}

/// Modal sheet content for [showPracticeModePickerSheet].
class _PracticeModePickerSheet extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: AppShapes.squircleRadius(
                    AppShapes.of(context).full,
                  ),
                ),
              ),
            ),
            Text(l10n.practiceModePickerTitle, style: textTheme.headlineSmall),
            const SizedBox(height: 8),
            _ModeOption(
              label: l10n.practiceModeZen,
              subtitle: l10n.practiceModeZenSubtitle,
              onTap: () => Navigator.of(context).pop(practiceModeKindZen),
            ),
            _ModeOption(
              label: l10n.practiceModeSprint30,
              subtitle: l10n.practiceModeSprintSubtitle,
              onTap: () => Navigator.of(context).pop(practiceModeKindSprint30),
            ),
            _ModeOption(
              label: l10n.practiceModeSprint60,
              subtitle: l10n.practiceModeSprintSubtitle,
              onTap: () => Navigator.of(context).pop(practiceModeKindSprint60),
            ),
            _ModeOption(
              label: l10n.practiceModeSprint120,
              subtitle: l10n.practiceModeSprintSubtitle,
              onTap: () => Navigator.of(context).pop(practiceModeKindSprint120),
            ),
            _ModeOption(
              label: l10n.practiceModePrecision,
              subtitle: l10n.practiceModePrecisionSubtitle,
              onTap: () => Navigator.of(context).pop(practiceModeKindPrecision),
            ),
            _ModeOption(
              label: l10n.practiceModeSurvival,
              subtitle: l10n.practiceModeSurvivalSubtitle,
              onTap: () => Navigator.of(context).pop(practiceModeKindSurvival),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeOption extends StatelessWidget {
  const new({required this.label, required this.subtitle, required this.onTap});

  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }
}
