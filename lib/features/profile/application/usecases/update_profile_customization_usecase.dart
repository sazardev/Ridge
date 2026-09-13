import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/profile/domain/entities/favorite_language.dart';
import 'package:ridge/features/profile/domain/repositories/profile_repository.dart';

/// Trims and validates the Guest Profile's profile-flair fields, then
/// persists all of them together through the repository port. The
/// keyboard setup has its own use case (`UpdateKeyboardSetupUseCase`) so
/// the two editors never overwrite each other's columns.
class UpdateProfileCustomizationUseCase {
  /// Creates the use case over the given [ProfileRepository] port.
  const new(this._repository);

  final ProfileRepository _repository;

  /// The longest a free-text field (favorite programmer) this app
  /// accepts.
  static const maxShortTextLength = 60;

  /// The longest favorite-quote text this app accepts.
  static const maxQuoteLength = 200;

  /// GitHub's own handle ceiling — 1 to 39 letters, digits and single
  /// hyphens (never leading/trailing, never doubled).
  static const maxGithubUsernameLength = 39;

  /// The longest personal-website URL this app accepts.
  static const maxWebsiteLength = 200;

  /// A GitHub handle: 1-39 chars, alphanumeric, single hyphens only
  /// between alphanumerics.
  static final _githubHandle = RegExp(
    r'^[A-Za-z0-9](?:[A-Za-z0-9]|-(?=[A-Za-z0-9])){0,38}$',
  );

  /// Validates and persists the given fields as the Guest Profile's new
  /// self-expression flair. Blank free text is normalized to `null`
  /// (clearing that field) rather than stored as an empty string.
  Future<Result<void, AppFailure>> call({
    List<FavoriteLanguage> favoriteLanguages = const [],
    String? favoriteQuote,
    String? favoriteProgrammer,
    String? githubUsername,
    String? websiteUrl,
  }) {
    final cleanProgrammer = _clean(favoriteProgrammer);
    if (cleanProgrammer != null &&
        cleanProgrammer.length > maxShortTextLength) {
      return Future.value(
        const Result.err(
          ValidationFailure(
            'Favorite programmer must be $maxShortTextLength characters or '
            'fewer',
          ),
        ),
      );
    }
    final cleanQuote = _clean(favoriteQuote);
    if (cleanQuote != null && cleanQuote.length > maxQuoteLength) {
      return Future.value(
        const Result.err(
          ValidationFailure(
            'Favorite quote must be $maxQuoteLength characters or fewer',
          ),
        ),
      );
    }
    final rawGithub = _clean(githubUsername);
    final cleanGithub = rawGithub == null ? null : _normalizeGithub(rawGithub);
    if (rawGithub != null && cleanGithub == null) {
      return Future.value(
        const Result.err(ValidationFailure('GitHub username is not valid')),
      );
    }
    final rawWebsite = _clean(websiteUrl);
    if (rawWebsite != null && rawWebsite.length > maxWebsiteLength) {
      return Future.value(
        const Result.err(
          ValidationFailure(
            'Website must be $maxWebsiteLength characters or fewer',
          ),
        ),
      );
    }
    final cleanWebsite = rawWebsite == null
        ? null
        : _normalizeWebsite(rawWebsite);
    if (rawWebsite != null && cleanWebsite == null) {
      return Future.value(
        const Result.err(
          ValidationFailure('Website must be a valid http(s) address'),
        ),
      );
    }

    return _repository.updateCustomization(
      favoriteLanguages: favoriteLanguages,
      favoriteQuote: cleanQuote,
      favoriteProgrammer: cleanProgrammer,
      githubUsername: cleanGithub,
      websiteUrl: cleanWebsite,
    );
  }

  String? _clean(String? value) {
    final trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }

  /// Reduces whatever the user typed — a bare handle, `@handle`,
  /// `github.com/handle`, or a full `https://github.com/handle` URL — to
  /// just the handle. Returns `null` when the result isn't a valid GitHub
  /// username, so callers can reject it without guessing.
  String? _normalizeGithub(String value) {
    var handle = value;
    final markerIndex = handle.toLowerCase().indexOf('github.com/');
    if (markerIndex != -1) {
      handle = handle.substring(markerIndex + 'github.com/'.length);
    }
    // Drop any path/query/fragment after the handle (e.g. a pasted
    // `?tab=repositories`), then a leading `@`.
    handle = handle.split(RegExp('[/?#]')).first;
    if (handle.startsWith('@')) handle = handle.substring(1);

    return _githubHandle.hasMatch(handle) ? handle : null;
  }

  /// Normalizes `example.com`, `www.example.com/path` or a full URL into an
  /// `http(s)://…` string. Returns `null` when it isn't a usable web
  /// address (no scheme, no dotted host, …) so callers can reject it.
  String? _normalizeWebsite(String value) {
    final candidate = value.contains('://') ? value : 'https://$value';
    final uri = Uri.tryParse(candidate);
    if (uri == null ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        !uri.host.contains('.')) {
      return null;
    }
    return uri.toString();
  }
}
