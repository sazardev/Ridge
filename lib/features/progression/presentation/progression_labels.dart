import 'package:flutter/material.dart';

import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/features/practice/domain/entities/finger.dart';
import 'package:just_in_time/features/progression/domain/entities/trend.dart';

/// Localized display label for a [Finger], shared by every widget that
/// renders one so the mapping lives in exactly one place (mirrors
/// `content`'s `DifficultyLabel`/`ContentCategoryLabel`).
extension FingerLabel on Finger {
  /// Returns this finger's localized display label.
  String label(AppLocalizations l10n) => switch (this) {
    Finger.leftPinky => l10n.progressFingerLeftPinky,
    Finger.leftRing => l10n.progressFingerLeftRing,
    Finger.leftMiddle => l10n.progressFingerLeftMiddle,
    Finger.leftIndex => l10n.progressFingerLeftIndex,
    Finger.rightIndex => l10n.progressFingerRightIndex,
    Finger.rightMiddle => l10n.progressFingerRightMiddle,
    Finger.rightRing => l10n.progressFingerRightRing,
    Finger.rightPinky => l10n.progressFingerRightPinky,
    Finger.thumb => l10n.progressFingerThumb,
  };
}

/// Localized display label and icon for a [Trend] — a weakness score
/// dropping (SPEC.md §4.2's "mejorando") is presented as a downward
/// trend, since lower is better for a "how bad is this" score.
extension TrendPresentation on Trend {
  /// Returns this trend's localized display label.
  String label(AppLocalizations l10n) => switch (this) {
    Trend.improving => l10n.progressTrendImproving,
    Trend.worsening => l10n.progressTrendWorsening,
    Trend.stable => l10n.progressTrendStable,
  };

  /// Returns this trend's display icon.
  IconData get icon => switch (this) {
    Trend.improving => Icons.trending_down_rounded,
    Trend.worsening => Icons.trending_up_rounded,
    Trend.stable => Icons.trending_flat_rounded,
  };
}
