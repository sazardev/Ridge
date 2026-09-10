// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Detects the current device's platform/OS/model for the onboarding
/// preview page. Read-only and separate from `EnsureDeviceInfoUseCase`'s
/// persisted detection — no Guest Profile exists yet at this point in the
/// flow (see `OnboardingScreen`), so there's nothing to save it onto;
/// once the profile is created right after, `deviceInfoSync` detects and
/// persists it again on its own.

@ProviderFor(onboardingDeviceInfo)
final onboardingDeviceInfoProvider = OnboardingDeviceInfoProvider._();

/// Detects the current device's platform/OS/model for the onboarding
/// preview page. Read-only and separate from `EnsureDeviceInfoUseCase`'s
/// persisted detection — no Guest Profile exists yet at this point in the
/// flow (see `OnboardingScreen`), so there's nothing to save it onto;
/// once the profile is created right after, `deviceInfoSync` detects and
/// persists it again on its own.

final class OnboardingDeviceInfoProvider
    extends
        $FunctionalProvider<
          AsyncValue<DetectedDeviceInfo>,
          DetectedDeviceInfo,
          FutureOr<DetectedDeviceInfo>
        >
    with
        $FutureModifier<DetectedDeviceInfo>,
        $FutureProvider<DetectedDeviceInfo> {
  /// Detects the current device's platform/OS/model for the onboarding
  /// preview page. Read-only and separate from `EnsureDeviceInfoUseCase`'s
  /// persisted detection — no Guest Profile exists yet at this point in the
  /// flow (see `OnboardingScreen`), so there's nothing to save it onto;
  /// once the profile is created right after, `deviceInfoSync` detects and
  /// persists it again on its own.
  OnboardingDeviceInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingDeviceInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingDeviceInfoHash();

  @$internal
  @override
  $FutureProviderElement<DetectedDeviceInfo> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DetectedDeviceInfo> create(Ref ref) {
    return onboardingDeviceInfo(ref);
  }
}

String _$onboardingDeviceInfoHash() =>
    r'ae475987577ba58b09e7515d3c10784782a2fafd';
