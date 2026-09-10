// Pure-Dart unit tests for the content feature's DTO<->domain mapping —
// no drift, no Flutter widget, no asset loading. Exercises exactly the
// kind of "pure domain modeling" logic the build phase brief calls out:
// enum<->string mapping, symbolFocus Set<->List<->comma-string, and the
// derived `charCount` getter.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/persistence/drift/app_database.dart';
import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/snippet_length.dart';
import 'package:ridge/features/content/domain/entities/symbol_focus.dart';
import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
import 'package:ridge/features/content/infrastructure/snippet_dto.dart';
import 'package:ridge/features/content/infrastructure/snippet_mapper.dart';

void main() {
  const dto = SnippetDto(
    id: 'go-ptr-001',
    revision: 1,
    language: 'go',
    difficulty: 'intermediate',
    category: 'pointers',
    length: 'short',
    titleEn: 'Increment through a pointer',
    titleEs: 'Incrementar a través de un puntero',
    code: 'func increment(n *int) {\n\t*n++\n}',
    sourceAttribution: 'hand-authored, idiomatic Go',
    isActive: true,
    tldrEn: 'Test tl;dr.',
    tldrEs: 'Tl;dr de prueba.',
    explanationEn: 'Test explanation.',
    explanationEs: 'Explicación de prueba.',
    symbolFocus: ['pointerOperators'],
  );

  group('SnippetDto JSON round-trip', () {
    test('toJson/fromJson preserves every field', () {
      final json = dto.toJson();
      final restored = SnippetDto.fromJson(json);
      expect(restored, dto);
    });

    test('symbolFocus defaults to an empty list when absent from JSON', () {
      final json = dto.toJson()..remove('symbolFocus');
      final restored = SnippetDto.fromJson(json);
      expect(restored.symbolFocus, isEmpty);
    });
  });

  group('SnippetDtoMapper.toDomain', () {
    test('maps every string field to its enum/value-object counterpart', () {
      final domain = dto.toDomain();
      expect(domain.id, const SnippetId('go-ptr-001'));
      expect(domain.revision, 1);
      expect(domain.language, ProgrammingLanguage.go);
      expect(domain.difficulty, Difficulty.intermediate);
      expect(domain.category, ContentCategory.pointers);
      expect(domain.length, SnippetLength.short);
      expect(domain.titleEn, dto.titleEn);
      expect(domain.titleEs, dto.titleEs);
      expect(domain.code, dto.code);
      expect(domain.sourceAttribution, dto.sourceAttribution);
      expect(domain.isActive, isTrue);
      expect(domain.symbolFocus, {SymbolFocus.pointerOperators});
    });

    test('an empty symbolFocus list maps to an empty Set', () {
      final noFocus = dto.copyWith(symbolFocus: const []);
      expect(noFocus.toDomain().symbolFocus, isEmpty);
    });
  });

  group('Snippet.charCount', () {
    test('is always derived from code.length, never stored', () {
      final domain = dto.toDomain();
      expect(domain.charCount, domain.code.length);
    });
  });

  group('domain <-> DTO <-> companion round-trip', () {
    test('Snippet.toDto() round-trips back to an equal domain entity', () {
      final domain = dto.toDomain();
      final roundTripped = domain.toDto().toDomain();
      expect(roundTripped, domain);
    });

    test('toCompanion() computes charCount from code.length', () {
      final companion = dto.toCompanion();
      expect(companion.charCount.value, dto.code.length);
    });

    test('toCompanion() joins a non-empty symbolFocus with commas', () {
      final companion = dto.toCompanion();
      expect(companion.symbolFocus.value, 'pointerOperators');
    });

    test('toCompanion() stores null symbolFocus when the set is empty', () {
      final companion = dto.copyWith(symbolFocus: const []).toCompanion();
      expect(companion.symbolFocus.value, isNull);
    });

    test('multiple symbol foci join and split back losslessly', () {
      final multi = dto.copyWith(
        symbolFocus: const ['pointerOperators', 'generics'],
      );
      final companion = multi.toCompanion();
      expect(companion.symbolFocus.value, 'pointerOperators,generics');

      final row = SnippetRow(
        id: multi.id,
        revision: multi.revision,
        language: multi.language,
        difficulty: multi.difficulty,
        category: multi.category,
        symbolFocus: companion.symbolFocus.value,
        length: multi.length,
        titleEn: multi.titleEn,
        titleEs: multi.titleEs,
        code: multi.code,
        sourceAttribution: multi.sourceAttribution,
        charCount: multi.code.length,
        isActive: multi.isActive,
        tldrEn: multi.tldrEn,
        tldrEs: multi.tldrEs,
        explanationEn: multi.explanationEn,
        explanationEs: multi.explanationEs,
      );
      expect(row.toDto().toDomain().symbolFocus, {
        SymbolFocus.pointerOperators,
        SymbolFocus.generics,
      });
    });
  });

  group('SnippetRowMapper.toDto', () {
    test('a null symbolFocus column maps to an empty list', () {
      final row = SnippetRow(
        id: dto.id,
        revision: dto.revision,
        language: dto.language,
        difficulty: dto.difficulty,
        category: dto.category,
        length: dto.length,
        titleEn: dto.titleEn,
        titleEs: dto.titleEs,
        code: dto.code,
        sourceAttribution: dto.sourceAttribution,
        charCount: dto.code.length,
        isActive: dto.isActive,
        tldrEn: dto.tldrEn,
        tldrEs: dto.tldrEs,
        explanationEn: dto.explanationEn,
        explanationEs: dto.explanationEs,
      );
      expect(row.toDto().symbolFocus, isEmpty);
    });
  });
}
