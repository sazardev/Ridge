import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/core/theme/app_shapes.dart';
import 'package:just_in_time/features/profile/presentation/providers/profile_providers.dart';

/// Shows a modal sheet to rename the Guest Profile.
Future<void> showRenameProfileSheet(
  BuildContext context, {
  required String currentUsername,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => RenameProfileSheet(currentUsername: currentUsername),
  );
}

/// Modal sheet content for [showRenameProfileSheet].
class RenameProfileSheet extends ConsumerStatefulWidget {
  /// Creates the sheet pre-filled with [currentUsername].
  const new({required this.currentUsername, super.key});

  /// The Guest Profile's username before this rename.
  final String currentUsername;

  @override
  ConsumerState<RenameProfileSheet> createState() => _RenameProfileSheetState();
}

class _RenameProfileSheetState extends ConsumerState<RenameProfileSheet> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.currentUsername,
  );
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
        .rename(_controller.text);
    if (!mounted) return;
    if (result.isOk) {
      Navigator.of(context).pop();
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
            Text(l10n.profileRenameTitle, style: textTheme.headlineSmall),
            const SizedBox(height: 16),
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
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.profileSave),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
