import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/features/daily_challenge/presentation/providers/daily_challenge_providers.dart';
import 'package:ridge/features/practice/domain/entities/practice_mode.dart';

/// The Daily Challenge entry point (SPEC.md §5.4) on `FreePracticeScreen`
/// — the shared, date-locked snippet every profile gets today. Renders
/// nothing while there's no data to show yet (see
/// `dailyChallengeCardProvider`'s doc), so it never competes with the
/// screen's own loading/empty states.
class DailyChallengeCard extends ConsumerWidget {
  /// Creates the Daily Challenge card.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dailyChallengeCardProvider).value;
    if (data == null) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final completion = data.completion;
    final alreadyPlayed = completion != null;

    return Card(
      shape: AppShapes.of(context).mediumShape,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: alreadyPlayed
            ? null
            : () => context.push(
                '/practice/session',
                extra: (
                  snippet: data.snippet,
                  mode: PracticeMode.dailyChallenge(
                    challengeDate: data.challengeDate.value,
                  ),
                  onContinue: null,
                ),
              ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                alreadyPlayed
                    ? LucideIcons.calendarCheck300
                    : LucideIcons.calendarDays300,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.dailyChallengeCardTitle,
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      alreadyPlayed
                          ? l10n.dailyChallengeCardAlreadyPlayed(
                              completion.score,
                            )
                          : l10n.dailyChallengeCardSubtitle,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (data.streak > 0) ...[
                const SizedBox(width: 8),
                Icon(
                  LucideIcons.flame600,
                  color: colorScheme.primary,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  l10n.dailyChallengeCardStreakLabel(data.streak),
                  style: textTheme.labelLarge,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
