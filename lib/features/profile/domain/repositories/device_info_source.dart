/// The device attributes auto-detected for the on-device Guest Profile.
/// Each field is `null` when the current platform doesn't expose it (e.g.
/// no hardware model is available on Linux/Windows) or detection failed.
typedef DetectedDeviceInfo = ({
  String? platform,
  String? operatingSystemVersion,
  String? deviceModel,
});

/// Driven port: detects the current device's platform/OS/model.
/// Infrastructure provides the adapter (`device_info_plus` + platform
/// checks) — the application core never touches a platform API directly.
abstract interface class DeviceInfoSource {
  /// Detects the current device's info. Never throws — an underlying
  /// platform-channel failure surfaces as all-`null` fields rather than
  /// propagating, since this is best-effort flair, not business data.
  Future<DetectedDeviceInfo> detect();
}
