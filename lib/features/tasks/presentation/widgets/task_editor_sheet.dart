import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/features/tasks/domain/entities/task.dart';
import 'package:just_in_time/features/tasks/domain/entities/task_priority.dart';
import 'package:just_in_time/features/tasks/presentation/providers/task_providers.dart';

Future<void> showTaskEditorSheet(BuildContext context, {Task? initial}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => TaskEditorSheet(initial: initial),
  );
}

class TaskEditorSheet extends ConsumerStatefulWidget {
  const new({super.key, this.initial});

  final Task? initial;

  @override
  ConsumerState<TaskEditorSheet> createState() => _TaskEditorSheetState();
}

class _TaskEditorSheetState extends ConsumerState<TaskEditorSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _notesController;
  late TaskPriority _priority;
  DateTime? _dueAt;
  bool _submitting = false;
  bool _showTitleError = false;

  bool get _isEditing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _titleController = TextEditingController(text: initial?.title ?? '');
    _notesController = TextEditingController(text: initial?.notes ?? '');
    _priority = initial?.priority ?? TaskPriority.medium;
    _dueAt = initial?.dueAt;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _dueAt ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 3)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dueAt ?? now),
    );
    if (!mounted) return;
    setState(() {
      _dueAt = DateTime(
        date.year,
        date.month,
        date.day,
        time?.hour ?? 9,
        time?.minute ?? 0,
      );
    });
  }

  Future<void> _submit() async {
    if (_titleController.text.trim().isEmpty) {
      setState(() => _showTitleError = true);
      return;
    }
    setState(() => _submitting = true);
    final controller = ref.read(tasksControllerProvider.notifier);
    final notes = _notesController.text.trim();
    if (_isEditing) {
      await controller.updateTask(
        widget.initial!.copyWith(
          title: _titleController.text.trim(),
          notes: notes.isEmpty ? null : notes,
          priority: _priority,
          dueAt: _dueAt,
        ),
      );
    } else {
      await controller.create(
        title: _titleController.text,
        notes: notes,
        priority: _priority,
        dueAt: _dueAt,
      );
    }
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    final task = widget.initial!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.tasksDeleteConfirmTitle),
        content: Text(l10n.tasksDeleteConfirmBody(task.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.tasksCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              l10n.tasksDelete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await ref.read(tasksControllerProvider.notifier).delete(task.id);
    if (mounted) Navigator.of(context).pop();
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
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _isEditing
                        ? l10n.tasksEditSheetTitle
                        : l10n.tasksAddSheetTitle,
                    style: textTheme.headlineSmall,
                  ),
                ),
                if (_isEditing)
                  IconButton(
                    onPressed: _submitting ? null : _delete,
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      color: colorScheme.error,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _titleController,
              autofocus: !_isEditing,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.tasksFieldTitle,
                hintText: l10n.tasksFieldTitleHint,
                errorText: _showTitleError ? l10n.tasksErrorEmptyTitle : null,
              ),
              onChanged: (_) {
                if (_showTitleError) setState(() => _showTitleError = false);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              minLines: 1,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.tasksFieldNotes,
                hintText: l10n.tasksFieldNotesHint,
              ),
            ),
            const SizedBox(height: 20),
            Text(l10n.tasksFieldPriority, style: textTheme.labelLarge),
            const SizedBox(height: 10),
            SegmentedButton<TaskPriority>(
              segments: [
                ButtonSegment(
                  value: TaskPriority.low,
                  label: Text(l10n.priorityLow),
                ),
                ButtonSegment(
                  value: TaskPriority.medium,
                  label: Text(l10n.priorityMedium),
                ),
                ButtonSegment(
                  value: TaskPriority.high,
                  label: Text(l10n.priorityHigh),
                ),
              ],
              selected: {_priority},
              onSelectionChanged: (selection) =>
                  setState(() => _priority = selection.first),
            ),
            const SizedBox(height: 20),
            Text(l10n.tasksFieldDueDate, style: textTheme.labelLarge),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickDueDate,
                    icon: const Icon(Icons.event_outlined),
                    label: Text(
                      _dueAt == null
                          ? l10n.tasksFieldDueDateNone
                          : DateFormat.yMMMd().add_Hm().format(_dueAt!),
                    ),
                  ),
                ),
                if (_dueAt != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => setState(() => _dueAt = null),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 28),
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
                    : Text(l10n.tasksSave),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
