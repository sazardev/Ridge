import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/learning_paths/infrastructure/active_language_local_data_source.dart';
import 'package:ridge/features/learning_paths/infrastructure/active_language_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  ActiveLanguageRepositoryImpl newRepository() => ActiveLanguageRepositoryImpl(
    ActiveLanguageLocalDataSource(SharedPreferencesAsync()),
  );

  test('reads null before anything was ever saved', () async {
    final result = await newRepository().read();

    expect(result.isErr, isFalse);
    expect(result.valueOrNull, isNull);
  });

  test('round-trips a language by its enum name', () async {
    final repository = newRepository();

    await repository.write(ProgrammingLanguage.rust);
    final result = await repository.read();

    expect(result.isErr, isFalse);
    expect(result.valueOrNull, ProgrammingLanguage.rust);
  });

  test('writing null clears a previously saved language', () async {
    final repository = newRepository();

    await repository.write(ProgrammingLanguage.sql);
    await repository.write(null);
    final result = await repository.read();

    expect(result.valueOrNull, isNull);
  });

  test(
    'a stored name with no matching enum value reads back as null',
    () async {
      final dataSource = ActiveLanguageLocalDataSource(
        SharedPreferencesAsync(),
      );
      await dataSource.write('cobol');
      final repository = ActiveLanguageRepositoryImpl(dataSource);

      final result = await repository.read();

      expect(result.isErr, isFalse);
      expect(result.valueOrNull, isNull);
    },
  );
}
