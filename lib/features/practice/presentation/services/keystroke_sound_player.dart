import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:ridge/features/settings/domain/entities/app_sound_pack.dart';

/// Plays short, low-latency sound effects for the capture engine — a
/// distinct "click" for every committed keystroke (forward or
/// correction) and a duller "thud" for a rejected attempt, so typing
/// feels tactile the way a real mechanical keyboard does.
///
/// Backed by [AudioPool] (not a single [AudioPlayer]) specifically
/// because typing fires sounds far faster than a normal player can
/// restart cleanly — the pool keeps several pre-loaded players ready so
/// two rapid keystrokes never cut each other off.
///
/// The constructor's [AppSoundPack] selects which `assets/sounds/<pack>/`
/// folder to load from — the instance is tied to one pack for its
/// lifetime; switching packs means creating a new instance (see
/// `practice_providers.dart`'s `keystrokeSoundPlayerProvider`, which
/// rebuilds on a settings change).
class KeystrokeSoundPlayer {
  /// Starts loading both sound pools for [pack] immediately; playback
  /// calls made before loading finishes are silently queued behind
  /// [_ready].
  new(AppSoundPack pack) : _pack = pack {
    _ready = _load();
  }

  final AppSoundPack _pack;
  late final Future<void> _ready;
  AudioPool? _clickPool;
  AudioPool? _rejectPool;
  bool _disposed = false;

  /// Sound is a feel-good extra, never a functional requirement — a
  /// missing audio backend (no plugin registered under test, no sound
  /// device on some Linux setups, a platform quirk) must never disrupt
  /// actual typing, so every platform call in this class is defensive:
  /// failures leave the pools `null` (or a no-op play) instead of
  /// throwing back into the capture field.
  Future<void> _load() async {
    try {
      final results = await Future.wait([
        AudioPool.createFromAsset(
          path: 'sounds/${_pack.name}/key_click.wav',
          maxPlayers: 8,
          playerMode: PlayerMode.lowLatency,
        ),
        AudioPool.createFromAsset(
          path: 'sounds/${_pack.name}/key_reject.wav',
          maxPlayers: 4,
          playerMode: PlayerMode.lowLatency,
        ),
      ]);
      if (_disposed) {
        // Disposed while loading (e.g. the session screen was popped
        // almost immediately) — release what just finished loading
        // rather than leaking two live audio pools.
        for (final pool in results) {
          unawaited(pool.dispose());
        }
        return;
      }
      _clickPool = results[0];
      _rejectPool = results[1];
    } on Exception {
      // No audio backend available — typing continues silently.
    }
  }

  /// Plays the click sound — every committed forward keystroke and
  /// every correction (backspace/Delete).
  Future<void> playClick() async {
    await _ready;
    if (_disposed) return;
    unawaited(_safeStart(_clickPool));
  }

  /// Plays the reject sound — a keystroke that didn't match and was
  /// rejected under hard lock (SPEC.md §4.1).
  Future<void> playReject() async {
    await _ready;
    if (_disposed) return;
    unawaited(_safeStart(_rejectPool));
  }

  /// Starts [pool] and swallows any failure — see this class's doc for
  /// why playback errors must never surface. A real `try`/`await` here
  /// (not a bare `unawaited(pool?.start())`) is what actually catches an
  /// error the *asynchronous* platform call raises, since the call
  /// itself returns a `Future` successfully before that error occurs.
  Future<void> _safeStart(AudioPool? pool) async {
    try {
      await pool?.start();
    } on Exception {
      // See [_load]'s doc — playback failures are silent, not fatal.
    }
  }

  /// Releases both audio pools. Safe to call even if [_load] hasn't
  /// finished yet.
  void dispose() {
    _disposed = true;
    unawaited(_clickPool?.dispose());
    unawaited(_rejectPool?.dispose());
  }
}
