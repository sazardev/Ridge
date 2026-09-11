import 'package:ridge/features/profile/domain/entities/keyboard_visual_layout.dart';

/// Driven port: read-only access to the curated keyboard-layout data
/// bank — no user data lives behind this port, only authored/curated
/// content (mirrors `learning_paths`' `LearningPathRepository`: static,
/// never user-mutated reference content, safe to load once and keep).
abstract interface class KeyboardVisualLayoutSource {
  /// Every curated layout, keyed by the exact `keyboardModel` string it
  /// applies to. Deliberately never throws and never partial-fails the
  /// whole map on one bad entry — see the implementation's doc comment.
  Future<Map<String, KeyboardVisualLayout>> loadCuratedLayouts();
}
