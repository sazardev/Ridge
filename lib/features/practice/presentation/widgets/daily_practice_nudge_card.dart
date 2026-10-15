import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/core/widgets/bouncy_tap.dart';
import 'package:ridge/features/content/presentation/widgets/practice_mode_picker_sheet.dart';
import 'package:ridge/features/practice/presentation/providers/practice_providers.dart';
import 'package:ridge/features/progression/presentation/providers/progression_providers.dart';

/// The in-app exercise nudge — the reminder's cross-platform layer
/// (STACK.md §3.1: only Android can schedule an OS notification, so this
/// card *is* the whole reminder everywhere else). Shown on the Practice
/// tab when the profile has practiced before but not today; tapping it
/// starts the weakness-based warm-up when one exists, and otherwise
/// lands on Free practice. Renders nothing when there's nothing to nudge
/// about (see `dailyPracticeNudgeProvider`'s doc).
class DailyPracticeNudgeCard extends ConsumerWidget {
  /// Creates the nudge card.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dailyPracticeNudgeProvider).value;
    if (data == null) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final title = data.streakDays >= 1
        ? l10n.practiceNudgeStreakTitle(data.streakDays)
        : l10n.practiceNudgeInactiveTitle(data.daysSinceLastSession);

    void start(BuildContext buttonContext) {
      final options = ref.watch(warmUpOptionsProvider).value;
      final warmUp = options == null || options.isEmpty ? null : options.first;
      if (warmUp != null) {
        unawaited(
          buttonContext.push(
            '/practice/session',
            extra: (snippet: warmUp.snippet, modeKind: practiceModeKindZen),
          ),
        );
      } else {
        buttonContext.go('/free-practice');
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: BouncyTap(
        enabled: true,
        child: Card(
          color: colorScheme.primaryContainer,
          shape: AppShapes.of(context).mediumShape,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => start(context),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.alarmClock300,
                    color: colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.practiceNudgeBody,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    LucideIcons.chevronRight300,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
