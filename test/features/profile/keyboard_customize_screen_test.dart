// Widget tests for `KeyboardCustomizeScreen` — the dedicated keyboard
// editor. The repository is faked so these are pure interaction tests:
// changing an option and saving must reach `updateKeyboardSetup`, and
// tapping a key on the live 3D preview must open the per-key editor.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/profile/domain/entities/favorite_language.dart';
import 'package:ridge/features/profile/domain/entities/guest_profile.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_customization.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_customization_options.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_key_spec.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_layout.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_visual_layout.dart';
import 'package:ridge/features/profile/domain/repositories/device_info_source.dart';
import 'package:ridge/features/profile/domain/repositories/keyboard_visual_layout_source.dart';
import 'package:ridge/features/profile/domain/repositories/profile_repository.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';
import 'package:ridge/features/profile/presentation/providers/keyboard_visual_layout_providers.dart';
import 'package:ridge/features/profile/presentation/providers/profile_providers.dart';
import 'package:ridge/features/profile/presentation/screens/keyboard_customize_screen.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_layout_painter.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_visual.dart';

/// One large 2u key whose centre is guaranteed to sit under the preview's
/// centre — a deterministic hit target, independent of whichever real
/// curated asset the test bundle happens to load.
class _FakeKeyboardVisualLayoutSource implements KeyboardVisualLayoutSource {
  const new();

  @override
  Future<Map<String, KeyboardVisualLayout>> loadCuratedLayouts() async => {
    'Keychron Q1': const KeyboardVisualLayout(
      model: 'Keychron Q1',
      keys: [
        KeyboardKeySpec(
          x: 0,
          y: 0,
          w: 2,
          h: 2,
          x2: 0,
          y2: 0,
          w2: 2,
          h2: 2,
          rotationAngle: 0,
          rotationX: 0,
          rotationY: 0,
          label: 'A',
        ),
      ],
    ),
  };
}

class _FakeProfileRepository implements ProfileRepository {
  KeyboardLayout? savedLayout;
  String? savedBrand;
  String? savedModel;
  KeyboardCustomization? savedCustomization;

  @override
  Future<Result<void, AppFailure>> updateKeyboardSetup({
    KeyboardLayout? keyboardLayout,
    String? keyboardBrand,
    String? keyboardModel,
    KeyboardCustomization? keyboardCustomization,
  }) async {
    savedLayout = keyboardLayout;
    savedBrand = keyboardBrand;
    savedModel = keyboardModel;
    savedCustomization = keyboardCustomization;
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

/// Matches only the editor preview's painted board.
final Finder _painted = find.byWidgetPredicate(
  (widget) => widget is CustomPaint && widget.painter is KeyboardLayoutPainter,
);

late _FakeProfileRepository _repository;

GuestProfile _profile() => GuestProfile(
  id: ProfileId.generate(),
  username: 'Omar',
  createdAt: DateTime(2026),
  keyboardModel: 'Keychron Q1',
);

Future<void> _pump(WidgetTester tester) async {
  _repository = _FakeProfileRepository();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        profileRepositoryProvider.overrideWithValue(_repository),
        keyboardVisualLayoutSourceProvider.overrideWithValue(
          const _FakeKeyboardVisualLayoutSource(),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: KeyboardCustomizeScreen(profile: _profile()),
      ),
    ),
  );
  await tester.pump();
  // flutter_animate starts each entrance on a zero-length timer, which
  // only fires once time advances; flush it so none outlives the test.
  await tester.pump(const Duration(milliseconds: 1));
}

Future<void> _save(WidgetTester tester) async {
  await tester.tap(find.byIcon(LucideIcons.check300));
  await tester.pump();
}

/// Scrolls the controls list until [finder] is visible — the editor's
/// ListView builds lazily, so off-screen sections don't exist yet.
Future<void> _scrollTo(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    160,
    // The *vertical* controls list — the section quick-nav is a horizontal
    // ListView, and `.first` would otherwise pick it.
    scrollable: find
        .descendant(
          of: find.byWidgetPredicate(
            (widget) =>
                widget is ListView && widget.scrollDirection == Axis.vertical,
          ),
          matching: find.byType(Scrollable),
        )
        .first,
  );
  await tester.pump();
}

