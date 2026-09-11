import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/core/widgets/escape_to_pop.dart';
import 'package:ridge/core/widgets/keyboard_scroll_shortcuts.dart';
import 'package:ridge/features/progression/domain/entities/progress_snapshot.dart';
import 'package:ridge/features/progression/presentation/progress_stats_json_codec.dart';
import 'package:ridge/features/progression/presentation/providers/progression_providers.dart';

/// Debug view of the active profile's full [ProgressSnapshot] as raw,
/// pretty-printed JSON (SPEC.md §15: the user owns their metadata and
/// can consult/export it at any time) — copyable to the clipboard and
/// exportable to a timestamped file on disk, for inspecting the
/// underlying numbers directly rather than through a chart or label.
/// Pushed as a non-shell route from the Progress screen's app bar (same
/// shape as `/changelog`).
class StatsJsonScreen extends ConsumerWidget {
  /// Creates the stats JSON debug screen.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final snapshotAsync = ref.watch(progressSnapshotControllerProvider);

    return EscapeToPop(
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.progressJsonScreenTitle)),
        body: snapshotAsync.when(
          data: (snapshot) => snapshot == null
              ? Center(child: Text(l10n.progressEmptyState))
              : _StatsJsonBody(snapshot: snapshot),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text(l10n.commonSomethingWrong)),
        ),
      ),
    );
  }
}

class _StatsJsonBody extends ConsumerStatefulWidget {
  const new({required this.snapshot});

  final ProgressSnapshot snapshot;

  @override
  ConsumerState<_StatsJsonBody> createState() => _StatsJsonBodyState();
}

class _StatsJsonBodyState extends ConsumerState<_StatsJsonBody> {
  final _scrollController = ScrollController();
  static const _prettyEncoder = JsonEncoder.withIndent('  ');

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _copyToClipboard(String pretty) async {
    final l10n = AppLocalizations.of(context);
    await Clipboard.setData(ClipboardData(text: pretty));
    _showMessage(l10n.progressJsonCopiedMessage);
  }

  Future<void> _exportToFile(String pretty) async {
    final l10n = AppLocalizations.of(context);
    try {
      final supportDir = await getApplicationSupportDirectory();
      final exportsDir = Directory(p.join(supportDir.path, 'exports'));
      await exportsDir.create(recursive: true);
      final stamp = DateTime.now().toIso8601String().replaceAll(
        RegExp('[:.]'),
        '-',
      );
      final file = File(p.join(exportsDir.path, 'ridge-stats-$stamp.json'));
      await file.writeAsString(pretty);
      _showMessage(l10n.progressJsonExportedMessage(file.path));
      // A malformed path or a full/read-only disk can throw more than
      // `Exception` (e.g. `FileSystemException` is an `Error` subtype on
      // some platforms) — this is a best-effort debug export, never
      // worth crashing the screen over.
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      _showMessage(l10n.progressJsonExportError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final masteryStatuses = widget.snapshot.masteryStatuses;
    final historyAsync = masteryStatuses.isEmpty
        ? null
        : ref.watch(
            personalHistoryForCategoryProvider(masteryStatuses.first.category),
          );

    final pretty = _prettyEncoder.convert(
      progressSnapshotToJson(
        widget.snapshot,
        topCategoryHistory: historyAsync?.value,
      ),
    );

    // Wraps the whole body, not just the scrollable — the Copy/Export
    // buttons above the JSON are siblings of the scrollable, so scoping
    // this to just the `SingleChildScrollView` would only let Home/End/
    // PageUp/PageDown reach it while focus was still on the scrollable
    // itself, not after tapping either button.
    return KeyboardScrollShortcuts(
      controller: _scrollController,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                FilledButton.tonalIcon(
                  onPressed: () => _copyToClipboard(pretty),
                  icon: const Icon(LucideIcons.copy300),
                  label: Text(l10n.progressJsonCopyButton),
                ),
                const SizedBox(width: 12),
                FilledButton.tonalIcon(
                  onPressed: () => _exportToFile(pretty),
                  icon: const Icon(LucideIcons.download300),
                  label: Text(l10n.progressJsonExportButton),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: ShapeDecoration(
                  shape: AppShapes.of(context).largeShape,
                  color: theme.colorScheme.surfaceContainerHigh,
                ),
                child: SelectableText(pretty, style: theme.textTheme.bodySmall),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
