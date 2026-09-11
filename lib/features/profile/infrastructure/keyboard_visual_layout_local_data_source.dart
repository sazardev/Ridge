import 'dart:convert';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/services.dart' show rootBundle;

import 'package:ridge/features/profile/domain/entities/keyboard_visual_layout.dart';
import 'package:ridge/features/profile/domain/repositories/keyboard_visual_layout_source.dart';
import 'package:ridge/features/profile/infrastructure/keyboard_visual_layout_dto.dart';
import 'package:ridge/features/profile/infrastructure/keyboard_visual_layout_mapper.dart';

/// Loads the bundled "keyboard layouts" data bank
/// (`assets/content/keyboard_layouts/`) — real per-model physical key
/// geometry, extracted from public open-source keyboard-firmware repos
/// (attribution/license per file in that directory's
/// `THIRD_PARTY_SOURCES.md`). Only curated for the handful of models
/// with genuinely verifiable public layout data — mostly split-ergo and
/// other QMK/VIA-hackable boards. Most `keyboardModel` suggestions are
/// closed-firmware OEM/gaming boards (Corsair, Razer, Logitech,
/// SteelSeries, ...) with no public per-key spec anywhere, so they're
/// deliberately never curated here; the profile's keyboard visual falls
/// back to `keyboard_shape_lookup.dart`'s generic family silhouette for
/// those instead of guessing.
///
/// Mirrors `LearningPathRepositoryImpl`'s design: static, never
/// user-mutated reference content, read straight from the bundle with
/// no drift table and no drift-seeding step.
class KeyboardVisualLayoutLocalDataSource
    implements KeyboardVisualLayoutSource {
  /// Creates the source, optionally over a custom [_manifestAssetPath] —
  /// tests can point at a fixture manifest.
  new([this._manifestAssetPath = defaultManifestAssetPath]);

  /// The manifest mapping each curated `keyboardModel` string to its
  /// asset file name (see `assets/content/keyboard_layouts/manifest.json`).
  static const defaultManifestAssetPath =
      'assets/content/keyboard_layouts/manifest.json';

  final String _manifestAssetPath;

  @override
  Future<Map<String, KeyboardVisualLayout>> loadCuratedLayouts() async {
    final byModel = <String, KeyboardVisualLayout>{};

    final Map<String, Object?> manifest;
    try {
      final raw = await rootBundle.loadString(_manifestAssetPath);
      manifest = jsonDecode(raw) as Map<String, Object?>;
      // A missing asset throws `FlutterError` (an `Error`, not an
      // `Exception`), so the narrower `on Exception` clause used below
      // wouldn't catch it — this whole data bank is optional decoration,
      // never worth crashing profile rendering over.
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      debugPrint('KeyboardVisualLayoutLocalDataSource: no manifest — $e');
      return byModel;
    }

    for (final entry in manifest.entries) {
      final model = entry.key;
      try {
        final fileName = entry.value! as String;
        final raw = await rootBundle.loadString(
          'assets/content/keyboard_layouts/$fileName',
        );
        final dto = KeyboardVisualLayoutDto.fromJson(
          jsonDecode(raw)! as Map<String, Object?>,
        );
        byModel[model] = dto.toDomain();
        // A malformed manifest entry or layout file must never take down
        // every other curated model — same defensive contract as
        // `content`'s `ExternalSnippetPackSource`.
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        debugPrint(
          'KeyboardVisualLayoutLocalDataSource: skipped "$model" — $e',
        );
      }
    }
    return byModel;
  }
}
