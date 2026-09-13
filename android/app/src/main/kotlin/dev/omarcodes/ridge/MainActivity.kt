package dev.omarcodes.ridge

import android.view.InputDevice
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

// FlutterFragmentActivity (not FlutterActivity) — local_auth's BiometricPrompt
// integration requires a FragmentActivity host on Android.
class MainActivity : FlutterFragmentActivity() {
    private val hardwareKeyboardChannel = "dev.omarcodes.ridge/hardware_keyboard"

    // Backs `HardwareKeyboardRepositoryImpl` (practice/infrastructure) — the
    // typing capture engine only ever reacts to real hardware key events
    // (STACK.md §2.8, no IME path), so Dart needs a way to tell "no physical
    // keyboard attached" apart from "user hasn't typed yet" and show
    // `KeyboardRequiredNotice` instead of sitting silently unresponsive.
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, hardwareKeyboardChannel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "isConnected" -> result.success(hasPhysicalKeyboard())
                    else -> result.notImplemented()
                }
            }
    }

    // A real physical/Bluetooth keyboard is any non-virtual `InputDevice`
    // reporting a full alphabetic layout over `SOURCE_KEYBOARD` — this
    // excludes the on-screen software keyboard (never an `InputDevice` at
    // all) and non-typing "keyboards" like the phone's own volume/power
    // buttons (`KEYBOARD_TYPE_NON_ALPHABETIC`).
    private fun hasPhysicalKeyboard(): Boolean {
        return InputDevice.getDeviceIds().any { id ->
            val device = InputDevice.getDevice(id) ?: return@any false
            !device.isVirtual &&
                device.keyboardType == InputDevice.KEYBOARD_TYPE_ALPHABETIC &&
                device.supportsSource(InputDevice.SOURCE_KEYBOARD)
        }
    }
}
