import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/core/widgets/keyboard_scroll_shortcuts.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/presentation/content_labels.dart';

/// Shows a modal sheet letting the user pick one of [languages]. Returns
/// the chosen language, or `null` if dismissed without a choice.
///
/// Same shape as `practice_mode_picker_sheet.dart` (compact trigger +
/// full-height list) — the free-practice tab used a `SegmentedButton`
/// before, which truncated labels as soon as more than a few languages
/// existed; a sheet scales to any number of them.
Future<ProgrammingLanguage?> showLanguagePickerSheet(
  BuildContext context, {
  required List<ProgrammingLanguage> languages,
  required ProgrammingLanguage selected,
}) {
  return showModalBottomSheet<ProgrammingLanguage>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) =>
        _LanguagePickerSheet(languages: languages, selected: selected),
  );
}

/// Modal sheet content for [showLanguagePickerSheet].
class _LanguagePickerSheet extends StatefulWidget {
  const new({required this.languages, required this.selected});

  final List<ProgrammingLanguage> languages;
  final ProgrammingLanguage selected;

  @override
  State<_LanguagePickerSheet> createState() => _LanguagePickerSheetState();
}

class _LanguagePickerSheetState extends State<_LanguagePickerSheet> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: KeyboardScrollShortcuts(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
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
              for (final language in widget.languages)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(language.label(l10n)),
                  subtitle: Text(language.blurb(l10n)),
                  trailing: language == widget.selected
                      ? Icon(LucideIcons.check300, color: colorScheme.primary)
                      : null,
                  onTap: () => Navigator.of(context).pop(language),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
