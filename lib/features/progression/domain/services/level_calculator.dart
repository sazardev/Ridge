import 'dart:math' as math;

import 'package:ridge/features/content/domain/entities/difficulty.dart';

/// Pure, stateless level curve (SPEC.md §6.2): `xpForLevel(n) = round(100
/// * n^1.6, nearest 10)`, uncapped — a purely long-term dedication
/// measure, independent of the competitive skill rating (§6.5).
///
/// Level 1 is a free starting floor everyone has at 0 XP (someone has to
/// start somewhere) — [xpForLevel] returns `0` for it rather than the raw
/// formula's value, so a brand-new profile is never gated out of its own
/// starting level. Every level from 2 upward uses the literal formula.
class LevelCalculator {
  /// Creates the (stateless) calculator.
  const new();

  /// The account level at which each [Difficulty] unlocks (SPEC.md
  /// §6.2). Beginner is always unlocked (level 1 is the universal floor).
  static const Map<Difficulty, int> difficultyUnlockLevels = {
    Difficulty.beginner: 1,
    Difficulty.intermediate: 5,
    Difficulty.advanced: 15,
    Difficulty.expert: 30,
  };

  /// The total XP required to *reach* [level].
  int xpForLevel(int level) {
    if (level <= 1) return 0;
    final raw = 100 * math.pow(level, 1.6);
    return (raw / 10).round() * 10;
  }

  /// The account level [totalXp] currently corresponds to — the largest
  /// level whose [xpForLevel] threshold [totalXp] has met or passed.
  int levelForXp(int totalXp) {
    var level = 1;
    while (totalXp >= xpForLevel(level + 1)) {
      level += 1;
    }
    return level;
  }

  /// Whether [difficulty]'s content is unlocked at [level].
  bool isDifficultyUnlocked(Difficulty difficulty, int level) {
    return level >= difficultyUnlockLevels[difficulty]!;
  }
}
