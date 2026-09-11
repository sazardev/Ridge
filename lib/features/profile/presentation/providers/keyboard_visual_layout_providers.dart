import 'package:ridge/features/profile/domain/entities/keyboard_visual_layout.dart';
import 'package:ridge/features/profile/domain/repositories/keyboard_visual_layout_source.dart';
import 'package:ridge/features/profile/infrastructure/keyboard_visual_layout_local_data_source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'keyboard_visual_layout_providers.g.dart';

/// Provides the [KeyboardVisualLayoutSource] implementation used across
/// the app.
@Riverpod(keepAlive: true)
KeyboardVisualLayoutSource keyboardVisualLayoutSource(Ref ref) {
  return KeyboardVisualLayoutLocalDataSource();
}

/// Loads every curated keyboard layout once and keeps it — the data bank
/// is bundled, read-only content, never re-fetched or invalidated within
/// an app session (same reasoning as `learningPathRepositoryProvider`).
@Riverpod(keepAlive: true)
Future<Map<String, KeyboardVisualLayout>> keyboardVisualLayouts(Ref ref) {
  return ref.watch(keyboardVisualLayoutSourceProvider).loadCuratedLayouts();
}
