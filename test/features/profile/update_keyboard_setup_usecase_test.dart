// Unit tests for `UpdateKeyboardSetupUseCase` — the validation/normalization
// boundary of the dedicated keyboard editor. Uses a hand-written fake
// port, same pattern as the other usecase tests.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/profile/application/usecases/update_keyboard_setup_usecase.dart';
import 'package:ridge/features/profile/domain/entities/favorite_language.dart';
import 'package:ridge/features/profile/domain/entities/guest_profile.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_customization.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_customization_options.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_layout.dart';
import 'package:ridge/features/profile/domain/repositories/device_info_source.dart';
import 'package:ridge/features/profile/domain/repositories/profile_repository.dart';

class _FakeProfileRepository implements ProfileRepository {
  bool updateCalled = false;
  KeyboardLayout? keyboardLayout;
  String? keyboardBrand;
  String? keyboardModel;
  KeyboardCustomization? keyboardCustomization;

  @override
  Future<Result<void, AppFailure>> updateKeyboardSetup({
    KeyboardLayout? keyboardLayout,
    String? keyboardBrand,
    String? keyboardModel,
    KeyboardCustomization? keyboardCustomization,
  }) async {
    updateCalled = true;
    this.keyboardLayout = keyboardLayout;
    this.keyboardBrand = keyboardBrand;
    this.keyboardModel = keyboardModel;
    this.keyboardCustomization = keyboardCustomization;
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
  Future<Result<void, AppFailure>> updateCustomization({
    List<FavoriteLanguage> favoriteLanguages = const [],
    String? favoriteQuote,
    String? favoriteProgrammer,
    String? githubUsername,
    String? websiteUrl,
  }) async => const Result.err(ValidationFailure('unused in this test'));

  @override
  Future<Result<void, AppFailure>> updateDeviceInfo(
    DetectedDeviceInfo info,
  ) async => const Result.err(ValidationFailure('unused in this test'));
}

void main() {
  late _FakeProfileRepository repository;
  late UpdateKeyboardSetupUseCase useCase;

  setUp(() {
    repository = _FakeProfileRepository();
    useCase = UpdateKeyboardSetupUseCase(repository);
  });

  test('persists layout, trimmed brand/model and the customization', () async {
    final result = await useCase(
      keyboardLayout: KeyboardLayout.colemak,
      keyboardBrand: '  Monsgeek ',
      keyboardModel: ' M1 ',
      keyboardCustomization: const KeyboardCustomization(
        switchType: SwitchType.linear,
      ),
    );

    expect(result.isOk, isTrue);
    expect(repository.keyboardLayout, KeyboardLayout.colemak);
    expect(repository.keyboardBrand, 'Monsgeek');
    expect(repository.keyboardModel, 'M1');
    expect(repository.keyboardCustomization?.switchType, SwitchType.linear);
  });

  test(
    'blank brand/model/notes clear to null and empty overrides are pruned',
    () async {
      final result = await useCase(
        keyboardBrand: '   ',
        keyboardCustomization: const KeyboardCustomization(
          notes: '  ',
          keyOverrides: [
            KeyboardKeyLegendOverride(keyId: '1.000,1.000'),
            KeyboardKeyLegendOverride(keyId: '2.000,1.000', label: '  Ñ  '),
          ],
          extraKeys: [KeyboardExtraKey(id: 'e1', label: '  ')],
          remaps: [KeyboardKeyRemap(physicalKey: ' keyA ', character: 'q')],
        ),
      );

      expect(result.isOk, isTrue);
      expect(repository.keyboardBrand, isNull);
      final customization = repository.keyboardCustomization!;
      expect(customization.notes, isNull);
      expect(customization.keyOverrides, hasLength(1));
      expect(customization.keyOverrides.single.label, 'Ñ');
      expect(customization.extraKeys.single.label, isNull);
      expect(customization.remaps.single.physicalKey, 'keyA');
    },
  );

  test('passing no customization stores null, not an empty blob', () async {
    final result = await useCase();

    expect(result.isOk, isTrue);
    expect(repository.keyboardCustomization, isNull);
  });

  group('rejections never reach the repository', () {
    Future<void> expectRejected(KeyboardCustomization customization) async {
      final result = await useCase(keyboardCustomization: customization);
      expect(result.isErr, isTrue);
      expect(result.failureOrNull, isA<ValidationFailure>());
      expect(repository.updateCalled, isFalse);
    }

    test('over-long brand', () async {
      final result = await useCase(keyboardBrand: 'a' * 61);

      expect(result.isErr, isTrue);
      expect(repository.updateCalled, isFalse);
    });

    test('over-long model', () async {
      final result = await useCase(keyboardModel: 'a' * 61);

      expect(result.isErr, isTrue);
      expect(repository.updateCalled, isFalse);
    });

    test('over-long notes', () async {
      await expectRejected(KeyboardCustomization(notes: 'a' * 501));
    });

    test('purchase year out of range', () async {
      await expectRejected(const KeyboardCustomization(purchaseYear: 1800));
      await expectRejected(
        KeyboardCustomization(purchaseYear: DateTime.now().year + 2),
      );
    });

    test('an empty or over-long remap character', () async {
      await expectRejected(
        const KeyboardCustomization(
          remaps: [KeyboardKeyRemap(physicalKey: 'keyA', character: '')],
        ),
      );
      await expectRejected(
        const KeyboardCustomization(
          remaps: [KeyboardKeyRemap(physicalKey: 'keyA', character: 'abc')],
        ),
      );
    });

    test('an extra key outside 1u–4u', () async {
      await expectRejected(
        const KeyboardCustomization(
          extraKeys: [KeyboardExtraKey(id: 'e1', width: 0.5)],
        ),
      );
      await expectRejected(
        const KeyboardCustomization(
          extraKeys: [KeyboardExtraKey(id: 'e1', height: 5)],
        ),
      );
    });

    test('too many extra keys', () async {
      await expectRejected(
        KeyboardCustomization(
          extraKeys: [for (var i = 0; i < 33; i++) KeyboardExtraKey(id: 'e$i')],
        ),
      );
    });

    test('an over-long legend', () async {
      await expectRejected(
        KeyboardCustomization(
          keyOverrides: [
            KeyboardKeyLegendOverride(keyId: '1.000,1.000', label: 'a' * 25),
          ],
        ),
      );
    });
  });
}
