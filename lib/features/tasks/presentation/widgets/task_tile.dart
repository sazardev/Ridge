import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:just_in_time/core/theme/app_motion.dart';
import 'package:just_in_time/core/theme/app_shapes.dart';
import 'package:just_in_time/core/theme/app_typography.dart';
import 'package:just_in_time/features/tasks/domain/entities/task.dart';
import 'package:just_in_time/features/tasks/domain/entities/task_priority.dart';

class TaskTile extends StatelessWidget {
  const new({
    required this.task,
    required this.onToggleDone,
    required this.onTap,
    super.key,
  });

  final Task task;
  final VoidCallback onToggleDone;
  final VoidCallback onTap;

  Color _priorityColor(ColorScheme scheme) => switch (task.priority) {
    TaskPriority.low => scheme.outline,
    TaskPriority.medium => scheme.tertiary,
    TaskPriority.high => scheme.error,
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDone = task.isDone;

    return Material(
      color: colorScheme.surfaceContainerLow,
      shape: AppShapes.large,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CheckToggle(checked: isDone, onTap: onToggleDone),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(right: 8, top: 2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _priorityColor(colorScheme),
                          ),
                        ),
                        Expanded(
                          child: AnimatedDefaultTextStyle(
                            duration: AppMotion.effectsDefault,
                            style:
                                textTheme.titleMedium?.copyWith(
                                  color: isDone
                                      ? colorScheme.onSurfaceVariant
                                      : colorScheme.onSurface,
                                  decoration: isDone
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  decorationColor: colorScheme.onSurfaceVariant,
                                ) ??
                                const TextStyle(),
                            child: Text(
                              task.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (task.notes case final notes? when notes.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        notes,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (task.dueAt case final dueAt?) ...[
                      const SizedBox(height: 8),
                      Text(
                        DateFormat.MMMd().add_Hm().format(dueAt),
                        style: textTheme.labelSmall?.tabular.copyWith(
                          color: task.isOverdue
                              ? colorScheme.error
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckToggle extends StatelessWidget {
  const new({required this.checked, required this.onTap});

  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 40,
      height: 40,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Center(
          child: AnimatedContainer(
            duration: AppMotion.effectsDefault,
            curve: AppMotion.spatial,
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: checked ? colorScheme.primary : Colors.transparent,
              border: Border.all(
                color: checked ? colorScheme.primary : colorScheme.outline,
                width: 2,
              ),
            ),
            child: AnimatedScale(
              scale: checked ? 1 : 0,
              duration: AppMotion.effectsFast,
              curve: AppMotion.emphasizedBounce,
              child: Icon(Icons.check, size: 16, color: colorScheme.onPrimary),
            ),
          ),
        ),
      ),
    );
  }
}
