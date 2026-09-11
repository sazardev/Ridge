import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/profile/presentation/keyboard_model_brand_matching.dart';

void main() {
  group('brandTokens', () {
    test('a plain brand name is its own single token', () {
      expect(brandTokens('MCHOSE'), ['MCHOSE']);
    });

    test('splits a parenthesized alias list into extra tokens', () {
      expect(brandTokens('ZSA (ErgoDox/Moonlander/Voyager)'), [
        'ZSA',
        'ErgoDox',
        'Moonlander',
        'Voyager',
      ]);
    });

    test('a single-alias parenthetical still splits cleanly', () {
      expect(brandTokens('Drop (Massdrop)'), ['Drop', 'Massdrop']);
    });

    test('an unclosed parenthesis falls back to just the primary name', () {
      expect(brandTokens('Weird (Brand'), ['Weird']);
    });
  });

  group('preferBrandMatches', () {
    const suggestions = [
      'Akko 5108B',
      'MCHOSE ACE60',
      'MCHOSE G68',
      'MCHOSE GX87',
      'ZSA Moonlander Mark I',
      'ErgoDox EZ',
    ];

    test(
      'brand-matching entries move ahead, order preserved within each group',
      () {
        final result = preferBrandMatches(suggestions, 'MCHOSE');
        expect(result, [
          'MCHOSE ACE60',
          'MCHOSE G68',
          'MCHOSE GX87',
          'Akko 5108B',
          'ZSA Moonlander Mark I',
          'ErgoDox EZ',
        ]);
      },
    );

    test('never drops a non-matching entry — only reorders', () {
      final result = preferBrandMatches(suggestions, 'MCHOSE');
      expect(result.toSet(), suggestions.toSet());
      expect(result.length, suggestions.length);
    });

    test('an alias in the brand surfaces a differently-named model too', () {
      final result = preferBrandMatches(
        suggestions,
        'ZSA (ErgoDox/Moonlander/Voyager)',
      );
      expect(result.take(2).toSet(), {'ZSA Moonlander Mark I', 'ErgoDox EZ'});
    });

    test('a brand with no matches leaves the list untouched', () {
      expect(preferBrandMatches(suggestions, 'Corsair'), suggestions);
    });
  });
}
