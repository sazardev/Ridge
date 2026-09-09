import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/profile/domain/entities/favorite_language.dart';
import 'package:just_in_time/features/profile/domain/entities/keyboard_layout.dart';
import 'package:just_in_time/features/profile/domain/repositories/profile_repository.dart';

/// Trims and validates the Guest Profile's self-expression fields, then
/// persists all six together through the repository port.
class UpdateProfileCustomizationUseCase {
  /// Creates the use case over the given [ProfileRepository] port.
  const new(this._repository);

  final ProfileRepository _repository;

  /// The longest a free-text field (keyboard brand/model, favorite
  /// programmer) this app accepts.
  static const maxShortTextLength = 60;

  /// The longest favorite-quote text this app accepts.
  static const maxQuoteLength = 200;

  /// Validates and persists the given fields as the Guest Profile's new
  /// self-expression flair. Blank free text is normalized to `null`
  /// (clearing that field) rather than stored as an empty string.
  Future<Result<void, AppFailure>> call({
    List<FavoriteLanguage> favoriteLanguages = const [],
    KeyboardLayout? keyboardLayout,
    String? keyboardBrand,
    String? keyboardModel,
    String? favoriteQuote,
    String? favoriteProgrammer,
  }) {
    final cleanBrand = _clean(keyboardBrand);
    if (cleanBrand != null && cleanBrand.length > maxShortTextLength) {
      return Future.value(
        const Result.err(
          ValidationFailure(
            'Keyboard brand must be $maxShortTextLength characters or fewer',
          ),
        ),
      );
    }
    final cleanModel = _clean(keyboardModel);
    if (cleanModel != null && cleanModel.length > maxShortTextLength) {
      return Future.value(
        const Result.err(
          ValidationFailure(
            'Keyboard model must be $maxShortTextLength characters or fewer',
          ),
        ),
      );
    }
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

    return _repository.updateCustomization(
      favoriteLanguages: favoriteLanguages,
      keyboardLayout: keyboardLayout,
      keyboardBrand: cleanBrand,
      keyboardModel: cleanModel,
      favoriteQuote: cleanQuote,
      favoriteProgrammer: cleanProgrammer,
    );
  }

  String? _clean(String? value) {
    final trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }
}
