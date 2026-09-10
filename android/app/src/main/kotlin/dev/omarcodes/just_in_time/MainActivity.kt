package dev.omarcodes.just_in_time

import io.flutter.embedding.android.FlutterFragmentActivity

// FlutterFragmentActivity (not FlutterActivity) — local_auth's BiometricPrompt
// integration requires a FragmentActivity host on Android.
class MainActivity : FlutterFragmentActivity()