/// The first text field inside the open key-editor bottom sheet — the
/// editor form behind it also has TextFields, so a bare
/// `find.byType(TextField)` would type into the wrong one.
Finder _sheetTextField() => find
    .descendant(
      of: find.ancestor(
        of: find.text('Edit key'),
        matching: find.byType(BottomSheet),
      ),
      matching: find.byType(TextField),
    )
    .first;

void main() {
  testWidgets('renders the editor with its sections and pinned preview', (
    tester,
  ) async {
    await _pump(tester);

    expect(find.text('Customize keyboard'), findsOneWidget);
    expect(find.text('Brand & model'), findsAtLeastNWidgets(1));
    expect(find.byType(KeyboardVisual), findsOneWidget);

    for (final title in [
      'Shape & size',
      'Keycaps',
      'Lighting',
      'Switches & materials',
      'Per-key customization',
    ]) {
      await _scrollTo(tester, find.text(title));
      expect(find.text(title), findsAtLeastNWidgets(1));
    }
  });

  testWidgets('shape, colors and RGB changes reach updateKeyboardSetup', (
    tester,
  ) async {
    await _pump(tester);

    await _scrollTo(tester, find.text('Round'));
    await tester.tap(find.text('Round'));
    await tester.pump();

    await _scrollTo(tester, find.text('Pudding'));
    await tester.tap(find.text('Pudding'));
    await tester.pump();

    await _scrollTo(tester, find.text('Has RGB backlight'));
    await tester.tap(find.text('Has RGB backlight'));
    await tester.pump();

    await _scrollTo(tester, find.text('Rainbow'));
    await tester.tap(find.text('Rainbow'));
    await tester.pump();

    await _save(tester);

    final saved = _repository.savedCustomization!;
    expect(saved.keycapShape, KeycapShape.round);
    expect(saved.keycapTransparency, KeycapTransparency.pudding);
    expect(saved.rgbEnabled, isTrue);
    expect(saved.rgbEffect, RgbEffect.rainbow);
  });

  testWidgets('tapping a key on the preview edits its legend override', (
    tester,
  ) async {
    await _pump(tester);

    await tester.tap(_painted);
    await tester.pumpAndSettle();

    expect(find.text('Edit key'), findsOneWidget);
    await tester.enterText(_sheetTextField(), 'Ñ');
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();

    await _save(tester);

    final saved = _repository.savedCustomization!;
    expect(saved.keyOverrides, hasLength(1));
    expect(saved.keyOverrides.single.label, 'Ñ');
  });

  testWidgets('with RGB on, a key can get its own light color', (tester) async {
    await _pump(tester);

    await _scrollTo(tester, find.text('Has RGB backlight'));
    await tester.tap(find.text('Has RGB backlight'));
    await tester.pump();

    await tester.tap(_painted);
    await tester.pumpAndSettle();
    expect(find.text('Key light'), findsOneWidget);

    // Custom color → picker dialog → apply there, then on the sheet.
    await tester.tap(
      find.descendant(
        of: find.byType(BottomSheet),
        matching: find.byIcon(Icons.colorize),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Apply'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(BottomSheet),
        matching: find.text('Apply'),
      ),
    );
    await tester.pumpAndSettle();

    await _save(tester);

    final saved = _repository.savedCustomization!;
    expect(saved.keyLights, hasLength(1));
    expect(saved.rgbEnabled, isTrue);
  });

  testWidgets('an extra key can be added and reaches updateKeyboardSetup', (
    tester,
  ) async {
    await _pump(tester);

    await _scrollTo(tester, find.text('Add extra key'));
    await tester.tap(find.text('Add extra key'));
    await tester.pumpAndSettle();
    await tester.enterText(_sheetTextField(), 'Macro');
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();

    expect(find.text('Macro'), findsOneWidget);

    await _save(tester);

    final saved = _repository.savedCustomization!;
    expect(saved.extraKeys, hasLength(1));
    expect(saved.extraKeys.single.label, 'Macro');
  });
}
