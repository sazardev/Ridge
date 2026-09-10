import 'package:just_in_time/features/profile/domain/entities/guest_profile.dart';
import 'package:just_in_time/features/profile/domain/repositories/device_info_source.dart';
import 'package:just_in_time/features/profile/domain/repositories/profile_repository.dart';

/// Detects and persists the current device's platform/OS/model onto the
/// existing Guest Profile — but only once, ever: the device a Guest
/// Profile lives on never changes (SPEC.md §7.1), so this is a no-op
/// once [GuestProfile.platform] is already set. Also a no-op if no
/// profile exists yet.
class EnsureDeviceInfoUseCase {
  /// Creates the use case over the given ports.
  const new(this._repository, this._source);

  final ProfileRepository _repository;
  final DeviceInfoSource _source;

  /// Detects and stores device info for [profile] if it hasn't been
  /// detected yet.
  Future<void> call(GuestProfile? profile) async {
    if (profile == null || profile.platform != null) return;
    final info = await _source.detect();
    await _repository.updateDeviceInfo(info);
  }
}
