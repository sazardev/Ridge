import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:ridge/firebase_options.dart';

/// Whether this build target can talk to Firebase at all. FlutterFire
/// ships no Linux desktop implementation (no `firebase_core`/`firebase_auth`
/// plugin exists for it), so Linux — the main development platform —
/// runs fully offline as a Guest Profile (SPEC.md §7.1) and every auth
/// entry point reports itself unavailable there. Android, Web and
/// Windows are supported.
bool get isFirebaseSupportedPlatform {
  if (kIsWeb) return true;
  return defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.windows;
}

/// Initializes Firebase exactly once, on supported platforms only —
/// a guarded no-op on Linux (and in tests, which run on the host
/// platform). Called from `main.dart` before `runApp` so the auth
/// session is restored as early as possible; safe to call again.
Future<void> ensureFirebaseInitialized() async {
  if (!isFirebaseSupportedPlatform) return;
  if (Firebase.apps.isNotEmpty) return;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
