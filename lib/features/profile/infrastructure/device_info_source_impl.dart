import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:ridge/features/profile/domain/repositories/device_info_source.dart';

/// [DeviceInfoSource] adapter over `device_info_plus` — one branch per
/// platform this app actually targets (Android, Linux, Windows, Web —
/// STACK.md §1); every platform exposes a different info shape, so there
/// is no single unified field to read. A hardware model isn't available
/// from this plugin on Linux, Windows, or Web, so [DetectedDeviceInfo
/// .deviceModel] stays `null` there.
class DeviceInfoSourceImpl implements DeviceInfoSource {
  /// Creates the adapter over a fresh [DeviceInfoPlugin].
  const new();

  @override
  Future<DetectedDeviceInfo> detect() async {
    try {
      final plugin = DeviceInfoPlugin();
      if (kIsWeb) {
        final info = await plugin.webBrowserInfo;
        return (
          platform: 'Web',
          operatingSystemVersion: info.platform,
          deviceModel: null,
        );
      }
      if (Platform.isAndroid) {
        final info = await plugin.androidInfo;
        return (
          platform: 'Android',
          operatingSystemVersion: 'Android ${info.version.release}',
          deviceModel: '${info.manufacturer} ${info.model}',
        );
      }
      if (Platform.isLinux) {
        final info = await plugin.linuxInfo;
        return (
          platform: 'Linux',
          operatingSystemVersion: info.prettyName,
          deviceModel: null,
        );
      }
      if (Platform.isWindows) {
        final info = await plugin.windowsInfo;
        return (
          platform: 'Windows',
          operatingSystemVersion:
              '${info.productName} (build ${info.buildNumber})',
          deviceModel: null,
        );
      }
      return (platform: null, operatingSystemVersion: null, deviceModel: null);
    } on Exception {
      return (platform: null, operatingSystemVersion: null, deviceModel: null);
    }
  }
}
