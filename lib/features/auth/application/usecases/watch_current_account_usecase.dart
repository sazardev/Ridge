import 'package:ridge/features/auth/domain/entities/registered_account.dart';
import 'package:ridge/features/auth/domain/repositories/account_repository.dart';

/// Observes the currently signed-in Registered Account (or `null`) — a
/// stream the SDK keeps alive across app restarts, so this is also how a
/// registered user is restored to their session on a cold start.
class WatchCurrentAccountUseCase {
  /// Creates the use case over the account port.
  const new(this._accounts);

  final AccountRepository _accounts;

  /// Emits the current account and every change after it.
  Stream<RegisteredAccount?> call() => _accounts.watchCurrentAccount();
}
