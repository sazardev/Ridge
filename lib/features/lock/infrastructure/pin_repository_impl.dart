import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/lock/domain/repositories/pin_repository.dart';

/// Secure-storage adapter for [PinRepository]. Only a salted SHA-256 digest
/// of the PIN ever touches disk — the raw PIN lives in memory just long
/// enough to be hashed.
class PinRepositoryImpl implements PinRepository {
  /// Creates the adapter over the given secure-storage instance.
  new(this._storage);

  final FlutterSecureStorage _storage;

  static const _hashKey = 'lock.pin_hash';
  static const _saltKey = 'lock.pin_salt';

  @override
  Future<bool> hasPin() async {
    final hash = await _storage.read(key: _hashKey);
    return hash != null;
  }

  @override
  Future<Result<void, AppFailure>> setPin(String pin) async {
    try {
      final salt = _generateSalt();
      await _storage.write(key: _saltKey, value: salt);
      await _storage.write(key: _hashKey, value: _hash(pin, salt));
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.err(StorageFailure('Could not save PIN', cause: e));
    }
  }

  @override
  Future<Result<bool, AppFailure>> verifyPin(String pin) async {
    try {
      final salt = await _storage.read(key: _saltKey);
      final storedHash = await _storage.read(key: _hashKey);
      if (salt == null || storedHash == null) {
        return const Result.ok(false);
      }
      return Result.ok(_hash(pin, salt) == storedHash);
    } on Exception catch (e) {
      return Result.err(StorageFailure('Could not verify PIN', cause: e));
    }
  }

  @override
  Future<Result<void, AppFailure>> clearPin() async {
    try {
      await _storage.delete(key: _hashKey);
      await _storage.delete(key: _saltKey);
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.err(StorageFailure('Could not clear PIN', cause: e));
    }
  }

  String _generateSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return base64UrlEncode(bytes);
  }

  String _hash(String pin, String salt) {
    return sha256.convert(utf8.encode('$salt:$pin')).toString();
  }
}
