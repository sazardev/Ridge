import 'dart:async';

import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:ridge/core/audio/sound_engine.dart';
import 'package:ridge/features/settings/domain/entities/app_sound_pack.dart';

/// Handle to one loaded keystroke clip.
///
/// The engine's concrete source type is hidden behind this thin interface —
/// just like [KeystrokeSoundLoader]/[KeystrokeSoundPlay]/
/// [KeystrokeSoundDispose] below — so tests can exercise loading, playback
/// and cleanup without touching a real audio backend.
abstract interface class KeystrokeSoundClip;

/// Loads one clip from an asset path. Resolves `null` when the audio backend
/// is unavailable — sound is decorative and must never break typing, so
/// production errors are swallowed by [KeystrokeSoundPlayer].
typedef KeystrokeSoundLoader = Future<KeystrokeSoundClip?> Function(
  String asset,
);

/// Fires one independent voice for an already-loaded [clip].
typedef KeystrokeSoundPlay = void Function(KeystrokeSoundClip clip);

/// Releases a loaded [clip].
typedef KeystrokeSoundDispose = Future<void> Function(KeystrokeSoundClip clip);

class _SoLoudClip implements KeystrokeSoundClip {
  new(this.source);

  final AudioSource source;
}

Future<KeystrokeSoundClip?> _loadSoLoudClip(String asset) async {
  await ensureSoundEngineInitialized();
  final soloud = SoLoud.instance;
  if (!soloud.isInitialized) return null;
  return _SoLoudClip(await soloud.loadAsset(asset));
}

void _playSoLoudClip(KeystrokeSoundClip clip) {
  SoLoud.instance.play((clip as _SoLoudClip).source);
}

Future<void> _disposeSoLoudClip(KeystrokeSoundClip clip) {
  return SoLoud.instance.disposeSource((clip as _SoLoudClip).source);
}

/// Plays short, low-latency sound effects for the capture engine — a
/// distinct "click" for every committed keystroke (forward or correction)
/// and a duller "thud" for a rejected attempt, so typing feels tactile the
/// way a real mechanical keyboard does.
///
/// Backed by SoLoud, whose `play()` is synchronous and mixes one
/// independent voice per call: five keystrokes in a second are five
/// overlapping voices, not a player being restarted between them. This
/// replaced `audioplayers`, whose `AudioPool` under `PlayerMode.lowLatency`
/// never recycled its players, so every keystroke loaded and leaked a
/// brand-new native player until the sounds trailed seconds behind the
/// typing rhythm (and the process eventually ran out of audio handles).
///
/// The constructor's [AppSoundPack] selects which `assets/sounds/<pack>/`
/// folder to load from — the instance is tied to one pack for its lifetime;
/// switching packs means creating a new instance (see
/// `practice_providers.dart`'s `keystrokeSoundPlayerProvider`, which
/// rebuilds on a settings change).
class KeystrokeSoundPlayer {
  /// Loads both clips for this player's [AppSoundPack] immediately;
  /// playback calls made before loading finishes are silently queued behind
  /// [_ready]. The engine operations are injectable seams defaulting to the
  /// real SoLoud ones.
  new(
    this._pack, {
    this._load = _loadSoLoudClip,
    this._play = _playSoLoudClip,
    this._disposeClip = _disposeSoLoudClip,
  }) {
    _ready = _loadClips();
  }

  /// A player wired to no backend at all — for widget tests that exercise
  /// the capture field without initializing native audio.
  new silent(this._pack)
    : _load = _loadNothing,
      _play = _playNothing,
      _disposeClip = _disposeNothing {
    _ready = Future<void>.value();
  }

  final AppSoundPack _pack;
  final KeystrokeSoundLoader _load;
  final KeystrokeSoundPlay _play;
  final KeystrokeSoundDispose _disposeClip;
  late final Future<void> _ready;
  KeystrokeSoundClip? _clickClip;
  KeystrokeSoundClip? _rejectClip;
  bool _disposed = false;

  /// Plays the click sound — every committed forward keystroke and every
  /// correction (backspace/Delete).
  Future<void> playClick() async {
    await _ready;
    if (_disposed) return;
    _fire(_clickClip);
  }

  /// Plays the reject sound — a keystroke that didn't match and was
  /// rejected under hard lock (SPEC.md §4.1).
  Future<void> playReject() async {
    await _ready;
    if (_disposed) return;
    _fire(_rejectClip);
  }

  /// Loads both clips. Each load is independent, so a failure in one still
  /// keeps the other (clicks without rejects beats silence), and every
  /// backend call stays defensive: sound is a feel-good extra, never a
  /// functional requirement, so a missing audio backend must leave typing
  /// untouched.
  Future<void> _loadClips() async {
    final click = await _tryLoad('assets/sounds/${_pack.name}/key_click.wav');
    final reject = await _tryLoad('assets/sounds/${_pack.name}/key_reject.wav');
    if (_disposed) {
      // Disposed while loading (e.g. the session screen was popped almost
      // immediately, or the pack changed mid-load) — release what just
      // finished loading rather than leaking two live clips.
      await _disposeQuietly(click);
      await _disposeQuietly(reject);
      return;
    }
    _clickClip = click;
    _rejectClip = reject;
  }

  Future<KeystrokeSoundClip?> _tryLoad(String asset) async {
    try {
      return await _load(asset);
    } on Exception {
      // No audio backend available — typing continues silently.
      return null;
    }
  }

  /// Fires [clip] as its own voice. A play failure can only ever be the
  /// backend's, never the caller's — playback errors never surface.
  void _fire(KeystrokeSoundClip? clip) {
    if (clip == null) return;
    try {
      _play(clip);
    } on Exception {
      // See [_tryLoad]'s doc.
    }
  }

  Future<void> _disposeQuietly(KeystrokeSoundClip? clip) async {
    if (clip == null) return;
    try {
      await _disposeClip(clip);
    } on Exception {
      // See [_tryLoad]'s doc.
    }
  }

  /// Releases both clips. Safe to call even if [_loadClips] hasn't finished
  /// yet, and safe to call twice.
  void dispose() {
    _disposed = true;
    final click = _clickClip;
    final reject = _rejectClip;
    _clickClip = null;
    _rejectClip = null;
    unawaited(_disposeQuietly(click));
    unawaited(_disposeQuietly(reject));
  }
}

Future<KeystrokeSoundClip?> _loadNothing(String asset) async => null;

void _playNothing(KeystrokeSoundClip clip) {}

Future<void> _disposeNothing(KeystrokeSoundClip clip) async {}
