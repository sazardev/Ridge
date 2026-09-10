import 'package:just_in_time/features/profile/domain/repositories/device_info_source.dart';
import 'package:just_in_time/features/profile/presentation/providers/profile_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_providers.g.dart';

/// Detects the current device's platform/OS/model for the onboarding
/// preview page. Read-only and separate from `EnsureDeviceInfoUseCase`'s
/// persisted detection — no Guest Profile exists yet at this point in the
/// flow (see `OnboardingScreen`), so there's nothing to save it onto;
/// once the profile is created right after, `deviceInfoSync` detects and
/// persists it again on its own.
@riverpod
Future<DetectedDeviceInfo> onboardingDeviceInfo(Ref ref) {
  return ref.watch(deviceInfoSourceProvider).detect();
}
