import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_info_provider.g.dart';

/// The running app's version + build number, read from the platform at
/// runtime. `pubspec.yaml` is the only place that ever sets these values
/// (STACK.md §10.1) — never hardcode a version string in presentation code.
@Riverpod(keepAlive: true)
Future<PackageInfo> appInfo(Ref ref) {
  return PackageInfo.fromPlatform();
}
