import 'package:ridge/features/practice/presentation/providers/practice_providers.dart';
import 'package:ridge/features/profile/presentation/providers/profile_providers.dart';
import 'package:ridge/features/progression/domain/services/weekly_summary_calculator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'weekly_summary_providers.g.dart';

const _calculator = WeeklySummaryCalculator();

/// The Progress screen's rolling weekly report card's data — `null`
/// while there's no active profile or no session history at all yet (a
/// brand-new profile has no week to report on; the Progress screen's own
/// empty state already covers that case).
///
/// Deliberately its own file: it reads `practice`'s sessions stream,
/// while `practice` reads `progression_providers.dart` — keeping this
/// provider out of that file avoids a library-level import cycle.
@riverpod
Future<WeeklySummary?> weeklySummary(Ref ref) async {
  final profile = ref.watch(activeProfileControllerProvider).value;
  if (profile == null) return null;
  final sessions = await ref.watch(typingSessionsProvider.future);
  if (sessions.isEmpty) return null;
  return _calculator.compute(sessions: sessions, nowLocal: DateTime.now());
}
