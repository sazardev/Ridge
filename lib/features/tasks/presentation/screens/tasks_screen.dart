import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/features/tasks/domain/entities/task.dart';
import 'package:just_in_time/features/tasks/presentation/providers/task_providers.dart';
import 'package:just_in_time/features/tasks/presentation/widgets/empty_state.dart';
import 'package:just_in_time/features/tasks/presentation/widgets/task_editor_sheet.dart';
import 'package:just_in_time/features/tasks/presentation/widgets/task_section_header.dart';
import 'package:just_in_time/features/tasks/presentation/widgets/task_tile.dart';

class TasksScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final tasksAsync = ref.watch(tasksControllerProvider);
    final sections = ref.watch(taskSectionsProvider);
    final remaining = tasksAsync.value?.where((t) => !t.isDone).length ?? 0;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tasksTitle)),
      body: tasksAsync.when(
        data: (tasks) {
          if (tasks.isEmpty) {
            return EmptyState(
              title: l10n.tasksEmptyTitle,
              body: l10n.tasksEmptyBody,
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 4, top: 8),
                child: Text(
                  l10n.tasksCountRemaining(remaining),
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ),
              if (sections.overdue.isNotEmpty) ...[
                TaskSectionHeader(
                  label: l10n.tasksSectionOverdue,
                  emphasize: true,
                ),
                for (final task in sections.overdue)
                  _TaskEntry(task: task, l10n: l10n),
              ],
              if (sections.today.isNotEmpty) ...[
                TaskSectionHeader(label: l10n.tasksSectionToday),
                for (final task in sections.today)
                  _TaskEntry(task: task, l10n: l10n),
              ],
              if (sections.upcoming.isNotEmpty) ...[
                TaskSectionHeader(label: l10n.tasksSectionUpcoming),
                for (final task in sections.upcoming)
                  _TaskEntry(task: task, l10n: l10n),
              ],
              if (sections.done.isNotEmpty) ...[
                TaskSectionHeader(label: l10n.tasksSectionDone),
                for (final task in sections.done)
                  _TaskEntry(task: task, l10n: l10n),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text(l10n.commonSomethingWrong)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showTaskEditorSheet(context),
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.tasksAdd),
      ),
    );
  }
}

class _TaskEntry extends ConsumerWidget {
  const new({required this.task, required this.l10n});

  final Task task;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final controller = ref.read(tasksControllerProvider.notifier);

    return Padding(
      key: ValueKey(task.id.value),
      padding: const EdgeInsets.only(bottom: 10),
      child: Dismissible(
        key: ValueKey('dismiss-${task.id.value}'),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          decoration: BoxDecoration(
            color: colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.delete_outline_rounded,
            color: colorScheme.onErrorContainer,
          ),
        ),
        onDismissed: (_) {
          unawaited(controller.delete(task.id));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.tasksUndoSnackbar),
              action: SnackBarAction(
                label: l10n.tasksUndoAction,
                onPressed: () => controller.updateTask(task),
              ),
            ),
          );
        },
        child: TaskTile(
          task: task,
          onToggleDone: () => controller.toggleDone(task),
          onTap: () => showTaskEditorSheet(context, initial: task),
        ),
      ),
    );
  }
}
