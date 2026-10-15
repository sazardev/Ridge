import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/auth/domain/entities/registered_account.dart';
import 'package:ridge/features/auth/domain/repositories/account_repository.dart';
import 'package:ridge/features/auth/domain/value_objects/account_username.dart';
import 'package:ridge/features/auth/infrastructure/callable_functions_client.dart';

/// Firebase-backed adapter for [AccountRepository] — the only place in
/// the app that imports Firebase (STACK.md §5: it is an infrastructure
/// detail, never referenced from `domain/` or `application/`).
///
/// Sign-in and sign-out go straight through the client SDK's own session
/// handling (fast, offline-friendly); the three flows Firebase can't do
/// client-side — registration with the one-time recovery code, recovery
/// itself, and account deletion — are implemented as callable Cloud
/// Functions invoked through [CallableFunctionsClient], because they
/// need the Admin SDK.
class FirebaseAccountRepository implements AccountRepository {
  /// Creates the adapter over the given function client; [auth] and
  /// [firestore] are injectable for tests.
  new(this._functions, {FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  final CallableFunctionsClient _functions;
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  /// Username → account cache, so restoring a session (which fires on
  /// every token refresh) doesn't re-read the profile document each time.
  final _accountsByUid = <String, RegisteredAccount>{};

  /// The internal email suffix every Registered Account's synthetic
  /// sign-in identifier uses (STACK.md §5.2) — never shown to the user
  /// and never used to send anything.
  static const syntheticEmailDomain = 'users.ridge.internal';

  /// The synthetic email for [username] — must match the derivation in
  /// the `register` Cloud Function exactly.
  static String syntheticEmailFor(AccountUsername username) =>
      '${username.value}@$syntheticEmailDomain';

  @override
  bool get isSupported => true;

  @override
  Stream<RegisteredAccount?> watchCurrentAccount() {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) {
        _accountsByUid.clear();
        return null;
      }
      return await _accountFor(user);
    });
  }

  @override
  Future<Result<AccountRegistration, AppFailure>> register({
    required AccountUsername username,
    required String password,
  }) async {
    try {
      final result = await _functions.call(
        'register',
        data: {'username': username.value, 'password': password},
      );
      final uid = result['uid'];
      final recoveryCode = result['recoveryCode'];
      if (uid is! String || recoveryCode is! String) {
        return const Result.err(
          UnexpectedFailure('Registration answered with an unexpected payload'),
        );
      }
      final account = RegisteredAccount(
        uid: uid,
        username: result['username'] as String? ?? username.value,
        createdAt: _parseTimestamp(result['createdAt']),
      );
      _accountsByUid[uid] = account;
      // Establishing the local session is best-effort: the account and
      // its recovery code already exist, and reporting failure here
      // would risk the user never seeing the code.
      try {
        await _auth.signInWithEmailAndPassword(
          email: syntheticEmailFor(username),
          password: password,
        );
      } on FirebaseAuthException {
        // The user can sign in explicitly; the code is still returned.
      }
      return Result.ok((account: account, recoveryCode: recoveryCode));
    } on CallableFunctionException catch (e) {
      return Result.err(_mapCallableFailure(e));
    } on TimeoutException {
      return const Result.err(
        UnexpectedFailure('The request timed out; check your connection'),
      );
    } on http.ClientException {
      return const Result.err(
        UnexpectedFailure('Could not reach the account service'),
      );
    }
  }

  @override
  Future<Result<RegisteredAccount, AppFailure>> signIn({
    required AccountUsername username,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: syntheticEmailFor(username),
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        return const Result.err(
          UnauthorizedFailure('Incorrect username or password'),
        );
      }
      return Result.ok(await _accountFor(user));
    } on FirebaseAuthException catch (e) {
      return Result.err(_mapAuthFailure(e));
    }
  }

  @override
  Future<Result<void, AppFailure>> signOut() async {
    try {
      await _auth.signOut();
      _accountsByUid.clear();
      return const Result.ok(null);
    } on FirebaseAuthException catch (e) {
      return Result.err(_mapAuthFailure(e));
    }
  }

  @override
  Future<Result<void, AppFailure>> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) {
      return const Result.err(
        NotFoundFailure('There is no signed-in account to delete'),
      );
    }
    try {
      final idToken = await user.getIdToken();
      await _functions.call('deleteAccount', idToken: idToken);
      await _auth.signOut();
      _accountsByUid.clear();
      return const Result.ok(null);
    } on CallableFunctionException catch (e) {
      return Result.err(_mapCallableFailure(e));
    } on TimeoutException {
      return const Result.err(
        UnexpectedFailure('The request timed out; check your connection'),
      );
    } on http.ClientException {
      return const Result.err(
        UnexpectedFailure('Could not reach the account service'),
      );
    } on FirebaseAuthException catch (e) {
      return Result.err(_mapAuthFailure(e));
    }
  }

  @override
  Future<Result<String, AppFailure>> recover({
    required AccountUsername username,
    required String recoveryCode,
    required String newPassword,
  }) async {
    try {
      final result = await _functions.call(
        'recoverAccount',
        data: {
          'username': username.value,
          'recoveryCode': recoveryCode,
          'newPassword': newPassword,
        },
      );
      final newCode = result['recoveryCode'];
      if (newCode is! String) {
        return const Result.err(
          UnexpectedFailure('Recovery answered with an unexpected payload'),
        );
      }
      return Result.ok(newCode);
    } on CallableFunctionException catch (e) {
      return Result.err(_mapCallableFailure(e));
    } on TimeoutException {
      return const Result.err(
        UnexpectedFailure('The request timed out; check your connection'),
      );
    } on http.ClientException {
      return const Result.err(
        UnexpectedFailure('Could not reach the account service'),
      );
    }
  }

  /// Resolves the [RegisteredAccount] behind an auth [user], reading the
  /// remote profile document for the display-cased username and creation
  /// date — falling back to the synthetic email's local part when
  /// offline.
  Future<RegisteredAccount> _accountFor(User user) async {
    final cached = _accountsByUid[user.uid];
    if (cached != null) return cached;

    var username = user.email?.split('@').first ?? user.uid;
    DateTime? createdAt;
    try {
      final doc = await _firestore.collection('profiles').doc(user.uid).get();
      final data = doc.data();
      final remoteUsername = data?['username'];
      if (remoteUsername is String && remoteUsername.isNotEmpty) {
        username = remoteUsername;
      }
      createdAt = _parseTimestamp(data?['createdAt']);
    } on FirebaseException {
      // Offline (or rules misconfigured): the synthetic email already
      // carries the normalized username.
    }

    final account = RegisteredAccount(
      uid: user.uid,
      username: username,
      createdAt: createdAt,
    );
    _accountsByUid[user.uid] = account;
    return account;
  }

  static DateTime? _parseTimestamp(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  static AppFailure _mapAuthFailure(FirebaseAuthException e) {
    return switch (e.code) {
      'user-not-found' ||
      'wrong-password' ||
      'invalid-credential' ||
      'invalid-login-credentials' ||
      'too-many-requests' => const UnauthorizedFailure(
        'Incorrect username or password',
      ),
      'user-disabled' => const UnauthorizedFailure(
        'This account has been disabled',
      ),
      'email-already-in-use' => const ValidationFailure(
        'That username is already taken',
      ),
      'weak-password' => const ValidationFailure('That password is too weak'),
      'network-request-failed' => const UnexpectedFailure(
        'Could not reach the account service',
      ),
      _ => UnexpectedFailure(e.message ?? e.code, cause: e),
    };
  }

  static AppFailure _mapCallableFailure(CallableFunctionException e) {
    return switch (e.status) {
      'invalid-argument' || 'already-exists' => ValidationFailure(e.message),
      'not-found' => NotFoundFailure(e.message),
      'permission-denied' ||
      'unauthenticated' => UnauthorizedFailure(e.message),
      _ => UnexpectedFailure(e.message),
    };
  }
}
