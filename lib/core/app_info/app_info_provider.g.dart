// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_info_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The running app's version + build number, read from the platform at
/// runtime. `pubspec.yaml` is the only place that ever sets these values
/// (STACK.md §10.1) — never hardcode a version string in presentation code.

@ProviderFor(appInfo)
final appInfoProvider = AppInfoProvider._();

/// The running app's version + build number, read from the platform at
/// runtime. `pubspec.yaml` is the only place that ever sets these values
/// (STACK.md §10.1) — never hardcode a version string in presentation code.

final class AppInfoProvider
    extends
        $FunctionalProvider<
          AsyncValue<PackageInfo>,
          PackageInfo,
          FutureOr<PackageInfo>
        >
    with $FutureModifier<PackageInfo>, $FutureProvider<PackageInfo> {
  /// The running app's version + build number, read from the platform at
  /// runtime. `pubspec.yaml` is the only place that ever sets these values
  /// (STACK.md §10.1) — never hardcode a version string in presentation code.
  AppInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appInfoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appInfoHash();

  @$internal
  @override
  $FutureProviderElement<PackageInfo> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PackageInfo> create(Ref ref) {
    return appInfo(ref);
  }
}

String _$appInfoHash() => r'0b5018b9f961ca13ef1fde186ec076ab90966dc5';
