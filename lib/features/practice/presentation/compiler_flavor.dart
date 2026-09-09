import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/features/practice/domain/entities/session_metrics.dart';

/// Picks a short, programmer/compiler-themed flavor line for a just-finished
/// session's result panel — purely cosmetic (never affects any stored
/// metric), based on [SessionMetrics.accuracyPct]. Keeps the tiers simple
/// (one line each) rather than a pool of random variants per tier, since a
/// result is only ever shown once per session anyway.
String compilerFlavorMessage(AppLocalizations l10n, SessionMetrics metrics) {
  final accuracy = metrics.accuracyPct;
  if (accuracy >= 100) return l10n.compilerFlavorPerfect;
  if (accuracy >= 95) return l10n.compilerFlavorGreat;
  if (accuracy >= 85) return l10n.compilerFlavorGood;
  if (accuracy >= 70) return l10n.compilerFlavorRough;
  return l10n.compilerFlavorBad;
}
