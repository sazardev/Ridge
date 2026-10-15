// Unit tests for `SignInAccountUseCase` — signs into the account through
// the port, then reconciles the on-device profile: relink an existing
// guest profile (renaming it to the account username), create one when
// the device has none yet, and never report the successful sign-in as a
// failure because a local write went wrong.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/auth/application/usecases/sign_in_account_usecase.dart';

import 'fakes.dart';

void main() {
  late FakeAccountRepository accounts;
  late FakeProfileRepository profiles;
  late SignInAccountUseCase useCase;

  setUp(() {
    accounts = FakeAccountRepository();
    profiles = FakeProfileRepository(profile: testGuestProfile());
    useCase = SignInAccountUseCase(accounts, profiles);
  });

  test('rejects an invalid username without touching the repository', () async {
    final result = await useCase(username: 'ño', password: 'longenough');

    expect(result.isErr, isTrue);
    expect(result.failureOrNull, isA<ValidationFailure>());
    expect(accounts.signInCalls, 0);
  });

  test('rejects an empty password without touching the repository', () async {
    final result = await useCase(username: 'omar', password: '');

    expect(result.isErr, isTrue);
    expect(accounts.signInCalls, 0);
  });

  test('signs in with the normalized username', () async {
    await useCase(username: '  Omar ', password: 'longenough');

    expect(accounts.lastUsername!.value, 'omar');
  });

  test('links an existing unlinked profile and renames it', () async {
    final result = await useCase(username: 'omar-ridge', password: 'pw');

    expect(result.isOk, isTrue);
    expect(profiles.renamedTo, 'omar-ridge');
    expect(profiles.linkedAccountUid, 'uid-1');
  });

  test('leaves an already-linked profile untouched', () async {
    profiles.profile = testGuestProfile().copyWith(
      username: 'omar',
      accountUid: 'uid-1',
    );

    await useCase(username: 'omar', password: 'pw');

    expect(profiles.renamedTo, isNull);
    expect(profiles.linkedAccountUid, isNull);
  });

  test('creates and links a profile when the device has none', () async {
    profiles.profile = null;

    await useCase(username: 'omar', password: 'pw');

    expect(profiles.createCalls, 1);
    expect(profiles.linkedAccountUid, 'uid-1');
  });

  test(
    'passes a bad-credentials failure through without touching local state',
    () async {
      accounts.signInResult = const Result.err(
        UnauthorizedFailure('Incorrect username or password'),
      );

      final result = await useCase(username: 'omar', password: 'wrong');

      expect(result.failureOrNull, isA<UnauthorizedFailure>());
      expect(profiles.linkedAccountUid, isNull);
      expect(profiles.renamedTo, isNull);
    },
  );

  test('still reports success when the local link fails', () async {
    profiles.linkFailure = const StorageFailure('disk full');

    final result = await useCase(username: 'omar', password: 'pw');

    expect(result.isOk, isTrue);
  });
}
