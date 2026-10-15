// Unit tests for `RecoverAccountUseCase` — username/code/password are
// validated locally first, and a success hands back the *reissued*
// one-time recovery code.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/auth/application/usecases/recover_account_usecase.dart';

import 'fakes.dart';

void main() {
  late FakeAccountRepository accounts;
  late RecoverAccountUseCase useCase;

  setUp(() {
    accounts = FakeAccountRepository();
    useCase = RecoverAccountUseCase(accounts);
  });

  test('normalizes the username and reissues the code', () async {
    accounts.recoverResult = const Result.ok('EEEEE-FFFFF-GGGGG-HHHHH');

    final result = await useCase(
      username: '  OMAR ',
      recoveryCode: 'AAAAA-BBBBB-CCCCC-DDDDD',
      newPassword: 'newlongpassword',
    );

    expect(result.valueOrNull, 'EEEEE-FFFFF-GGGGG-HHHHH');
    expect(accounts.lastUsername!.value, 'omar');
    expect(accounts.lastRecoveryCode, 'AAAAA-BBBBB-CCCCC-DDDDD');
    expect(accounts.lastNewPassword, 'newlongpassword');
  });

  test('rejects an empty recovery code before any network call', () async {
    final result = await useCase(
      username: 'omar',
      recoveryCode: '   ',
      newPassword: 'newlongpassword',
    );

    expect(result.failureOrNull, isA<ValidationFailure>());
    expect(accounts.recoverCalls, 0);
  });

  test('rejects a too-short new password before any network call', () async {
    final result = await useCase(
      username: 'omar',
      recoveryCode: 'AAAAA',
      newPassword: 'short',
    );

    expect(result.failureOrNull, isA<ValidationFailure>());
    expect(accounts.recoverCalls, 0);
  });

  test('passes a server rejection through unchanged', () async {
    accounts.recoverResult = const Result.err(
      UnauthorizedFailure('Invalid recovery code'),
    );

    final result = await useCase(
      username: 'omar',
      recoveryCode: 'WRONG',
      newPassword: 'newlongpassword',
    );

    expect(result.failureOrNull, isA<UnauthorizedFailure>());
  });
}
