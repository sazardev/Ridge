import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/features/data_management/presentation/providers/data_management_providers.dart';
import 'package:just_in_time/features/data_management/presentation/widgets/lesson_picker_dialog.dart';
import 'package:just_in_time/features/learning_paths/presentation/learning_paths_labels.dart';
import 'package:just_in_time/features/learning_paths/presentation/providers/learning_paths_providers.dart';
import 'package:just_in_time/features/settings/presentation/widgets/settings_section.dart';

/// Asks the user to confirm a destructive action before running it —
/// every "danger zone" tile below goes through this, styled with the
/// error color so the confirm button always reads as a warning.
Future<bool> _confirm(
  BuildContext context, {
  required String title,
  required String body,
  required String confirmLabel,
}) async {
  final l10n = AppLocalizations.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.settingsDataActionCancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}

/// The Settings screen's "danger zone": three escalating, local-only,
/// irreversible cleanup actions over the on-device drift database —
/// reset one lesson, reset every lesson, or erase everything including
/// the Guest Profile itself. Every action asks for confirmation first
/// (see [_confirm]) since none of them can be undone.
class DataManagementSection extends ConsumerStatefulWidget {
  /// Creates the danger-zone settings section.
  const new({super.key});

  @override
  ConsumerState<DataManagementSection> createState() =>
      _DataManagementSectionState();
}

class _DataManagementSectionState extends ConsumerState<DataManagementSection> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    await action();
    if (mounted) setState(() => _busy = false);
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _resetLesson() async {
    final l10n = AppLocalizations.of(context);
    final lessonId = await showLessonPickerDialog(context);
    if (lessonId == null || !mounted) return;

    final overviews = ref.read(learningPathsControllerProvider).value ?? [];
    final lesson = [for (final overview in overviews) ...overview.path.lessons]
        .where((lesson) => lesson.id == lessonId)
        .firstOrNull;
    final lessonTitle = lesson?.titleFor(context) ?? '';

    final confirmed = await _confirm(
      context,
      title: l10n.settingsResetLessonConfirmTitle(lessonTitle),
      body: l10n.settingsResetLessonConfirmBody,
      confirmLabel: l10n.settingsDataActionReset,
    );
    if (!confirmed || !mounted) return;

    await _run(() async {
      final result = await ref
          .read(dataManagementControllerProvider.notifier)
          .resetLesson(lessonId);
      _showMessage(
        result.isOk
            ? l10n.settingsResetLessonSuccess
            : l10n.settingsDataActionError,
      );
    });
  }

  Future<void> _resetAllLessons() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await _confirm(
      context,
      title: l10n.settingsResetAllLessonsConfirmTitle,
      body: l10n.settingsResetAllLessonsConfirmBody,
      confirmLabel: l10n.settingsDataActionReset,
    );
    if (!confirmed || !mounted) return;

    await _run(() async {
      final result = await ref
          .read(dataManagementControllerProvider.notifier)
          .resetAllLessons();
      _showMessage(
        result.isOk
            ? l10n.settingsResetAllLessonsSuccess
            : l10n.settingsDataActionError,
      );
    });
  }

  Future<void> _wipeAllData() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await _confirm(
      context,
      title: l10n.settingsWipeAllDataConfirmTitle,
      body: l10n.settingsWipeAllDataConfirmBody,
      confirmLabel: l10n.settingsDataActionEraseEverything,
    );
    if (!confirmed || !mounted) return;

    await _run(() async {
      final result = await ref
          .read(dataManagementControllerProvider.notifier)
          .wipeAllData();
      // On success the Guest Profile is gone and the router redirects
      // to `/profile/create` on its own (`hasGuestProfileProvider`) —
      // this screen may already be off-stage by the time this message
      // would show, which is fine, `_showMessage` no-ops if unmounted.
      if (result.isErr) _showMessage(l10n.settingsDataActionError);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SettingsSection(
      title: l10n.settingsSectionDataManagement,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              l10n.settingsDataManagementSubtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
        ListTile(
          title: Text(l10n.settingsResetLesson),
          subtitle: Text(l10n.settingsResetLessonSubtitle),
          enabled: !_busy,
          onTap: _resetLesson,
        ),
        const Divider(height: 1, indent: 16, endIndent: 16),
        ListTile(
          title: Text(l10n.settingsResetAllLessons),
          subtitle: Text(l10n.settingsResetAllLessonsSubtitle),
          enabled: !_busy,
          onTap: _resetAllLessons,
        ),
        const Divider(height: 1, indent: 16, endIndent: 16),
        ListTile(
          title: Text(
            l10n.settingsWipeAllData,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          subtitle: Text(l10n.settingsWipeAllDataSubtitle),
          enabled: !_busy,
          onTap: _wipeAllData,
        ),
      ],
    );
  }
}
