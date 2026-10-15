// Unit tests for `DeleteAccountUseCase` — remote deletion first, local
// wipe only after: a failed remote delete must never half-delete the
// device while the account still exists in the cloud.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/auth/application/usecases/delete_account_usecase.dart';

import 'fakes.dart';

void main() {
  late FakeAccountRepository accounts;
  late FakeDataResetRepository dataReset;
  late DeleteAccountUseCase useCase;

  setUp(() {
    accounts = FakeAccountRepository();
    dataReset = FakeDataResetRepository();
    useCase = DeleteAccountUseCase(accounts, dataReset);
  });

  test('deletes the account remotely, then wipes all local data', () async {
    final result = await useCase();

    expect(result.isOk, isTrue);
    expect(accounts.deleteCalls, 1);
    expect(dataReset.wipeCalls, 1);
  });

  test('never wipes locally when the remote deletion fails', () async {
    accounts.deleteAccountResult = const Result.err(
      UnexpectedFailure('network down'),
    );

    final result = await useCase();

    expect(result.isErr, isTrue);
    expect(dataReset.wipeCalls, 0);
  });

  test('surfaces a local wipe failure', () async {
    dataReset.wipeFailure = const StorageFailure('locked');

    final result = await useCase();

    expect(result.failureOrNull, isA<StorageFailure>());
  });

  test('fails cleanly on an unsupported platform', () async {
    accounts = FakeAccountRepository(isSupported: false);
    useCase = DeleteAccountUseCase(accounts, dataReset);

    final result = await useCase();

    expect(result.isErr, isTrue);
    expect(accounts.deleteCalls, 0);
    expect(dataReset.wipeCalls, 0);
  });
}
