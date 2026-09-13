import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_dto.freezed.dart';
part 'profile_dto.g.dart';

/// Wire/storage shape for a `GuestProfile`. Kept separate from the domain
/// entity so a future storage-format change never leaks into business
/// logic — only `ProfileMapper` needs to change.
@freezed
abstract class ProfileDto with _$ProfileDto {
  /// Creates a DTO snapshot ready for JSON serialization.
  const factory({
    required String id,
    required String username,
    required String createdAt,
    List<String>? favoriteLanguages,
    String? keyboardLayout,
    String? keyboardBrand,
    String? keyboardModel,
    String? favoriteQuote,
    String? favoriteProgrammer,
    String? githubUsername,
    String? websiteUrl,
    String? platform,
    String? operatingSystemVersion,
    String? deviceModel,
    String? keyboardCustomizationJson,
  }) = _ProfileDto;

  /// Deserializes a DTO from decoded JSON.
  factory fromJson(Map<String, Object?> json) => _$ProfileDtoFromJson(json);
}
