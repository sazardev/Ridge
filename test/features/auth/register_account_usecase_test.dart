// Unit tests for `RegisterAccountUseCase` — validation happens before
// any network call, the local profile is renamed to the account username
// and linked to its uid on success, and a local linking failure never
// swallows the one-time recovery code. Uses hand-written fakes, same
// pattern as the other usecase tests.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/auth/application/usecases/register_account_usecase.dart';

import 'fakes.dart';

void main() {
  late FakeAccountRepository accounts;
  late FakeProfileRepository profiles;
  late RegisterAccountUseCase useCase;

  setUp(() {
    accounts = FakeAccountRepository();
    profiles = FakeProfileRepository(profile: testGuestProfile());
    useCase = RegisterAccountUseCase(accounts, profiles);
  });

  test('rejects an invalid username without touching the repository', () async {
    final result = await useCase(username: 'no spaces', password: 'longenough');

    expect(result.isErr, isTrue);
    expect(result.failureOrNull, isA<ValidationFailure>());
    expect(accounts.registerCalls, 0);
  });

  test(
    'rejects a too-short password without touching the repository',
    () async {
      final result = await useCase(username: 'omar', password: 'short');

      expect(result.isErr, isTrue);
      expect(result.failureOrNull, isA<ValidationFailure>());
      expect(accounts.registerCalls, 0);
    },
  );

  test('fails cleanly on an unsupported platform', () async {
    accounts = FakeAccountRepository(isSupported: false);
    useCase = RegisterAccountUseCase(accounts, profiles);

    final result = await useCase(username: 'omar', password: 'longenough');

    expect(result.isErr, isTrue);
    expect(accounts.registerCalls, 0);
  });

  test('normalizes the username before registering', () async {
    await useCase(username: '  OMAR  ', password: 'longenough');

    expect(accounts.lastUsername!.value, 'omar');
  });

  test('renames and links the local profile on success', () async {
    accounts.registerResult = Result.ok((
      account: testAccount(username: 'omar-ridge'),
      recoveryCode: 'AAAAA-BBBBB-CCCCC-DDDDD',
    ));

    final result = await useCase(username: 'omar', password: 'longenough');

    expect(result.valueOrNull!.recoveryCode, 'AAAAA-BBBBB-CCCCC-DDDDD');
    expect(profiles.renamedTo, 'omar-ridge');
    expect(profiles.linkedAccountUid, 'uid-1');
  });

  test('still returns the recovery code when linking locally fails', () async {
    profiles.linkFailure = const StorageFailure('disk full');

    final result = await useCase(username: 'omar', password: 'longenough');

    expect(result.isOk, isTrue);
    expect(result.valueOrNull!.recoveryCode, isNotEmpty);
  });

  test('passes a repository failure through unchanged', () async {
    accounts.registerResult = const Result.err(
      UnauthorizedFailure('That username is already taken'),
    );

    final result = await useCase(username: 'omar', password: 'longenough');

    expect(result.failureOrNull, isA<UnauthorizedFailure>());
    expect(profiles.linkedAccountUid, isNull);
  });
}
