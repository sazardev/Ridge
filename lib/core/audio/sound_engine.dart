import 'package:flutter_soloud/flutter_soloud.dart';

/// Initializes the shared [SoLoud] engine exactly once, with Ridge's
/// low-latency configuration for keystroke sound effects.
///
/// Calling `SoLoud.init` on an already-initialized engine tears it down and
/// reloads every sound (its own doc says so), which is why `main.dart`'s
/// warm-up and every `KeystrokeSoundPlayer` go through here instead of
/// calling `init` directly: the first caller performs the work and everyone
/// else awaits the same future.
///
/// Sound is decorative, never a functional requirement, so an unavailable
/// audio backend (headless CI, no output device) resolves this future
/// silently — the app keeps working with sound switched off.
Future<void> ensureSoundEngineInitialized() {
  return _initialization ??= _init();
}

Future<void>? _initialization;

Future<void> _init() async {
  try {
    final soloud = SoLoud.instance;
    if (soloud.isInitialized) return;
    await soloud.init(
      // The render-ahead ring is what makes a `play()` fired from the key
      // handler reach the speakers within one small device period (~11 ms
      // at 512 frames) instead of the default mix buffer's ~46 ms quantum
      // (2048 frames) — the exact "click glued to the key" feel this
      // feature exists for. Native only; Web ignores both parameters and
      // `play()` stays buffer-quantized there. `lowLatency` stays at its
      // (low-latency) default.
      devicePeriodFrames: 512,
      renderAheadFrames: 1536,
    );
  } on Exception {
    // No audio backend — see this file's doc. The cached future stays
    // resolved so no caller ever retries `init` in a hot path.
  }
}
