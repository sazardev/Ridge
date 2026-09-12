// Unit tests for `UpdateProfileCustomizationUseCase`'s link handling — a
// pasted GitHub handle/`@handle`/URL all normalize to a bare handle, a
// scheme-less website gets `https://`, and anything unusable is rejected
// with a `ValidationFailure` before it can reach the repository. Uses a
// hand-written fake port, same pattern as the other usecase tests.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/profile/application/usecases/update_profile_customization_usecase.dart';
import 'package:ridge/features/profile/domain/entities/favorite_language.dart';
import 'package:ridge/features/profile/domain/entities/guest_profile.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_layout.dart';
import 'package:ridge/features/profile/domain/repositories/device_info_source.dart';
import 'package:ridge/features/profile/domain/repositories/profile_repository.dart';

class _FakeProfileRepository implements ProfileRepository {
  bool updateCalled = false;
  List<FavoriteLanguage>? favoriteLanguages;
  KeyboardLayout? keyboardLayout;
  String? keyboardBrand;
  String? keyboardModel;
  String? favoriteQuote;
  String? favoriteProgrammer;
  String? githubUsername;
  String? websiteUrl;

  @override
  Future<Result<void, AppFailure>> updateCustomization({
    List<FavoriteLanguage> favoriteLanguages = const [],
    KeyboardLayout? keyboardLayout,
    String? keyboardBrand,
    String? keyboardModel,
    String? favoriteQuote,
    String? favoriteProgrammer,
    String? githubUsername,
    String? websiteUrl,
  }) async {
    updateCalled = true;
    this.favoriteLanguages = favoriteLanguages;
    this.keyboardLayout = keyboardLayout;
    this.keyboardBrand = keyboardBrand;
    this.keyboardModel = keyboardModel;
    this.favoriteQuote = favoriteQuote;
    this.favoriteProgrammer = favoriteProgrammer;
    this.githubUsername = githubUsername;
    this.websiteUrl = websiteUrl;
    return const Result.ok(null);
  }

  @override
  Stream<GuestProfile?> watchActiveProfile() => const Stream.empty();

  @override
  Future<Result<GuestProfile, AppFailure>> createGuestProfile(
    String username,
  ) async => const Result.err(ValidationFailure('unused in this test'));

  @override
  Future<Result<void, AppFailure>> renameProfile(String newUsername) async =>
      const Result.err(ValidationFailure('unused in this test'));

  @override
  Future<Result<void, AppFailure>> updateDeviceInfo(
    DetectedDeviceInfo info,
  ) async => const Result.err(ValidationFailure('unused in this test'));
}

void main() {
  late _FakeProfileRepository repository;
  late UpdateProfileCustomizationUseCase useCase;

  setUp(() {
    repository = _FakeProfileRepository();
    useCase = UpdateProfileCustomizationUseCase(repository);
  });

  group('GitHub', () {
    test('accepts a bare handle', () async {
      final result = await useCase(githubUsername: 'sazar');

      expect(result.isOk, isTrue);
      expect(repository.githubUsername, 'sazar');
    });

    test('normalizes @handle, github.com/handle and full URLs to the '
        'bare handle', () async {
      for (final input in [
        '@sazar',
        'github.com/sazar',
        'https://github.com/sazar',
        'https://github.com/sazar?tab=repositories',
        'www.github.com/sazar/',
      ]) {
        repository = _FakeProfileRepository();
        useCase = UpdateProfileCustomizationUseCase(repository);

        final result = await useCase(githubUsername: input);

        expect(result.isOk, isTrue, reason: input);
        expect(repository.githubUsername, 'sazar', reason: input);
      }
    });

    test('blank input clears the field', () async {
      final result = await useCase(githubUsername: '   ');

      expect(result.isOk, isTrue);
      expect(repository.githubUsername, isNull);
    });

    test('rejects an invalid handle without touching the repository', () async {
      for (final input in [
        'not a handle!',
        'a--b',
        '-sazar',
        'sazar-',
        'a' * 40,
      ]) {
        repository = _FakeProfileRepository();
        useCase = UpdateProfileCustomizationUseCase(repository);

        final result = await useCase(githubUsername: input);

        expect(result.isErr, isTrue, reason: input);
        expect(result.failureOrNull, isA<ValidationFailure>(), reason: input);
        expect(repository.updateCalled, isFalse, reason: input);
      }
    });
  });

  group('website', () {
    test('gives a scheme-less address an https:// prefix', () async {
      for (final input in ['example.com', 'example.com/path']) {
        repository = _FakeProfileRepository();
        useCase = UpdateProfileCustomizationUseCase(repository);

        final result = await useCase(websiteUrl: input);

        expect(result.isOk, isTrue, reason: input);
        expect(repository.websiteUrl, 'https://$input', reason: input);
      }
    });

    test('keeps a valid http(s) URL', () async {
      final result = await useCase(websiteUrl: 'https://example.com/path');

      expect(result.isOk, isTrue);
      expect(repository.websiteUrl, 'https://example.com/path');
    });

    test('blank input clears the field', () async {
      final result = await useCase(websiteUrl: '  ');

      expect(result.isOk, isTrue);
      expect(repository.websiteUrl, isNull);
    });

    test(
      'rejects an unusable address without touching the repository',
      () async {
        for (final input in ['foo', 'not a website', 'ftp://example.com']) {
          repository = _FakeProfileRepository();
          useCase = UpdateProfileCustomizationUseCase(repository);

          final result = await useCase(websiteUrl: input);

          expect(result.isErr, isTrue, reason: input);
          expect(result.failureOrNull, isA<ValidationFailure>(), reason: input);
          expect(repository.updateCalled, isFalse, reason: input);
        }
      },
    );

    test('rejects an over-long address', () async {
      final result = await useCase(
        websiteUrl: 'https://example.com/${'a' * 200}',
      );

      expect(result.isErr, isTrue);
      expect(result.failureOrNull, isA<ValidationFailure>());
    });
  });

  test('links travel alongside the other self-expression fields', () async {
    final result = await useCase(
      favoriteLanguages: const [FavoriteLanguage.go],
      keyboardLayout: KeyboardLayout.qwerty,
      keyboardBrand: 'Monsgeek',
      keyboardModel: 'M1',
      favoriteQuote: 'Simple is better',
      favoriteProgrammer: 'Rob Pike',
      githubUsername: 'sazar',
      websiteUrl: 'example.com',
    );

    expect(result.isOk, isTrue);
    expect(repository.favoriteLanguages, const [FavoriteLanguage.go]);
    expect(repository.keyboardLayout, KeyboardLayout.qwerty);
    expect(repository.keyboardBrand, 'Monsgeek');
    expect(repository.keyboardModel, 'M1');
    expect(repository.favoriteQuote, 'Simple is better');
    expect(repository.favoriteProgrammer, 'Rob Pike');
    expect(repository.githubUsername, 'sazar');
    expect(repository.websiteUrl, 'https://example.com');
  });

  test('leaving the links untouched persists nulls (clears them)', () async {
    final result = await useCase();

    expect(result.isOk, isTrue);
    expect(repository.githubUsername, isNull);
    expect(repository.websiteUrl, isNull);
  });
}
