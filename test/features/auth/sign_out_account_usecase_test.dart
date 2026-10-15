// Unit tests for `SignOutAccountUseCase` — the remote sign-out runs
// first; the local profile is unlinked only once it succeeded, so a
// failed sign-out never leaves the profile pretending to be a guest
// while the session is still live.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/auth/application/usecases/sign_out_account_usecase.dart';

import 'fakes.dart';

void main() {
  late FakeAccountRepository accounts;
  late FakeProfileRepository profiles;
  late SignOutAccountUseCase useCase;

  setUp(() {
    accounts = FakeAccountRepository();
    profiles = FakeProfileRepository(
      profile: testGuestProfile().copyWith(accountUid: 'uid-1'),
    );
    useCase = SignOutAccountUseCase(accounts, profiles);
  });

  test('signs out remotely, then unlinks the local profile', () async {
    final result = await useCase();

    expect(result.isOk, isTrue);
    expect(accounts.signOutCalls, 1);
    expect(profiles.unlinked, isTrue);
    expect(profiles.profile!.accountUid, isNull);
  });

  test('does not unlink when the remote sign-out fails', () async {
    accounts.signOutResult = const Result.err(
      UnexpectedFailure('network down'),
    );

    final result = await useCase();

    expect(result.isErr, isTrue);
    expect(profiles.unlinked, isFalse);
    expect(profiles.profile!.accountUid, 'uid-1');
  });
}
